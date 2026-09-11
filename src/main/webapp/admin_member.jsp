<!-- admin.member.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DTO.UserDTO"%>
<%@ page import="java.util.List"%>
<%
UserDAO dao = new UserDAO();
int pageSize = 10;
int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
int totalCount = dao.getTotalUserCount();
int totalPage = (int) Math.ceil((double) totalCount / pageSize);
List<UserDTO> list = dao.getTotalUserList(currentPage, pageSize);
int no = (currentPage - 1) * pageSize + 1;

//현재 페이지 표시
request.setAttribute("currentMenu", "member");
request.setAttribute("subMenu", "member_list");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 회원 목록 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" href="css/admin_member.css">
</head>
<body>
	<!-- 헤더 -->
	<jsp:include page="includes/admin_header.jsp" />
	<main>
		<div class="container">
			<h2>전체 회원 목록</h2>
			<table class="user-table">
				<thead>
					<tr>
						<th colspan="9" style="text-align: left;">※ 전체 회원 목록입니다.</th>
					</tr>
					<tr>
						<th>No.</th>
						<th>회원ID</th>
						<th>유형</th>
						<th>이름</th>
						<th>등급</th>
						<th>가입일</th>
						<th>상태</th>
						<th>포인트</th>
						<th>마케팅 수신</th>
					</tr>
				</thead>
				<tbody>
					<%
					if (list != null && !list.isEmpty()) {
						for (UserDTO user : list) {
					%>
					<tr
						onclick="openCRM('<%=user.getUser_id()%>', '<%=user.getUser_type()%>')"
						style="cursor: pointer;">
						<td><%=no++%></td>
						<td><%=user.getUser_id()%></td>
						<td><%=user.getUser_type()%></td>
						<td><%=user.getUser_name()%></td>
						<td><%=user.getUser_rank()%></td>
						<td><%=user.getCreated_at()%></td>
						<td><%=user.getUser_account_state()%></td>
						<td><%=user.getUser_point()%>P</td>
						<td><%=user.getUser_marketing_state()%></td>
					</tr>
					<%
					}
					} else {
					%>
					<tr>
						<td colspan="9" style="text-align: center;">표시할 데이터가 없습니다.</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>

			<div class="pagination">
				<%
				// 이전 페이지
				if (currentPage > 1) {
				%>
				<a href="admin_member.jsp?page=<%=currentPage - 1%>">Prev</a>
				<%
				} else {
				%>
				<span class="disabled">Prev</span>
				<%
				}

				// 페이지 번호 표시 범위 설정
				int startPage = Math.max(1, currentPage - 2);
				int endPage = Math.min(totalPage, currentPage + 2);

				// 페이지 번호
				for (int i = startPage; i <= endPage; i++) {
				%>
				<a href="admin_member.jsp?page=<%=i%>"
					class="<%=i == currentPage ? "active" : ""%>"><%=i%></a>
				<%
				}

				// 다음 페이지
				if (currentPage < totalPage) {
				%>
				<a href="admin_member.jsp?page=<%=currentPage + 1%>">Next</a>
				<%
				} else {
				%>
				<span class="disabled">Next</span>
				<%
				}
				%>
			</div>
		</div>
	</main>

	<!-- 푸터 포함 -->
	<jsp:include page="/includes/admin_footer.jsp" />

<script>
  function openCRM(id, type) {
    const url = "<%=request.getContextPath()%>/crm/userCRM.jsp?user_id=" + id + "&user_type=" + type;  // ✅ 절대 경로
    window.open(url, "CRM상세", "width=1000,height=585,left=150,top=100,scrollbars=yes,resizable=no");
  }
</script>

</body>
</html>
