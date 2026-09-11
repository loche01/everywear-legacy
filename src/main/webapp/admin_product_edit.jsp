<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="DTO.ProductDTO, DAO.ProductDAO, DAO.CategoryDAO, java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="DTO.ProductDetailDTO, DTO.ProductImgDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 상태 메시지 처리
    String status = (String) request.getAttribute("status");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    
    // 파라미터로 전달된 경우도 처리
    if (status == null) status = request.getParameter("status");
    if (message == null) message = request.getParameter("message");
    if (error == null) error = request.getParameter("error");
    
    String mode = "create";
    String pageTitle = "상품 등록";
    ProductDTO product = new ProductDTO();
    String id = request.getParameter("id");
    
    // 상품 정보 변수 초기화
    List<ProductDetailDTO> productDetails = null;
    List<ProductImgDTO> productImages = null;
    
    // request 속성으로 id가 전달된 경우
    if(id == null) {
        Object idAttr = request.getAttribute("id");
        if(idAttr != null) {
            id = idAttr.toString();
        }
    }

    // id 가 양의 정수일 때만 수정 모드로 조회한다. 비숫자/없는 상품이면 등록 폼으로 안전하게 대체(HTTP 500 방지).
    if (id != null && id.matches("\\d+")) {
        int pid = Integer.parseInt(id);
        ProductDAO dao = new ProductDAO();
        ProductDTO found = dao.getProductById(pid);
        if (found != null) {
            mode = "edit";
            pageTitle = "상품 수정";
            product = found;
            productDetails = dao.getProductDetails(pid);
            productImages = dao.getProductImages(pid);
        }
    }
    
    // 관리자 메뉴 활성화를 위한 속성 설정
    request.setAttribute("currentMenu", "product");
    request.setAttribute("subMenu", mode.equals("edit") ? "product_list" : "product_add");
    
    // 카테고리 정보 가져오기 (3단계 계층 구조)
    CategoryDAO categoryDAO = new CategoryDAO();
    Map<String, Map<String, List<String>>> categoryHierarchy = categoryDAO.getCategoryHierarchy();
    
    // 현재 상품의 카테고리 정보
    String currentCategory = "";
    String currentMainCategory = "";
    String currentSubCategory = "";
    String currentDetailCategory = "";
    
    if (product != null && product.getP_category() != null) {
        currentCategory = product.getP_category();
        
        // 카테고리 계층 구조에서 현재 카테고리의 위치 찾기
        boolean found = false;
        
        for (String mainCat : categoryHierarchy.keySet()) {
            // 메인 카테고리와 일치하는지 확인
            if (mainCat.equals(currentCategory)) {
                currentMainCategory = mainCat;
                found = true;
                break;
            }
            
            // 서브 카테고리들 확인
            Map<String, List<String>> subCats = categoryHierarchy.get(mainCat);
            for (String subCat : subCats.keySet()) {
                // 서브 카테고리와 일치하는지 확인
                if (subCat.equals(currentCategory)) {
                    currentMainCategory = mainCat;
                    currentSubCategory = subCat;
                    found = true;
                    break;
                }
                
                // 세부 카테고리들 확인
                List<String> detailCats = subCats.get(subCat);
                for (String detailCat : detailCats) {
                    // 세부 카테고리와 일치하는지 확인
                    if (detailCat.equals(currentCategory)) {
                        currentMainCategory = mainCat;
                        currentSubCategory = subCat;
                        currentDetailCategory = detailCat;
                        found = true;
                        break;
                    }
                }
                
                if (found) break;
            }
            
            if (found) break;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= pageTitle %> | everyWEAR 관리자</title>
    <link rel="stylesheet" href="css/admin_product_edit.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- 헤더 포함 -->
    <jsp:include page="/includes/admin_header.jsp" />
    
    <main>
        <div class="container">
        <h2><%= pageTitle %></h2>
            
        <!-- 상태 메시지 표시 영역 -->
        <% if (status != null && "success".equals(status)) { %>
        <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px; border: 1px solid #c3e6cb;">
            <strong>성공!</strong> <%= message != null ? message : "작업이 성공적으로 완료되었습니다." %>
        </div>
        <% } else if (error != null) { %>
        <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 15px; border-radius: 5px; border: 1px solid #f5c6cb;">
            <strong>오류!</strong> <%= error.equals("insertFailed") ? "상품 등록에 실패했습니다." : 
                       error.equals("updateFailed") ? "상품 수정에 실패했습니다." : 
                       error.equals("detailInsertFailed") ? "상품 상세 정보 등록에 실패했습니다." : 
                       error.equals("detailDeleteFailed") ? "상품 상세 정보 삭제에 실패했습니다." : 
                       error %>
        </div>
        <% } %>
            
        <form action="ProductServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="<%= mode.equals("edit") ? "update" : "insert" %>" />
            <input type="hidden" name="adminCsrfToken" value="<%= session.getAttribute("adminCsrfToken") %>" />
            <% if (mode.equals("edit")) { %>
                <input type="hidden" name="id" value="<%= product.getP_id() %>" />
            <% } %>

                <!-- 기본 정보 섹션 -->
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-info-circle"></i> 기본 정보</h3>

            <div class="form-group">
                <div class="form-row" style="display: flex; gap: 20px; width: 100%;">
                    <div style="flex: 1;">
                        <label>상품 번호</label>
                        <input type="number" name="p_id" value="<%= product.getP_id() > 0 ? product.getP_id() : "" %>" 
                               placeholder="상품 번호" 
                               style="width: 100%; box-sizing: border-box;" />
                        <small style="display: block; margin-top: 5px; font-size: 11px; color: #666;">* 입력하지 않으면 자동으로 부여됩니다.</small>
                    </div>
                    <div style="flex: 2;">
                        <label class="required">상품명</label>
                        <input type="text" name="p_name" value="<%= product.getP_name() != null ? product.getP_name() : "" %>" 
                               maxlength="30" required placeholder="30자 이내로 입력해주세요." 
                               style="width: 100%; box-sizing: border-box;" />
                    </div>
                </div>
            </div>

                    <!-- 카테고리 선택 (상위/하위/세부) -->
                <div class="form-group">
                        <label class="required">카테고리</label>
                        <div class="category-selection" style="display: flex; justify-content: space-between; gap: 10px;">
                            <div style="flex: 1;">
                                <label style="display: block; margin-bottom: 5px; font-size: 12px; color: #555;">상위 카테고리</label>
                                <select id="mainCategory" name="mainCategory" required onchange="updateSubCategories()" style="width: 100%;">
                                    <option value="">선택하세요</option>
                                    <% for (String mainCat : categoryHierarchy.keySet()) { %>
                                        <option value="<%= mainCat %>" <%= mainCat.equals(currentMainCategory) ? "selected" : "" %>><%= mainCat %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div style="flex: 1;">
                                <label style="display: block; margin-bottom: 5px; font-size: 12px; color: #555;">하위 카테고리</label>
                                <select id="subCategory" name="subCategory" onchange="updateDetailCategories()" style="width: 100%;">
                                    <option value="">선택하세요</option>
                                </select>
                            </div>
                            <div style="flex: 1;">
                                <label style="display: block; margin-bottom: 5px; font-size: 12px; color: #555;">세부 카테고리</label>
                                <select id="detailCategory" name="detailCategory" onchange="updateFinalCategory()" style="width: 100%;">
                                    <option value="">선택하세요</option>
                                </select>
                                <!-- 실제 카테고리 값을 저장할 히든 필드 추가 -->
                                <input type="hidden" id="p_category" name="p_category" value="<%= product.getP_category() != null ? product.getP_category() : "" %>">
                            </div>
                        </div>
                    </div>
                    
                    <!-- 색상, 가격, 할인율 -->
                <div class="form-group">
                        <div class="form-row" style="display: flex; justify-content: space-between; gap: 20px; width: 100%;">
                            <!-- 색상 -->
                            <div style="flex: 1;">
                                <label style="display: block; margin-bottom: 5px;">색상</label>
                                <input type="text" name="p_color" value="<%= product.getP_color() != null ? product.getP_color() : "" %>" 
                                       placeholder="대문자로 입력, ex: BLACK" style="width: 100%; text-transform: uppercase; box-sizing: border-box;" />
                                <small style="display: block; margin-top: 5px; font-size: 11px; color: #666;">* 현재 색상: <%= product.getP_color() != null ? product.getP_color() : "정보 없음" %></small>
                            </div>

                            <!-- 판매 가격 -->
                            <div style="flex: 1;">
                                <label class="required" style="display: block; margin-bottom: 5px;">판매가격</label>
                                <input type="number" name="p_price" id="price" 
                                       value="<%= product.getP_price() > 0 ? product.getP_price() : "" %>" 
                                       required placeholder="판매가 입력" min="0" 
                                       onchange="calculateFinalPrice()" onkeyup="calculateFinalPrice()" 
                                       style="width: 100%; box-sizing: border-box;" />
                            </div>
                            
                            <!-- 할인율 -->
                            <div style="flex: 1;">
                                <label style="display: block; margin-bottom: 5px;">할인율</label>
                                <input type="number" name="p_disc" id="discount" 
                                       value="<%= product.getP_disc() > 0 ? product.getP_disc() : "0" %>" 
                                       placeholder="%" min="0" max="100" 
                                       onchange="calculateFinalPrice()" onkeyup="calculateFinalPrice()" 
                                       style="width: 100%; box-sizing: border-box;" />
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 사이즈 및 재고 섹션과 상품 설명 섹션을 감싸는 컨테이너 -->
                <div style="display: flex; gap: 20px; margin-bottom: 30px;">
                    <!-- 사이즈 및 재고 섹션 -->
                    <div class="form-section" style="flex: 3.5; margin-bottom: 0; padding-bottom: 0; border-bottom: none;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <h3 class="section-title"><i class="fas fa-box"></i> 사이즈 및 재고</h3>
                            <button type="button" class="add-size-btn" onclick="addSize()" style="width: auto; padding: 0 10px; white-space: nowrap;">+ 사이즈 추가</button>
                        </div>
                        
                        <div class="size-stock-container" id="sizeStockContainer" style="padding: 16px; background-color: #f9fafc; border-radius: 8px;">
                            <% 
                            // 기존 상품 상세 정보가 있는 경우 표시
                            if (mode.equals("edit") && productDetails != null && !productDetails.isEmpty()) {
                                for (ProductDetailDTO detail : productDetails) {
                            %>
                            <div class="size-stock-row" style="display: flex; align-items: center; margin-bottom: 14px; gap: 12px;">
                                <div class="size-input" style="flex: 1;">
                                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #444; font-weight: 500;">사이즈</label>
                                    <select name="sizes[]" style="width: 100%; box-sizing: border-box; height: 38px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px;">
                                        <option value="">사이즈 선택</option>
                                        <option value="XS" <%= "XS".equals(detail.getPd_size()) ? "selected" : "" %>>XS</option>
                                        <option value="S" <%= "S".equals(detail.getPd_size()) ? "selected" : "" %>>S</option>
                                        <option value="M" <%= "M".equals(detail.getPd_size()) ? "selected" : "" %>>M</option>
                                        <option value="L" <%= "L".equals(detail.getPd_size()) ? "selected" : "" %>>L</option>
                                        <option value="XL" <%= "XL".equals(detail.getPd_size()) ? "selected" : "" %>>XL</option>
                                        <option value="XXL" <%= "XXL".equals(detail.getPd_size()) ? "selected" : "" %>>XXL</option>
                                        <option value="FREE" <%= "FREE".equals(detail.getPd_size()) ? "selected" : "" %>>FREE</option>
                                    </select>
                                </div>
                                <div class="stock-input" style="flex: 1.5;">
                                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #444; font-weight: 500;">재고 수량</label>
                                    <input type="number" name="stocks[]" placeholder="재고 수량" min="0" value="<%= detail.getPd_stock() %>" style="width: 100%; box-sizing: border-box; height: 38px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px;" />
                                </div>
                                <button type="button" class="remove-size-btn" onclick="removeSize(this)" style="margin-top: 26px; height: 38px; width: 38px; border-radius: 4px; background-color: #fff2f0; color: #ff4d4f; font-size: 16px; border: none;">-</button>
                            </div>
                            <% 
                                }
                            } else { 
                            // 새 상품 등록인 경우 기본 입력란 표시
                            %>
                            <div class="size-stock-row" style="display: flex; align-items: center; margin-bottom: 14px; gap: 12px;">
                                <div class="size-input" style="flex: 1;">
                                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #444; font-weight: 500;">사이즈</label>
                                    <select name="sizes[]" style="width: 100%; box-sizing: border-box; height: 38px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px;">
                                        <option value="">사이즈 선택</option>
                                        <option value="XS">XS</option>
                                        <option value="S">S</option>
                                        <option value="M">M</option>
                                        <option value="L">L</option>
                                        <option value="XL">XL</option>
                                        <option value="XXL">XXL</option>
                                        <option value="FREE">FREE</option>
                                    </select>
                                </div>
                                <div class="stock-input" style="flex: 1.5;">
                                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #444; font-weight: 500;">재고 수량</label>
                                    <input type="number" name="stocks[]" placeholder="재고 수량" min="0" style="width: 100%; box-sizing: border-box; height: 38px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px;" />
                                </div>
                                <button type="button" class="remove-size-btn" onclick="removeSize(this)" style="margin-top: 26px; height: 38px; width: 38px; border-radius: 4px; background-color: #fff2f0; color: #ff4d4f; font-size: 16px; border: none;">-</button>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- 상품 설명 섹션 -->
                    <div class="form-section" style="flex: 6.5; margin-bottom: 0; padding-bottom: 0; border-bottom: none;">
                        <h3 class="section-title"><i class="fas fa-file-alt"></i> 상품 설명</h3>
                        
                <div class="form-group">
                            <label class="required">상세 설명</label>
                            <textarea name="p_text" required placeholder="상품에 대한 상세 설명을 입력해주세요." style="height: 400px;"><%= product.getP_text() != null ? product.getP_text().replace("<br>", "\n") : "" %></textarea>
                        </div>
                    </div>
                </div>
                
                <!-- 이미지 업로드 섹션 -->
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-images"></i> 상품 이미지</h3>
                    
                    <div class="form-group" style="display: flex; gap: 20px;">
                        <!-- 대표 이미지 업로드 영역 (작게 조정) -->
                        <div style="flex: 1; max-width: 220px;">
                            <label class="img-upload-label">대표 이미지</label>
                            <div class="img-upload-container" style="padding: 15px; border-radius: 8px; border: 1px solid #eee; background-color: #fafafa;">
                                <div class="img-upload-box">
                                    <input type="file" name="main_image" accept="image/*" onchange="previewImage(this)" />
                                    <% 
                                    // 기존 대표 이미지가 있는 경우 표시
                                    String mainImageUrl = null;
                                    if (mode.equals("edit") && productImages != null) {
                                        for (ProductImgDTO img : productImages) {
                                            if (img.getPi_orders() == 1) { // 대표 이미지는 orders가 1
                                                mainImageUrl = img.getPi_url();
                                                break;
                                            }
                                        }
                                    }                                                     
                                    
                                    if (mainImageUrl != null) {
                                    %>
                                    <img src="<%= mainImageUrl %>" class="img-preview" style="max-width: 100%; max-height: 150px;" />
                                    <% } else { %>
                                    <i class="fas fa-plus"></i>
                                    <span>메인 상품 이미지</span>
                                    <% } %>
                                </div>
                            </div>
                            <p style="margin-top: 8px; font-size: 12px; color: #666;">* 상품 목록에 표시되는 대표 이미지입니다.</p>
                        </div>
                        
                        <!-- 상세 이미지 업로드 영역 (넓게 조정) -->
                        <div style="flex: 4;">
                            <label class="img-upload-label">상세 이미지 (여러 장 선택 가능)</label>
                            <div class="img-upload-container" style="padding: 15px; border-radius: 8px; border: 1px solid #eee; background-color: #fafafa; overflow-x: auto;">
                                <div style="display: flex; flex-wrap: wrap; gap: 15px; padding-bottom: 5px; align-items: flex-start;">
                                    <div class="img-upload-box">
                                        <input type="file" name="detail_image[]" accept="image/*" multiple onchange="previewMultipleImages(this)" />
                                        <i class="fas fa-plus"></i>
                                        <span>상세 상품 이미지</span>
                                    </div>
                                    <div id="detail-images-preview" style="display: flex; flex-wrap: wrap; gap: 15px;">
                                        <% 
                                        // 기존 상세 이미지가 있는 경우 표시
                                        if (mode.equals("edit") && productImages != null) {
                                            for (ProductImgDTO img : productImages) {
                                                if (img.getPi_orders() > 1) { // 상세 이미지는 orders가 2 이상
                                        %>
                                        <div class="img-preview-item" style="position: relative; width: 150px; height: 150px; display: inline-block;">
                                            <img src="<%= img.getPi_url() %>" class="img-preview" style="width: 100%; height: 100%; object-fit: cover; border-radius: 4px; border: 1px solid #eee;" />
                                            <input type="hidden" name="existing_images[]" value="<%= img.getPi_id() %>" />
                                        </div>
                                        <% 
                                                }
                                            }
                                        }
                                        %>
                                    </div>
                                </div>
                            </div>
                            <p style="margin-top: 8px; font-size: 12px; color: #666;">* 상품 상세 페이지에 표시되는 이미지입니다. 여러 장을 선택하면 옆으로 표시되고 공간이 부족하면 아래로 표시됩니다.</p>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn-submit"><%= mode.equals("edit") ? "상품 수정하기" : "상품 등록하기" %></button>
            </form>
            </div>
    </main>
    
    <!-- 푸터 포함 -->
    <jsp:include page="/includes/admin_footer.jsp" />
    
    <script>
        // 카테고리 데이터를 JavaScript 객체로 변환
        const categoryData = {
            <% 
            boolean isFirst = true;
            for (String mainCat : categoryHierarchy.keySet()) {
                if (!isFirst) { out.print(","); } 
                isFirst = false;
            %>
            "<%= mainCat %>": {
                <% 
                Map<String, List<String>> subCategories = categoryHierarchy.get(mainCat);
                boolean isFirstSub = true;
                for (String subCat : subCategories.keySet()) {
                    if (!isFirstSub) { out.print(","); } 
                    isFirstSub = false;
                %>
                "<%= subCat %>": [
                    <% 
                    List<String> detailCategories = subCategories.get(subCat);
                    boolean isFirstDetail = true;
                    for (String detailCat : detailCategories) {
                        if (!isFirstDetail) { out.print(","); } 
                        isFirstDetail = false;
                    %>
                    "<%= detailCat %>"
                    <% } %>
                ]
                <% } %>
            }
            <% } %>
        };
        
        // 상위 카테고리 변경 시 하위 카테고리 업데이트
        function updateSubCategories() {
            const mainCategory = document.getElementById('mainCategory').value;
            const subCategorySelect = document.getElementById('subCategory');
            const detailCategorySelect = document.getElementById('detailCategory');
            
            // 하위 카테고리와 세부 카테고리 초기화
            subCategorySelect.innerHTML = '<option value="">하위 카테고리</option>';
            detailCategorySelect.innerHTML = '<option value="">세부 카테고리(선택)</option>';
            
            // p_category 값 업데이트
            updateFinalCategory();
            
            if (mainCategory && categoryData[mainCategory]) {
                const subCategories = Object.keys(categoryData[mainCategory]);
                subCategories.forEach(subCategory => {
                    const option = document.createElement('option');
                    option.value = subCategory;
                    option.textContent = subCategory;
                    subCategorySelect.appendChild(option);
                });
            }
        }
        
        // 하위 카테고리 변경 시 세부 카테고리 업데이트
        function updateDetailCategories() {
            const mainCategory = document.getElementById('mainCategory').value;
            const subCategory = document.getElementById('subCategory').value;
            const detailCategorySelect = document.getElementById('detailCategory');
            
            // 세부 카테고리 초기화
            detailCategorySelect.innerHTML = '<option value="">세부 카테고리(선택)</option>';
            
            // p_category 값 업데이트
            updateFinalCategory();
            
            if (mainCategory && subCategory && 
                categoryData[mainCategory] && 
                categoryData[mainCategory][subCategory]) {
                
                const detailCategories = categoryData[mainCategory][subCategory];
                detailCategories.forEach(detailCategory => {
                    const option = document.createElement('option');
                    option.value = detailCategory;
                    option.textContent = detailCategory;
                    detailCategorySelect.appendChild(option);
                });
            }
        }
        
        // 최종 카테고리 값 업데이트 (가장 하위 카테고리 선택)
        function updateFinalCategory() {
            const mainCategory = document.getElementById('mainCategory').value;
            const subCategory = document.getElementById('subCategory').value;
            const detailCategory = document.getElementById('detailCategory').value;
            const categoryInput = document.getElementById('p_category');
            
            // 가장 하위 카테고리를 p_category에 저장
            if (detailCategory) {
                // 세부 카테고리가 선택된 경우
                categoryInput.value = detailCategory;
            } else if (subCategory) {
                // 하위 카테고리까지만 선택된 경우
                categoryInput.value = subCategory;
            } else if (mainCategory) {
                // 상위 카테고리만 선택된 경우
                categoryInput.value = mainCategory;
            } else {
                // 아무것도 선택되지 않은 경우
                categoryInput.value = '';
            }
            
            console.log("최종 카테고리 값:", categoryInput.value);
        }
        
        // 사이즈/재고 관련 스크립트
        function addSize() {
            const container = document.getElementById('sizeStockContainer');
            const newRow = document.createElement('div');
            newRow.className = 'size-stock-row';
            newRow.style.display = 'flex';
            newRow.style.alignItems = 'center';
            newRow.style.marginBottom = '14px';
            newRow.style.gap = '12px';
            
            newRow.innerHTML = `
                <div class="size-input" style="flex: 1;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #444; font-weight: 500;">사이즈</label>
                    <select name="sizes[]" style="width: 100%; box-sizing: border-box; height: 38px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px;">
                        <option value="">사이즈 선택</option>
                        <option value="XS">XS</option>
                        <option value="S">S</option>
                        <option value="M">M</option>
                        <option value="L">L</option>
                        <option value="XL">XL</option>
                        <option value="XXL">XXL</option>
                        <option value="FREE">FREE</option>
                    </select>
                </div>
                <div class="stock-input" style="flex: 1.5;">
                    <label style="display: block; margin-bottom: 6px; font-size: 13px; color: #444; font-weight: 500;">재고 수량</label>
                    <input type="number" name="stocks[]" placeholder="재고 수량" min="0" style="width: 100%; box-sizing: border-box; height: 38px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px;" />
                </div>
                <button type="button" class="remove-size-btn" onclick="removeSize(this)" style="margin-top: 26px; height: 38px; width: 38px; border-radius: 4px; background-color: #fff2f0; color: #ff4d4f; font-size: 16px; border: none;">-</button>
            `;
            container.appendChild(newRow);
        }
        
        function removeSize(button) {
            const container = document.getElementById('sizeStockContainer');
            if (container.children.length > 1) {
                const row = button.parentNode;
                container.removeChild(row);
            } else {
                alert('최소 하나의 사이즈/재고 정보는 필요합니다.');
            }
        }
        
        // 가격 계산 스크립트 - final-price 제거
        function calculateFinalPrice() {
            // 빈 함수로 유지 (이벤트 핸들러에 연결되어 있으므로 완전히 제거하지 않음)
            // final-price 요소가 제거되었으므로 관련 로직도 제거
        }
        
        // 이미지 미리보기
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const uploadBox = input.parentNode;
                    
                    // 기존 내용 삭제
                    while (uploadBox.firstChild) {
                        uploadBox.removeChild(uploadBox.firstChild);
                    }
                    
                    // 파일 입력 요소 다시 추가
                    uploadBox.appendChild(input);
                    
                    // 이미지 미리보기 추가
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'img-preview';
                    uploadBox.appendChild(img);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // 이미지 미리보기 함수 추가
        function previewMultipleImages(input) {
            const previewContainer = document.getElementById('detail-images-preview');
            
            if (input.files) {
                // 기존 미리보기 이미지 제거
                while (previewContainer.firstChild) {
                    previewContainer.removeChild(previewContainer.firstChild);
                }
                
                // 각 파일에 대한 미리보기 생성
                for (let i = 0; i < input.files.length; i++) {
                    const file = input.files[i];
                    const reader = new FileReader();
                    
                    reader.onload = function(e) {
                        const imgContainer = document.createElement('div');
                        imgContainer.className = 'img-preview-item';
                        imgContainer.style.position = 'relative';
                        imgContainer.style.width = '150px';
                        imgContainer.style.height = '150px';
                        imgContainer.style.display = 'inline-block';
                        
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'img-preview';
                        img.style.width = '100%';
                        img.style.height = '100%';
                        img.style.objectFit = 'cover';
                        img.style.borderRadius = '4px';
                        img.style.border = '1px solid #eee';
                        
                        const removeBtn = document.createElement('button');
                        removeBtn.type = 'button';
                        removeBtn.innerHTML = '×';
                        removeBtn.style.position = 'absolute';
                        removeBtn.style.top = '5px';
                        removeBtn.style.right = '5px';
                        removeBtn.style.background = 'rgba(255, 0, 0, 0.7)';
                        removeBtn.style.color = 'white';
                        removeBtn.style.border = 'none';
                        removeBtn.style.borderRadius = '50%';
                        removeBtn.style.width = '24px';
                        removeBtn.style.height = '24px';
                        removeBtn.style.cursor = 'pointer';
                        removeBtn.style.fontSize = '16px';
                        removeBtn.style.display = 'flex';
                        removeBtn.style.justifyContent = 'center';
                        removeBtn.style.alignItems = 'center';
                        
                        removeBtn.onclick = function() {
                            previewContainer.removeChild(imgContainer);
                            // 파일 선택을 초기화하는 방법 (선택적)
                            if (previewContainer.children.length === 0) {
                                input.value = '';
                            }
                        };
                        
                        imgContainer.appendChild(img);
                        imgContainer.appendChild(removeBtn);
                        previewContainer.appendChild(imgContainer);
                    };
                    
                    reader.readAsDataURL(file);
                }
            }
        }
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log("페이지 로드됨, 카테고리 초기화 시작");
            
            // 카테고리 초기화
            const mainCategory = document.getElementById('mainCategory').value;
            if (mainCategory) {
                console.log("상위 카테고리:", mainCategory);
                updateSubCategories();
                
                // 하위 카테고리 선택 (기존 값 사용)
                const subCat = "<%= currentSubCategory %>";
                if (subCat) {
                    console.log("하위 카테고리:", subCat);
                    setTimeout(() => {
                        // 드롭다운에서 해당 값 선택
                        const subSelect = document.getElementById('subCategory');
                        for (let i = 0; i < subSelect.options.length; i++) {
                            if (subSelect.options[i].value === subCat) {
                                subSelect.selectedIndex = i;
                                break;
                            }
                        }
                        
                        // 세부 카테고리 업데이트
                        updateDetailCategories();
                        
                        // 세부 카테고리 선택 (기존 값 사용)
                        const detailCat = "<%= currentDetailCategory %>";
                        if (detailCat) {
                            console.log("세부 카테고리:", detailCat);
                            setTimeout(() => {
                                // 드롭다운에서 해당 값 선택
                                const detailSelect = document.getElementById('detailCategory');
                                for (let i = 0; i < detailSelect.options.length; i++) {
                                    if (detailSelect.options[i].value === detailCat) {
                                        detailSelect.selectedIndex = i;
                                        break;
                                    }
                                }
                                
                                // 최종 카테고리 값 설정
                                updateFinalCategory();
                            }, 100);
                        } else {
                            updateFinalCategory();
                        }
                    }, 100);
                } else {
                    updateFinalCategory();
                }
            } else {
                updateFinalCategory();
            }
            
            // 가격 계산 초기화
            calculateFinalPrice();
        });
    </script>
</body>
</html>



