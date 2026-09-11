<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminRefundDAO,java.util.*,java.text.NumberFormat,java.text.SimpleDateFormat" %>
<%!
private String h(Object value) {
    return value == null ? "" : String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
}
private String shown(Object value) { return value == null ? "-" : h(value); }
%>
<%
response.setHeader("Cache-Control", "no-store");
int refundId;
try {
    refundId = Integer.parseInt(request.getParameter("rf_id"));
    if (refundId <= 0) throw new IllegalArgumentException();
} catch (IllegalArgumentException e) {
    out.print("<p>환불 정보를 찾을 수 없습니다.</p>");
    return;
}
Map<String, Object> refund;
try {
    refund = new AdminRefundDAO().getRefundDetail(refundId);
} catch (Exception e) {
    response.setStatus(503);
    System.err.println("Admin refund detail retrieval failed.");
    out.print("<p role='alert'>환불 정보를 조회할 수 없습니다. 잠시 후 다시 시도해주세요.</p>");
    return;
}
if (refund == null) {
    out.print("<p>환불 정보를 찾을 수 없습니다.</p>");
    return;
}
List<Map<String, Object>> orders = (List<Map<String, Object>>)refund.get("orders");
NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.KOREA);
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<section class="refund-detail" data-refund-id="<%= h(refund.get("rf_id")) %>">
  <h2>환불 상세 정보</h2>
  <div class="info-section">
    <div class="info-row"><strong>환불 ID</strong><div class="info-value"><%= shown(refund.get("rf_id")) %></div></div>
    <div class="info-row"><strong>상태</strong><div class="info-value"><%= shown(refund.get("rf_status")) %></div></div>
    <div class="info-row"><strong>환불 수량</strong><div class="info-value"><%= shown(refund.get("rf_quantity")) %></div></div>
    <div class="info-row"><strong>환불 금액</strong><div class="info-value"><%= h(currency.format(refund.get("rf_amount"))) %></div></div>
    <div class="info-row"><strong>사유 코드</strong><div class="info-value"><%= shown(refund.get("rf_reason_code")) %></div></div>
    <div class="info-row"><strong>사유 내용</strong><div class="info-value"><%= shown(refund.get("rf_reason_text")) %></div></div>
    <div class="info-row"><strong>처리일시</strong><div class="info-value"><%= refund.get("refunded_at") == null ? "-" : h(dateFormat.format(refund.get("refunded_at"))) %></div></div>
    <div class="info-row"><strong>처리 관리자</strong><div class="info-value"><%= shown(refund.get("admin_name")) %><% if (refund.get("admin_id") != null) { %> (<%= h(refund.get("admin_id")) %>)<% } %></div></div>
  </div>
  <% if (orders.isEmpty()) { %>
  <p class="refund-notice">연결된 주문 정보가 없습니다.</p>
  <% } else if (orders.size() > 1) { %>
  <p class="refund-warning" role="alert">여러 주문이 연결된 환불입니다: <%= orders.size() %>건. 관계 확인이 필요합니다.</p>
  <% } %>
  <% for (Map<String, Object> order : orders) { %>
  <section class="info-section" data-order-id="<%= h(order.get("o_id")) %>">
    <h3>연결 주문</h3>
    <div class="info-row"><strong>주문번호</strong><div class="info-value"><%= shown(order.get("o_num")) %></div></div>
    <div class="info-row"><strong>주문자명</strong><div class="info-value"><%= shown(order.get("o_name")) %></div></div>
    <div class="info-row"><strong>전화번호</strong><div class="info-value"><%= shown(order.get("o_phone")) %></div></div>
    <div class="info-row"><strong>주문일시</strong><div class="info-value"><%= order.get("created_at") == null ? "-" : h(dateFormat.format(order.get("created_at"))) %></div></div>
    <div class="info-row"><strong>상품명</strong><div class="info-value"><%= shown(order.get("p_name")) %></div></div>
    <div class="info-row"><strong>사이즈</strong><div class="info-value"><%= shown(order.get("pd_size")) %></div></div>
    <div class="info-row"><strong>주문 수량</strong><div class="info-value"><%= shown(order.get("o_quantity")) %></div></div>
    <div class="info-row"><strong>주문 금액</strong><div class="info-value"><%= order.get("o_total_amount") == null ? "-" : h(currency.format(order.get("o_total_amount"))) %></div></div>
  </section>
  <% } %>
</section>
