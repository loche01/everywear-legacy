<%@page import="DAO.UserDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");
String birth = request.getParameter("birth");

  
UserDAO userDao = new UserDAO();

  if (userDao.updateBirth(id, userType, birth)) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
