<!-- main2.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="stylesheet" type="text/css" href="css/main2.css?v=389">
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet"
	href="https://unpkg.com/swiper/swiper-bundle.min.css" />
</head>
<body>

	<%@ include file="includes/header.jsp"%>
	
	<%
	String category = request.getParameter("category");
	if (category == null) category = "all"; // 기본값
	%>

	<!-- 대분류 카테고리 -->
	<nav class="sub-nav">
		<ul>
			<li><a href="productList.jsp?cat=all">ALL</a></li>
			<li><a href="productList.jsp?cat=outer">OUTER</a></li>
			<li><a href="productList.jsp?cat=top">TOP</a></li>
			<li><a href="productList.jsp?cat=bottom">BOTTOM</a></li>
			<li><a href="productList.jsp?cat=acc">ACC</a></li>
		</ul>
	</nav>

	<!-- 여기부터 메인 컨텐츠 시작 -->
	<section class="main-collection">
		<div class="collection-left">
			<h2 class="collection-title">2025 SS COLLECTION</h2>

			<!-- Swiper 슬라이드 시작 -->
			<div class="swiper">
				<div class="swiper-wrapper">
					<div class="swiper-slide" onclick="goToDetail('10')">
						<img src="images/product-placeholder.svg" alt="DEMO LIGHT JACKET - NAVY">
					</div>
					<div class="swiper-slide" onclick="goToDetail('11')">
						<img src="images/product-placeholder.svg" alt="DEMO TRUCKER JACKET - INDIGO">
					</div>
					<div class="swiper-slide" onclick="goToDetail('12')">
						<img src="images/product-placeholder.svg" alt="DEMO PUFFER PARKA - BLACK">
					</div>
					<div class="swiper-slide" onclick="goToDetail('13')">
						<img src="images/product-placeholder.svg" alt="DEMO WINDBREAKER - OLIVE">
					</div>
					<div class="swiper-slide" onclick="goToDetail('8')">
						<img src="images/product-placeholder.svg" alt="DEMO WOOL KNIT - GREEN">
					</div>
				</div>

				<!-- 화살표 버튼 -->
				<div class="swiper-button-next"></div>
				<div class="swiper-button-prev"></div>
			</div>
			<!-- Swiper 슬라이드 끝 -->
		</div>

		<div class="collection-right">
			<img class="collection-video" src="images/product-placeholder.svg" alt="everyWEAR 데모 컬렉션">
		</div>
	</section>
	
	<script>
	function goToDetail(p_id){
		location.href = "pdDetail.jsp?p_id=" + p_id;
	}
	</script>

	<!-- Swiper 스크립트 -->
	<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
	<script>
		document.addEventListener('DOMContentLoaded', function() {
			const swiper = new Swiper('.swiper', {
				speed : 650,
				navigation : {
					nextEl : '.swiper-button-next',
					prevEl : '.swiper-button-prev',
				},
				autoplay : {
					delay : 3000,
					disableOnInteraction : false,
				},
				grabCursor : true,
				loop : true,
				slidesPerView : 1, // 한 번에 1장만 보이게
				centeredSlides : false, // 가운데 정렬 X (필요 시 true로도 가능)
				spaceBetween : 0,
			})
		});
	</script>

	<!-- 메인 중앙 이미지 슬라이더 영역 -->
