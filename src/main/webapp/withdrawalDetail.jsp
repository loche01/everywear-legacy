<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DTO.UserDTO, java.sql.SQLException, org.apache.taglibs.standard.functions.Functions"%>
<%
request.setCharacterEncoding("UTF-8");
response.setHeader("Cache-Control", "no-store");

String[] ids = request.getParameterValues("user_id");
String[] types = request.getParameterValues("user_type");
String user_id = ids != null && ids.length == 1 ? ids[0] : null;
String user_type = types != null && types.length == 1 ? types[0] : null;
String errorMessage = "해당 탈퇴회원 정보를 찾을 수 없습니다.";
UserDTO user = null;

if (user_id == null || user_id.isBlank() || user_id.length() > 30
        || user_type == null || user_type.isBlank() || user_type.length() > 10) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    errorMessage = "잘못된 요청입니다.";
} else {
    UserDAO dao = new UserDAO();
    try {
        if ("POST".equals(request.getMethod()) && "restore".equals(request.getParameter("action"))) {
            if (dao.restoreWithdrawnUser(user_id, user_type)) {
                out.println("<script>");
                out.println("alert('정상회원으로 복구되었습니다.');");
                out.println("if (window.opener && !window.opener.closed) { window.opener.location.reload(); }");
                out.println("window.close();");
                out.println("</script>");
                return;
            }
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        } else {
            user = dao.getWithdrawalDetail(user_id, user_type);
            if (user == null) response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    } catch (SQLException e) {
        application.log("Withdrawal operation failed.");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        errorMessage = "처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>탈퇴회원 상세정보</title>
<link rel="stylesheet" href="css/withdrawlDetail.css">
</head>
<body>
	<div class="container">
		<h3>탈퇴회원 상세정보</h3>

		<%
		if (user == null) {
		%>
		<p class="error">❗ <%=errorMessage%></p>
		<%
		} else {
		%>
		<ul class="info-list">
			<li><strong>회원 ID:</strong> <%=Functions.escapeXml(user.getUser_id())%></li>
			<li><strong>이름:</strong> <%=Functions.escapeXml(user.getUser_name())%></li>
			<li><strong>등급:</strong> <%=Functions.escapeXml(user.getUser_rank())%></li>
			<li><strong>가입일:</strong> <%=Functions.escapeXml(user.getCreated_at())%></li>
			<li><strong>탈퇴일:</strong> <%=Functions.escapeXml(user.getUser_wd_date())%></li>
			<li><strong>탈퇴 사유:</strong> <%=Functions.escapeXml(user.getUser_wd_reason())%></li>
			<li><strong>상세 사유:</strong> <%=Functions.escapeXml(user.getUser_wd_detail_reason())%></li>
		</ul>
		<form action="withdrawalDetail.jsp" method="post" onsubmit="return confirm('정상회원으로 복구시키겠습니까?');" class="restore-form">
			<input type="hidden" name="user_id" value="<%=Functions.escapeXml(user.getUser_id())%>">
			<input type="hidden" name="user_type" value="<%=Functions.escapeXml(user.getUser_type())%>">
			<input type="hidden" name="adminCsrfToken" value="<%=Functions.escapeXml((String) session.getAttribute("adminCsrfToken"))%>">
			<input type="hidden" name="action" value="restore">
			<button type="submit" class="restore-btn">정상회원으로 전환</button>
		</form>
		<%
		}
		%>
	</div>
</body>
</html>