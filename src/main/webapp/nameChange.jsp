<%@page import="DAO.UserDAO"%>
<%@ page  contentType="text/html; charset=UTF-8"%>
<%
		UserDAO user = new UserDAO();
		
		String name = request.getParameter("name");
		
		String userId = (String)session.getAttribute("id");
		String userType = (String)session.getAttribute("userType");
		
		if(user.updateName(name, userId, userType)) {
			out.print("{\"result\":\"success\"}");
		} else{
			out.print("{\"result\":\"fail\"}");
		}
%>