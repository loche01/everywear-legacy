<%@ page import="DAO.UserDAO,DAO.PhoneSMS,Security.PasswordResetGrant,java.time.LocalDate" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
    response.setHeader("Cache-Control", "no-store");
    if (!"POST".equals(request.getMethod())) { response.setHeader("Allow", "POST"); response.setStatus(405); return; }
    if (!PasswordResetGrant.isPostForm(request)) { response.setStatus(400); out.print("{\"result\":\"fail\"}"); return; }
    PasswordResetGrant.clear(session);
    boolean sent = false;
    try {
        String id = request.getParameter("id"), phone = request.getParameter("phone");
        String birth = LocalDate.parse(request.getParameter("birth")).toString();
        if (phone != null && phone.matches("010[0-9]{8}")
                && new UserDAO().isLockUser(id, birth, phone.substring(0,3) + "-" + phone.substring(3,7) + "-" + phone.substring(7))) {
            String otp = PasswordResetGrant.begin(session, id, PasswordResetGrant.UNLOCK);
            PhoneSMS.sendVerification(phone, otp);
            sent = true;
        }
    } catch (Exception ignored) { }
    if (!sent) PasswordResetGrant.clear(session);
    out.print(sent ? "{\"result\":\"success\"}" : "{\"result\":\"fail\"}");
%>
