<%@page import="DTO.InquiryReplyDTO"%>
<%@page import="DTO.InquiryImgDTO"%>
<%@page import="DTO.InquiryDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="iDao" class="DAO.QnaDAO"/>
<%
		String user_id = (String)session.getAttribute("id");
		String i_id = request.getParameter("i_id");
		String isReply = request.getParameter("reply");
		InquiryDTO qna = null;
		InquiryImgDTO qnaImg = null;
		InquiryReplyDTO qnaReply = null;
		if(i_id == null || i_id.trim().isEmpty()){
			response.sendRedirect("Q&A.jsp");
		} else{
			int id = Integer.parseInt(i_id);
			qna = iDao.showOneQna(id);
			qnaImg = iDao.showOneQnaImage(id);
			qnaReply = iDao.showOneQnaReply(id);
		}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/board.css?v=45354">
</head>
<body>

	<%@ include file="includes/boardHeader.jsp"%>

	<section class="content2">
	<h3>Q&A</h3>
	</section>

	<div class="container">
		<aside class="sidebar2">
			<ul>
				<li><a href="board.jsp">BOARD</a></li>
				<li><a href="FAQ.jsp">FAQ</a></li>
				<li><a href="Q&A.jsp">Q&A</a></li>
			</ul>
		</aside>

		<section class="content">
			<%
			if(qna.getI_isPrivate().equals("Y")){
				if(user_id == null || !qna.getUser_id().equals(user_id)){
			%>
				<script>
					alert("비공개 글입니다.");
					location.href = "Q&A.jsp";
				</script>
				<%
						return;
					}
			}
				%>
			<table class="notice-table">
			<%if("Y".equals(isReply)){%>
				<%if(qna.getI_isPrivate().equals("Y")){ %>
					<tr class="normal">
						<td class="title"><strong>[답변] <%=qna.getI_title()%> &#128274;</strong></td>
						<td class="date"><%=qnaReply.getCreated_at()%></td>
						<td class="views"><%=qnaReply.getAdmin_id()%></td>
					</tr>
				<%}else{ %>
					<tr class="normal">
						<td class="title"><strong>[답변] <%=qna.getI_title()%></strong></td>
						<td class="date"><%=qnaReply.getCreated_at()%></td>
						<td class="views"><%=qnaReply.getAdmin_id()%></td>
					</tr>
				<%	} %>
			<%}else{ %>
				<%if(qna.getI_isPrivate().equals("Y")){ %>
					<tr class="normal">
						<td class="title"><%=qna.getI_title()%> &#128274;</td>
						<td class="date"><%=qna.getCreated_at()%></td>
						<td class="views"><%=qna.getUser_id().substring(0, 4) + "*****"%></td>
					</tr>
				<%}else{ %>
					<tr class="normal">
						<td class="title"><%=qna.getI_title()%></td>
						<td class="date"><%=qna.getCreated_at()%></td>
						<td class="views"><%=qna.getUser_id().substring(0, 4) + "*****"%></td>
					</tr>
				<%	} %>
				<%} %>

				<!-- 본문 내용을 별도 tr로 처리 -->
				<tr>
					<td colspan="3" class="notice-content">
						<div class="notice-body">
						<%if("Y".equals(isReply)){ %>
							<br><br>
							<p><strong><%=qnaReply.getIr_content()%></strong></p>
							<br><br>
							<p>원글 : <%=qna.getI_content()%></p>
							<br><br>
							<%if(qnaImg != null){ %>
							<div>
								<img alt="img" src="Q&A_images/<%=qnaImg.getIi_url()%>" width="300">
							</div>
							<%} %>
						<%}else{ %>
							<br><br>
							<p><%=qna.getI_content()%></p>
							<br><br>
						<%if(qnaImg != null){ %>
							<div>
								<img alt="img" src="Q&A_images/<%=qnaImg.getIi_url()%>" width="300">
							</div>
						<%} %>
							<%} %>
						</div>
					</td>
				</tr>
			</table>

			<div class="list-wrapper">
				<%if(user_id != null && qna.getUser_id().equals(user_id) && !"Y".equals(isReply)){ %>
				<button class="list1" onclick="updateQna(<%=qna.getI_id()%>)">수정</button>
				<button class="list2" onclick="deleteQna(<%=qna.getI_id()%>)">삭제</button>
				<%} %>
				<button class="list" onclick="window.history.back()">목록</button>
			</div>
			
				<form action="qnaFormForCommonUdp.jsp" method="post" id="updateForm">
					<input type="hidden" name = "i_id" id = "hidden_id">
				</form>

			<div class="footer-bottom">
				<p>2025&copy;everyWEAR</p>
			</div>
		</section>
	</div>
<script>
	function deleteQna(i_id){
		if (confirm("정말 삭제하시겠습니까?")) {
			fetch("deleteQna", {method:"POST", body:new URLSearchParams({i_id:i_id, userCsrfToken:"<%=Security.UserRequestGuard.token(session)%>"})})
            .then(r => { if(r.ok) location.href="Q&A.jsp"; else alert("삭제할 수 없습니다."); });
		}
	}
	function updateQna(i_id){
		document.getElementById("hidden_id").value = i_id;
		document.getElementById("updateForm").submit();
	}
</script>
</body>