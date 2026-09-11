<!-- findIdResult.jsp -->

<%@page import="DTO.UserDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="Security.VerificationGrant"%>
<%@page import="org.apache.taglibs.standard.functions.Functions"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<jsp:useBean id="userDao" class="DAO.UserDAO"/>
<%
		response.setHeader("Cache-Control", "no-store");

		// 본인확인(OTP)을 통과한 1회용 grant 가 있을 때만 조회한다.
		if (!"POST".equals(request.getMethod())) {
			response.setHeader("Allow", "POST");
			response.setStatus(405);
			return;
		}

		String authType = VerificationGrant.single(request, "authType");
		String name = VerificationGrant.single(request, "name");
		boolean phoneFlow = "phone".equals(authType);
		boolean emailFlow = "email".equals(authType);

		String recipient = null;
		String purpose = null;
		if (phoneFlow) {
			purpose = VerificationGrant.FIND_ID_PHONE;
			String p1 = VerificationGrant.single(request, "phone1");
			String p2 = VerificationGrant.single(request, "phone2");
			String p3 = VerificationGrant.single(request, "phone3");
			if (p1 != null && p2 != null && p3 != null) {
				recipient = VerificationGrant.normalizePhone(p1 + p2 + p3);
			}
		} else if (emailFlow) {
			purpose = VerificationGrant.FIND_ID_EMAIL;
			recipient = VerificationGrant.normalizeEmail(VerificationGrant.single(request, "email"));
		}

		boolean badRequest = (!phoneFlow && !emailFlow) || recipient == null
				|| name == null || name.isBlank() || name.length() > 10;
		boolean verified = !badRequest && VerificationGrant.consume(request, purpose, recipient);

		Vector<UserDTO> ulist = new Vector<UserDTO>();
		if (!verified) {
			response.setStatus(badRequest ? 400 : 403);
		} else if (phoneFlow) {
			String phone = recipient.substring(0, 3) + "-" + recipient.substring(3, 7) + "-" + recipient.substring(7);
			ulist = userDao.findIdByPhone(name, phone);
		} else {
			ulist = userDao.findIdByEmail(name, recipient);
		}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>검색 결과 | everyWEAR</title>
  <link rel="stylesheet" type="text/css" href="css/find.css">
  <link rel="stylesheet" type="text/css" href="css/findResult.css">
  <link rel="icon" type="image/png" href="images/fav-icon.png">
</head>
<body>

<%@ include file="includes/loginHeader.jsp" %>

<div class="result-container">
  <h1>아이디 찾기 결과</h1>
<br>
<% if (!verified) { %>
  <div class="description">
    본인확인이 완료되지 않았습니다.<br>
    아이디 찾기를 다시 진행해주세요.
  </div>
  <div class="btn-group">
    <a href="findId.jsp" class="btn black">아이디 찾기</a>
  </div>
<% } else if(ulist.size() != 0){ %>
  <div class="description">
    아이디 찾기가 완료되었습니다.<br>
    가입된 아이디가 총 <strong><%=ulist.size()%>개</strong> 있습니다.
  </div>
	<br>
	<p align="center"><strong><%=Functions.escapeXml(name)%></strong>님의 아이디 목록</p>
<div class="result-box">
	<%for(int i = 0; i<ulist.size(); i++){
			UserDTO user = ulist.get(i);
	%>
		  <label for="user<%=i+1%>"><strong><%=Functions.escapeXml(user.getUser_id())%></strong> (<%=Functions.escapeXml(user.getUser_rank())%>, <%=Functions.escapeXml(user.getCreated_at())%> 가입)</label>
	<%} %>
	</div>

<br>
<br>
  <div class="btn-group">
    <a href="login.jsp" class="btn black">로그인</a>
    <a href="findPwd.jsp" class="btn white">비밀번호 찾기</a>
  </div>
  <%} else{ //회원이 없는 경우
  %>
  			  <div class="description">
    			입력하신 정보와 일치하는 회원을 찾을 수 없습니다.
  			</div>
  			  <div class="btn-group">
    			<a href="signup.jsp" class="btn black">회원가입</a>
  			</div>
  <%} %>
</div>

<footer>2025©everyWEAR</footer>

</body>
</html>
