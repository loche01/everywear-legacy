<%@page import="DTO.CouponDTO"%>
<%@page import="DTO.UserCouponDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.UserDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="uDao" class="DAO.UserDAO"/>
<jsp:useBean id="cDao" class="DAO.CouponDAO"/>
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
		UserDTO userDto = uDao.getOneUser(userId, userType);
		int couponCnt = uDao.showOneUserCoupon(userId, userType);
		
		 DecimalFormat formatter = new DecimalFormat("#,###");

	       String point = formatter.format(userDto.getUser_point());
	       
	       Vector<UserCouponDTO> uclist = cDao.getUserAllCoupon(userId, userType);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>쿠폰 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/coupon.css">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section class="content2">
		<h3>보유 쿠폰</h3>
	</section>

	<div class="container">
		<div class="user-box">
			<p class="username"><%=userDto.getUser_name()%> 님</p>
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
		  <div class="coupon-filter-dropdown">
			  <!-- 필터링 드롭다운 (왼쪽) -->
			  <select id="couponFilter" onchange="applyFilterAndSort()">
			    <option value="ALL">전체</option>
			    <option value="VALID_ONLY">사용 가능 쿠폰</option>
			    <option value="EXPIRED_ONLY">만료된 쿠폰</option>
			  </select>
			  <!-- 정렬 드롭다운 (오른쪽) -->
			  <select id="couponSort" onchange="applyFilterAndSort()">
			    <option value="NONE">정렬없음</option>
			    <option value="EXPIRE_DATE">쿠폰 만료일 순</option>
			    <option value="DISCOUNT_DESC">할인순</option>
			  </select>
		</div>

			<!-- 쿠폰 목록 -->
			<div class="coupon-content">

				<!-- 사용 가능한 쿠폰 -->
				<%if(uclist != null && !uclist.isEmpty()){
						for(int i = 0; i<uclist.size(); i++){ 
							UserCouponDTO ucDto = uclist.get(i);
							CouponDTO uDto = cDao.getCouponInfo(ucDto.getCp_id());
				%>
					<div class="coupon-item"
					     data-expire="${coupon.endDate}"
					     data-discount="${coupon.price}">
     					<img src="images/fav-icon.png" alt="10% 할인 쿠폰">
					<div class="coupon-info">
						<p class="coupon-name"><%=uDto.getCp_name()%></p>
						<p class="coupon-detail">
						할인금액 | <%=uDto.getCp_type().equals("정률") ? uDto.getCp_price() + "%" : formatter.format(uDto.getCp_price()) + "원" %><br>
				      사용기한 | <%=uDto.getCp_start()%> ~ <%=uDto.getCp_end()%><br>
				      최소주문금액 | <%=formatter.format(uDto.getCp_min_price())%>원<br>
				    	</p>					
				    </div>
					  <button class="coupon-button" onclick="useCoupon(this)">적용상품</button>
				</div>
				<%
						}
					} else{
				%>
				<div style="text-align: center; margin-top: 200px;">
					<span style="color: #CCCCCC">쿠폰함이 비어 있습니다</span>
				</div>
				<%} %>
				
					<div class="coupon-item"
					     data-expire="${coupon.endDate}"
					     data-discount="${coupon.price}">				  
					     <img src="images/fav-icon.png" alt="회원전용 쿠폰">
				  <div class="coupon-info">
				    <p class="coupon-name">7% GOLD 회원 전용 쿠폰</p>
				    <p class="coupon-detail">
				      사용기한 | 2025-04-01 ~ 2025-05-01<br>
				      최소주문금액: 20,000원<br>
				    </p>
				  </div>
				  <button class="coupon-button">적용상품</button>
				</div>
								
				<!-- 사용 불가(만료) 쿠폰 -->
					<div class="coupon-item soldout"
					     data-expire="${coupon.endDate}"
					     data-discount="${coupon.price}">					
					     <img src="images/fav-icon.png" alt="만료된 쿠폰">
					<div class="coupon-info">
						<p class="coupon-name">5000원 할인 쿠폰</p>
						<p class="coupon-detail">
				     	 사용기한 | 2024-04-10 ~ 2025-04-10<br>
				     	 최소주문금액: 20,000원<br>
				   		 </p>					
				   		</div>
					  <button class="coupon-button" disabled>사용불가</button>
				</div>

			</div>
		</section>
	</div>
</body>
	<script>
	function applyFilterAndSort() {
		  const filterType = document.getElementById('couponFilter').value;
		  const sortType = document.getElementById('couponSort').value;

		  const container = document.querySelector('.coupon-content');
		  let items = Array.from(container.querySelectorAll('.coupon-item'));

		  // 필터 처리
		  if (filterType === 'VALID_ONLY') {
		    items = items.filter(item => item.dataset.status === 'VALID');
		  } else if (filterType === 'EXPIRED_ONLY') {
		    items = items.filter(item => item.dataset.status === 'EXPIRED');
		  }

		  // 정렬 처리
		  if (sortType === 'EXPIRE_DATE') {
		    items.sort((a, b) => new Date(a.dataset.expire) - new Date(b.dataset.expire));
		  } else if (sortType === 'DISCOUNT_DESC') {
		    items.sort((a, b) => Number(b.dataset.discount) - Number(a.dataset.discount));
		  }

		  // 렌더링
		  container.innerHTML = '';
		  items.forEach(item => container.appendChild(item));
		}
	</script>
	
</html>
