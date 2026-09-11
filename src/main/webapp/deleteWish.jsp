<%@page import="DAO.FavoriteDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");

int f_id = Integer.parseInt(request.getParameter("f_id"));

FavoriteDAO fDao = new FavoriteDAO();

  if (fDao.deleteOwned(new int[]{f_id}, id, userType, "찜")) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
