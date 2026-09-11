<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminRefundDAO" %>
<%!
private boolean hasSingleParameter(javax.servlet.http.HttpServletRequest request, String name) {
    String[] values = request.getParameterValues(name);
    return values != null && values.length == 1 && values[0] != null;
}
%>
<%
response.setHeader("Cache-Control", "no-store");
if (!"POST".equals(request.getMethod())) {
    response.setHeader("Allow", "POST");
    response.setStatus(405);
    return;
}

String result = "invalid";
try {
    if (!hasSingleParameter(request, "o_id") || !hasSingleParameter(request, "rf_id")
            || !hasSingleParameter(request, "rf_status")
            || !hasSingleParameter(request, "adminCsrfToken")) {
        throw new IllegalArgumentException();
    }
    int orderId = Integer.parseInt(request.getParameter("o_id"));
    int refundId = Integer.parseInt(request.getParameter("rf_id"));
    String status = request.getParameter("rf_status");
    Object adminIdValue = session.getAttribute("adminId");
    if (orderId <= 0 || refundId <= 0 || !(adminIdValue instanceof String)
            || ((String)adminIdValue).trim().isEmpty()) {
        throw new IllegalArgumentException();
    }
    new AdminRefundDAO().updateRefundStatusForOrder(orderId, refundId, status, (String)adminIdValue);
    result = "updated";
} catch (IllegalArgumentException e) {
    result = "invalid";
} catch (Exception e) {
    result = "failed";
    System.err.println("Admin refund status update failed.");
}
response.sendRedirect("admin_order_refund.jsp?refundStatusResult=" + result);
%>
