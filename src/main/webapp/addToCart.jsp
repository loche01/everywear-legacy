<%@page import="DAO.FavoriteDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");

int pd_id = Integer.parseInt(request.getParameter("pd_id"));

FavoriteDAO fDao = new FavoriteDAO();

  if (fDao.addCartFromWish(id, userType, pd_id)) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
