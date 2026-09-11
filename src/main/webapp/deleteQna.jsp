<%@page import="DAO.QnaDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");
int i_id = Integer.parseInt(request.getParameter("i_id"));

  
QnaDAO qnaDao = new QnaDAO();

  if (qnaDao.deleteQna(i_id, id, userType, request)) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
