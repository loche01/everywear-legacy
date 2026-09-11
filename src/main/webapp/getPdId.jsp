<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="DAO.ProductDAO, DTO.ProductDetailDTO" %>
<%
  request.setCharacterEncoding("UTF-8");

  int p_id = Integer.parseInt(request.getParameter("p_id"));
  String size = request.getParameter("size");

  ProductDAO dao = new ProductDAO();
  int pd_id = dao.getPd_id(p_id, size); // DAO에서 해당 함수 구현

  out.print("{\"pd_id\": " + pd_id + "}");
%>
