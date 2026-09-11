<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DTO.UserDTO, DTO.OrdersDTO"%>
<%@ page import="java.util.List"%>
<%
UserDAO dao = new UserDAO();
List<OrdersDTO> orderList = null;
int newUser = dao.getTodayNewUserCount();
int orderCount = dao.getTodayOrderCount();
int withdrawalUser = dao.getWithdrawalUserCount();
int totalUser = dao.getTotalUserCount();
String type = request.getParameter("type");
String reason = request.getParameter("reason");
if (type == null)
	type = "order";
int pageSize = 10;
int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
int totalCount = 0;
int totalPage = 0;
List<UserDTO> list = null;
if ("order".equals(type)) {
	totalCount = dao.getTodayOrderCount();
	orderList = dao.getTodayOrderList(currentPage, pageSize);
} else if ("withdrawal".equals(type)) {
	if (reason == null)
		reason = "";
	if (!reason.trim().isEmpty()) {
		list = dao.getWithdrawalUserList(currentPage, pageSize, reason);
		totalCount = list.size();
	} else {
		list = dao.getWithdrawalUserList(currentPage, pageSize);
		totalCount = dao.getWithdrawalUserCount();
	}
} else if ("total".equals(type)) {
	totalCount = dao.getTotalUserCount();
	list = dao.getTotalUserList(currentPage, pageSize);
} else {
	totalCount = dao.getTodayNewUserCount();
	list = dao.getTodayNewUserList(currentPage, pageSize);
}
totalPage = (int) Math.ceil((double) totalCount / pageSize);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 메인 대시보드</title>
<link rel="stylesheet" type="text/css" href="css/admin_main.css">
<link rel="icon" type="image/png" href="images/fav-icon.png">
<script>
	
</script>
</head>
<body>
	<!-- 헤더선언 -->
	<jsp:include page="includes/admin_header.jsp" />
	<main>
		<div class="container">
			<h2>관리자 메인 대시보드</h2>
			<div class="dashboard-cards">
				<div class="card">
					<h3>신규주문</h3>
					<p class="clickable">
						<a href="admin_main.jsp?type=order&page=1"><%=orderCount%>건</a>
					</p>
				</div>
				<div class="card">
					<h3>신규회원</h3>
					<p class="clickable">
						<a href="admin_main.jsp?type=new&page=1"><%=newUser%>명</a>
					</p>
				</div>
				<div class="card">
					<h3>탈퇴회원</h3>
					<p class="clickable">
						<a href="admin_wdmember_manage.jsp?type=withdrawal&page=1"><%=withdrawalUser%>명</a>
					</p>
				</div>
				<div class="card">
					<h3>총 회원</h3>
					<p class="clickable">
						<a href="admin_member.jsp?type=total&page=1"><%=totalUser%>명</a>
					</p>
				</div>
			</div>
		</div>
	</main>
	<jsp:include page="/includes/admin_footer.jsp" />
</body>
</html>