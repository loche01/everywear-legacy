<%@page import="DAO.QnaDAO"%>
<%@page import="DAO.ReviewDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, DTO.*"%>
<%
String user_id = request.getParameter("user_id");
String user_type = request.getParameter("user_type");

ReviewDAO reviewDao = new ReviewDAO();
QnaDAO qnaDao = new QnaDAO();

List<ReviewDTO> reviews = reviewDao.getReviewsByUser(user_id, user_type);
List<InquiryDTO> inquiries = qnaDao.showUserQna(user_id, user_type);
%>

<div class="crm-section">
	<h2>✍️ 회원 게시글 정보</h2>
	<div class="post-content-box">

		<div class="tab-buttons">
			<button class="active" onclick="toggleTab('review')">리뷰</button>
			<button onclick="toggleTab('inquiry')">문의</button>
		</div>

		<!-- 리뷰 탭 -->
		<div id="reviewTab" class="post-tab">
			<h4>📝 작성한 리뷰</h4>
			<%
			if (reviews.isEmpty()) {
			%>
			<p>작성한 리뷰가 없습니다.</p>
			<%
			} else {
			%>
			<%
			for (ReviewDTO r : reviews) {
			%>
			<%-- 관리자 리뷰 상세관리(reviewAdmin.jsp)는 Legacy 복구 범위에서 안전 비활성화되어 진입을 제거했다. --%>
			<div
				style="border: 1px solid #ccc; padding: 10px; margin-bottom: 15px; border-radius: 6px;">

				<%
				String pdName = reviewDao.getProductNameByPdId(r.getPd_id());
				String isHidden = r.getR_isHidden();
				String hiddenClass = "hidden-" + isHidden.toLowerCase(); // hidden-y 또는 hidden-n
				%>
				<p>
					<strong>작성일:</strong>
					<%=r.getCreated_at()%></p>
				<p>
					<strong>상품명:</strong>
					<%=pdName%>
					(<%=r.getPd_id()%>)
				</p>
				<p>
					<strong>별점:</strong> <span class="rating-stars"> <span
						class="stars" style="--rating: <%=r.getR_rating()%>;"></span>
					</span> (<%=r.getR_rating()%>점)
				</p>
				<p>
					<strong>신고 수:</strong>
					<%=r.getR_report_count()%></p>
				<p>
					<strong>숨김 여부:</strong> <span class="<%=hiddenClass%>"><%=isHidden.equals("Y") ? "숨김" : "공개"%></span>
				</p>


				<%
				List<ReviewImgDTO> imgs = reviewDao.getReviewImages(r.getR_id());
				if (!imgs.isEmpty()) {
				%>
				<div style="margin-top: 10px;">
					<%
					for (ReviewImgDTO img : imgs) {
					%>
					<img src="<%=img.getRi_url()%>"
						style="max-width: 100px; margin-right: 5px;" />
					<%
					}
					%>
				</div>
				<%
				}
				%>
			</div>
			<%
			}
			%>
			<%
			}
			%>
		</div>

		<!-- 문의 탭 -->
		<div id="inquiryTab" class="post-tab" style="display: none;">
			<h4>📩 작성한 문의</h4>
			<%
			if (inquiries.isEmpty()) {
			%>
			<p>작성한 문의글이 없습니다.</p>
			<%
			} else {
			%>
			<%
			for (InquiryDTO i : inquiries) {
			%>
			<%-- 관리자 문의 수정(inquiryEdit.jsp)은 구현되지 않아 진입을 제거했다. --%>
			<div
				style="border: 1px solid #ccc; padding: 10px; margin-bottom: 15px; border-radius: 6px;">
				<p>
					<strong>상품ID:</strong>
					<%=i.getP_id()%></p>
				<p>
					<strong>주문ID:</strong>
					<%=i.getO_id()%></p>
				<p>
					<strong>제목:</strong>
					<%=i.getI_title()%></p>
				<p>
					<strong>내용:</strong>
					<%=i.getI_content()%></p>
				<p>
					<strong>공개 여부:</strong>
					<%=i.getI_isPrivate()%></p>
				<p>
					<strong>답변 상태:</strong>
					<%=i.getI_status()%></p>
				<p>
					<strong>작성일:</strong>
					<%=i.getCreated_at()%></p>

				<%
				List<InquiryImgDTO> imgs = qnaDao.showOneQnaImage(i.getI_id()) != null ? List.of(qnaDao.showOneQnaImage(i.getI_id()))
						: List.of();
				if (!imgs.isEmpty()) {
				%>
				<div style="margin-top: 10px;">
					<%
					for (InquiryImgDTO img : imgs) {
					%>
					<img src="<%=img.getIi_url()%>"
						style="max-width: 100px; margin-right: 5px;" />
					<%
					}
					%>
				</div>
				<%
				}
				%>
			</div>
			<%
			}
			%>
			<%
			}
			%>
		</div>

	</div>
</div>
