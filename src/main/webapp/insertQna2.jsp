<%@ page contentType="application/json; charset=UTF-8" %>
<jsp:useBean id="qDao" class="DAO.QnaDAO"/>
<%
		String id = (String)session.getAttribute("id");
		String type = (String)session.getAttribute("userType");
		boolean saved = qDao.insertQna2(id, type, request);
		if (!saved) response.setStatus(409);
        out.print(saved ? "{\"result\":\"success\"}" : "{\"result\":\"fail\"}");
%>