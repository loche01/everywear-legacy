<%@ page contentType="application/json; charset=UTF-8" %><%
    // 서버에서 PG 결제 금액을 다시 확인하지 않는 경로이므로 payment/orders/delivery 를 생성하지 않는다.
    // 클라이언트가 보낸 imp_uid/금액/상품/주소 파라미터는 신뢰하지도 저장하지도 않는다.
%>{"result":"demo","paymentCreated":false,"orderCreated":false}
