<!-- mypageHeader.jsp -->

<!-- 상위 네비 -->
<header class="top-nav">
  <div class="nav-left">
    <!-- 햄버거 버튼 -->
    <button class="menu-btn">&#9776;</button>
  </div>

  <!-- 중앙 로고 -->
  <div class="logo-wrap">
    <a href="main.jsp">
      <img src="images/logo-black.png" alt="everyWEAR" class="logo-img">
    </a>
    <p class="mypage-title">MYPAGE</p>
  </div>

  <div class="nav-right">
    <form action="<%=request.getContextPath()%>/UserLogout" method="post" style="display:inline;margin:0">
      <input type="hidden" name="userCsrfToken" value="<%=Security.UserRequestGuard.token(session)%>">
      <button type="submit" style="border:0;background:none;padding:0;font:inherit;cursor:pointer">LOGOUT</button>
    </form>
    <a href="cart2.jsp">CART</a>
  </div>
</header>
