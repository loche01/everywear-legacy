<!-- payProc.jsp -->
<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.JSONObject"%>
<%!
    // 주문서에서 넘어온 값은 모두 JS 문자열 리터럴로 escape 해서 출력한다(원본은 그대로 삽입해 XSS 위험이 있었다).
    private static String js(String value) {
        return JSONObject.quote(value == null ? "" : value);
    }
%>
<%
    request.setCharacterEncoding("UTF-8");

    // 테스트 결제 전용 경로. 아임포트 공개 테스트 식별코드와 이니시스 테스트 PG만 사용한다.
    // 결제 결과를 DB에 저장하지 않는다. 저장하려면 서버에서 결제 금액을 다시 검증하는 로직이 필요하다.
    String products = request.getParameter("Products");
    String oNum = request.getParameter("ONum");
    String pName = request.getParameter("PName");
    String pPhone = request.getParameter("PPhone");
    String pEmail = request.getParameter("PEmail");
    String pZipcode = request.getParameter("PZipcode");
    String pAddress1 = request.getParameter("PAddress1");
    String pAddress2 = request.getParameter("PAddress2");

    long price = 0;
    try {
        price = Long.parseLong(request.getParameter("Price"));
    } catch (Exception e) {
        price = 0;
    }
    if (price < 1 || price > 10_000_000L) {
        price = 0; // 테스트 결제는 1원 이상 1천만원 이하만 허용한다.
    }

    if (products == null || products.isBlank()) {
        products = "everyWEAR 주문";
    }

    String buyerAddr = (pZipcode == null ? "" : pZipcode + " ")
            + (pAddress1 == null ? "" : pAddress1)
            + (pAddress2 == null || pAddress2.isBlank() ? "" : " " + pAddress2);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 | everyWEAR</title>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; margin: 0; background: #fff; }
    .wrap { max-width: 540px; margin: 60px auto; padding: 28px; border: 1px solid #e0e0e0; border-radius: 8px; }
    .notice { background: #fff4d6; color: #6b5a1e; font-size: 13px; padding: 10px 14px; border-radius: 6px; margin-bottom: 20px; }
    h2 { margin: 0 0 12px; font-size: 20px; }
    dl { display: grid; grid-template-columns: 120px 1fr; gap: 8px 12px; font-size: 14px; margin: 16px 0; }
    dt { color: #666; }
    dd { margin: 0; word-break: break-all; }
    .btns { margin-top: 24px; text-align: center; }
    .btns button { padding: 10px 18px; margin: 0 6px; cursor: pointer; }
    .fail { color: #b3261e; }
</style>
</head>
<body>
<div class="wrap">
    <div class="notice">테스트 결제 환경입니다. 아임포트 테스트 식별코드와 이니시스 테스트 결제창을 사용하며, 실제 청구는 발생하지 않습니다. 결제 결과는 주문·결제 데이터로 저장되지 않습니다.</div>
    <h2 id="title">결제창을 여는 중입니다…</h2>
    <dl id="result"></dl>
    <div class="btns">
        <button type="button" onclick="history.back()">이전 화면</button>
        <button type="button" onclick="location.href='main2.jsp'">쇼핑 계속하기</button>
    </div>
</div>
<script>
(function () {
    var price = <%= price %>;
    var title = document.getElementById("title");
    var result = document.getElementById("result");

    function show(text, rows, isFail) {
        title.textContent = text;
        title.className = isFail ? "fail" : "";
        result.innerHTML = "";
        (rows || []).forEach(function (row) {
            var dt = document.createElement("dt");
            dt.textContent = row[0];
            var dd = document.createElement("dd");
            dd.textContent = row[1] == null ? "-" : String(row[1]);
            result.appendChild(dt);
            result.appendChild(dd);
        });
    }

    if (!price) {
        show("결제 금액이 올바르지 않습니다.", [], true);
        return;
    }

    IMP.init('iamport'); // 아임포트 공개 테스트 식별코드
    IMP.request_pay({
        pg: 'html5_inicis',
        pay_method: 'card',
        merchant_uid: 'merchant_' + new Date().getTime(),
        name: <%= js(products) %>,
        amount: price,
        buyer_name: <%= js(pName) %>,
        buyer_tel: <%= js(pPhone) %>,
        buyer_email: <%= js(pEmail) %>,
        buyer_addr: <%= js(buyerAddr) %>,
        buyer_postcode: <%= js(pZipcode) %>
    }, function (rsp) {
        if (rsp.success) {
            show("테스트 결제가 완료되었습니다.", [
                ["주문번호", <%= js(oNum) %>],
                ["결제 금액", rsp.paid_amount + "원"],
                ["결제 수단", rsp.pay_method],
                ["카드 승인번호", rsp.apply_num],
                ["아임포트 거래 ID", rsp.imp_uid],
                ["상점 거래 ID", rsp.merchant_uid]
            ], false);
        } else {
            show("결제가 완료되지 않았습니다.", [
                ["사유", rsp.error_msg]
            ], true);
        }
    });
})();
</script>
</body>
</html>
