<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminOrderDAO" %>
<%
// POST 요청 확인
if(!"POST".equalsIgnoreCase(request.getMethod())) {
    response.sendRedirect("admin_order_list.jsp");
    return;
}

// 결제 ID와 주문 ID, 변경할 상태 가져오기
int paymentId = 0;
int orderId = 0;
String status = "";

try {
    paymentId = Integer.parseInt(request.getParameter("pay_id"));
    orderId = Integer.parseInt(request.getParameter("o_id"));
    status = request.getParameter("pay_status");
    
    // 입력값 유효성 검사
    if(paymentId <= 0 || orderId <= 0 || status == null || status.isEmpty()) {
        response.sendRedirect("admin_order_detail.jsp?o_id=" + orderId + "&message=" + java.net.URLEncoder.encode("유효하지 않은 입력값입니다.", "UTF-8") + "&messageType=danger");
        return;
    }
    
    // 상태값 유효성 검사
    if(!status.equals("결제 완료") && !status.equals("환불 처리중") && !status.equals("환불 완료")) {
        response.sendRedirect("admin_order_detail.jsp?o_id=" + orderId + "&message=" + java.net.URLEncoder.encode("유효하지 않은 결제 상태입니다.", "UTF-8") + "&messageType=danger");
        return;
    }
    
    // DAO를 통해 상태 업데이트
    AdminOrderDAO orderDAO = new AdminOrderDAO();
    boolean success = orderDAO.updatePaymentStatus(orderId, paymentId, status);
    
    if(success) {
        response.sendRedirect("admin_order_detail.jsp?o_id=" + orderId + "&message=" + java.net.URLEncoder.encode("결제 상태가 '" + status + "'로 변경되었습니다.", "UTF-8") + "&messageType=success");
    } else {
        response.sendRedirect("admin_order_detail.jsp?o_id=" + orderId + "&message=" + java.net.URLEncoder.encode("결제 상태 변경에 실패했습니다.", "UTF-8") + "&messageType=danger");
    }
    
} catch(Exception e) {
    System.err.println("Admin payment status request failed.");
    response.sendRedirect("admin_order_detail.jsp?o_id=" + orderId + "&message=" + java.net.URLEncoder.encode("결제 상태 변경에 실패했습니다.", "UTF-8") + "&messageType=danger");
}
%> 