<%@page import="DTO.ReviewImgDTO"%>
<%@page import="DTO.ReviewDTO"%>
<%@page import="DTO.InquiryReplyDTO"%>
<%@page import="DTO.InquiryImgDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="DTO.InquiryDTO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.UserDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="userDao" class="DAO.UserDAO"/>
<jsp:useBean id="qnaDao" class="DAO.QnaDAO"/>
<jsp:useBean id="reDao" class="DAO.ReviewDAO"/>
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

		
		UserDTO userDto = userDao.getOneUser(userId, userType);
		int couponCnt = userDao.showOneUserCoupon(userId, userType);
		
        DecimalFormat formatter = new DecimalFormat("#,###");

        String point = formatter.format(userDto.getUser_point());
        
        Vector<InquiryDTO> qlist = qnaDao.showUserQna(userId, userType);
        
        
        Vector<ReviewDTO> rlist = reDao.showUserReview(userId, userType);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/postMn.css?v=6541">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section2 class="content2">
	<h3>게시물 관리</h3>
	</section2>

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
			<div class="tab-container">
				<div class="tabs">
					<button class="tab-btn active" onclick="showTab('review')">리뷰</button>
					<button class="tab-btn" onclick="showTab('qna')">Q&A</button>
				</div>

<!-- 리뷰 -->
				<div class="tab-content" id="review-tab">
					<%-- 사용자가 작성한 리뷰 목록 출력 --%>
					<%-- <jsp:include page="reviewList.jsp" /> --%>
					<table class="notice-table" id="notice-table">
						<tbody>
						<%if(rlist != null){ 
								for(int i = 0; i<rlist.size(); i++){
									ReviewDTO reviewDto = rlist.get(i);
									String rating = "";
									for(int j = 0; j<reviewDto.getR_rating(); j++){
										rating += "★";
										if(j == reviewDto.getR_rating() -1){
											for(int k = 0; k< (5-reviewDto.getR_rating()); k++)
												rating += "☆";
										}
									}
									Vector<ReviewImgDTO> rilist = reDao.showUserReviewImg(reviewDto.getR_id());
									if(!rilist.isEmpty()){
										ReviewImgDTO reImgDto = rilist.get(0);
						%>
							<tr class="QnABox">
								<td class="pdInfo" onclick="javascropt:reviewDetail('<%=reviewDto.getR_id()%>')">
									<div class="product-box">
										<img src="review_images/<%=reImgDto.getRi_url()%>" alt="상품 이미지" class="product-img">
										<div class="product-info">
											<strong>DEMO PRODUCT</strong>
											<br> NAVY
											<br><%=reviewDto.getR_content()%>
										</div>
									</div>
								</td>
								<td class="date"><%=reviewDto.getCreated_at()%><br><%=rating%>
									<div class="review-actions">
										<a href="#" class="edit">수정</a> 
										<a href="#" class="delete disabled" onclick="openDeleteModal2(event, '<%=reviewDto.getR_id()%>')">삭제</a>
									</div>
								</td>
							</tr>
							<%
							}else{ 
							%>
							<tr class="QnABox">
								<td class="pdInfo" onclick="javascropt:reviewDetail('<%=reviewDto.getR_id()%>')">
									<div class="product-box">
										<div class="product-info">
											<strong>DEMO PRODUCT</strong>
											<br> NAVY
											<br><%=reviewDto.getR_content()%>
										</div>
									</div>
								</td>
								<td class="date" ><%=reviewDto.getCreated_at()%><br><%=rating%>
									<div class="review-actions">
										<a href="#" class="edit">수정</a> 
										<a href="#" class="delete disabled" onclick="openDeleteModal2(event, '<%=reviewDto.getR_id()%>')">삭제</a>
									</div>
								</td>
							</tr>
						<%
								}
							}
						} 
						%>

						</tbody>
					</table>
				</div>


