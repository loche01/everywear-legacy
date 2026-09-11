<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.ProductDetailDTO"%>
<%@ page import="java.util.Vector" %>
<%@ page import="DAO.ProductDAO, DTO.ProductDTO" %>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String id = (String)session.getAttribute("id");
    request.setCharacterEncoding("UTF-8");
    int p_id = Integer.parseInt(request.getParameter("p_id"));
    ProductDAO pDao = new ProductDAO();
    
    DecimalFormat formatter = new DecimalFormat("#,###");
    
    ProductDTO pDto = pDao.getOnePd(p_id);
    Vector<String> ilist = pDao.getPdImg(p_id);
    Vector<ProductDetailDTO> pdlist = pDao.getOneProductDetail(p_id);

    if (pDto == null) {
        response.setStatus(404);
%>
			<span class="close-btn" id="closeBtn" onclick="closeDetail()">×</span>
			<div class="left-panel">
				<div class="product-detail-wrapper">
					<p class="product-name">존재하지 않는 상품입니다.</p>
				</div>
			</div>
<%
        return;
    }

    String placeholderImage = "images/product-placeholder.svg";
    String mainImage = placeholderImage;
    if (ilist != null && !ilist.isEmpty()) {
        String firstImage = ilist.get(0);
        if (firstImage != null && !firstImage.trim().isEmpty()) {
            mainImage = firstImage;
        }
    }
%>
			<span class="close-btn" id="closeBtn" onclick="closeDetail()">×</span>
			<span class="expand-btn" id="expandBtn" onclick="toggleFullView('<%=pDto.getP_id()%>')">🔳</span>

			<div class="left-panel">
				<div class="product-detail-wrapper">
					<img src="<%=mainImage%>" alt="<%=pDto.getP_name()%>"
						class="product-image" />
					<h2 class="product-name"><%=pDto.getP_name()%></h2>
					<div class="price" id="price">KRW <%=formatter.format(pDto.getP_price())%></div>

					<div class="section">
						<label class="section-title">COLOR</label>
						<div class="color-options">
							<div class="color-circle" style="background-color: #61584F;"></div>
							<div class="color-circle" style="background-color: #2A2B32;"></div>
						</div>
					</div>

					<div class="section">
						<label class="section-title">SIZE</label>
						<div class="size-options">
						<%for(int i = 0; i<pdlist.size(); i++){ 
							ProductDetailDTO pd = pdlist.get(i);
						%>
							<button id="sizeCheckBtn" class="<%=pd.getPd_stock() != 0 ? "size-btn" : "size-btn disabled"%>" onclick="sizeCheck('<%=pDto.getP_name()%>', '<%=pd.getPd_size()%>')"><%=pd.getPd_size()%></button>
						<%} %>
						<!-- <button class="size-btn disabled">S [재입고 알림]</button> -->
						</div>
					</div>

					<div class="selection-preview" id="selectedSize">
						<!-- SLASH ZIPPER JACKET - WASHED GRAY 옵션: S <span class="remove" onclick="deleteSelect()">X</span> -->
					</div>

					<div class="notify-btn">
						<button>🔔 재입고 알림</button>
					</div>

					<div class="total-price" id="tprice">KRW 0</div>

					<div class="buy-buttons">
						<button class="btn outline" onclick="addToBag('<%=pDto.getP_id()%>')">ADD TO BAG</button>
						<button class="btn filled" onclick="buyNow('<%=pDto.getP_id()%>')">BUY NOW</button>
						<button class="btn wishlist-btn" id="wishlistBtn" onclick="addToWish('<%=pDto.getP_id()%>')">🤍</button>
					</div>

					<div class="section">
						<h4 class="guide-title">SIZE(cm) / GUIDE</h4>
						<%=pDto.getP_text()%>
					</div>

<!-- 					<div class="info-note">
						* 워싱 제품 특성상 개체 차이가 존재 합니다.<br> * Object differences exist due
						to the nature of the washed product.<br> <br> * 두꺼운 포리벡
						특성상 옷에 슬립제가 무다나올 수 있습니다.<br> * 어두운 색 계열의 상품 구매 시 보이는 슬립제는 불량의
						사유가 아니라는 것을 알려드립니다.<br> * The slip agent on dark clothes is
						not defective.
					</div> -->
					<div class="inner-panel right-panel" style="display: none;"
						id="abc">
						<!-- 텍스트 설명, 옵션, 버튼 등 -->
						<%for(int i = 1; i<ilist.size(); i++){ %>
						<img src="<%=ilist.get(i)%>"> 
						<%} %>
					</div>
				</div>
			</div>
			<div class="inner-panel right-panel">
				<!-- 텍스트 설명, 옵션, 버튼 등 -->
				<%for(int i = 1; i<ilist.size(); i++){ %>
					<img src="<%=ilist.get(i)%>"> 
				<%} %>
			</div>
			
