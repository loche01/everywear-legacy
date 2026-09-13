<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.DecimalFormat, java.util.Map" %>
<%@ page import="DTO.ProductDTO, DTO.ProductDetailDTO, DAO.ProductDAO, DAO.CategoryDAO" %>

<%
    // 요청 인코딩 강제 설정
    request.setCharacterEncoding("UTF-8");

    // 상태 메시지 처리
    String status = (String) request.getAttribute("status");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    
    // 파라미터로 전달된 경우도 처리
    if (status == null) status = request.getParameter("status");
    if (message == null) message = request.getParameter("message");
    if (error == null) error = request.getParameter("error");

    // 디버깅용 로그 추가
    System.out.println("==== 관리자 상품 목록 페이지 요청 정보 ====");
    System.out.println("category 파라미터: " + request.getParameter("category"));
    System.out.println("topCategory 파라미터: " + request.getParameter("topCategory"));
    System.out.println("middleCategory 파라미터: " + request.getParameter("middleCategory"));
    System.out.println("subCategory 파라미터: " + request.getParameter("subCategory"));
    System.out.println("상태 메시지: " + status + ", " + message);
    System.out.println("오류 메시지: " + error);
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

    request.setAttribute("currentMenu", "product");
    request.setAttribute("subMenu", "product_list");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 관리 | everyWEAR 관리자</title>
    <link rel="icon" type="image/png" href="images/fav-icon.png">
    <link rel="stylesheet" href="css/admin_product_list.css">
</head>

<body>
<jsp:include page="/includes/admin_header.jsp" />

