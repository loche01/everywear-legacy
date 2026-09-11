<%@page import="DAO.UserDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");
String gender = request.getParameter("gender");
int height = 0;
if(request.getParameter("height") != null && request.getParameter("height") != "") {
	height = Integer.parseInt(request.getParameter("height"));
}
int weight = 0;
if(request.getParameter("weight") != null && request.getParameter("weight") != "") {
	weight = Integer.parseInt(request.getParameter("weight"));
}
  
UserDAO userDao = new UserDAO();

  if (userDao.updateGender(gender, height, weight, id, userType)) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
