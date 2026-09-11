<%@page import="DTO.ProductDetailDTO"%>
<%@page import="DTO.ProductDTO"%>
<%@page import="DTO.FavoriteDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.UserDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="uDao" class="DAO.UserDAO"/>
<jsp:useBean id="fDao" class="DAO.FavoriteDAO"/>
<jsp:useBean id="pDao" class="DAO.ProductDAO"/>
<%
		String userId = (String)session.getAttribute("id");
		String userType = (String)session.getAttribute("userType");
		
		// 현재 페이지 경로를 얻기 위한 코드
		String fullUrl2 = request.getRequestURI();
		String queryString2 = request.getQueryString();
		if (queryString2 != null) {
			fullUrl2 += "?" + queryString2;
		}
		if(userId == null || userId == ""){
			response.sendRedirect("login.jsp?redirect=" + java.net.URLEncoder.encode(fullUrl2, "UTF-8"));
			return;
		}
		
		UserDTO uDto = uDao.getOneUser(userId, userType);
		int couponCnt = uDao.showOneUserCoupon(userId, userType);
		
        DecimalFormat formatter = new DecimalFormat("#,###");

        String point = formatter.format(uDto.getUser_point());
        
        Vector<FavoriteDTO> wlist = fDao.getUserWish(userId, userType);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/wishList2.css">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section2 class="content2">
	<h3>찜 목록</h3>
	</section2>

	<div class="container">
		<div class="user-box">
			<p class="username"><%=uDto.getUser_name()%> 님</p>
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
			<!-- 찜 목록 본문 -->
			<div class="wishlist-content">

				<%
					ProductDTO pDto = new ProductDTO();
					if(!wlist.isEmpty() && wlist != null){
						for(int i = 0; i<wlist.size(); i++){
							FavoriteDTO fDto = wlist.get(i);
							String size = pDao.getOnePdSizeForCart(fDto.getPd_id());
							pDto = pDao.getOnePdForCart(fDto.getPd_id());
							Vector<String> urllist = pDao.getOnePdImgForCart(fDto.getPd_id());
							ProductDetailDTO pdDetail = pDao.getOnePdDetail(fDto.getPd_id());
				%>
				<div class="<%=pdDetail.getPd_stock() != 0 ? "wishlist-item" : "wishlist-item soldout"%>">
					<img src="<%=urllist.get(0)%>" alt="<%=pDto.getP_name()%>">
					<div class="wishlist-info">
						<p class="wishlist-name"><%=pDto.getP_name()%><br><%=size%> SIZE</p>
						<p class="wishlist-price"><%=formatter.format(pDto.getP_price())%> 원</p>
					</div>
					<div class="wishlist-cart" onclick="addToCart(this, '<%=fDto.getPd_id()%>')">🛒</div>
					<div class="wishlist-heart active" onclick="toggleWishlistHeart(this, '<%=fDto.getF_id()%>')">❤️</div>
				</div>
				<%
						}
				} else{
				%>
				<div style="text-align: center; margin-top: 200px;">
					<span style="color: #CCCCCC">찜이 비어 있습니다</span>
				</div>
				<%} %>
				
			</div>
		</section>
	</div>
</body>
<script>

function addToCart(el, pd_id) {
	  const item = el.closest(".wishlist-item");

	  // 혹시라도 JS 쪽에서 한 번 더 체크하고 싶다면 (선택사항)
	  if (item.classList.contains("soldout")) {
	    alert("품절 상품은 장바구니에 담을 수 없습니다.");
	    return;
	  }

	  const itemName = item.querySelector(".wishlist-name").innerText;

     fetch("addToCart.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "pd_id=" + encodeURIComponent(pd_id) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
     .then(res => res.json())
     .then(data => {
       if (data.result === "success") {
    	   alert("해당 상품을 장바구니에 담았습니다.");
       } else {
 		alert("장바구니에 담을 수 없습니다.");
       }
     });
	}
  
  function toggleWishlistHeart(el, f_id) {
    const item = el.closest(".wishlist-item");
    const isActive = el.classList.contains("active");

    if (isActive) {
      // 확인 창
      const confirmDelete = confirm("찜 상품을 해제하시겠습니까?");
      if (!confirmDelete) return;

      // 찜 해제 처리
      el.classList.remove("active");
      el.innerText = "🤍";
      item.remove(); // DOM에서 삭제
    } else {
      el.classList.add("active");
      el.innerText = "❤️";
      // 다시 찜하기 기능은 여기에 필요 시 추가
    }

    fetch("deleteWish.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "f_id=" + encodeURIComponent(f_id) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
    .then(res => res.json())
    .then(data => {
      if (data.result === "success") {
   	   /* alert("해제되었습니다."); */
      } else {
		alert("해제할 수 없습니다.");
      }
    });
  }
</script>

</html>