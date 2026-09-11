<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<jsp:useBean id="pDao" class="DAO.ProductDAO"/>
<jsp:useBean id="fDao" class="DAO.FavoriteDAO"/>
<%
  String id = (String)session.getAttribute("id");
String userType = (String)session.getAttribute("userType");
int p_id = Integer.parseInt(request.getParameter("p_id"));
String size = request.getParameter("size");

int pd_id = pDao.getPd_id(p_id, size);

  if (fDao.addCart(id, userType, pd_id)) {
    out.print("{\"result\":\"success\"}");
  } else {
    out.print("{\"result\":\"fail\"}");
  }
%>