<!-- Q&A -->
				<div class="tab-content hidden" id="qna-tab">
					<%-- 사용자가 작성한 Q&A 목록 출력 --%>
					<%-- <jsp:include page="qnaList.jsp" /> --%>
					<table class="notice-table" id="notice-table">
						<tbody>
						<%if(qlist != null){
						for(int i = 0;i<qlist.size(); i++){
							InquiryDTO qnaDto = qlist.get(i);
							InquiryImgDTO qnaImgDto = qnaDao.showOneQnaImage(qnaDto.getI_id());
							InquiryReplyDTO qnaReDto = qnaDao.showOneQnaReply(qnaDto.getI_id());
							String onclick = "goCommonUpdate(event, '" + qnaDto.getI_id() + "')";
							if(qnaDto.getP_id() != 0 || qnaDto.getO_id() != 0)
								onclick = "goUpdate(event, '" + qnaDto.getI_id() + "')";
							if(qnaImgDto != null){
								if(qnaReDto != null){
						%>
							<tr class="QnABox">
								<td class="pdInfo" onclick="javascript:goDetailWithReply('<%=qnaDto.getI_id()%>')">
									<div class="product-box">
										<img src="Q&A_images/<%=qnaImgDto.getIi_url()%>" alt="상품 이미지" class="product-img">
										<div class="product-info">
										<%if(qnaDto.getI_isPrivate().equals("Y")){ %>
											<strong><%=qnaDto.getI_title()%> &#128274;</strong>
											<%} else{ %>
											<strong><%=qnaDto.getI_title()%></strong>
											<%} %>
											<br> <%=qnaDto.getI_content()%>
											<!-- <br>배송 문의 -->
										</div>
									</div>
								</td>
								<td class="date"><%=qnaDto.getCreated_at()%><br><label style="<%= qnaDto.getI_status().equals("답변완료") ? "color: green; font-weight: bold;" : "" %>"><%=qnaDto.getI_status()%></label>
									<div class="review-actions">
										<a href="#" class="edit" onclick="<%=onclick%>">수정</a> 
										<a href="#" class="delete disabled" onclick="openDeleteModal(event, '<%=qnaDto.getI_id()%>')">삭제</a>
									</div>
								</td>
							</tr>
							<%}else{ %>
							<tr class="QnABox">
								<td class="pdInfo" onclick="javascript:goDetail('<%=qnaDto.getI_id()%>')">
									<div class="product-box">
										<img src="Q&A_images/<%=qnaImgDto.getIi_url()%>" alt="상품 이미지" class="product-img">
										<div class="product-info">
										<%if(qnaDto.getI_isPrivate().equals("Y")){ %>
											<strong><%=qnaDto.getI_title()%> &#128274;</strong>
											<%} else{ %>
											<strong><%=qnaDto.getI_title()%></strong>
											<%} %>
											<br> <%=qnaDto.getI_content()%>
											<!-- <br>배송 문의 -->
										</div>
									</div>
								</td>
								<td class="date"><%=qnaDto.getCreated_at()%><br><label style="<%= qnaDto.getI_status().equals("답변완료") ? "color: green; font-weight: bold;" : "" %>"><%=qnaDto.getI_status()%></label>
									<div class="review-actions">
										<a href="#" class="edit" onclick="<%=onclick%>">수정</a> 
										<a href="#" class="delete disabled" onclick="openDeleteModal(event, '<%=qnaDto.getI_id()%>')">삭제</a>
									</div>
								</td>
							</tr>
						<%
							}
								} else{
									if(qnaReDto != null){
						%>
							<tr class="QnABox">
								<td class="pdInfo" onclick="javascript:goDetailWithReply('<%=qnaDto.getI_id()%>')">
									<div class="product-box">
										<div class="product-info">
										<%if(qnaDto.getI_isPrivate().equals("Y")){ %>
											<strong><%=qnaDto.getI_title()%> &#128274;</strong>
											<%}else{ %>
											<strong><%=qnaDto.getI_title()%></strong>
											<%} %>
											<br> <%=qnaDto.getI_content()%>
											<!-- <br>배송 문의 -->
										</div>
									</div>
								</td>
								<td class="date"><%=qnaDto.getCreated_at()%><br><label style="<%= qnaDto.getI_status().equals("답변완료") ? "color: green; font-weight: bold;" : "" %>"><%=qnaDto.getI_status()%></label>
									<div class="review-actions">
										<a href="#" class="edit" onclick="<%=onclick%>">수정</a> 
										<a href="#" class="delete disabled" onclick="openDeleteModal(event, '<%=qnaDto.getI_id()%>')">삭제</a>
									</div>
								</td>
							</tr>
							<%}else{ %>
							<tr class="QnABox">
								<td class="pdInfo" onclick="javascript:goDetail('<%=qnaDto.getI_id()%>')">
									<div class="product-box">
										<div class="product-info">
										<%if(qnaDto.getI_isPrivate().equals("Y")){ %>
											<strong><%=qnaDto.getI_title()%> &#128274;</strong>
											<%} else{ %>
											<strong><%=qnaDto.getI_title()%></strong>
											<%} %>
											<br> <%=qnaDto.getI_content()%>
											<!-- <br>배송 문의 -->
										</div>
									</div>
								</td>
								<td class="date"><%=qnaDto.getCreated_at()%><br><label style="<%= qnaDto.getI_status().equals("답변완료") ? "color: green; font-weight: bold;" : "" %>"><%=qnaDto.getI_status()%></label>
									<div class="review-actions">
										<a href="#" class="edit" onclick="<%=onclick%>">수정</a> 
										<a href="#" class="delete disabled" onclick="openDeleteModal(event, '<%=qnaDto.getI_id()%>')">삭제</a>
									</div>
								</td>
							</tr>
								<%
									}
								}
							} 
						}
						%>
										
						</tbody>
					</table>
				</div>
			</div>

		</section>
	</div>
	
	<!-- 삭제 모달 -->
	<div id="deleteModal" class="modal" style="display: none;">
	  <div class="modal-content">
	    <p>정말 삭제하시겠습니까?</p>
	    <div class="modal-buttons">
	      <button class="modalBtn1" id="modalBtn1" onclick="closeModal()">취소</button>
	      <button id="deleteQna" class="modalBtn2" onclick="deleteQna()">삭제</button>
	      <!-- <a id="confirmDelete" href="#">삭제</a> -->
	    </div>
	  </div>
	</div>
	
	
	<form action="reviewDetail.jsp" method="post" id="goReviewDetail">
		<input type="hidden" id="hidden_rid" name="r_id">
		<input type="hidden" name="redirect" value="<%=fullUrl2%>">
		<%-- <input type="hidden" name="redirect" value="<%=java.net.URLEncoder.encode(fullUrl2, "UTF-8")%>"> --%>
	</form>
	
	<form action="qnaDetail.jsp" method="post" id="goDetail">
		<input type="hidden" id="hidden_id" name="i_id">
	</form>
	
	<form action="qnaDetail.jsp" method="post" id="goDetailWithReply">
		<input type="hidden" id="hidden_iid" name="i_id">
		<input type="hidden" id="hidden_irid" name="reply" value="Y">
	</form>
	
	<form action="qnaFormForCommonUdp.jsp" method="post" id="qnaUpdate">
		<input type="hidden" id="hidden_i_id" name="i_id">
	</form>

	<script>
