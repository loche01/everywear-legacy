<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>결제 데모 | everyWEAR</title>
  <link rel="stylesheet" href="css/payComplete.css">
</head>
<body>

<%@ include file="includes/header.jsp"%>

<section class="content2">
  <h3 class="order-complete-message">결제 데모</h3>
</section>

<div class="order-container">

  <section class="product-section">
    <p class="section-title">안내</p>
    <p>이 포트폴리오 환경에서는 실제 주문·결제·배송이 생성되지 않습니다.</p>
    <p>입력하신 상품·배송 정보는 저장되지 않았으며, 결제·적립금·장바구니에 어떤 변경도 발생하지 않았습니다.</p>
  </section>

  <div class="back-to-home">
    <button onclick="location.href='main2.jsp'">홈으로 돌아가기</button>
  </div>
</div>

<footer class="footer">2025©everyWEAR</footer>

</body>
</html>
