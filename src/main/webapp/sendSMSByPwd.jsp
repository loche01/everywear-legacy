<%@ page import="DAO.PhoneSMS" %>
<%@ page import="Security.PasswordResetGrant" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<jsp:useBean id="user" class="DAO.UserDAO"/>
<%
    response.setHeader("Cache-Control", "no-store");
    if (!"POST".equals(request.getMethod())) { response.setHeader("Allow", "POST"); response.setStatus(405); return; }
    if (!PasswordResetGrant.isPostForm(request)) { response.setStatus(400); out.print("{\"result\":\"fail\"}"); return; }
    PasswordResetGrant.clear(session);
    String name = request.getParameter("name"), id = request.getParameter("id"), phone = request.getParameter("phone");
    boolean sent = false;
    try {
        if (id != null && !id.isBlank() && name != null && !name.isBlank() && phone != null && phone.matches("010[0-9]{8}")
                && user.findPwdByPhone(id, name, phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7))) {
            String otp = PasswordResetGrant.begin(session, id, PasswordResetGrant.FORGOT);
            PhoneSMS.sendVerification(phone, otp);
            sent = true;
        }
    } catch (Exception ignored) { }
    if (!sent) PasswordResetGrant.clear(session);
    out.print(sent ? "{\"result\":\"success\"}" : "{\"result\":\"fail\"}");
%>
