<%@page import="DTO.ProductDetailDTO"%>
<%@page import="DTO.ProductDTO"%>
<%@page import="DTO.FavoriteDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.UserDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="uDao" class="DAO.UserDAO"/>
<jsp:useBean id="pDao" class="DAO.ProductDAO"/>
<jsp:useBean id="fDao" class="DAO.FavoriteDAO"/>
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
if (user == null) {
	session.invalidate();
	String fullUrl = request.getRequestURI();
	String queryString = request.getQueryString();
	if (queryString != null) {
		fullUrl += "?" + queryString;
	}
	response.sendRedirect("login.jsp?redirect=" + java.net.URLEncoder.encode(fullUrl, "UTF-8"));
	return;
}
int couponCnt = uDao.showOneUserCoupon(userId, userType);
DecimalFormat formatter = new DecimalFormat("#,###");

String point = formatter.format(user.getUser_point());

Vector<FavoriteDTO> flist = fDao.getUserCart(userId, userType);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/cart.css">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section2 class="content2">
	<h3>장바구니</h3>
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

			<div class="order-content">
			<%
					ProductDTO pDto = new ProductDTO();
					if(!flist.isEmpty()){
			%>
			<form action="pay.jsp" method="post" id="payForm">
				<!-- 장바구니 본문 -->
				<!-- 상단 선택/삭제 -->
				<div class="order-row"
					style="justify-content: space-between; border-bottom: 1px solid #ddd;">
					<label><input type="checkbox" id="select-all" checked>전체 선택</label>
					<div class="delete-box">
					  <span class="delete-text" onclick="deleteSelectedItems()">선택 삭제 <span class="delete-icon">&#10005;</span></span>
					</div>
				</div>
			<%
						for(int i = 0; i<flist.size(); i++){ 
							FavoriteDTO fDto = flist.get(i);
							String size = pDao.getOnePdSizeForCart(fDto.getPd_id());
							pDto = pDao.getOnePdForCart(fDto.getPd_id());
							Vector<String> urllist = pDao.getOnePdImgForCart(fDto.getPd_id());
							ProductDetailDTO pdDetail = pDao.getOnePdDetail(fDto.getPd_id());
			%>
				<!-- 상품 -->
				<div class="<%=pdDetail.getPd_stock() != 0 ? "order-row" : "order-row soldout"%>">
					<input type="checkbox"class="item-checkbox" data-fid="<%=fDto.getF_id()%>" name="f_ids" value="<%=fDto.getF_id()%>" onchange="updateTotalPrice()" <%=pdDetail.getPd_stock() != 0 ? "checked" : ""%>> 
					<img src="<%=urllist.get(0)%>" alt="<%=pDto.getP_name()%>">
					<div class="order-info">
						<p class="item-name"><%=pDto.getP_name()%></p>
						<p class="item-option">SIZE  |  <%=size%><br>COLOR  |  <%=pDto.getP_color()%></p>
						<div class="qty-control">
							<button type="button" class="qty-btn" onclick="minusQty('<%=i%>', '<%=fDto.getF_id()%>', '<%=fDto.getPd_id()%>', '<%=pDto.getP_price()%>')">-</button>
							<span class="qty-value" id="quantity<%=i%>"><%=fDto.getF_quantity()%></span>
							<button type="button" class="qty-btn" onclick="plusQty('<%=i%>', '<%=fDto.getF_id()%>', '<%=fDto.getPd_id()%>', '<%=pDto.getP_price()%>')">+</button>
						</div>
					</div>
					<div class="order-meta">
						<p style="text-align: right;">
							<a href="javascript:deleteCart('<%=fDto.getF_id()%>')" style="color: #999; font-size: 13px; text-decoration: none;">삭제</a>
							<br> <a href="#" class="option-button">옵션 변경</a> <br>
							<strong style="font-size: 14px;" id="price<%=i%>"><%=formatter.format(pDto.getP_price() * fDto.getF_quantity())%> 원</strong>
						</p>
					</div>
				</div>
				<%
						}//--for
				%>
				<div style="text-align: right;">
					<strong id="total-price">KRW 50000원</strong>
				</div>
				<!-- 주문하기 버튼 -->
				<div style="width: 100%; display: flex; justify-content: center; margin-top: 20px;">
					<button type="button" style="background: black; color: white; border: none; padding: 12px 40px; font-size: 14px; border-radius: 6px; cursor: pointer;" onclick="pay()">주문하기</button>
				</div>
			</form>
				<%
					}else{
				%>
				<div style="text-align: center; margin-top: 200px;">
					<span style="color: #CCCCCC">장바구니가 비어 있습니다</span>
				</div>
				<%} %>


			</div>
		</section>
	</div>
	
<script>
function pay() {
	  const checkedItems = document.querySelectorAll(".item-checkbox:checked");
	  
	  if (checkedItems.length === 0) {
	    alert("주문할 상품을 선택해주세요.");
	    return;
	  }
	  
	  // 품절 상품이 선택되어 있는지 검사
	  for (let checkbox of checkedItems) {
	    const orderRow = checkbox.closest(".order-row");
	    if (orderRow && orderRow.classList.contains("soldout")) {
	      alert("품절 상품은 주문할 수 없습니다.");
	      return;
	    }
	  }

	  document.getElementById("payForm").submit();
	}
</script>

