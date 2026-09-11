<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
		String id = (String)session.getAttribute("id");

		// 현재 페이지 경로를 얻기 위한 코드
		String fullUrl = request.getRequestURI();
		String queryString = request.getQueryString();
		if (queryString != null) {
			fullUrl += "?" + queryString;
		}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="stylesheet" type="text/css" href="css/boardHeader.css?v=1354351">
<link rel="icon" type="image/png" href="images/fav-icon.png">
</head>
<body>

	<!-- 상위 네비 -->
	<header class="top-nav">
		<div class="nav-left">
			<button class="menu-btn" onclick="toggleSidebar()">&#9776;</button>
			<script>
				function toggleSidebar() {
					const sidebar = document.getElementById("sidebar");
					const overlay = document.getElementById("overlay");
					sidebar.classList.toggle("open");
					overlay.classList.toggle("active");
				}

				function closeSidebar() {
					document.getElementById("sidebar").classList.remove("open");
					document.getElementById("overlay").classList.remove("active");
				}
			</script>

		</div>
		<%if(id == null){ %>
		<div class="nav-right">
			<a href="login.jsp?redirect=<%= java.net.URLEncoder.encode(fullUrl, "UTF-8") %>">LOGIN</a> <a href="cart2.jsp">CART</a>
		</div>
		<%} else{ %>
		<div class="nav-right">
			<form action="<%=request.getContextPath()%>/UserLogout" method="post" style="display:inline;margin:0">
				<input type="hidden" name="userCsrfToken" value="<%=Security.UserRequestGuard.token(session)%>">
				<button type="submit" style="border:0;background:none;padding:0;font:inherit;cursor:pointer">LOGOUT</button>
			</form> <a href="cart2.jsp">CART</a>
		</div>
		<%} %>

		<!-- 사이드바 메뉴 -->
		<div id="sidebar" class="sidebar">
			<a href="productNew.jsp">NEW</a>
			<a href="productBest.jsp">BEST</a>
			<a href="productList.jsp?cat=all" class="group-gap">ALL</a>
			<a href="productList.jsp?cat=outer">OUTER</a>
			<a href="productList.jsp?cat=top">TOP</a>
			<a href="productList.jsp?cat=bottom">BOTTOM</a>
			<a href="productList.jsp?cat=acc">ACC</a>
			<a href="#">SALE</a>
			<a href="myPage.jsp" class="group-gap">MY PAGE</a>
			<a href="board.jsp">BOARD</a>
		</div>

		<div id="overlay" class="overlay" onclick="closeSidebar()"></div>

	</header>

	<!-- 로고 -->
	<div class="logo-wrap">
		<a href="main2.jsp"> <img src="images/logo-black.png"
			alt="everyWEAR" class="logo-img">
		</a>
	</div>

</body>