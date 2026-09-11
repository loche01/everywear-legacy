<%@ page import="Security.VerificationGrant" %>
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
    String recipient = VerificationGrant.normalizeRecipient(purpose, VerificationGrant.single(request, "recipient"));
    // 전화번호 변경은 verifyCode3.jsp 에서만 처리한다(로그인 + CSRF 보호 경로).
    boolean allowedPurpose = VerificationGrant.SIGNUP_PHONE.equals(purpose)
            || VerificationGrant.FIND_ID_PHONE.equals(purpose)
            || VerificationGrant.FIND_ID_EMAIL.equals(purpose);

    if (!allowedPurpose || recipient == null) {
        response.setStatus(400);
        out.print("{\"result\":\"fail\"}");
        return;
    }

    // purpose + recipient 가 일치하고 만료·시도횟수 안에 있을 때만 통과한다.
    // 성공 시 pending OTP 는 즉시 소비되고 1회용 grant 가 발급된다.
    String grant = VerificationGrant.verify(session, purpose, recipient, VerificationGrant.single(request, "code"));
    if (grant == null) {
        out.print("{\"result\":\"fail\"}");
        return;
    }
    out.print("{\"result\":\"success\",\"otpGrant\":\"" + grant + "\"}");
%>
