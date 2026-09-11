<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminOrderDAO" %>
<%@ page import="DAO.AdminRefundDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%!
private String refundHtml(Object value) {
    return value == null ? "-" : String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 주문 상세 정보</title>
    <link rel="icon" type="image/png" href="images/fav-icon.png">
    <link rel="stylesheet" href="css/admin_order.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1, h2 {
            color: #333;
            margin-bottom: 20px;
        }
        h1 {
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        h2 {
            margin-top: 30px;
            font-size: 1.5em;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
        .info-section {
            margin-bottom: 30px;
        }
        .info-row {
            display: flex;
            border-bottom: 1px solid #eee;
            padding: 10px 0;
        }
        .info-label {
            width: 200px;
            font-weight: bold;
            color: #555;
        }
        .info-value {
            flex: 1;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            margin: 5px;
            font-size: 14px;
            font-weight: 400;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            cursor: pointer;
            border: 1px solid transparent;
            border-radius: 4px;
            color: #fff;
            background-color: #337ab7;
            border-color: #2e6da4;
            text-decoration: none;
        }
        .btn:hover {
            background-color: #286090;
        }
        .btn-danger {
            background-color: #d9534f;
            border-color: #d43f3a;
        }
        .btn-danger:hover {
            background-color: #c9302c;
        }
        .btn-success {
            background-color: #5cb85c;
            border-color: #4cae4c;
        }
        .btn-success:hover {
            background-color: #449d44;
        }
        .btn-warning {
            background-color: #f0ad4e;
            border-color: #eea236;
        }
        .btn-warning:hover {
            background-color: #ec971f;
        }
        .btn-info {
            background-color: #5bc0de;
            border-color: #46b8da;
        }
        .btn-info:hover {
            background-color: #31b0d5;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 14px;
            color: white;
            font-weight: bold;
        }
        .status-pay-complete {
            background-color: #28a745;
        }
        .status-refund {
            background-color: #dc3545;
        }
        .status-preparing {
            background-color: #ffc107;
            color: #212529;
        }
        .status-shipping {
            background-color: #17a2b8;
        }
        .status-delivered {
            background-color: #6c757d;
        }
        .form-control {
            display: block;
            width: 100%;
            height: 34px;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .actions-panel {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
            border: 1px solid #ddd;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-success {
            color: #3c763d;
            background-color: #dff0d8;
            border-color: #d6e9c6;
        }
        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/admin_header.jsp" />
    <div class="container">
        <h1>주문 상세 정보</h1>
        
        <%
        // 메시지 처리
        String message = request.getParameter("message");
        String messageType = request.getParameter("messageType");
        if(message != null && !message.isEmpty()) {
        %>
        <div class="alert alert-<%= messageType != null ? messageType : "success" %>">
            <%= message %>
        </div>
        <%
        }
        
        // 주문 ID 가져오기
        int orderId = 0;
        try {
            orderId = Integer.parseInt(request.getParameter("o_id"));
        } catch(Exception e) {
            out.println("<div class='alert alert-danger'>유효하지 않은 주문 ID입니다.</div>");
            return;
        }
        
        // DAO 객체 생성
        AdminOrderDAO orderDAO = new AdminOrderDAO();
        Map<String, Object> orderDetail = orderDAO.getOrderDetailById(orderId);
        
        if(orderDetail == null || orderDetail.isEmpty()) {
            out.println("<div class='alert alert-danger'>주문 정보를 찾을 수 없습니다.</div>");
            return;
        }
        
        // 화폐 포맷
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.KOREA);
        %>
        
        <div class="info-section">
            <h2>기본 정보</h2>
            <div class="info-row">
                <div class="info-label">주문 번호</div>
                <div class="info-value"><%= orderDetail.get("o_num") %></div>
            </div>
            <div class="info-row">
                <div class="info-label">주문 일시</div>
                <div class="info-value"><%= orderDetail.get("created_at") %></div>
            </div>
            <div class="info-row">
                <div class="info-label">회원 구분</div>
                <div class="info-value"><%= "Y".equals(orderDetail.get("o_isMember")) ? "회원" : "비회원" %></div>
            </div>
            <% if(orderDetail.get("user_id") != null) { %>
            <div class="info-row">
                <div class="info-label">회원 ID</div>
                <div class="info-value"><%= orderDetail.get("user_id") %> (<%= orderDetail.get("user_type") %>)</div>
            </div>
            <% } %>
            <div class="info-row">
                <div class="info-label">주문자명</div>
                <div class="info-value"><%= orderDetail.get("o_name") %></div>
            </div>
            <div class="info-row">
                <div class="info-label">주문자 연락처</div>
                <div class="info-value"><%= orderDetail.get("o_phone") %></div>
            </div>
        </div>
        
        <div class="info-section">
            <h2>상품 정보</h2>
            <div class="info-row">
                <div class="info-label">상품 ID</div>
                <div class="info-value"><%= orderDetail.get("p_id") %></div>
            </div>
            <div class="info-row">
                <div class="info-label">상품명</div>
                <div class="info-value"><%= orderDetail.get("p_name") %></div>
            </div>
            <div class="info-row">
                <div class="info-label">사이즈</div>
                <div class="info-value"><%= orderDetail.get("pd_size") %></div>
            </div>
            <div class="info-row">
                <div class="info-label">수량</div>
                <div class="info-value"><%= orderDetail.get("o_quantity") %></div>
            </div>
            <div class="info-row">
                <div class="info-label">단가</div>
                <div class="info-value"><%= currencyFormat.format(orderDetail.get("p_price")) %></div>
            </div>
            <div class="info-row">
                <div class="info-label">총 결제금액</div>
                <div class="info-value"><%= currencyFormat.format(orderDetail.get("o_total_amount")) %></div>
            </div>
        </div>
        
        <div class="info-section">
            <h2>결제 정보</h2>
            <div class="info-row">
                <div class="info-label">결제 상태</div>
                <div class="info-value">
                    <% 
                    String payStatus = (String)orderDetail.get("pay_status");
                    if(payStatus != null) {
                        if(payStatus.contains("완료") || payStatus.contains("결제")) {
                            %><span class="status-badge status-pay-complete"><%= payStatus %></span><%
                        } else if(payStatus.contains("환불")) {
                            %><span class="status-badge status-refund"><%= payStatus %></span><%
                        } else {
                            %><%= payStatus %><%
                        }
                    } else {
                        %>-<%
                    }
                    %>
                </div>
            </div>
            <div class="info-row">
                <div class="info-label">결제 수단</div>
                <div class="info-value"><%= orderDetail.get("card_name") != null ? orderDetail.get("card_name") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">결제 고유번호</div>
                <div class="info-value"><%= orderDetail.get("imp_uid") != null ? orderDetail.get("imp_uid") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">승인번호</div>
                <div class="info-value"><%= orderDetail.get("apply_num") != null ? orderDetail.get("apply_num") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">결제 일시</div>
                <div class="info-value"><%= orderDetail.get("pay_date") != null ? orderDetail.get("pay_date") : "-" %></div>
            </div>
        </div>
        
        <div class="info-section">
            <h2>배송 정보</h2>
            <% if(orderDetail.get("d_id") != null && !orderDetail.get("d_id").equals(0)) { %>
            <div class="info-row">
                <div class="info-label">배송지명</div>
                <div class="info-value"><%= orderDetail.get("d_name") != null ? orderDetail.get("d_name") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">받는분</div>
                <div class="info-value"><%= orderDetail.get("recv_name") != null ? orderDetail.get("recv_name") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">받는분 연락처</div>
                <div class="info-value"><%= orderDetail.get("recv_phone") != null ? orderDetail.get("recv_phone") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">우편번호</div>
                <div class="info-value"><%= orderDetail.get("recv_zipcode") != null ? orderDetail.get("recv_zipcode") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">주소</div>
                <div class="info-value">
                    <%= orderDetail.get("recv_addr_road") != null ? orderDetail.get("recv_addr_road") : "" %>
                    <%= orderDetail.get("recv_addr_detail") != null ? orderDetail.get("recv_addr_detail") : "" %>
                </div>
            </div>
            <div class="info-row">
                <div class="info-label">배송 상태</div>
                <div class="info-value">
                    <% 
                    String dStatus = (String)orderDetail.get("d_status");
                    if(dStatus != null) {
                        if(dStatus.contains("준비")) {
                            %><span class="status-badge status-preparing"><%= dStatus %></span><%
                        } else if(dStatus.contains("배송중")) {
                            %><span class="status-badge status-shipping"><%= dStatus %></span><%
                        } else if(dStatus.contains("완료")) {
                            %><span class="status-badge status-delivered"><%= dStatus %></span><%
                        } else {
                            %><%= dStatus %><%
                        }
                    } else {
                        %>-<%
                    }
                    %>
                </div>
            </div>
            <div class="info-row">
                <div class="info-label">택배사</div>
                <div class="info-value"><%= orderDetail.get("d_courier") != null ? orderDetail.get("d_courier") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">송장번호</div>
                <div class="info-value"><%= orderDetail.get("d_tracking_num") != null ? orderDetail.get("d_tracking_num") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">배송 시작일</div>
                <div class="info-value"><%= orderDetail.get("shipped_at") != null ? orderDetail.get("shipped_at") : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">배송 완료일</div>
                <div class="info-value"><%= orderDetail.get("completed_at") != null ? orderDetail.get("completed_at") : "-" %></div>
            </div>
            <% } else { %>
            <div class="alert alert-warning">배송 정보가 없습니다.</div>
            <% } %>
        </div>
        
        <% String refundResult = request.getParameter("refundResult");
           if ("created".equals(refundResult)) { %>
        <p class="alert alert-success">환불 요청이 등록되었습니다. 실제 결제 취소는 수행하지 않았습니다.</p>
        <% } else if ("invalid".equals(refundResult) || "failed".equals(refundResult)) { %>
        <p class="alert alert-danger">환불 요청을 등록할 수 없습니다. 기존 환불 여부와 주문·입력값을 확인해주세요.</p>
        <% } %>
        <% if(orderDetail.get("rf_id") != null && !orderDetail.get("rf_id").equals(0)) { %>
        <div class="info-section">
            <h2>환불 정보</h2>
            <div class="info-row">
                <div class="info-label">환불 상태</div>
                <div class="info-value">
                    <% 
                    String rfStatus = (String)orderDetail.get("rf_status");
                    if(rfStatus != null) {
                        if(rfStatus.contains("신청")) {
                            %><span class="status-badge status-preparing"><%= rfStatus %></span><%
                        } else if(rfStatus.contains("완료")) {
                            %><span class="status-badge status-refund"><%= rfStatus %></span><%
                        } else {
                            %><%= rfStatus %><%
                        }
                    } else {
                        %>-<%
                    }
                    %>
                </div>
            </div>
            <div class="info-row">
                <div class="info-label">환불 사유</div>
                <div class="info-value"><%= refundHtml(orderDetail.get("rf_reason")) %></div>
            </div>
            <div class="info-row">
                <div class="info-label">환불 금액</div>
                <div class="info-value"><%= orderDetail.get("rf_amount") != null ? currencyFormat.format(orderDetail.get("rf_amount")) : "-" %></div>
            </div>
            <div class="info-row">
                <div class="info-label">환불 일시</div>
                <div class="info-value"><%= orderDetail.get("rf_date") != null ? orderDetail.get("rf_date") : "-" %></div>
            </div>
        </div>
        <% } %>
        
        <% if (orderDetail.get("rf_id") == null || orderDetail.get("rf_id").equals(0)) { %>
        <div class="info-section" id="refundRequest">
            <h2>환불 요청 등록</h2>
            <p>주문당 최초 요청 1건만 등록합니다. 추가·분할 요청 및 실제 결제 취소는 지원하지 않습니다.</p>
            <form action="admin_create_refund.jsp" method="post" accept-charset="UTF-8">
                <input type="hidden" name="adminCsrfToken" value="<%= refundHtml(session.getAttribute("adminCsrfToken")) %>">
                <input type="hidden" name="o_id" value="<%= orderId %>">
                <input type="hidden" name="quantity" value="<%= refundHtml(orderDetail.get("o_quantity")) %>">
                <input type="hidden" name="amount" value="<%= refundHtml(orderDetail.get("o_total_amount")) %>">
                <p>환불 수량: <strong><%= refundHtml(orderDetail.get("o_quantity")) %></strong></p>
                <p>환불 금액: <strong><%= currencyFormat.format(orderDetail.get("o_total_amount")) %></strong></p>
                <p><label>환불 사유 <select name="reasonCode" required>
                    <option value="">선택해주세요</option>
                    <% for (String reason : AdminRefundDAO.REQUEST_REASON_CODES) { %>
                    <option value="<%= refundHtml(reason) %>"><%= refundHtml(reason) %></option>
                    <% } %>
                </select></label></p>
                <p><label>상세 사유 <textarea name="reasonText" maxlength="<%= AdminRefundDAO.MAX_REASON_TEXT_LENGTH %>"></textarea></label></p>
                <button type="submit" class="btn">환불 요청 등록</button>
            </form>
        </div>
        <% } else { %>
        <p>이미 환불이 연결된 주문입니다. <a href="admin_order_refund.jsp">환불 조회 화면</a>에서 확인해주세요.</p>
        <% } %>
        <div class="actions-panel">
            <div style="text-align: center;">
                <a href="admin_order_list.jsp" class="btn">목록으로 돌아가기</a>
            </div>
        </div>
    </div>
</body>
</html> 