<main>
    <div class="container">
        <h2>상품 관리</h2>

        <!-- 상태 메시지 표시 영역 -->
        <% if (status != null && "success".equals(status)) { %>
        <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px; border: 1px solid #c3e6cb;">
            <strong>성공!</strong> <%= message != null ? message : "작업이 성공적으로 완료되었습니다." %>
        </div>
        <% } else if (error != null) { %>
        <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 15px; border-radius: 5px; border: 1px solid #f5c6cb;">
            <strong>오류!</strong> <%= error %>
        </div>
        <% } %>

        <div class="product-list-container">
            <!-- 검색 필터 폼을 상단으로 이동 -->
            <form method="get" class="filter-form" style="margin: 0 0 15px 0; background: none; box-shadow: none; padding: 0; flex-wrap: wrap;" onsubmit="return setCategoryValue()">
                <div style="width: 100%; display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px; margin-bottom: 15px;">
                    <!-- 첫 번째 열 -->
                    <!-- 사이즈 필터 -->
                    <div style="background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                        <label for="size" style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">사이즈 선택</label>
                        <select id="size" name="size" style="width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;">
                <option value="">전체 사이즈</option>
                            <option value="XS" <%= "XS".equals(selectedSize) ? "selected" : "" %>>XS</option>
                <option value="S" <%= "S".equals(selectedSize) ? "selected" : "" %>>S</option>
                <option value="M" <%= "M".equals(selectedSize) ? "selected" : "" %>>M</option>
                <option value="L" <%= "L".equals(selectedSize) ? "selected" : "" %>>L</option>
                            <option value="XL" <%= "XL".equals(selectedSize) ? "selected" : "" %>>XL</option>
                            <option value="XXL" <%= "XXL".equals(selectedSize) ? "selected" : "" %>>XXL</option>
                <option value="FREE" <%= "FREE".equals(selectedSize) ? "selected" : "" %>>FREE</option>
            </select>
                    </div>
                    
                    <!-- 재고 상태 필터 -->
                    <div style="background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                        <label for="stockStatus" style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">재고 상태</label>
                        <select id="stockStatus" name="stockStatus" style="width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;">
                            <option value="">모든 상품</option>
                            <option value="instock" <%= "instock".equals(request.getParameter("stockStatus")) ? "selected" : "" %>>재고 있음</option>
                            <option value="lowstock" <%= "lowstock".equals(request.getParameter("stockStatus")) ? "selected" : "" %>>품절 임박 (15개 이하)</option>
                            <option value="outofstock" <%= "outofstock".equals(request.getParameter("stockStatus")) ? "selected" : "" %>>품절</option>
                        </select>
                    </div>
                    
                    <!-- 할인 적용 여부 필터 -->
                    <div style="background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                        <label for="discount" style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">할인 적용 여부</label>
                        <select id="discount" name="discount" style="width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;">
                            <option value="">모든 상품</option>
                            <option value="yes" <%= "yes".equals(request.getParameter("discount")) ? "selected" : "" %>>할인 상품만</option>
                            <option value="no" <%= "no".equals(request.getParameter("discount")) ? "selected" : "" %>>정상가 상품만</option>
                        </select>
                    </div>
                    
                    <!-- 두 번째 열 -->
                    <!-- 카테고리 필터 -->
                    <div style="background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                        <label for="topCategory" style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">카테고리 선택</label>
                        
                        <!-- 최상위 카테고리 선택 -->
                        <select id="topCategory" name="topCategory" style="width: 100%; box-sizing: border-box; margin-bottom: 8px; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;" onchange="updateMiddleCategories();">
                            <option value="">전체 카테고리</option>
                            <% 
                            // 최상위 카테고리 표시
                            for (String topCategory : categoryHierarchy.keySet()) { 
                                String selected = "";
                                if (category != null) {
                                    if (category.equals(topCategory) || 
                                        category.startsWith(topCategory + "/")) {
                                        selected = "selected";
                                    }
                                }
                            %>
                                <option value="<%= topCategory %>" <%= selected %>><%= topCategory %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <!-- 중간 카테고리 선택 -->
                    <div style="background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                        <label for="middleCategory" style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">하위 카테고리</label>
                        <select id="middleCategory" name="middleCategory" style="width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;" onchange="updateSubCategories();">
                            <option value="">- 하위 카테고리 선택 -</option>
                        </select>
                    </div>
                    
                    <!-- 최하위 카테고리 선택 -->
                    <div style="background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                        <label for="subCategory" style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">세부 카테고리</label>
                        <select id="subCategory" name="subCategory" style="width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;" onchange="setCategoryValue();">
                            <option value="">- 세부 카테고리 선택 -</option>
                        </select>
                        
                        <!-- 실제 카테고리 값을 저장할 히든 필드 -->
                        <input type="hidden" id="category" name="category" value="<%= category != null ? category : "" %>">
                    </div>
                    
                    <!-- 세 번째 열 -->
                    <!-- 검색어 필터, 가격 범위, 검색 버튼을 한 줄에 배치 -->
                    <div style="grid-column: 1 / span 3; display: flex; gap: 12px; margin-top: 10px;">
                        <!-- 검색어 필터 (상품명 또는 코드) -->
                        <div style="flex: 2; background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                            <label for="keyword" style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">상품명 또는 코드 검색</label>
                            <input type="text" id="keyword" name="keyword" placeholder="상품명 또는 코드 검색" value="<%= keyword != null ? keyword : "" %>" style="width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;">
                        </div>
                        
                        <!-- 가격 범위 필터 -->
                        <div style="flex: 2; background-color: #ffffff; border-radius: 8px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.06);">
                            <label style="display: block; margin-bottom: 8px; font-size: 14px; color: #333; font-weight: 600;">가격 범위</label>
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <input type="number" name="minPrice" placeholder="최소 가격" value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>" style="width: 45%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;">
                                <span style="font-size: 14px; color: #666; font-weight: 600;">~</span>
                                <input type="number" name="maxPrice" placeholder="최대 가격" value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "" %>" style="width: 45%; box-sizing: border-box; padding: 10px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; transition: border-color 0.2s; background-color: #fafafa;">
                            </div>
                        </div>
                        
                        <!-- 검색 버튼 -->
                        <div style="flex: 1; display: flex; flex-direction: column; justify-content: flex-end; gap: 8px;">
                            <button type="submit" style="height: 38px; width: 100%; font-weight: 600; font-size: 14px; background-color: #0a2963; color: white; border-radius: 6px; border: none; cursor: pointer; transition: all 0.2s; box-shadow: 0 1px 3px rgba(10, 41, 99, 0.2);">검색</button>
                            <button type="button" onclick="resetFilters()" style="height: 38px; width: 100%; background-color: #f5f5f5; color: #333; border: 1px solid #e0e0e0; font-weight: 600; border-radius: 6px; cursor: pointer; transition: all 0.2s; font-size: 14px;">초기화</button>
                        </div>
                    </div>
                </div>
        </form>

            <!-- 정렬 옵션과 총 상품 개수를 포함하는 상단 행 -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                <!-- 총 상품 개수 라벨 - 왼쪽 배치 -->
                <div style="font-size: 16px; color: #333; font-weight: 500;">
                    <span>총 <b style="color: #0a2963; font-size: 18px;"><%= totalProducts %></b>개의 상품이 있습니다.</span>
                </div>
                
                <!-- 정렬 옵션 - 오른쪽 배치 -->
                <div class="sort-container" style="margin: 0;">
                    <div class="sort-label">정렬:</div>
                    <form id="sortForm" method="get" style="display: flex; align-items: center; gap: 10px;">
                        <!-- 히든 필드로 현재 페이지 정보와 검색 조건 유지 -->
                        <input type="hidden" name="page" value="<%= currentPage %>">
                        <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>">
                        <input type="hidden" name="size" value="<%= selectedSize != null ? selectedSize : "" %>">
                        <input type="hidden" name="category" value="<%= category != null ? category : "" %>">
                        <input type="hidden" name="minPrice" value="<%= minPrice != null ? minPrice : "" %>">
                        <input type="hidden" name="maxPrice" value="<%= maxPrice != null ? maxPrice : "" %>">
                        <input type="hidden" name="stockStatus" value="<%= stockStatus != null ? stockStatus : "" %>">
                        <input type="hidden" name="discount" value="<%= discount != null ? discount : "" %>">
                        
                        <select name="sortBy" class="sort-select" onchange="this.form.submit()">
                            <option value="p_id" <%= "p_id".equals(sortBy) ? "selected" : "" %>>등록순</option>
                            <option value="p_name" <%= "p_name".equals(sortBy) ? "selected" : "" %>>이름순</option>
                            <option value="p_price" <%= "p_price".equals(sortBy) ? "selected" : "" %>>가격순</option>
                            <option value="p_disc" <%= "p_disc".equals(sortBy) ? "selected" : "" %>>할인순</option>
                        </select>
                        
                        <a href="?sortBy=<%= sortBy %>&sortOrder=<%= "asc".equals(sortOrder) ? "desc" : "asc" %><%= paginationParams.substring(paginationParams.indexOf("&keyword")) %>" 
                           class="sort-direction" title="정렬 방향 변경">
                            <% if ("asc".equals(sortOrder)) { %>
                                <span>▲</span>
                            <% } else { %>
                                <span>▼</span>
                            <% } %>
                        </a>
                    </form>
                </div>
            </div>

            <% if (productList == null || productList.isEmpty()) { %>
                <div class="no-products">등록된 상품이 없습니다.</div>
            <% } else {
                for (ProductDTO product : productList) {
                    String imageUrl = productDAO.getProductMainImage(product.getP_id());
                    if (imageUrl == null || imageUrl.isEmpty()) {
                        imageUrl = "images/product-placeholder.svg";
                    }
                    List<ProductDetailDTO> details = productDAO.getProductDetails(product.getP_id());
            %>
				<div class="product-item">
					<!-- 상품 이미지 -->
					<img src="<%=imageUrl%>" class="product-image" alt="상품 이미지" />

					<!-- 상품 정보 -->
					<div class="product-content">
						<!-- 상품 상단 메타 정보 -->
						<div class="product-meta">
							<div class="product-id">
								#상품번호 - <%=product.getP_id()%></div>
							<div class="product-date">
								등록일:
								<%=product.getCreated_at() != null ? product.getCreated_at() : "정보 없음"%></div>
						</div>

						<!-- 상품명과 가격 같은 줄에 표시 -->
						<div class="product-name-price">
							<div class="product-name"><%=product.getP_name()%></div>
							<div style="display: flex; flex-direction: column; align-items: flex-end;">
								<div class="product-price"><%= priceFormat.format(product.getP_price()) %>원</div>
							</div>
						</div>

						<!-- 카테고리 정보와 할인 정보 같은 줄에 표시 -->
						<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
							<div class="product-category" style="margin-bottom: 0;">
								카테고리 :
							<%=product.getP_category().replace("/", " > ")%>
							</div>
							
							<!-- 할인 정보 표시 -->
							<div class="discount-info" style="font-size: 12px; color: #e53935; font-weight: bold;">
								<% if(product.getP_disc() > 0) { %>
									<span><%= product.getP_disc() %>% 할인중</span>
								<% } else { %>
									<span style="color: #999;">할인정보 없음</span>
								<% } %>
							</div>
						</div>

						<!-- 재고 + 버튼 한 줄에 정렬 -->
						<div class="product-stock-row"
							style="display: flex; justify-content: space-between; align-items: center; margin-top: 8px;">

							<div class="product-stock"
								style="display: flex; align-items: center;">
								<span style="margin-right: 6px;">재고:</span>
								<div class="stock-badges">
									<%
									// 사이즈 순서를 정의
									String[] sizeOrder = {"XS", "S", "M", "L", "XL", "XXL", "FREE"};
									
									// 사이즈 순서대로 재고 정보를 표시
									for (String size : sizeOrder) {
									for (ProductDetailDTO d : details) {
											if (d.getPd_size().equalsIgnoreCase(size)) {
												String badgeClass = "stock-badge";
												if (d.getPd_stock() <= 0) {
													badgeClass = "stock-badge out-of-stock";
												} else if (d.getPd_stock() <= 15) {
													badgeClass = "stock-badge low-stock";
												}
									%>
									<span class="<%=badgeClass%>"><%=d.getPd_size()%> : <%=d.getPd_stock()%>개</span>
									<%
											}
										}
									}
									%>
								</div>
							</div>

							<div style="display: flex; align-items: center; gap: 15px;">
							<div class="product-actions-inline">
								<button class="action-button edit-button"
									onclick="location.href='admin_product_edit.jsp?id=<%=product.getP_id()%>'">수정</button>
								<button class="action-button delete-button"
									onclick="deleteProduct('<%=product.getP_id()%>')">삭제</button>
								</div>
							</div>
						</div>

					</div>
				</div>


			
				<% } } %>

            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="?page=1<%= paginationParams %>" class="pagination-link">맨앞</a>
                    <a href="?page=<%= currentPage - 1 %><%= paginationParams %>" class="pagination-link">이전</a>
                <% } else { %>
                    <span class="pagination-link disabled">맨앞</span>
                    <span class="pagination-link disabled">이전</span>
                <% } %>
                
                <% 
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, startPage + 4);
                
                for (int i = startPage; i <= endPage; i++) { 
                %>
                    <% if (i == currentPage) { %>
                        <span class="pagination-link active"><%= i %></span>
                    <% } else { %>
                        <a href="?page=<%= i %><%= paginationParams %>" class="pagination-link"><%= i %></a>
                    <% } %>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="?page=<%= currentPage + 1 %><%= paginationParams %>" class="pagination-link">다음</a>
                    <a href="?page=<%= totalPages %><%= paginationParams %>" class="pagination-link">맨끝</a>
                <% } else { %>
                    <span class="pagination-link disabled">다음</span>
                    <span class="pagination-link disabled">맨끝</span>
                <% } %>
            </div>
        </div>
    </div>
