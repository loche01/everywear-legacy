<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminRefundDAO" %>
<%!
private String single(javax.servlet.http.HttpServletRequest request, String name, boolean required) {
    String[] values = request.getParameterValues(name);
    if (values == null && !required) return null;
    if (values == null || values.length != 1 || values[0] == null) throw new IllegalArgumentException();
    return values[0];
}
%>
<%
response.setHeader("Cache-Control", "no-store");
if (!"POST".equals(request.getMethod())) {
    response.setHeader("Allow", "POST");
    response.setStatus(405);
    return;
}
request.setCharacterEncoding("UTF-8");
int orderId = 0;
String result = "invalid";
try {
    orderId = Integer.parseInt(single(request, "o_id", true));
    if (orderId <= 0) throw new IllegalArgumentException();
    int quantity = Integer.parseInt(single(request, "quantity", true));
    int amount = Integer.parseInt(single(request, "amount", true));
    String reasonCode = single(request, "reasonCode", true);
    String reasonText = single(request, "reasonText", false);
    if (quantity <= 0 || amount <= 0 || !AdminRefundDAO.REQUEST_REASON_CODES.contains(reasonCode)
            || (reasonText != null && reasonText.length() > AdminRefundDAO.MAX_REASON_TEXT_LENGTH)) {
        throw new IllegalArgumentException();
    }
    result = "failed";
    new AdminRefundDAO().createRefundForOrder(orderId, quantity, amount, reasonCode, reasonText);
    result = "created";
} catch (IllegalArgumentException e) {
    result = "invalid";
} catch (Exception e) {
    result = "failed";
    System.err.println("Admin refund request creation failed.");
}
if (orderId > 0) response.sendRedirect("admin_order_detail.jsp?o_id=" + orderId + "&refundResult=" + result);
else {
    response.setStatus(400);
    out.print("<p>환불 요청의 주문과 입력값을 확인해주세요.</p>");
}
%>