<script>/* 체크박스 script */
  // 전체 선택 체크박스 클릭 시
  const selectAllCheckbox = document.getElementById("select-all");
  if (selectAllCheckbox) selectAllCheckbox.addEventListener("change", function () {
    const isChecked = this.checked;
    document.querySelectorAll(".item-checkbox").forEach(cb => {
      cb.checked = isChecked;
    });
    updateTotalPrice();
  });

  // 하위 체크박스 변경 시 → 전체선택 체크박스 상태 자동 반영
  document.querySelectorAll(".item-checkbox").forEach(cb => {
    cb.addEventListener("change", function () {
      const all = document.querySelectorAll(".item-checkbox").length;
      const checked = document.querySelectorAll(".item-checkbox:checked").length;
      selectAllCheckbox.checked = all === checked;
    });
  });
</script>

<script>/* 수량변경 script */
function plusQty(i, f_id, pd_id, price){
	const currentQty = parseInt(document.getElementById("quantity" + i).textContent);
	
	// 최소 수량 제한 (예: 1)
	const newQty = Math.max(1, currentQty + 1);
	
     fetch("updateCart.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "f_id=" + encodeURIComponent(f_id) + "&quantity=" + encodeURIComponent(newQty) + "&pd_id=" + encodeURIComponent(pd_id) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
    .then(res => res.json())
    .then(data => {
      if (data.result === "success") {
   		document.getElementById("quantity" + i).textContent = newQty;
   		document.getElementById("price" + i).textContent = (newQty * price).toLocaleString() + " 원";
   		updateTotalPrice();
      } else {
		alert("재고가 부족합니다.");
      }
    });
}

function minusQty(i, f_id, pd_id, price){
	const currentQty = parseInt(document.getElementById("quantity" + i).textContent);
	
	// 최소 수량 제한 (예: 1)
	const newQty = Math.max(1, currentQty - 1);
	
    fetch("updateCart.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "f_id=" + encodeURIComponent(f_id) + "&quantity=" + encodeURIComponent(newQty) + "&pd_id=" + encodeURIComponent(pd_id) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
    .then(res => res.json())
    .then(data => {
      if (data.result === "success") {
   		document.getElementById("quantity" + i).textContent = newQty;
   		document.getElementById("price" + i).textContent = (newQty * price).toLocaleString() + " 원";
   		updateTotalPrice();
      } else {
		alert("재고가 부족합니다.");
      }
    });
}
</script>

<script> /* 장바구니 삭제 */
function deleteCart(f_id){
    fetch("deleteCart.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "f_id=" + encodeURIComponent(f_id) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
    .then(res => res.json())
    .then(data => {
      if (data.result === "success") {
   		alert("삭제되었습니다");
   		location.reload();
      } else {
		alert("삭제에 실패하였습니다");
      }
    });
}
</script>

<script> /* 선택 삭제 */
function deleteSelectedItems() {
  // 체크된 체크박스 전부 가져오기
  const checkedItems = document.querySelectorAll('.item-checkbox:checked');

  if (checkedItems.length === 0) {
    alert("삭제할 항목을 선택해주세요.");
    return;
  }

  // f_id 값을 수집
  const idsToDelete = [];
  checkedItems.forEach(item => {
    const fId = item.getAttribute('data-fid');
    if (fId) {
      idsToDelete.push(fId);
    }
  });

  // 서버로 삭제 요청 보내기
  fetch('deleteCartItems.jsp', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-User-CSRF-Token': '<%=Security.UserRequestGuard.token(session)%>'
    },
    body: JSON.stringify({ ids: idsToDelete })
  })
  .then(res => res.json())
  .then(data => {
    if (data.result === 'success') {
      alert("선택한 상품이 삭제되었습니다.");
      location.reload(); // 새로고침으로 반영
    } else {
      alert("삭제 중 오류가 발생했습니다.");
    }
  });
}
</script>

<script> /* 총 가격 변경 */
function updateTotalPrice() {
	  const checkboxes = document.querySelectorAll('.item-checkbox');
	  let total = 0;

	  checkboxes.forEach((checkbox, index) => {
	    if (checkbox.checked) {
	      // price는 "price0", "price1", ... 형식으로 ID가 지정되어 있음
	      const priceElement = document.getElementById("price" + index);
	      if (priceElement) {
	        const priceText = priceElement.textContent.replace(/[^\d]/g, ""); // 숫자만 추출
	        const price = parseInt(priceText);
	        if (!isNaN(price)) {
	          total += price;
	        }
	      }
	    }
	  });

		  const totalPrice = document.getElementById("total-price");
		  if (totalPrice) {
		    totalPrice.textContent = "KRW " + total.toLocaleString() + "원";
		  }
	}
	
window.addEventListener("DOMContentLoaded", () => {
	  updateTotalPrice(); // 페이지 로드 시 초기 총합 계산
	});
</script>

<script>
window.addEventListener("DOMContentLoaded", () => {
	  updateTotalPrice(); // 기존 총합 계산

	  // 전체 선택 체크박스 상태 자동 조정
	  const itemCheckboxes = document.querySelectorAll(".item-checkbox");
	  const checkedCheckboxes = document.querySelectorAll(".item-checkbox:checked");

	  const selectAll = document.getElementById("select-all");

		  if (!selectAll) {
		    return;
		  }

		  if (itemCheckboxes.length !== checkedCheckboxes.length) {
	    selectAll.checked = false;
	  } else {
	    selectAll.checked = true;
	  }
	});

</script>
<!-- <script>
// 페이지 로드 후 특정 상품을 품절 처리
window.addEventListener("DOMContentLoaded", () => {
  const orderRows = document.querySelectorAll(".order-row");
  
  // 예: 3번째 상품을 회색 처리하고 싶다면 (index는 0부터 시작)
  const soldOutIndex = 2;
  if (orderRows[soldOutIndex]) {
    orderRows[soldOutIndex].classList.add("soldout");
  }
});
</script> -->

</body>
</html>
