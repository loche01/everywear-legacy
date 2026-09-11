<%@ page import="org.apache.taglibs.standard.functions.Functions" %>
<%@page import="DTO.NoticeDTO"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="nDao" class="DAO.NoticeDAO" />
<%
Vector<NoticeDTO> nIlist = nDao.showImpNotice(); // 중요 공지 리스트
Vector<NoticeDTO> nNIlist = nDao.showNotImpNotice(); // 일반 공지 리스트

int totalData = nNIlist.size(); // 일반 공지의 수
int itemsPerPage = 7; // 한 페이지당 7개
int totalPage = (int) Math.ceil((double) totalData / itemsPerPage);

int currentPage = 1;
try {
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }
} catch (NumberFormatException invalidPage) {
    currentPage = 1;
}
currentPage = Math.max(1, Math.min(currentPage, Math.max(1, totalPage)));

int start = (currentPage - 1) * itemsPerPage;
int end = start + itemsPerPage;
if (end > totalData)
	end = totalData;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/board.css?v=654315">
</head>
<body class="board-list">

	<%@ include file="includes/header.jsp"%>

	<section class="content2">
		<h3>BOARD</h3>
	</section>

	<div class="container">
		<aside class="sidebar2">
			<ul>
				<li><a href="board.jsp?">BOARD</a></li>
				<li><a href="FAQ.jsp">FAQ</a></li>
				<li><a href="Q&A.jsp">Q&A</a></li>
			</ul>
		</aside>

		<section class="content">
			<table class="notice-table" id="notice-table">
		<thead>
			<tr>
				<th class="title">제목</th>
				<th class="date">작성일</th>
				<th class="views">조회수</th>
			</tr>
		</thead>
		<tbody>			
			<%-- 중요 공지사항은 항상 출력 --%>
			<%
			for (int i = 0; i < nIlist.size(); i++) {
				NoticeDTO notice = nIlist.get(i);
			%>
			<tr class="important">
				<td class="title">
					<a href="noticeRead.jsp?noti_id=<%=notice.getNoti_id()%>"> ※ <%=Functions.escapeXml(notice.getNoti_title())%></a>
				</td>
				<td class="date"><%=Functions.escapeXml(notice.getCreated_at())%></td>
				<td class="views"><%=notice.getNoti_views()%></td>
			</tr>
			<% } %>

			<%-- 일반 공지사항 페이징 출력 --%>
			<%
			for (int i = start; i < end; i++) {
				NoticeDTO notice = nNIlist.get(i);
			%>
			<tr class="normal">
				<td class="title">
					<a href="noticeRead.jsp?noti_id=<%=notice.getNoti_id()%>"><%=Functions.escapeXml(notice.getNoti_title())%></a>
				</td>
				<td class="date"><%=Functions.escapeXml(notice.getCreated_at())%></td>
				<td class="views"><%=notice.getNoti_views()%></td>
			</tr>
			<% } %>
		</tbody>
	</table>

			<%-- 페이징 영역 추가 --%>
			<div class="pagination" id="pagination">
				<%
				if (currentPage > 1) {
				%>
				<a href="board.jsp?page=<%=currentPage - 1%>">Prev</a>
				<%
				} else {
				%>
				<span class="invisible-button">Prev</span>
				<%
				}
				%>

				<%
				for (int i = 1; i <= totalPage; i++) {
				%>
				<a href="board.jsp?page=<%=i%>"
					class="<%=(i == currentPage ? "active" : "")%>"><%=i%></a>
				<%
				}
				%>

				<%
				if (currentPage < totalPage) {
				%>
				<a href="board.jsp?page=<%=currentPage + 1%>">Next</a>
				<%
				} else {
				%>
				<span class="invisible-button">Next</span>
				<%
				}
				%>
			</div>

			<div class="footer-bottom">
				<p>2025&copy;everyWEAR</p>
			</div>
		</section>
	</div>

	<script>
		
	</script>

</body>
</html>
