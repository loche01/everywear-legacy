<%@ page import="DAO.UserDAO, Security.VerificationGrant" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
  response.setHeader("Cache-Control", "no-store");
  // UserAuthFilter + UserRequestGuard 가 POST · 로그인 · CSRF · form 인코딩을 이미 강제한다.
  // 변경 대상은 언제나 현재 로그인 사용자이며 요청 파라미터로 지정할 수 없다.
  String id = (String) session.getAttribute("id");
  String type = (String) session.getAttribute("userType");
  String phone = VerificationGrant.normalizePhone(VerificationGrant.single(request, "phone"));

  if (id == null || id.isBlank() || type == null || type.isBlank() || phone == null) {
    response.setStatus(400);
    out.print("{\"result\":\"fail\"}");
    return;
  }

  // CHANGE_PHONE 목적으로 바로 이 번호에 발급된 OTP 만 통과한다.
  String grant = VerificationGrant.verify(session, VerificationGrant.CHANGE_PHONE, phone,
          VerificationGrant.single(request, "code"));
  if (grant == null) {
    out.print("{\"result\":\"fail\"}");
    return;
  }
  if (!VerificationGrant.consumeToken(session, VerificationGrant.CHANGE_PHONE, phone, grant)) {
    VerificationGrant.clear(session);
    out.print("{\"result\":\"fail\"}");
    return;
  }

  String formatted = phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7);
  UserDAO uDao = new UserDAO();
  out.print(uDao.updatePhone(id, formatted, type) ? "{\"result\":\"success\"}" : "{\"result\":\"cant\"}");
%>