function showTab(tab) {
 	const reviewTab = document.getElementById('review-tab');
 	const qnaTab = document.getElementById('qna-tab');
 	const buttons = document.querySelectorAll('.tab-btn');

 	buttons.forEach(btn => btn.classList.remove('active'));

  	if (tab === 'review') {
    	reviewTab.classList.remove('hidden');
    	qnaTab.classList.add('hidden');
    	buttons[0].classList.add('active');
 	 	} else {
    	reviewTab.classList.add('hidden');
    	qnaTab.classList.remove('hidden');
    	buttons[1].classList.add('active');
  	}
}
	

function goDetail(id) {
  document.getElementById("hidden_id").value = id;
  document.getElementById("goDetail").submit();
}

function goDetailWithReply(id){
   document.getElementById("hidden_iid").value = id;
   document.getElementById("goDetailWithReply").submit();
}

function reviewDetail(r_id){
	document.getElementById("hidden_rid").value = r_id;
	document.getElementById("goReviewDetail").submit();
}

/* 모달 */
function openDeleteModal(event, i_id) {
  event.preventDefault(); // a 태그 기본 동작 막기
  document.getElementById("deleteModal").style.display = "flex";
  document.getElementById("hidden_id").value = i_id;
}

function openDeleteModal2(event, r_id){
	  event.preventDefault(); // a 태그 기본 동작 막기
	  document.getElementById("deleteModal").style.display = "flex";
	  document.getElementById("deleteQna").onclick = deleteReview;
	  document.getElementById("hidden_id").value = r_id;
}

function closeModal() {
  document.getElementById("deleteModal").style.display = "none";
}

function deleteQna(){
	const i_id = document.getElementById("hidden_id");
	
	 fetch("deleteQna.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "i_id=" + encodeURIComponent(i_id.value) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
	    .then(res => res.json())
	    .then(data => {
	      if (data.result === "success") {
	        alert("삭제되었습니다.");
	        location.reload();
	      } else {
	        alert("삭제에 실패하였습니다.");
	      }
	    });
}

function deleteReview(){
	const r_id = document.getElementById("hidden_id");
	
	 fetch("deleteReview.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "r_id=" + encodeURIComponent(r_id.value) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
	    .then(res => res.json())
	    .then(data => {
	      if (data.result === "success") {
	        alert("삭제되었습니다.");
	        location.reload();
	      } else {
	        alert("삭제에 실패하였습니다.");
	      }
	    });
}

function goUpdate(event, i_id){
	 event.preventDefault();
	 document.getElementById("qnaUpdate").action = "qnaForm";
	 document.getElementById("hidden_i_id").value = i_id;
		document.getElementById("qnaUpdate").submit();
}

function goCommonUpdate(event, i_id){
	event.preventDefault();
	document.getElementById("hidden_i_id").value = i_id;
	document.getElementById("qnaUpdate").submit();
}



	</script>

</body>