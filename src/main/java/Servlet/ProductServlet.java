package Servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import DAO.ProductDAO;
import DTO.ProductDTO;
import DTO.ProductDetailDTO;
import DTO.ProductImgDTO;
import Security.ProductImageInput;
import java.nio.file.Path;

@WebServlet("/ProductServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("insert".equals(action)) {
            insertProduct(request, response);
        } else if ("update".equals(action)) {
            updateProduct(request, response);
        } else if ("delete".equals(action)) {
            deleteProduct(request, response);
        } else {
            response.sendRedirect("admin_product_list.jsp?error=invalidAction");
        }
    }
    
    // 상품 mutation(insert/update/delete)은 POST 전용이다.
    // GET은 상태를 바꾸지 않고 목록으로 되돌린다. (기존 GET action=delete 제거)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.sendRedirect("admin_product_list.jsp");
    }

    // 숫자 파라미터 안전 파싱. 유효한 양의 정수가 아니면 -1.
    private int safePositiveInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return -1;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            return parsed > 0 ? parsed : -1;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response, String target)
            throws ServletException, IOException {
        request.setAttribute("error", "serverError");
        request.getRequestDispatcher(target).forward(request, response);
    }
    
    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String p_name = request.getParameter("p_name");
            String p_category = request.getParameter("p_category");

            int p_price = safePositiveInt(request.getParameter("p_price"));
            if (p_price < 0) {
                forwardError(request, response, "/admin_product_edit.jsp");
                return;
            }
            int p_disc = 0;
            String discRaw = request.getParameter("p_disc");
            if (discRaw != null && !discRaw.trim().isEmpty()) {
                int parsedDisc = safePositiveInt(discRaw);
                p_disc = parsedDisc < 0 ? 0 : parsedDisc;
            }

            String p_text = request.getParameter("p_text");
            if (p_text != null) {
                // 저장 표현 유지: 기존 <br> 를 개행으로 되돌린 뒤 다시 <br> 로 정규화
                p_text = p_text.replace("<br>", "\n").replace("\n", "<br>");
            }
            String p_color = request.getParameter("p_color");

            // p_id 는 항상 AUTO_INCREMENT. client 가 보낸 p_id 는 신뢰하지 않는다.
            ProductDTO product = new ProductDTO();
            product.setP_id(0);
            product.setP_name(p_name);
            product.setP_category(p_category);
            product.setP_price(p_price);
            product.setP_disc(p_disc);
            product.setP_text(p_text);
            product.setP_color(p_color);

            LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            product.setCreated_at(now.format(formatter));

            // 1. 업로드 이미지를 DB write 전에 전부 실제 decode 검증한다. 하나라도 실패하면 중단.
            List<ProductImageInput.Image> validated = new ArrayList<>();
            List<Integer> validatedOrders = new ArrayList<>();
            try {
                ProductImageInput.Image mainImg = ProductImageInput.validate(request.getPart("main_image"));
                if (mainImg != null) {
                    validated.add(mainImg);
                    validatedOrders.add(1);
                }
                int order = 2;
                for (Part part : getDetailImageParts(request)) {
                    ProductImageInput.Image img = ProductImageInput.validate(part);
                    if (img != null) {
                        if (validated.size() >= ProductImageInput.MAX_FILES) {
                            throw new IOException("이미지는 최대 " + ProductImageInput.MAX_FILES + "장까지 등록할 수 있습니다.");
                        }
                        validated.add(img);
                        validatedOrders.add(order++);
                    }
                }
            } catch (IOException imageError) {
                request.setAttribute("error", imageError.getMessage());
                request.getRequestDispatcher("/admin_product_edit.jsp").forward(request, response);
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            int productId = productDAO.insertProduct(product);
            if (productId <= 0) {
                request.setAttribute("error", "insertFailed");
                request.getRequestDispatcher("/admin_product_edit.jsp").forward(request, response);
                return;
            }

            // 상품 행 생성 이후의 처리(사이즈/재고, 이미지 저장·행 삽입)에서
            // 확인 가능한 실패가 발생하면, 방금 만든 상품/상세/이미지 행과 저장 파일을 보상 정리한다.
            List<String> savedFiles = new ArrayList<>();
            try {
                // 2. 사이즈/재고
                String[] sizes = request.getParameterValues("sizes[]");
                String[] stocks = request.getParameterValues("stocks[]");
                if (sizes != null && stocks != null && sizes.length == stocks.length) {
                    for (int i = 0; i < sizes.length; i++) {
                        if (sizes[i] != null && !sizes[i].isEmpty() && stocks[i] != null && !stocks[i].isEmpty()) {
                            int stockValue = safePositiveInt(stocks[i]);
                            if (stockValue < 0) {
                                stockValue = 0;
                            }
                            ProductDetailDTO detail = new ProductDetailDTO();
                            detail.setP_id(productId);
                            detail.setPd_size(sizes[i]);
                            detail.setPd_stock(stockValue);
                            if (!productDAO.insertProductDetail(detail)) {
                                throw new IOException("상품 상세 정보 저장에 실패했습니다.");
                            }
                        }
                    }
                }

                // 3. 검증된 이미지 저장 (파일명은 서버가 결정, 확장자는 decode 결과에서만)
                Path dir = ProductImageInput.webDir(request, "uploads/products");
                for (int i = 0; i < validated.size(); i++) {
                    String saved = ProductImageInput.save(validated.get(i), dir, "product_" + productId);
                    if (saved == null) {
                        continue;
                    }
                    savedFiles.add(saved);
                    ProductImgDTO imgDTO = new ProductImgDTO();
                    imgDTO.setP_id(productId);
                    imgDTO.setPi_url("uploads/products/" + saved);
                    imgDTO.setPi_orders(validatedOrders.get(i));
                    if (!productDAO.insertProductImage(imgDTO)) {
                        throw new IOException("상품 이미지 정보 저장에 실패했습니다.");
                    }
                }
            } catch (Exception writeError) {
                writeError.printStackTrace();
                compensateInsert(request, productId, savedFiles);
                forwardError(request, response, "/admin_product_edit.jsp");
                return;
            }

            request.setAttribute("status", "success");
            request.setAttribute("message", "등록이 완료되었습니다");
            request.getRequestDispatcher("/admin_product_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            forwardError(request, response, "/admin_product_edit.jsp");
        }
    }

    // insert 중간 실패 보상: 방금 만든 product(+detail+image 행)와 저장 파일을 되돌린다.
    private void compensateInsert(HttpServletRequest request, int productId, List<String> savedFiles) {
        try {
            if (!new ProductDAO().deleteProduct(productId)) {
                System.err.println("상품 등록 보상 DB 삭제 실패 또는 결과 불확실: productId=" + productId
                        + "; 저장 파일 유지, 수동 정합성 확인 필요");
                return;
            }
        } catch (Exception rollbackError) {
            System.err.println("상품 등록 보상 DB 삭제 예외: productId=" + productId
                    + "; 저장 파일 유지, 수동 정합성 확인 필요");
            rollbackError.printStackTrace();
            return;
        }
        try {
            Path dir = ProductImageInput.webDir(request, "uploads/products");
            for (String name : savedFiles) {
                ProductImageInput.remove(dir, name);
            }
        } catch (Exception cleanupError) {
            cleanupError.printStackTrace();
        }
    }
    
    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int p_id = safePositiveInt(request.getParameter("id"));
            if (p_id < 0) {
                forwardError(request, response, "/admin_product_edit.jsp");
                return;
            }

            String p_name = request.getParameter("p_name");
            String p_category = request.getParameter("p_category");

            int p_price = safePositiveInt(request.getParameter("p_price"));
            if (p_price < 0) {
                forwardError(request, response, "/admin_product_edit.jsp");
                return;
            }
            int p_disc = 0;
            String discRaw = request.getParameter("p_disc");
            if (discRaw != null && !discRaw.trim().isEmpty()) {
                int parsedDisc = safePositiveInt(discRaw);
                p_disc = parsedDisc < 0 ? 0 : parsedDisc;
            }

            String p_text = request.getParameter("p_text");
            if (p_text != null) {
                p_text = p_text.replace("<br>", "\n").replace("\n", "<br>");
            }
            String p_color = request.getParameter("p_color");

            ProductDTO product = new ProductDTO();
            product.setP_id(p_id);
            product.setP_name(p_name);
            product.setP_category(p_category);
            product.setP_price(p_price);
            product.setP_disc(p_disc);
            product.setP_text(p_text);
            product.setP_color(p_color);

            // 기본 정보 수정 + 사이즈/재고 삭제·재삽입을 하나의 transaction 으로 처리한다.
            // 대상 상품이 없거나 어느 단계든 실패하면 rollback 되어 false 가 온다.
            // (이미지 교체/삭제는 PHASE 5A 범위 밖 — 기존과 동일하게 update 에서 다루지 않는다.)
            String[] sizes = request.getParameterValues("sizes[]");
            String[] stocks = request.getParameterValues("stocks[]");

            ProductDAO productDAO = new ProductDAO();
            boolean success = productDAO.updateProductWithDetails(product, sizes, stocks);

            if (success) {
                request.setAttribute("status", "success");
                request.setAttribute("message", "수정이 완료되었습니다");
                request.getRequestDispatcher("/admin_product_list.jsp").forward(request, response);
            } else {
                request.setAttribute("id", p_id);
                request.setAttribute("error", "updateFailed");
                request.getRequestDispatcher("/admin_product_edit.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            forwardError(request, response, "/admin_product_edit.jsp");
        }
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = safePositiveInt(request.getParameter("id"));
            if (productId < 0) {
                forwardError(request, response, "/admin_product_list.jsp");
                return;
            }

            ProductDAO productDAO = new ProductDAO();

            // DB 삭제 전에 이미지 파일명을 확보한다.
            List<String> imageFiles = new ArrayList<>();
            for (ProductImgDTO img : productDAO.getProductImages(productId)) {
                String name = ProductImageInput.fileNameFromUrl(img.getPi_url());
                if (name != null) {
                    imageFiles.add(name);
                }
            }

            boolean success = productDAO.deleteProduct(productId);

            if (success) {
                // DB 삭제가 성공한 뒤에만, 정규화된 uploads 디렉터리 안에서 파일을 정리한다.
                try {
                    Path dir = ProductImageInput.webDir(request, "uploads/products");
                    for (String name : imageFiles) {
                        ProductImageInput.remove(dir, name);
                    }
                } catch (IOException cleanupError) {
                    cleanupError.printStackTrace();
                }
                request.setAttribute("status", "success");
                request.setAttribute("message", "삭제가 완료되었습니다");
                request.getRequestDispatcher("/admin_product_list.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "deleteFailed");
                request.getRequestDispatcher("/admin_product_list.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            forwardError(request, response, "/admin_product_list.jsp");
        }
    }

    // 상세 이미지 파트 목록 가져오기
    private List<Part> getDetailImageParts(HttpServletRequest request) throws ServletException, IOException {
        List<Part> imageParts = new ArrayList<>();
        for (Part part : request.getParts()) {
            if (part.getName().equals("detail_image[]")) {
                imageParts.add(part);
            }
        }
        return imageParts;
    }
} 