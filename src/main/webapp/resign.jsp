<%@page import="DAO.UserDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");
String reason = request.getParameter("reason");
String detail = request.getParameter("detail");

  
UserDAO userDao = new UserDAO();

  if (userDao.deleteUser(id, userType, reason, detail)) {
	  session.invalidate();
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
