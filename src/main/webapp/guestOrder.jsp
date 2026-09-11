<!-- guestOrder.jsp -->

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비회원 주문 조회 | everyWEAR</title>

    <link rel="stylesheet" type="text/css" href="css/login.css">
    <link rel="icon" type="image/png" href="images/logo-white.png">
</head>
<body>

    <%@ include file="includes/loginHeader.jsp" %>

    <div class="login-container">
        <form action="guestOrderCheck.jsp" method="post">
            <label for="name">주문자명</label>
            <input type="text" id="name" name="name" placeholder="이름을 입력하세요." required>

            <label for="orderNumber">주문번호</label>
            <input type="text" id="orderNumber" name="orderNumber" placeholder="주문번호를 입력하세요." required>

            <label for="phone">비회원주문 전화번호</label>
            <input type="text" id="phone" name="phone" placeholder="전화번호를 입력하세요." required>

            <!-- 로그인 버튼과 동일한 너비로 적용 -->
            <button type="submit" class="login-btn">주문 조회</button>
        </form>
    </div>

    <footer>
        2025©everyWEAR
    </footer>

</body>
</html>