<!-- 	<div class="slider-container">
		<button class="slider-btn prev">&#10094;</button>
		<div class="slider-wrapper">
			<div class="slider-track">
				<div class="slide">
					<img src="images/bald2.jpg" alt="look1">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
				<div class="slide">
					<img src="images/bald.png" alt="look2">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac1.jpg" alt="look1">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac2.jpg" alt="look1">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac3.jpg" alt="look1">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac4.jpg" alt="look2">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac5.jpg" alt="look2">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac6.jpg" alt="look2">
					<div class="slide-text">
						<strong>2025 SS</strong><br> <strong>STORY BEHIND</strong><br>
						THE IMAGES(NOW BASED IN BUENOS AIRES)
					</div>
				</div>
			</div>
		</div>
		<button class="slider-btn next">&#10095;</button>
	</div> -->
	<!-- 메인 중앙 이미지 슬라이더 영역 -->
	<div class="slider-container">
		<button class="slider-btn prev">&#10094;</button>
		<div class="slider-wrapper">
			<div class="slider-track">
				<div class="slide">
					<img src="images/mainac10.png" alt="look1">
					<div class="slide-text">
						<strong>JSP B TEAM LOGO</strong><br> <strong>MADE BY
							ECLIPSE..</strong><br> LOGO CODING!
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac8.jpg" alt="look2">
					<div class="slide-text">
						<strong>2018SS "NMxAE."</strong><br> <strong>ARCHIVING
							PIC</strong><br> WE JUST GET SUNGLASS!
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac11.png" alt="look1">
					<div class="slide-text">
						<strong>FUCKYAAA</strong><br> <strong>WORK EASY,
							SLEEP HARD.</strong><br> d u wAnnA Us stIckEr?
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac7.jpg" alt="look1">
					<div class="slide-text">
						<strong>2020SS “THE NORTH WIND AND THE SUN.”</strong><br> <strong>SSUNWIND
							DUO!!!</strong><br> ARE THEY HUMAN?
					</div>
				</div>
				<div class="slide">
					<img src="images/tk.jpg" alt="look1">
					<div class="slide-text">
						<strong>???</strong><br> <strong>BAG? HOODIE?</strong><br>
						WHATS IN MA "BACK"
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac5.jpg" alt="look2">
					<div class="slide-text">
						<strong>zzZ</strong><br> <strong>NG CUT ㅋㅋ</strong><br>
						현대인들이여 KEEP SLEEPING~
					</div>
				</div>
				<div class="slide">
					<img src="images/mainac2.jpg" alt="look2">
					<div class="slide-text">
						<strong>idk</strong><br> <strong>IDK!!!!!!</strong><br>
						look my head. FUCKIN REEEEEEEEEDDDD
					</div>
				</div>
				<div class="slide">
					<img src="images/bald.png" alt="look2">
					<div class="slide-text">
						<strong>MAYBE JDJ..?</strong><br> <strong>JDJ!?????!?!!?</strong><br>
						runner DJ @@
					</div>
				</div>
			</div>
		</div>
		<button class="slider-btn next">&#10095;</button>
	</div>

	<!-- <script>
  const track = document.querySelector('.slider-track');
  const slides = document.querySelectorAll('.slide');
  const prevBtn = document.querySelector('.prev');
  const nextBtn = document.querySelector('.next');
  
  let index = 0;

  function getOffset() {
    let offset = 0;
    for (let i = 0; i < index; i++) {
      offset += slides[i].offsetWidth + 40; // margin-right 고려
    }
    return offset;
  }

  function updateSlider() {
	  const maxOffset = track.scrollWidth - track.clientWidth;
	  const offset = getOffset();
	  track.style.transform = `translateX(-\${Math.min(offset, maxOffset)}px)`;
  }

  prevBtn.addEventListener('click', () => {
	  index = (index - 1 + slides.length) % slides.length;
    updateSlider();
  });

  nextBtn.addEventListener('click', () => {
	  index = (index + 1) % slides.length;
    updateSlider();
  });

  // 자동 슬라이드 (3초 간격)
  setInterval(() => {
    index = (index + 1) % slides.length;
    updateSlider();
  }, 3500);
  
	</script> -->
	<script>
	  const track = document.querySelector('.slider-track');
	  const slides = document.querySelectorAll('.slide');
	  const prevBtn = document.querySelector('.prev');
	  const nextBtn = document.querySelector('.next');
	  
	  let index = 0;
	
	  // 슬라이드 전환 속도
	  track.style.transition = 'transform 0.35s ease-in-out';
	
	  function getOffset() {
	    let offset = 0;
	    for (let i = 0; i < index; i++) {
	      offset += slides[i].offsetWidth + 35; // margin-right
	    }
	    return offset;
	  }
	
	  function updateSlider() {
	    const maxOffset = track.scrollWidth - track.clientWidth;
	    const offset = getOffset();
	    track.style.transform = `translateX(-\${Math.min(offset, maxOffset)}px)`;
	  }
	
	  // 자동 슬라이드 (setTimeout 방식)
	  let autoSlideTimer;
	
	  function startAutoSlide() {
	    const isLastSlide = index === slides.length - 1;
	    const delay = isLastSlide ? 100 : 2000; // 마지막 슬라이드는 1초 대기
	
	    autoSlideTimer = setTimeout(() => {
	      index = (index + 1) % slides.length;
	      updateSlider();
	      startAutoSlide(); // 재귀 호출
	    }, delay);
	  }
	
	  function restartAutoSlide() {
	    clearTimeout(autoSlideTimer);
	    startAutoSlide();
	  }
	
	  // 버튼 클릭 시 자동 슬라이드 재시작
	  prevBtn.addEventListener('click', () => {
	    index = (index - 1 + slides.length) % slides.length;
	    updateSlider();
	    restartAutoSlide();
	  });
	
	  nextBtn.addEventListener('click', () => {
	    index = (index + 1) % slides.length;
	    updateSlider();
	    restartAutoSlide();
	  });
	
	  // 슬라이드 자동 시작
	  startAutoSlide();
	</script>

	<!-- 메인 하단 이미지 영역 -->
	<div class="bottom-image-section">
		<img src="images/logo-black.png" alt="로고 이미지" class="background-logo">
		<img src="images/main-model.png" alt="모델 이미지" class="main-model">
	</div>

	<%@ include file="includes/footer.jsp"%>

	<button id="topBtn">TOP</button>

	<script>
  	document.getElementById("topBtn").addEventListener("click", function () {
    	window.scrollTo({ top: 0, behavior: 'smooth' });
  	});
	</script>

</body>
</html>