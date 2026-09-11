<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  response.setHeader("Cache-Control", "no-store");
  response.setStatus(410);
  out.print("{\"result\":\"fail\"}");
%>
