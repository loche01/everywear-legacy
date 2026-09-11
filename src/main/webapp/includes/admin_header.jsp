<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String currentMenu = (String)request.getAttribute("currentMenu");
	String subMenu = (String)request.getAttribute("subMenu");
	if(currentMenu == null) currentMenu = "";
	if(subMenu == null) subMenu = "";
%>
<!-- 공통 스타일 포함 -->
<!-- ↓↓↓↓↓이게 css임↓↓↓↓↓ -->
<jsp:include page="/includes/admin_styles.jsp" />

<!-- admin_header.jsp: 관리자 공통 헤더 -->
<header>
	<div class="header-container">
		<div class="logo-container">
			<a href="admin_main.jsp">
				<img src="images/logo-white.png" alt="everyWEAR 로고" class="header-logo">
			</a>
		</div>
		<nav class="admin-nav">
			<ul class="main-menu">
				<li><a href="admin_main.jsp" <%= "main".equals(currentMenu) ? "class=\"active\"" : "" %>>대시보드</a></li>
				<li><a href="#" <%= "order".equals(currentMenu) ? "class=\"active\"" : "" %>>주문</a></li>
				<li><a href="admin_product_list.jsp" <%= "product".equals(currentMenu) ? "class=\"active\"" : "" %>>상품</a></li>
				<li><a href="#" <%= "member".equals(currentMenu) ? "class=\"active\"" : "" %>>회원</a></li>
				<li><a href="#" <%= "board".equals(currentMenu) ? "class=\"active\"" : "" %>>게시판</a></li>
			</ul>
			<div class="megamenu">
				<div class="menu-column empty-column"></div>
				<div class="menu-column">
					<a href="admin_order_list.jsp" <%= "order_list".equals(subMenu) ? "class=\"active\"" : "" %>>주문 내역 조회</a>
					<a href="admin_order_refund.jsp" <%= "order_cancel".equals(subMenu) ? "class=\"active\"" : "" %>>주문 취소/환불</a>
					<a href="admin_order_delivery.jsp" <%= "order_list".equals(subMenu) ? "class=\"active\"" : "" %>>배송 상태 변경</a>
				</div>
				<div class="menu-column">
					<a href="admin_product_list.jsp" <%= "product_list".equals(subMenu) ? "class=\"active\"" : "" %>>상품 관리</a>
					<a href="admin_product_edit.jsp" <%= "product_add".equals(subMenu) ? "class=\"active\"" : "" %>>상품 등록</a>
				</div>
				<div class="menu-column">
					<a href="admin_member.jsp" <%= "member_list".equals(subMenu) ? "class=\"active\"" : "" %>>회원 목록 조회</a>
					<a href="admin_wdmember_manage.jsp" <%= "member_manage".equals(subMenu) ? "class=\"active\"" : "" %>>탈퇴회원 관리</a>
				</div>
				<div class="menu-column">
					<a href="admin_notice.jsp" <%= "notice".equals(subMenu) ? "class=\"active\"" : "" %>>공지사항</a>
					<a href="#" <%= "review".equals(subMenu) ? "class=\"active\"" : "" %>>리뷰</a>
					<a href="#" <%= "qna".equals(subMenu) ? "class=\"active\"" : "" %>>Q&A</a>
				</div>
			</div>
		</nav>
		<div class="logout-container">
			<form action="<%=request.getContextPath()%>/AdminLogout" method="post" style="margin: 0;">
				<button type="submit" class="logout-btn" style="cursor: pointer;">로그아웃</button>
			</form>
		</div>
	</div>
</header>

<style>
/* 하위 메뉴 시작 위치 조정 - 첫 번째 열은 빈 공간으로 두어 대시보드 아래에는 하위메뉴가 없도록 설정 */
.megamenu {
    grid-template-columns: repeat(5, 1fr) !important;
}

/* 첫 번째 빈 칼럼 */
.megamenu .menu-column:first-child {
    visibility: hidden;
}
</style>

<script>
	// 대시보드 메뉴에 대해서만 하위 메뉴가 표시되지 않도록 설정
	document.addEventListener('DOMContentLoaded', function() {
		const dashboardMenuItem = document.querySelector('.main-menu li:first-child');
		const megamenu = document.querySelector('.megamenu');
		
		// 대시보드 메뉴 클릭 시 하위 메뉴 표시 방지
		dashboardMenuItem.addEventListener('click', function(e) {
			// 기본 동작 방지
			e.preventDefault();
			// 하위 메뉴 숨기기
			megamenu.style.display = 'none';
			// 대시보드 페이지로 이동
			window.location.href = 'admin_main.jsp';
		});
		
		// 대시보드 메뉴에 마우스 오버 이벤트 추가
		dashboardMenuItem.addEventListener('mouseenter', function(e) {
			// 하위 메뉴 숨기기
			megamenu.style.display = 'none';
		});
		
		// 다른 메뉴 항목들에 대해서는 기존 동작 유지
		const otherMenuItems = document.querySelectorAll('.main-menu li:not(:first-child)');
		otherMenuItems.forEach(item => {
			item.addEventListener('mouseenter', function() {
				megamenu.style.display = 'grid';
			});
		});
	});
</script>



<script>
document.addEventListener('DOMContentLoaded', function () {
    const navItem = document.querySelector('.admin-nav');
    const megaMenu = document.querySelector('.megamenu');
    let menuTimeout;

    navItem.addEventListener('mouseenter', function () {
        clearTimeout(menuTimeout);
        megaMenu.style.display = 'block';
    });

    navItem.addEventListener('mouseleave', function () {
        menuTimeout = setTimeout(() => {
            megaMenu.style.display = 'none';
        }, 200);
    });

    megaMenu.addEventListener('mouseenter', function () {
        clearTimeout(menuTimeout);
    });

    megaMenu.addEventListener('mouseleave', function () {
        menuTimeout = setTimeout(() => {
            megaMenu.style.display = 'none';
        }, 200);
    });
});
</script>
