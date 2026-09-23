<%@page import="DTO.InquiryDTO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.ProductDetailDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="DTO.ProductDTO"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="pDao" class="DAO.ProductDAO"/>
<jsp:useBean id="qDao" class="DAO.QnaDAO"/>
<%
String[] productIds = request.getParameterValues("p_id");
int p_id = -1;
if (productIds != null && productIds.length == 1) {
	try {
		p_id = Integer.parseInt(productIds[0]);
	} catch (NumberFormatException e) {
		// 잘못된 상품 번호는 DAO 조회 전에 거부한다.
	}
}
if (p_id <= 0) {
	response.sendError(400, "상품 번호가 올바르지 않습니다.");
	return;
}

ProductDTO pDto = pDao.getOnePd(p_id);
Vector<String> ilist = pDao.getPdImg(p_id);
Vector<ProductDetailDTO> pdlist = pDao.getOneProductDetail(p_id);

if (pDto == null) {
	response.sendError(404, "존재하지 않는 상품입니다.");
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

Vector<InquiryDTO> qlist = qDao.getQnaForPd(p_id);

DecimalFormat formatter = new DecimalFormat("#,###");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="stylesheet" type="text/css" href="css/pdDetail.css">
<link rel="icon" type="image/png" href="images/fav-icon.png">
<!-- Swiper CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

<!-- Swiper JS -->
<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<!-- 대분류 카테고리 -->
	<nav class="sub-nav">
		<ul>
			<li><a href="productList.jsp?cat=all">ALL</a></li>
			<li><a href="productList.jsp?cat=outer">OUTER</a></li>
			<li><a href="productList.jsp?cat=top">TOP</a></li>
			<li><a href="productList.jsp?cat=bottom">BOTTOM</a></li>
			<li><a href="productList.jsp?cat=acc">ACC</a></li>
		</ul>
	</nav>

	<div class="container">

		<div class="detail-panel" id="detailPanel">

			<div class="inner-panel left-panel">
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
						</div>
					</div>

					<div class="selection-preview" id="selectedSize">
						<!-- SLASH ZIPPER JACKET - WASHED GRAY 옵션: S <span class="remove">X</span> -->
					</div>

					<div class="notify-btn">
						<button>🔔 재입고 알림</button>
					</div>

					<div class="total-price" id="tprice">KRW 0</div>

					<div class="buy-buttons">
						<button class="btn outline" onclick="addToBag('<%=pDto.getP_id()%>', this)">ADD TO BAG</button>
						<button class="btn filled" onclick="buyNow('<%=pDto.getP_id()%>')">BUY NOW</button>
						<button class="btn wishlist-btn" id="wishlistBtn" onclick="addToWish('<%=pDto.getP_id()%>')">🤍</button>
					</div>

					<div class="section2">
						<button class="guide-toggle" onclick="toggleGuide()">
							SIZE(cm) / GUIDE</button>
						<div class="guide-content" id="guideContent">
							<%=pDto.getP_text()%>
						</div>
					</div>

					<div class="section2">
						<button class="guide-toggle" onclick="toggleGuide()">
							SHIPPING</button>
						<div class="guide-content" id="guideContent">
							<p>
								배송 방법 : 택배<br> 배송 지역 : 전국지역<br> 배송 비용 : 무료<br> 배송
								기간 : 3일 ~ 7일<br> 배송 안내 :<br> 고객님께서 주문하신 상품은 결제 확인 후 발송
								됩니다.
							</p>
							<p>오전 9시 이전 결제건에 대해서는 당일 발송 됩니다.</p>
							<p>배송 완료까지 1~2 영업일 소요 됩니다.</p>
							<p>다만, 상품 종류에 따라서 상품의 배송이 다소 지연될 수 있습니다.</p>
						</div>
					</div>
					<div class="section2">
						<button class="guide-toggle" onclick="toggleGuide()">
							RETURN</button>
						<div class="guide-content" id="guideContent">
							<p>
								교환 및 반품이 가능한 경우<br> - 상품을 공급 받으신 날로부터 7일 이내 교환/반품 신청이
								가능합니다.<br> - 물류 센터에 반송된 상품의 입고 여부가 확인된 후에 제품 검품 후 환불 처리
								됩니다.<br> - 단순변심(색상 교환, 사이즈 교환 등 포함)으로 인한 상품의 교환/반품의 경우, 택배
								비용은 고객 부담이오니 이 점 양해 바랍니다.
							</p>
							<p>
								교환 및 반품이 불가능한 경우<br> - 상품 수령 후 7일이 지난 경우<br> - 포장을
								개봉하였거나 포장이 훼손되어 상품 가치가 현저히 상실된 경우<br> - 고객의 사용 또는 일부 소비에
								의하여 상품의 가치가 현저히 감소한 경우 (예: 제품의 구김이나 기타 오염, 세탁, 채취, 화장품의 흔적, 애완동물
								털 등)<br> - 상품의 택, 스티커, 비닐 포장 등을 훼손 및 멸실한 경우<br> - 시간의
								경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우<br> - 상품과 함께
								동봉해드린 사은품이 누락된 경우
							</p>
						</div>
					</div>

				</div>

			</div>

			<div class="inner-panel right-panel">
				<div class="image-wrapper">
					<%for(int i = 1; i<ilist.size(); i++){ %>
					<img src="<%=ilist.get(i)%>"> 
				<%} %>
				</div>
			</div>
		</div>
	</div>

	<div class="buy-with-section">
		<h3>BUY WITH</h3>

		<div class="swiper buy-with-slider">
			<div class="swiper-wrapper">
			<%
					for(int i = 0; i<10; i++){ 
						ProductDTO pd = pDao.getAllPd().get(i);
						Vector<String> buyWithImages = pDao.getPdImg(pd.getP_id());
						String buyWithImage = placeholderImage;
						if (buyWithImages != null && !buyWithImages.isEmpty()) {
							String firstBuyWithImage = buyWithImages.get(0);
							if (firstBuyWithImage != null && !firstBuyWithImage.trim().isEmpty()) {
								buyWithImage = firstBuyWithImage;
							}
						}
			%>
				<div class="swiper-slide slider-item" onclick="goToDetail('<%=pd.getP_id()%>')">
					<img src="<%=buyWithImage%>" alt="<%=pd.getP_name()%>" width="300" height="300" />
					<p class="item-name"><%=pd.getP_name()%></p>
					<p class="item-price">
						<del>KRW <%=formatter.format(pd.getP_price()) %></del>
						KRW <%=formatter.format(pd.getP_price() *80 / 100) %>
					</p>
					<!-- <a>ADD TO BAG</a> -->
				</div>
			<%} %>


				<!-- 필요한 만큼 slide 복사 -->
			</div>
		</div>
	</div>

	<!-- 리뷰 영역 -->
	<section class="review-section">
		<h3>REVIEW (1)</h3>
		<div class="review-summary">
			<div class="rating-box">
				<div class="star-score">★ 4.8</div>
				<p>99%의 구매자가 이 상품을 좋아합니다.</p>
				<!-- <button class="write-review-btn">상품 리뷰 작성하기</button> -->
			</div>
			<div class="rating-bars">
				<div class="rating-row">
					<div class="rating-label">아주 좋아요</div>
					<div class="bar">
						<div class="fill" style="width: 100%;"></div>
					</div>
					<div class="rating-count">10</div>
				</div>
				<div class="rating-row">
					<div class="rating-label">맘에 들어요</div>
					<div class="bar">
						<div class="fill" style="width: 0%;"></div>
					</div>
					<div class="rating-count">0</div>
				</div>
				<div class="rating-row">
					<div class="rating-label">보통이에요</div>
					<div class="bar">
						<div class="fill" style="width: 0%;"></div>
					</div>
					<div class="rating-count">0</div>
				</div>
				<div class="rating-row">
					<div class="rating-label">그냥 그래요</div>
					<div class="bar">
						<div class="fill" style="width: 0%;"></div>
					</div>
					<div class="rating-count">0</div>
				</div>
				<div class="rating-row">
					<div class="rating-label">별로예요</div>
					<div class="bar">
						<div class="fill" style="width: 0%;"></div>
					</div>
					<div class="rating-count">0</div>
				</div>
				<!-- 나머지도 동일하게 반복 -->
			</div>

		</div>

		<!-- 필터 및 정렬 -->
		<div class="review-filters">
			<div class="sort">
				<span class="sort-option inactive">추천순</span> |
				<span class="sort-option active">최신순</span>
			</div>
			<div class="photo-toggle">📷 포토/영상 리뷰만 보기</div>
			<input type="text" placeholder="리뷰 키워드 검색" />
		</div>
		
		<div class="review-filters2">
			<div class="filter-box">
				<button class="filter-btn" data-target="star-filter">별점 ▽</button>
				<button class="filter-btn" data-target="height-filter">키 ▽</button>
				<button class="filter-btn" data-target="weight-filter">몸무게 ▽</button>
				<button class="filter-btn" data-target="size-filter">사이즈 ▽</button>
			</div>

			<!-- 별점 필터 드롭다운 -->
			<div class="filter-dropdown" id="star-filter">
				<div class="dropdown-header">
					<span>별점</span>
					<button class="reset-btn">초기화 🔄</button>
				</div>
				<ul class="star-options">
					<li><span>★★★★★</span> 아주 좋아요 <input type="checkbox"></li>
					<li><span>★★★★☆</span> 맘에 들어요 <input type="checkbox"></li>
					<li><span>★★★☆☆</span> 보통이에요 <input type="checkbox"></li>
					<li><span>★★☆☆☆</span> 그냥 그래요 <input type="checkbox"></li>
					<li><span>★☆☆☆☆</span> 별로예요 <input type="checkbox"></li>
				</ul>
				<button class="complete-btn">완료</button>
			</div>
		</div>
		
		<!-- 키 필터 드롭다운 -->
<div class="filter-dropdown" id="height-filter">
  <div class="dropdown-header">
    <span>키</span>
    <button class="reset-btn" onclick="resetHeightFilter()">초기화 🔄</button>
  </div>
  
  <div class="height-options">
    <button class="height-btn">149 cm 이하</button>
    <button class="height-btn">150 ~ 152 cm</button>
    <button class="height-btn">153 ~ 155 cm</button>
    <button class="height-btn">156 ~ 158 cm</button>
    <button class="height-btn">159 ~ 161 cm</button>
    <button class="height-btn">162 ~ 164 cm</button>
    <button class="height-btn">165 ~ 167 cm</button>
    <button class="height-btn">168 ~ 170 cm</button>
    <button class="height-btn">171 ~ 173 cm</button>
    <button class="height-btn">174 ~ 176 cm</button>
    <button class="height-btn">177 ~ 179 cm</button>
    <button class="height-btn">180 ~ 182 cm</button>
    <button class="height-btn">183 ~ 185 cm</button>
    <button class="height-btn">186 ~ 188 cm</button>
    <button class="height-btn">189 ~ 191 cm</button>
    <button class="height-btn">192 cm 이상</button>
  </div>

  <button class="complete-btn">완료</button>
</div>

		<!-- 리뷰 리스트 -->
		<div class="review-list">
			<div class="review-item">
				<p class="review-text">
					너무 예뻐요 흑흑흑<br>다른 색상도 사고 싶어용
				</p>
				<p class="review-meta">
					pw****님의 리뷰입니다.<br>키 | 몸무게 | 평소사이즈<br> <span
						class="review-sub">color</span> / <span class="review-sub">size</span>
				</p>
			</div>
		</div>
	</section>

	<!-- Q&A 영역 -->
	<section class="qna-section">
		<h2>Q&amp;A (<%=qlist.size()%>)</h2>
		<hr class="qna-divider">

		<div class="qna-list">
		<%
			if(qlist != null && !qlist.isEmpty()){
				for(int i = 0; i<qlist.size(); i++){
					InquiryDTO qDto = qlist.get(i);
					
					String onclick = "";
					if(qDto.getI_isPrivate().equals("N")){
						onclick = "location.href='qnaDetail.jsp?i_id=" + qDto.getI_id() + "'";
					}else{
						String uuid = (String)session.getAttribute("id");
						if(uuid != null && !uuid.equals("")){
							if(qDto.getUser_id().equals(id)){
								onclick = "location.href='qnaDetail.jsp?i_id=" + qDto.getI_id() + "'";
							}
							
						}
					}
		%>
			<div class="qna-item" onclick="<%=onclick%>">
				<span class="qna-lock"><%=qDto.getI_isPrivate().equals("Y") ? "🔒" : ""%></span> <span class="qna-title"><%=qDto.getI_title()%></span>
				<div class="qna-meta">
					<span class="qna-status"><%=qDto.getI_status().equals("답변대기") ? "답변대기" : "답변완료"%></span> <span class="qna-date"><%=qDto.getCreated_at()%></span>
					<span class="qna-category"><%=qDto.getO_id() != 0 ? "배송 문의" : "상품 문의"%></span>
				</div>
			</div>
			<%
				}
			} else{
			%>
			<div style="text-align: center; margin-top: 100px; margin-bottom: 100px;">
					<span style="color: #CCCCCC">Q&A가 없습니다.</span>
				</div>
			<%} %>
		</div>

		<div class="qna-btn-wrapper">
			<button class="qna-write-btn" onclick="writeQNA('<%=p_id%>')">작성하기</button>
		</div>
	</section>
	
	<form action="qnaForm.jsp" id="qnaFF">
		<input type="hidden" name="p_id" id="hidPID">
	</form>

	<form action="pay.jsp" method="post" id="goPayForm">
		<input type="hidden" id="hidden_pd_id" name="pd_id">
		<input type="hidden" name="quantity" value="1">
	</form>

<script>
function writeQNA(p_id){
	<%
		String uId = (String)session.getAttribute("id");
		if(uId != null && !uId.equals("")){
	%>
	document.getElementById("hidPID").value = p_id;
	document.getElementById("qnaFF").submit();
	<%}else{%>
	alert("회원만 Q&A를 작성하실 수 있습니다.");
	return;
	<%}%>
	
}
</script>

	<script>
  	document.querySelectorAll(".guide-toggle").forEach(button => {
    	button.addEventListener("click", () => {
      	const content = button.nextElementSibling;
	
      	button.classList.toggle("active");
      	content.classList.toggle("open");
      	
    	});
  	});
	</script>

	<script>
  	document.addEventListener("DOMContentLoaded", function () {
    	new Swiper(".buy-with-slider", {
      	slidesPerView: "auto", // 슬라이드 너비에 맞춰 자동
      	spaceBetween: 40,
      	grabCursor: true, // 커서 스타일 변경
      	freeMode: true, // 드래그한 만큼 넘어감
    	});
  	});
	</script>

	<script>
/*  		document.addEventListener("DOMContentLoaded", () => {
    	const wishlistBtn = document.getElementById("wishlistBtn");

    	wishlistBtn.addEventListener("click", () => {
      	wishlistBtn.classList.toggle("active");
      	wishlistBtn.textContent = wishlistBtn.classList.contains("active") ? "❤️" : "🤍";
    	});
  	}); */
	</script>

	<script>
	document.addEventListener("DOMContentLoaded", () => {
	  // 필터 버튼 클릭 시 드롭다운 열기
	  document.querySelectorAll(".filter-btn").forEach(btn => {
	    btn.addEventListener("click", () => {
	      const targetId = btn.dataset.target;
	      const dropdown = document.getElementById(targetId);
	
	      // 다른 드롭다운 닫기
	      document.querySelectorAll(".filter-dropdown").forEach(el => {
	        if (el !== dropdown) el.style.display = "none";
	      });
	
	      // 현재 드롭다운 토글
	      dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
	    });
	  });
	
	  // ✅ 완료 버튼 클릭 시 드롭다운 닫기
	  document.querySelectorAll(".complete-btn").forEach(btn => {
	    btn.addEventListener("click", () => {
	      const dropdown = btn.closest(".filter-dropdown");
	      dropdown.style.display = "none";
	    });
	  });
	
	  // ✅ 바깥 클릭 시 드롭다운 닫기 (선택)
	  document.addEventListener("click", (e) => {
	    if (!e.target.closest(".filter-box") && !e.target.closest(".filter-dropdown")) {
	      document.querySelectorAll(".filter-dropdown").forEach(el => el.style.display = "none");
	    }
	  });
	});
	</script>
				<script>
				 let selectedSize = null;
				function addToBag(p_id, btnEl){
					<%
					String user_id = (String)session.getAttribute("id");
					if(user_id == null || user_id.equals("") ){
					%>
					alert("회원만 장바구니에 담을 수 있습니다.");
					return;
					<%}%>
				    if (!selectedSize) {
				        alert("사이즈를 선택해주세요.");
				        return false;
				      }

				     fetch("addCart.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "p_id=" + encodeURIComponent(p_id) + "&size=" + encodeURIComponent(selectedSize) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
				     .then(res => {
				       if (!res.ok) {
				         const error = new Error("cart request failed");
				         error.status = res.status;
				         throw error;
				       }
				       return res.json();
				     })
				     .then(data => {
				       if (data.result === "success") {
				    	   // alert()는 눈에 띄지 않을 수 있어 버튼 자체에 즉시 시각 피드백을 준다.
				    	   if (btnEl) {
				    	     const original = btnEl.textContent;
				    	     btnEl.textContent = "담았습니다 ✓";
				    	     btnEl.disabled = true;
				    	     setTimeout(() => { btnEl.textContent = original; btnEl.disabled = false; }, 1500);
				    	   } else {
				    	     alert("장바구니에 추가되었습니다!");
				    	   }
				       } else {
				 		alert("장바구니에 넣을 수 없습니다.");
				       }
				     })
				     .catch(error => {
				       if (error && error.status === 401) {
				         alert("로그인이 필요합니다.");
				       } else {
				         alert("장바구니에 넣을 수 없습니다.");
				       }
				     });
				}
				
				function buyNow(p_id){
				    if (!selectedSize) {
				        alert("사이즈를 선택해주세요.");
				        return false;
				      }
				    
				    fetch('getPdId.jsp', {
				        method: 'POST',
				        headers: {
				          'Content-Type': 'application/x-www-form-urlencoded'
				        },
				        body: "p_id=" + encodeURIComponent(p_id) + "&size=" + encodeURIComponent(selectedSize)
				      })
				      .then(response => response.json())
				      .then(data => {
				        const pd_id = data.pd_id;

				        // 👉 여기서 페이지에 반영하거나, 다른 함수로 넘기기
				        document.getElementById("hidden_pd_id").value = pd_id;
				        document.getElementById("goPayForm").submit();
				      })
				      .catch(error => console.error('에러 발생:', error));
				}
				
				function sizeCheck(name, size){
					selectedSize = size;
					document.getElementById("selectedSize").innerHTML = name + " 옵션 : " + size + "<span class='remove' onclick='deleteSelect()'> X</span>";
					const price = document.getElementById("price").textContent;
					document.getElementById("tprice").textContent = price;
				}
				
				function deleteSelect(){
					selectedSize = null;
					document.getElementById("selectedSize").innerHTML = "";
					document.getElementById("tprice").textContent = "KRW 0";
				}
				
				function addToWish(p_id){
					<%
					String u_id = (String)session.getAttribute("id");
					if(u_id == null || u_id.equals("") ){
					%>
					alert("회원만 찜할 수 있습니다.");
					return;
					<%}%>
				    if (!selectedSize) {
				        alert("사이즈를 선택해주세요.");
				        return false;
				      }
				    
				     const removingWish = document.getElementById("wishlistBtn").classList.contains("active"); /* ❤️ 상태면 해제, 🤍 상태면 찜 */ fetch(removingWish ? "deleteWish.jsp" : "addWish.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "p_id=" + encodeURIComponent(p_id) + "&size=" + encodeURIComponent(selectedSize) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
				     .then(res => res.json())
				     .then(data => {
				       if (data.result === "success") {
				    	   alert(removingWish ? "찜이 해제되었습니다." : "해당 상품이 찜되었습니다!");
				    	   const wishlistBtn = document.getElementById("wishlistBtn");

				    	   wishlistBtn.classList.toggle("active");
				         	wishlistBtn.textContent = wishlistBtn.classList.contains("active") ? "❤️" : "🤍";
/* 				       	wishlistBtn.addEventListener("click", () => {
				         	wishlistBtn.classList.toggle("active");
				         	wishlistBtn.textContent = wishlistBtn.classList.contains("active") ? "❤️" : "🤍";
				       	}); */
				       } else {
				 		alert("찜할 수 없습니다.");
				       }
				     });	
				}
				
				function goToDetail(p_id){
					location.href = "pdDetail.jsp?p_id=" + p_id;
				}
			</script>

</body>
</html>