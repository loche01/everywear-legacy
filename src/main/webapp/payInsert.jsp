<%@ page contentType="application/json; charset=UTF-8" %><%
    // PHASE 6: 포트폴리오 Demo 환경.
    // 실제 PG 결제 검증이 없는 Legacy 경로이므로 payment/orders/delivery 를 생성하지 않는다.
    // 클라이언트가 보낸 imp_uid/금액/상품/주소 파라미터는 신뢰하지도 저장하지도 않는다.
%>{"result":"demo","paymentCreated":false,"orderCreated":false}