</main>

<!-- 상품 삭제는 GET 링크가 아니라 CSRF 토큰을 담은 POST 로만 처리한다. -->
<form id="deleteProductForm" action="ProductServlet" method="post" style="display:none;">
    <input type="hidden" name="action" value="delete" />
    <input type="hidden" name="adminCsrfToken" value="<%= session.getAttribute("adminCsrfToken") %>" />
    <input type="hidden" name="id" id="deleteProductId" value="" />
</form>

<script>
    function deleteProduct(productId) {
        if (confirm('정말로 이 상품을 삭제하시겠습니까?')) {
            document.getElementById('deleteProductId').value = productId;
            document.getElementById('deleteProductForm').submit();
        }
    }
    
    function resetFilters() {
        // 모든 필터값을 초기화하고 페이지를 리로드
        window.location.href = 'admin_product_list.jsp';
    }

    // 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
        // 페이지 로드 시 카테고리 드롭다운 초기화
        initCategoryDropdowns();
        
        // 폼 제출 전에 카테고리 값 설정
        document.querySelector('.filter-form').addEventListener('submit', function(e) {
            // 폼 제출 전에 카테고리 값 설정
            setCategoryValue();
            
            // 디버깅용 콘솔 로그
            console.log("폼 제출 시 카테고리 값:", document.getElementById('category').value);
        });
    });

    // 카테고리 드롭다운 초기화
    function initCategoryDropdowns() {
        const category = "<%= category != null ? category : "" %>";
        
        if (category) {
            const parts = category.split('/');
            const topCategory = parts[0];
            
            // 최상위 카테고리 설정
            document.getElementById('topCategory').value = topCategory;
            
            // 중간 카테고리 업데이트
            updateMiddleCategories();
            
            if (parts.length > 1) {
                const middleCategory = parts[1];
                
                // 중간 카테고리가 있으면 설정
                setTimeout(() => {
                    document.getElementById('middleCategory').value = middleCategory;
                    
                    // 최하위 카테고리 업데이트
                    updateSubCategories();
                    
                    if (parts.length > 2) {
                        const subCategory = parts[2];
                        // 최하위 카테고리가 있으면 설정
                        setTimeout(() => {
                            document.getElementById('subCategory').value = subCategory;
                        }, 100);
                    }
                }, 100);
            }
        }
    }

    // 최상위 카테고리 변경 시 중간 카테고리 업데이트
    function updateMiddleCategories() {
        const topCategorySelect = document.getElementById('topCategory');
        const middleCategorySelect = document.getElementById('middleCategory');
        const subCategorySelect = document.getElementById('subCategory');
        const selectedTopCategory = topCategorySelect.value;
        
        // 중간 및 최하위 카테고리 초기화
        middleCategorySelect.innerHTML = '<option value="">- 하위 카테고리 선택 -</option>';
        subCategorySelect.innerHTML = '<option value="">- 세부 카테고리 선택 -</option>';
        
        // 최상위 카테고리가 선택된 경우
        if (selectedTopCategory) {
            <%-- 서버에서 가져온 카테고리 계층 구조 데이터 --%>
            const categoryData = {};
            
            <%-- 3단계 계층 구조로 변환 --%>
            <% for (String topCat : categoryHierarchy.keySet()) { %>
                categoryData["<%= topCat %>"] = {};
                <% for (String midCat : categoryHierarchy.get(topCat).keySet()) { %>
                    categoryData["<%= topCat %>"]["<%= midCat %>"] = [
                        <% for (String subCat : categoryHierarchy.get(topCat).get(midCat)) { %>
                            "<%= subCat %>",
                        <% } %>
                    ];
                <% } %>
            <% } %>
            
            // 선택된 최상위 카테고리에 속한 중간 카테고리들 추가
            if (categoryData[selectedTopCategory]) {
                for (const middleCategory in categoryData[selectedTopCategory]) {
                    const option = document.createElement("option");
                    option.value = middleCategory;
                    option.textContent = middleCategory;
                    middleCategorySelect.appendChild(option);
                }
            }
        }
        
        // 카테고리 값 설정
        setCategoryValue();
    }

    // 중간 카테고리 변경 시 최하위 카테고리 업데이트
    function updateSubCategories() {
        const topCategorySelect = document.getElementById('topCategory');
        const middleCategorySelect = document.getElementById('middleCategory');
        const subCategorySelect = document.getElementById('subCategory');
        const selectedTopCategory = topCategorySelect.value;
        const selectedMiddleCategory = middleCategorySelect.value;
        
        // 최하위 카테고리 초기화
        subCategorySelect.innerHTML = '<option value="">- 세부 카테고리 선택 -</option>';
        
        // 최상위 및 중간 카테고리가 선택된 경우
        if (selectedTopCategory && selectedMiddleCategory) {
            <%-- 서버에서 가져온 카테고리 계층 구조 데이터 --%>
            const categoryData = {};
            
            <%-- 3단계 계층 구조로 변환 --%>
            <% for (String topCat : categoryHierarchy.keySet()) { %>
                categoryData["<%= topCat %>"] = {};
                <% for (String midCat : categoryHierarchy.get(topCat).keySet()) { %>
                    categoryData["<%= topCat %>"]["<%= midCat %>"] = [
                        <% for (String subCat : categoryHierarchy.get(topCat).get(midCat)) { %>
                            "<%= subCat %>",
                        <% } %>
                    ];
                <% } %>
            <% } %>
            
            // 선택된 중간 카테고리에 속한 최하위 카테고리들 추가
            if (categoryData[selectedTopCategory] && 
                categoryData[selectedTopCategory][selectedMiddleCategory]) {
                
                for (const subCategory of categoryData[selectedTopCategory][selectedMiddleCategory]) {
                    const option = document.createElement("option");
                    option.value = subCategory;
                    option.textContent = subCategory;
                    subCategorySelect.appendChild(option);
                }
            }
        }
        
        // 카테고리 값 설정
        setCategoryValue();
    }

    // 실제 카테고리 값 설정
    function setCategoryValue() {
        const topCategory = document.getElementById('topCategory').value;
        const middleCategory = document.getElementById('middleCategory').value;
        const subCategory = document.getElementById('subCategory').value;
        const categoryInput = document.getElementById('category');
        
        // 테이블 구조에 맞게 수정: p_category는 category 테이블의 category_name을 참조하는 외래키
        // 선택된 가장 깊은 단계의 카테고리 값만 사용
        if (subCategory) {
            // 3단계 선택 시 마지막 카테고리 값
            categoryInput.value = subCategory;
        } else if (middleCategory) {
            // 2단계 선택 시 중간 카테고리 값
            categoryInput.value = middleCategory;
        } else if (topCategory) {
            // 1단계 선택 시 최상위 카테고리 값
            categoryInput.value = topCategory;
        } else {
            // 아무것도 선택되지 않은 경우
            categoryInput.value = '';
        }
        
        console.log("카테고리 값 설정:", categoryInput.value);
    }
</script>

<jsp:include page="/includes/admin_footer.jsp" />
</body>
</html>
