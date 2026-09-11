<%@page import="DAO.UserDAO"%>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
		if (!Security.UserRequestGuard.authorize(request, response)) return;
		if (!Security.PasswordResetGrant.isPostForm(request) || !"일반".equals(session.getAttribute("userType"))) {
			response.setStatus(403); out.print("{\"result\":\"fail\"}"); return;
		}
		UserDAO user = new UserDAO();
		
		String password = request.getParameter("password");
		
		String userId = (String)session.getAttribute("id");
		
		if(user.isPwd(userId, password)) {
			out.print("{\"result\":\"success\"}");
		} else{
			out.print("{\"result\":\"fail\"}");
		}
%>
