<%@ page import="DAO.PhoneSMS, Security.VerificationGrant, Security.UserRequestGuard" %>
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
    String phone = VerificationGrant.normalizePhone(VerificationGrant.single(request, "phone"));
    boolean allowedPurpose = VerificationGrant.SIGNUP_PHONE.equals(purpose)
            || VerificationGrant.FIND_ID_PHONE.equals(purpose)
            || VerificationGrant.CHANGE_PHONE.equals(purpose);

    if (!allowedPurpose || phone == null) {
        VerificationGrant.clear(session);
        response.setStatus(400);
        out.print("{\"result\":\"fail\"}");
        return;
    }
    // 전화번호 변경은 로그인 사용자만 시작할 수 있다.
    if (VerificationGrant.CHANGE_PHONE.equals(purpose) && !UserRequestGuard.authenticated(session)) {
        VerificationGrant.clear(session);
        response.setStatus(401);
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
        String otp = VerificationGrant.begin(session, purpose, phone);
        PhoneSMS.sendVerification(phone, otp);
        sent = true;
    } catch (Exception ignored) { }

    // 인증번호는 어떤 응답에도 포함하지 않는다. 발송 실패 시 pending 상태를 남기지 않는다.
    if (sent) VerificationGrant.markSent(session);
    else VerificationGrant.clear(session);
    out.print(sent ? "{\"result\":\"success\"}" : "{\"result\":\"fail\"}");
%>
