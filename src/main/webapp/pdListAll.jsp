<!-- main2.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="stylesheet" type="text/css" href="css/pdListAll.css">
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet"
	href="https://unpkg.com/swiper/swiper-bundle.min.css" />
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<!-- 하위 네비 -->
	<nav class="sub-nav">
		<ul>
			<li><a href="pdListAll.jsp" class="active">ALL</a></li>
			<li><a href="#">OUTER</a></li>
			<li><a href="#">TOP</a></li>
			<li><a href="#">BOTTOM</a></li>
			<li><a href="#">ACC</a></li>
		</ul>
	</nav>

	<!-- 상품 목록 영역 -->
	<section class="product-list">
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품1">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품2">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품3">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품4">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품1">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품2">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품3">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품4">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품3">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
		<div class="product-card">
			<img src="images/main-cloth1.png" alt="상품4">
			<p class="product-name">I ♥ JDJ</p>
			<p class="product-price">KRW 88,000</p>
		</div>
	</section>

	<!-- 상세 패널 -->
	<div id="product-detail-panel" class="detail-panel hidden">
		<button class="close-btn" onclick="closeDetail()">X</button>
		<img id="detail-image" src="images/main-cloth1.png" alt="상품 이미지">
		<div class="btn-group">
			<button class="add-to-bag">ADD TO BAG</button>
			<button class="buy-now">BUY NOW</button>
		</div>
	</div>

	<!-- 더 보기 버튼 -->
	<div class="load-more-wrap">
		<button class="load-more">VIEW MORE</button>
	</div>

</body>
</html>