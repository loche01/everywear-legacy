<%@page import="DTO.ProductDTO"%>
<%@page import="DTO.OrdersDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.UserDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="uDao" class="DAO.UserDAO"/>
<jsp:useBean id="oDao" class="DAO.OrderDAO"/>
<jsp:useBean id="pDao" class="DAO.ProductDAO"/>
<jsp:useBean id="dDao" class="DAO.DeliveryDAO"/>
<%
String userId = (String) session.getAttribute("id");
String userType = (String) session.getAttribute("userType");
if(userId == null || userId == ""){
	// 현재 페이지 경로를 얻기 위한 코드
	String fullUrl = request.getRequestURI();
	String queryString = request.getQueryString();
	if (queryString != null) {
		fullUrl += "?" + queryString;
	}
	response.sendRedirect("login.jsp?redirect=" + java.net.URLEncoder.encode(fullUrl, "UTF-8"));
	return;
}
UserDTO user = uDao.getOneUser(userId, userType);
int couponCnt = uDao.showOneUserCoupon(userId, userType);
DecimalFormat formatter = new DecimalFormat("#,###");

String point = formatter.format(user.getUser_point());

Vector<OrdersDTO> olist = oDao.getOrderHistory(userId, userType);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/orderHistory.css?v=20260918">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section2 class="content2">
	<h3>주문 내역</h3>
	</section2>

	<div class="container">
		<div class="user-box">
			<p class="username"><%=user.getUser_name()%> 님</p>
			<div class="user-info">
				<div class="label">적립금</div>
				<div class="value"><%=point%> ￦</div>
				<div class="label"><a href="coupon.jsp">쿠폰</a></div>
				<div class="value"><%=couponCnt%> 개</div>
			</div>
		</div>

		<aside class="sidebar2">
		<br>
			<ul>
				<li><a href="myPage.jsp">회원 정보 수정</a></li>
				<li><a href="orderHistory2.jsp">주문 내역</a></li>
				<li><a href="cart2.jsp">장바구니</a></li>
				<li><a href="wishList2.jsp">찜 상품</a></li>
				<li><a href="postMn.jsp">게시물 관리</a></li>
				<li><a href="deliveryMn.jsp">배송지 관리</a></li>
			</ul>
		</aside>

		<section class="content">
			<!-- 주문 내역 본문 시작 -->
			<div class="order-content">

				<!-- 필터 드롭다운 -->
				<div class="order-filter">
<!-- 					<select id="statusFilter" onchange="filterOrders()">
						<option value="all">전체</option>
						<option value="shipping">배송중</option>
						<option value="done">배송 완료</option>
						<option value="cancel">주문 취소</option>
					</select> -->
				</div>

				<!-- 주문 리스트 -->
				<div class="order-list">
					<%if(olist != null && olist.size()>=0){ 
							for(int i = 0; i<olist.size(); i++){
								OrdersDTO oDto = olist.get(i);
								int p_id = pDao.getPID(oDto.getPd_id());
								ProductDTO pDto = pDao.getProductById(p_id);
								Vector<String> slist = dDao.getDeliState(oDto.getO_id());
								Vector<String> ilist = pDao.getPdImg(p_id);
					%>
					<!-- 주문 항목 -->
					<div class="order-row shipping">
						<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>" alt="상품 이미지">
						<div class="order-info">
							<p class="item-name"><%=pDto.getP_name()%></p>
							<p class="item-option">SIZE | <%=pDao.getOnePdSizeForCart(oDto.getPd_id())%></p>
							<p class="item-count">수량: <%=oDto.getQuantity()%>개</p>
						</div>
						<div class="order-meta">
							<p class="order-date">
								주문번호 | <%=oDto.getO_num()%><br><%=oDto.getCreated_at()%>
							</p>
							<p class="order-status shipping"><%=slist.get(0)%></p>
						</div>
					</div>
					<%
							}
					} else{
					%>
					<div style="text-align: center; margin-top: 200px;">
					<span style="color: #CCCCCC">주문기록이 없습니다</span>
				</div>
					<%} %>

					

<!-- 					<div class="order-row done">
						<img src="images/orderHistory3.jpg" alt="상품 이미지">
						<div class="order-info">
							<p class="item-name">AETHER NYLON JACKET</p>
							<p class="item-option">one size</p>
							<p class="item-count">수량: 1개</p>
						</div>
						<div class="order-meta">
							<p class="order-date">
								주문번호<br>2025-03-30
							</p>
							<p class="order-status done">배송 완료</p>
							<button class="review-button" onclick="location.href='reviewForm.jsp'">리뷰작성</button>
						</div>
					</div> -->

				</div>
			</div>
		</section>
	</div>

</body>