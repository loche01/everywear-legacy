<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminOrderDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%!
private String refundHtml(Object value) {
    return value == null ? "-" : String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
}
%>

<%
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

<div class="modal-container">
    <div class="modal-header">
        <h1>주문 상세 정보</h1>
        <span class="close-btn" onclick="closeOrderModal()">&times;</span>
    </div>

    <div class="modal-body">
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
                <div class="info-label">주소</div>
                <div class="info-value">
                    <%= orderDetail.get("recv_zipcode") != null ? "(" + orderDetail.get("recv_zipcode") + ") " : "" %>
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
            <% } else { %>
            <div class="alert alert-warning">배송 정보가 없습니다.</div>
            <% } %>
        </div>
        
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
        </div>
        <% } %>
        <% if (orderDetail.get("rf_id") == null || orderDetail.get("rf_id").equals(0)) { %>
        <p><a href="admin_order_detail.jsp?o_id=<%= orderId %>#refundRequest">환불 요청 등록 화면</a></p>
        <% } %>
    </div>
</div> 