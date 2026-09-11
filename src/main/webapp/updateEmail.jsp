<%@page import="DAO.UserDAO"%>
<%@page import="Security.VerificationGrant"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  response.setHeader("Cache-Control", "no-store");
  // UserAuthFilter + UserRequestGuard 가 POST · 로그인 · CSRF · form 인코딩을 이미 강제한다.
  // 이메일 변경 재인증(OTP)은 이번 범위가 아니며 docs/known-issues.md 에 한계로 기록한다.
  String id = (String) session.getAttribute("id");
  String userType = (String) session.getAttribute("userType");
  // user.user_email 은 varchar(30) 이므로 저장 길이를 넘기지 않는다. CR/LF·제어문자는 거부된다.
  String email = VerificationGrant.normalizeEmail(VerificationGrant.single(request, "email"), 30);

  if (id == null || id.isBlank() || userType == null || userType.isBlank() || email == null) {
    response.setStatus(400);
    out.print("{\"result\":\"fail\"}");
    return;
  }

  UserDAO userDao = new UserDAO();
  out.print(userDao.updateEmail(id, userType, email) ? "{\"result\":\"success\"}" : "{\"result\":\"fail\"}");
%>
