<%@page import="DAO.UserDAO"%>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
		if (!Security.UserRequestGuard.authorize(request, response)) return;
		if (!Security.PasswordResetGrant.isPostForm(request) || !"일반".equals(session.getAttribute("userType"))) {
			response.setStatus(403); out.print("{\"result\":\"fail\"}"); return;
		}
		UserDAO user = new UserDAO();
		
		String password = request.getParameter("password");
		String newPassword = request.getParameter("newPassword");
		if (!Security.PasswordResetGrant.validPassword(newPassword, newPassword)) {
			response.setStatus(400); out.print("{\"result\":\"cant\"}"); return;
		}
		
		String userId = (String)session.getAttribute("id");
		
		if(user.isPwd(userId, password)) {
			if(user.updatePwd(userId, newPassword)){
				out.print("{\"result\":\"success\"}");	//변경 성공	
				return;
			}
			out.print("{\"result\":\"cant\"}");	//변경 실패
		} else{
			out.print("{\"result\":\"fail\"}");	//잘못된 기존 아이디
		}
%>
