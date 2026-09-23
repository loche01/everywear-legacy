<%@page import="DAO.FavoriteDAO"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");

FavoriteDAO fDao = new FavoriteDAO();
boolean ok;
if (request.getParameter("f_id") != null) {
	// 찜 목록 화면: 찜 한 건 해제
	int f_id = Integer.parseInt(request.getParameter("f_id"));
	ok = fDao.deleteOwned(new int[]{f_id}, id, userType, "찜");
} else {
	// 상품 상세의 하트 토글: 상품 + 사이즈로 본인 찜 해제
	int p_id = Integer.parseInt(request.getParameter("p_id"));
	int pd_id = new DAO.ProductDAO().getPd_id(p_id, request.getParameter("size"));
	ok = fDao.removeWish(id, userType, pd_id);
}

  if (ok) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
