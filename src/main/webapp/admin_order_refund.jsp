<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminRefundDAO,java.util.*,java.text.NumberFormat,java.text.SimpleDateFormat,java.net.URLEncoder" %>
<%!
private String h(Object value) {
    return value == null ? "" : String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
}
private String shown(Object value) { return value == null ? "-" : h(value); }
%>
<%
response.setHeader("Cache-Control", "no-store");
request.setAttribute("currentMenu", "order");
request.setAttribute("subMenu", "order_cancel");
String orderNum = request.getParameter("orderNum");
orderNum = orderNum == null ? "" : orderNum.trim();
String filter = request.getParameter("status");
filter = filter == null || filter.isEmpty() ? "all" : filter;
String status = null;
int pageSize = 10, currentPage = 1, totalPages = 1, totalRefunds = 0;
String error = null;
String statusResult = request.getParameter("refundStatusResult");
String statusNotice = null;
if ("updated".equals(statusResult)) statusNotice = "환불 상태가 변경되었습니다.";
else if ("invalid".equals(statusResult) || "failed".equals(statusResult)) {
    statusNotice = "환불 상태를 변경할 수 없습니다. 요청 내용을 확인해주세요.";
}
List<Map<String, Object>> refunds = Collections.emptyList();
try {
    if (orderNum.length() > 100) throw new IllegalArgumentException();
    switch (filter) {
        case "all": break;
        case "requested": status = "신청됨"; break;
        case "processing": status = "처리중"; break;
        case "completed": status = "완료"; break;
        case "rejected": status = "거절"; break;
        default: throw new IllegalArgumentException();
    }
    if (request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page"));
    if (currentPage < 1) throw new IllegalArgumentException();
} catch (IllegalArgumentException e) {
    response.setStatus(400);
    error = "검색 조건을 확인해주세요.";
}
if (error == null) {
    try {
        AdminRefundDAO dao = new AdminRefundDAO();
        totalRefunds = dao.getRefundCount(orderNum, status);
        totalPages = (int)Math.max(1L, (totalRefunds + (long)pageSize - 1) / pageSize);
        currentPage = Math.min(currentPage, totalPages);
        refunds = dao.getRefundList(orderNum, status, (currentPage - 1) * pageSize, pageSize);
    } catch (Exception e) {
        response.setStatus(503);
        error = "환불 내역을 조회할 수 없습니다. 잠시 후 다시 시도해주세요.";
        System.err.println("Admin refund list retrieval failed.");
    }
}
NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.KOREA);
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String pageQuery = "&orderNum=" + URLEncoder.encode(orderNum, "UTF-8")
        + "&status=" + URLEncoder.encode(filter, "UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>환불 내역 조회 | everyWEAR</title>
  <link rel="icon" type="image/png" href="images/fav-icon.png">
  <link rel="stylesheet" href="css/admin_order.css">
  <style>
    .refund-table-wrap { overflow-x: auto; margin-top: 20px; }
    .refund-notice { padding: 16px; background: #f5f5f5; }
    .refund-warning { color: #8a4b00; }
    #refundModal { width: min(850px, 90vw); max-height: 85vh; border: 0; border-radius: 6px; padding: 24px; }
    #refundModal::backdrop { background: rgba(0,0,0,.5); }
    #refundModal .info-row { display: grid; grid-template-columns: 140px 1fr; gap: 12px; padding: 8px 0; border-bottom: 1px solid #eee; }
    #refundModal .info-value { overflow-wrap: anywhere; white-space: pre-wrap; }
    #refundModal .info-section { margin-top: 20px; }
  </style>
</head>
<body>
<jsp:include page="includes/admin_header.jsp" />
<main>
  <div class="container">
    <h2>환불 내역 조회</h2>
    <p>환불 상태를 조회하고 허용된 다음 상태로 개별 변경합니다. 실제 결제 취소는 수행하지 않습니다.</p>
    <form action="admin_order_refund.jsp" method="get" class="filter-group" id="refundSearchForm">
      <label for="refundOrderNum">주문번호</label>
      <input id="refundOrderNum" class="search-input" name="orderNum" maxlength="100" value="<%= h(orderNum) %>">
      <label for="refundStatus">상태</label>
      <select id="refundStatus" class="custom-select" name="status">
        <option value="all" <%= "all".equals(filter) ? "selected" : "" %>>전체</option>
        <option value="requested" <%= "requested".equals(filter) ? "selected" : "" %>>신청됨</option>
        <option value="processing" <%= "processing".equals(filter) ? "selected" : "" %>>처리중</option>
        <option value="completed" <%= "completed".equals(filter) ? "selected" : "" %>>완료</option>
        <option value="rejected" <%= "rejected".equals(filter) ? "selected" : "" %>>거절</option>
      </select>
      <button type="submit" class="search-button">검색</button>
      <a href="admin_order_refund.jsp">초기화</a>
    </form>
    <% if (statusNotice != null) { %>
    <p class="refund-notice" role="status"><%= h(statusNotice) %></p>
    <% } %>
    <% if (error != null) { %>
    <p class="refund-notice" role="alert"><%= h(error) %></p>
    <% } else { %>
    <p id="refundCount">총 <strong><%= totalRefunds %></strong>건</p>
    <% if (refunds.isEmpty()) { %>
    <p class="refund-notice" id="refundEmpty">환불 내역이 없습니다.</p>
    <% } else { %>
    <div class="refund-table-wrap">
      <table class="order-table" id="refundTable">
        <thead><tr><th>환불 ID</th><th>연결 주문 / 주문자 / 상품</th><th>환불 수량</th><th>환불 금액</th><th>사유</th><th>상태 / 변경</th><th>처리일시</th><th>처리 관리자</th><th>상세</th></tr></thead>
        <tbody>
        <% for (Map<String, Object> refund : refunds) {
            List<Map<String, Object>> orders = (List<Map<String, Object>>)refund.get("orders");
        %>
          <tr data-refund-id="<%= h(refund.get("rf_id")) %>">
            <td><%= shown(refund.get("rf_id")) %></td>
            <td>
              <% if (orders.isEmpty()) { %>연결된 주문 없음<% } %>
              <% if (orders.size() > 1) { %><p class="refund-warning">여러 주문 연결: <%= orders.size() %>건 · 관계 확인 필요</p><% } %>
              <% for (Map<String, Object> order : orders) { %>
              <div><%= shown(order.get("o_num")) %> / <%= shown(order.get("o_name")) %> / <%= shown(order.get("p_name")) %></div>
              <% } %>
            </td>
            <td><%= shown(refund.get("rf_quantity")) %></td>
            <td><%= h(currency.format(refund.get("rf_amount"))) %></td>
            <td><%= shown(refund.get("rf_reason_code")) %></td>
            <td>
              <% String currentStatus = String.valueOf(refund.get("rf_status"));
                 List<String> statusOptions = new ArrayList<>();
                 statusOptions.add(currentStatus);
                 if ("신청됨".equals(currentStatus)) {
                     statusOptions.add("처리중");
                     statusOptions.add("거절");
                 } else if ("처리중".equals(currentStatus)) {
                     statusOptions.add("완료");
                     statusOptions.add("거절");
                 }
              %>
              <div><%= shown(currentStatus) %></div>
              <% if (orders.size() == 1 && List.of("신청됨", "처리중", "완료", "거절").contains(currentStatus)) { %>
              <form action="admin_update_refund_status.jsp" method="post" accept-charset="UTF-8">
                <input type="hidden" name="adminCsrfToken" value="<%= h(session.getAttribute("adminCsrfToken")) %>">
                <input type="hidden" name="o_id" value="<%= h(orders.get(0).get("o_id")) %>">
                <input type="hidden" name="rf_id" value="<%= h(refund.get("rf_id")) %>">
                <select name="rf_status" aria-label="환불 상태">
                  <% for (String option : statusOptions) { %>
                  <option value="<%= h(option) %>" <%= option.equals(currentStatus) ? "selected" : "" %>><%= h(option) %></option>
                  <% } %>
                </select>
                <button type="submit" class="btn btn-sm">저장</button>
              </form>
              <% } else { %>
              <div class="refund-warning">주문 관계 확인 필요</div>
              <% } %>
            </td>
            <td><%= refund.get("refunded_at") == null ? "-" : h(dateFormat.format(refund.get("refunded_at"))) %></td>
            <td><%= shown(refund.get("admin_name")) %></td>
            <td><button type="button" class="btn btn-sm refund-detail-btn" data-refund-id="<%= h(refund.get("rf_id")) %>">상세보기</button></td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>
    <% } %>
    <% if (totalPages > 1) { %>
    <nav class="pagination-container" aria-label="환불 페이지">
      <ul class="pagination">
        <% if (currentPage > 1) { %><li><a href="<%= h("admin_order_refund.jsp?page=" + (currentPage - 1) + pageQuery) %>">이전</a></li><% } %>
        <% for (int pageNo = Math.max(1, currentPage - 2); pageNo <= Math.min(totalPages, currentPage + 2); pageNo++) { %>
        <li class="<%= pageNo == currentPage ? "active" : "" %>"><a href="<%= h("admin_order_refund.jsp?page=" + pageNo + pageQuery) %>" <%= pageNo == currentPage ? "aria-current=\"page\"" : "" %>><%= pageNo %></a></li>
        <% } %>
        <% if (currentPage < totalPages) { %><li><a href="<%= h("admin_order_refund.jsp?page=" + (currentPage + 1) + pageQuery) %>">다음</a></li><% } %>
      </ul>
    </nav>
    <% } } %>
  </div>
</main>
<dialog id="refundModal" aria-label="환불 상세 정보">
  <button type="button" class="btn" id="refundModalClose">닫기</button>
  <div id="refundModalContent" aria-live="polite"></div>
</dialog>
<script>
(() => {
  const modal = document.getElementById('refundModal');
  const content = document.getElementById('refundModalContent');
  let requestVersion = 0;
  document.getElementById('refundModalClose').addEventListener('click', () => modal.close());
  modal.addEventListener('close', () => { requestVersion++; content.textContent = ''; });
  document.querySelectorAll('.refund-detail-btn').forEach(button => {
    button.addEventListener('click', async () => {
      const version = ++requestVersion;
      content.textContent = '조회 중입니다.';
      if (!modal.open) modal.showModal();
      try {
        const response = await fetch('admin_refund_modal.jsp?rf_id=' + encodeURIComponent(button.dataset.refundId), {
          method: 'GET', credentials: 'same-origin', headers: { 'X-Requested-With': 'XMLHttpRequest' }
        });
        if (version !== requestVersion) return;
        if (response.status === 401 || response.redirected) {
          content.textContent = '관리자 인증이 필요합니다. ';
          const link = document.createElement('a');
          link.href = 'admin_login.jsp';
          link.textContent = '다시 로그인';
          content.appendChild(link);
        } else if (!response.ok) {
          content.textContent = '환불 정보를 조회할 수 없습니다. 잠시 후 다시 시도해주세요.';
        } else {
          const fragment = await response.text();
          if (version === requestVersion) content.innerHTML = fragment;
        }
      } catch (error) {
        if (version === requestVersion) content.textContent = '환불 정보를 조회할 수 없습니다. 잠시 후 다시 시도해주세요.';
      }
    });
  });
})();
</script>
</body>
</html>