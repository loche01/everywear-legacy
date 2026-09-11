<%@page import="DAO.GmailSend"%>
<%@page import="Security.PasswordResetGrant"%>
<%@ page contentType="application/json; charset=UTF-8" %>
<jsp:useBean id="user" class="DAO.UserDAO"/>
<%
    response.setHeader("Cache-Control", "no-store");
    if (!"POST".equals(request.getMethod())) { response.setHeader("Allow", "POST"); response.setStatus(405); return; }
    if (!PasswordResetGrant.isPostForm(request)) { response.setStatus(400); out.print("{\"result\":\"fail\"}"); return; }
    PasswordResetGrant.clear(session);
    String name = request.getParameter("name"), email = request.getParameter("email"), id = request.getParameter("id");
    boolean sent = false;
    try {
        if (id != null && !id.isBlank() && name != null && !name.isBlank() && email != null && email.matches("[^\\s@]+@[^\\s@]+")
                && user.findPwdByEmail(id, name, email)) {
            String otp = PasswordResetGrant.begin(session, id, PasswordResetGrant.FORGOT);
            GmailSend.sendVerification(email, otp);
            sent = true;
        }
    } catch (Exception ignored) { }
    if (!sent) PasswordResetGrant.clear(session);
    out.print(sent ? "{\"result\":\"success\"}" : "{\"result\":\"fail\"}");
%>