<%@ page import="DAO.GmailSend, Security.VerificationGrant" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
    response.setHeader("Cache-Control", "no-store");
    if (!"POST".equals(request.getMethod())) {
        response.setHeader("Allow", "POST");
        response.setStatus(405);
        out.print("{\"result\":\"fail\"}");
        return;
    }
    if (!VerificationGrant.isPostForm(request)) {
        response.setStatus(400);
        out.print("{\"result\":\"fail\"}");
        return;
    }

    String purpose = VerificationGrant.single(request, "purpose");
    String email = VerificationGrant.normalizeEmail(VerificationGrant.single(request, "email"));
    if (!VerificationGrant.FIND_ID_EMAIL.equals(purpose) || email == null) {
        VerificationGrant.clear(session);
        response.setStatus(400);
        out.print("{\"result\":\"fail\"}");
        return;
    }
    if (VerificationGrant.cooldownRemaining(session) > 0) {
        response.setStatus(429);
        out.print("{\"result\":\"cooldown\"}");
        return;
    }

    boolean sent = false;
    try {
        String otp = VerificationGrant.begin(session, purpose, email);
        // 제목·본문 모두 서버측 상수만 사용한다. 사용자 입력(name)은 메일에 넣지 않는다.
        GmailSend.sendVerification(email, otp, "[everyWEAR] 아이디 찾기 인증번호");
        sent = true;
    } catch (Exception ignored) { }

    if (sent) VerificationGrant.markSent(session);
    else VerificationGrant.clear(session);
    out.print(sent ? "{\"result\":\"success\"}" : "{\"result\":\"fail\"}");
%>
