<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminDeliveryDAO" %>
<%@ page import="java.util.*" %>

<%
// 인코딩 설정
request.setCharacterEncoding("UTF-8");

// DAO 객체 생성
AdminDeliveryDAO deliveryDAO = new AdminDeliveryDAO();

// 일괄 업데이트 여부 확인
String bulkUpdate = request.getParameter("bulkUpdate");
boolean isBulkUpdate = "true".equals(bulkUpdate);

String message = "";
boolean success = false;
List<Integer> requestedIds = new ArrayList<>();
List<Integer> requestedOrders = new ArrayList<>();
List<String> requestedStatuses = new ArrayList<>();

try {
if (isBulkUpdate) {
    // 일괄 업데이트 처리
    String bulkStatus = request.getParameter("bulkStatus");
    String[] deliveryIdsStr = request.getParameterValues("deliveryIds");
    
    if (deliveryIdsStr != null && deliveryIdsStr.length > 0 && bulkStatus != null && !bulkStatus.isEmpty()) {
        for (String deliveryIdStr : deliveryIdsStr) {
            int deliveryId = Integer.parseInt(deliveryIdStr);
            requestedIds.add(deliveryId);
            requestedOrders.add(Integer.parseInt(request.getParameter("order_" + deliveryId)));
            requestedStatuses.add(bulkStatus);
        }
        message = requestedIds.size() + "개 배송 정보의 상태가 '" + bulkStatus + "'(으)로 변경되었습니다.";
    } else {
        message = "업데이트할 배송 정보가 선택되지 않았거나 상태값이 잘못되었습니다.";
    }
} else {
    // 개별 업데이트 처리
    Enumeration<String> paramNames = request.getParameterNames();
    
    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();
        
        if (paramName.startsWith("status_")) {
            String d_idStr = paramName.substring("status_".length());
            int d_id = Integer.parseInt(d_idStr);
            String status = request.getParameter(paramName);
            
            requestedIds.add(d_id);
            requestedOrders.add(Integer.parseInt(request.getParameter("order_" + d_id)));
            requestedStatuses.add(status);
        }
    }
    
    if (!requestedIds.isEmpty()) {
        message = requestedIds.size() + "개 배송 정보의 상태가 변경되었습니다.";
    } else {
        message = "변경된 배송 상태가 없습니다.";
    }
}

// 모든 입력값을 읽은 뒤 하나의 트랜잭션에서 전체 주문/배송 관계를 확인한다.
if (!requestedIds.isEmpty()) {
    int[] deliveryIds = new int[requestedIds.size()];
    int[] orderIds = new int[requestedIds.size()];
    for (int i = 0; i < deliveryIds.length; i++) {
        deliveryIds[i] = requestedIds.get(i);
        orderIds[i] = requestedOrders.get(i);
    }
    success = deliveryDAO.updateMultipleDeliveryStatus(deliveryIds, orderIds,
            requestedStatuses.toArray(new String[0]));
    if (!success) message = "배송 상태 변경에 실패했습니다. 주문과 배송 정보를 확인해주세요.";
}
} catch (NumberFormatException e) {
    message = "배송 상태 변경에 실패했습니다. 주문과 배송 정보를 확인해주세요.";
}

// 상태 메시지와 함께 목록 페이지로 리다이렉트
response.sendRedirect("admin_order_delivery.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%> 