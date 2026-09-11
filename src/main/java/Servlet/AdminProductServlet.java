package Servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.text.DecimalFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import DTO.ProductDTO;
import DAO.ProductDAO;
import DAO.CategoryDAO;

@WebServlet("/AdminProductServlet")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 디버깅용 로그 추가
        System.out.println("==== 관리자 상품 목록 페이지 요청 정보 ====");
        System.out.println("category 파라미터: " + request.getParameter("category"));
        System.out.println("topCategory 파라미터: " + request.getParameter("topCategory"));
        System.out.println("middleCategory 파라미터: " + request.getParameter("middleCategory"));
        System.out.println("subCategory 파라미터: " + request.getParameter("subCategory"));
        System.out.println("====================================");

        int currentPage = 1;
        try {
            if (request.getParameter("page") != null) {
                currentPage = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        int itemsPerPage = 10;
        int start = (currentPage - 1) * itemsPerPage;

        // 검색 필터 파라미터
        String keyword = request.getParameter("keyword");
        String selectedSize = request.getParameter("size");
        String category = request.getParameter("category");
        
        // 가격 범위
        Integer minPrice = null;
        Integer maxPrice = null;
        try {
            if (request.getParameter("minPrice") != null && !request.getParameter("minPrice").trim().isEmpty()) {
                minPrice = Integer.parseInt(request.getParameter("minPrice"));
            }
            if (request.getParameter("maxPrice") != null && !request.getParameter("maxPrice").trim().isEmpty()) {
                maxPrice = Integer.parseInt(request.getParameter("maxPrice"));
            }
        } catch (NumberFormatException e) {
            // 숫자 변환 실패 시 무시
        }
        
        // 재고 상태
        String stockStatus = request.getParameter("stockStatus");
        
        // 할인 적용 여부
        String discount = request.getParameter("discount");
        
        // 정렬 파라미터 추가
        String sortBy = request.getParameter("sortBy");
        if (sortBy == null) sortBy = "p_id"; // 기본 정렬: 상품번호순
        
        String sortOrder = request.getParameter("sortOrder");
        if (sortOrder == null) sortOrder = "desc"; // 기본 정렬 방향: 내림차순

        ProductDAO productDAO = new ProductDAO();
        List<ProductDTO> productList = productDAO.getProductListWithAdvancedFilters(
            start, itemsPerPage, keyword, selectedSize, category, 
            minPrice, maxPrice, stockStatus, discount, sortBy, sortOrder
        );
        int totalProducts = productDAO.getTotalProductCountWithAdvancedFilters(
            keyword, selectedSize, category, minPrice, maxPrice, stockStatus, discount
        );
        int totalPages = (int) Math.ceil((double) totalProducts / itemsPerPage);

        DecimalFormat priceFormat = new DecimalFormat("#,###");
        
        // 페이지네이션 URL 생성을 위한 공통 파라미터
        String paginationParams = String.format(
            "&keyword=%s&size=%s&category=%s&minPrice=%s&maxPrice=%s&stockStatus=%s&discount=%s&sortBy=%s&sortOrder=%s",
            keyword != null ? keyword : "",
            selectedSize != null ? selectedSize : "",
            category != null ? category : "",
            minPrice != null ? minPrice : "",
            maxPrice != null ? maxPrice : "",
            stockStatus != null ? stockStatus : "",
            discount != null ? discount : "",
            sortBy != null ? sortBy : "",
            sortOrder != null ? sortOrder : ""
        );
        
        // 카테고리 계층 구조 가져오기
        CategoryDAO categoryDAO = new CategoryDAO();
        Map<String, Map<String, List<String>>> categoryHierarchy = categoryDAO.getCategoryHierarchy();

        // Request 속성 설정
        request.setAttribute("productList", productList);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("itemsPerPage", itemsPerPage);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedSize", selectedSize);
        request.setAttribute("category", category);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("stockStatus", stockStatus);
        request.setAttribute("discount", discount);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("paginationParams", paginationParams);
        request.setAttribute("categoryHierarchy", categoryHierarchy);
        request.setAttribute("priceFormat", priceFormat);
        
        // 현재 메뉴 표시를 위한 속성 설정
        request.setAttribute("currentMenu", "product");
        request.setAttribute("subMenu", "product_list");

        // JSP로 포워딩
        request.getRequestDispatcher("/admin_product_list.jsp").forward(request, response);
    }
} 