<%@page import="DAO.ReviewDAO"%>
<%@page import="DAO.QnaDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");
int r_id = Integer.parseInt(request.getParameter("r_id"));

  
ReviewDAO rDao = new ReviewDAO();

  if (rDao.deleteReview(r_id, id, userType, request)) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
