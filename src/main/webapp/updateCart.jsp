<%@page import="DAO.FavoriteDAO"%>
<%@page import="DAO.UserDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");
int f_id = Integer.parseInt(request.getParameter("f_id"));
int quantity = Integer.parseInt(request.getParameter("quantity"));
int pd_id = Integer.parseInt(request.getParameter("pd_id"));

FavoriteDAO fDao = new FavoriteDAO();

  if (fDao.updateCart(f_id, quantity, pd_id, id, userType)) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
