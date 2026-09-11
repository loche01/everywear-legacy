<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
		String user_id = (String)session.getAttribute("id");
		if(user_id == null || user_id == ""){
			// 현재 페이지 경로를 얻기 위한 코드
			String fullUrl = request.getRequestURI();
			String queryString = request.getQueryString();
			if (queryString != null) {
				fullUrl += "?" + queryString;
			}
			response.sendRedirect("login.jsp?redirect=" + java.net.URLEncoder.encode(fullUrl, "UTF-8"));
			return;
		}
		
		String i_id = request.getParameter("i_id");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/qnaForm.css?v=316845">
</head>
<body>

	<%@ include file="includes/boardHeader.jsp"%>

	<section class="content2">
	<h3>Q&A</h3>
	</section>

	<div class="container">
		<aside class="sidebar2">
			<ul>
				<li><a href="board.jsp">BOARD</a></li>
				<li><a href="FAQ.jsp">FAQ</a></li>
				<li><a href="Q&A.jsp">Q&A</a></li>
			</ul>
		</aside>

		<section class="content">

			<div class="form-container">
				<form action="submitQna.jsp" method="post" enctype="multipart/form-data" onsubmit="return false;">
							<label for="title">제목 *</label>
								<input type="text" name="title"
						id="title" maxlength="30" placeholder="30자 이내로 입력해주세요." required>

							<label><input type="checkbox" name="private" id="private"> 비공개</label>
							<label for="content">내용 *</label>
							<textarea name="content" id="content" rows="6"
							 placeholder="내용을 입력해주세요." required></textarea>

							<label>사진 첨부</label>

					<!-- 클릭용 박스 -->
					<label for="file-upload" class="photo-box" id="photo-box">＋</label>
					<input type="file" id="file-upload" name="file" accept="image/*"
						style="display: none;">

					<!-- 파일명 표시 -->
					<p id="file-name"
						style="font-size: 14px; margin-top: 8px; color: #444;"></p>

					<!-- 미리보기 + 삭제버튼 -->
					<div class="preview-wrapper" id="preview-wrapper"
						style="display: none;">
						<img id="preview-image" />
						<button type="button" class="delete-btn" id="delete-btn">✕</button>
					</div>

					<script>
						const fileInput = document
								.getElementById('file-upload');
						const previewImage = document
								.getElementById('preview-image');
						const previewWrapper = document
								.getElementById('preview-wrapper');
						const photoBox = document.getElementById('photo-box');
						const deleteBtn = document.getElementById('delete-btn');
						const fileNameText = document
								.getElementById('file-name');

						fileInput.addEventListener('change', function() {
							const file = this.files[0];
							if (file) {
								// 파일명 표시
								fileNameText.innerText = file.name;

								// 미리보기 표시
								const reader = new FileReader();
								reader.onload = function(e) {
									previewImage.src = e.target.result;
									previewWrapper.style.display = 'block';
									photoBox.style.display = 'none';
								};
								reader.readAsDataURL(file);
							}
						});

						deleteBtn.addEventListener('click', function() {
							fileInput.value = '';
							fileNameText.innerText = '';
							previewWrapper.style.display = 'none';
							photoBox.style.display = 'flex';
						});
					</script>

				</form>
			</div>

			<div class="write-btn-wrapper">
				<button type="button" class="write-btn" onclick="validateForm()">작성하기</button>
			</div>

			<div id="overlay"></div>

			<div id="popup">
				<h3>Q&A</h3>
				<p></p>
				<button onclick="closePopup()">확인</button>
			</div>

			<!-- 확인 전 팝업 -->
			<div id="confirm-popup" style="display: none;">
				<p>작성하시겠습니까?</p>
				<button class="cancel-btn" onclick="closeConfirmPopup()">취소</button>
				<button onclick="submitWithSuccessPopup()">확인</button>
			</div>

			<!-- 작성 완료 팝업 -->
			<div id="success-popup" style="display: none;">
				<p>작성되었습니다.</p>
				<button onclick="submitForm()">확인</button>
			</div>

			<!-- <script>
				function showPopup(message) {
					const overlay = document.getElementById('overlay');
					const popup = document.getElementById('popup');
					popup.querySelector('p').textContent = message;
					overlay.style.display = 'block';
					popup.style.display = 'block';
				}

				function closePopup() {
					document.getElementById('overlay').style.display = 'none';
					document.getElementById('popup').style.display = 'none';
				}

				function validateForm() {
					const type = document.getElementById('type').value;
					const title = document.getElementById('title').value.trim();
					const content = document.getElementById('content').value
							.trim();

					if (!type || type === '문의 유형 선택') {
						showPopup("문의 유형을 선택해주세요.");
						return;
					}
					if (title === "") {
						showPopup("제목을 입력해주세요.");
						return;
					}
					if (content === "") {
						showPopup("내용을 입력해주세요.");
						return;
					}

					// 모든 조건이 통과되면 form 제출
					document.getElementById('qnaForm').submit();
				}
			</script> -->

			<script>
				function showPopup(popupId) {
					document.getElementById('overlay').style.display = 'block';
					document.getElementById(popupId).style.display = 'block';
				}

				function hideAllPopups() {
					document.getElementById('overlay').style.display = 'none';
					document.getElementById('confirm-popup').style.display = 'none';
					document.getElementById('success-popup').style.display = 'none';
				}

				// 기존 유효성 검사
				function validateForm() {
					const title = document.getElementById('title').value
							.trim();
					const content = document.getElementById('content').value
							.trim();

					if (title === "") {
						showSimplePopup("제목을 입력해주세요.");
						return;
					}
					if (content === "") {
						showSimplePopup("내용을 입력해주세요.");
						return;
					}

					// 모든 조건 충족 시 확인 팝업 띄우기
					showPopup("confirm-popup");
				}
				
				function writeQna(){
					const formData = new FormData();
					formData.append("title", document.getElementById("title").value);
					formData.append("content", document.getElementById("content").value);
					formData.append("private", document.getElementById("private").checked ? "on" : "");

					const fileInput = document.getElementById("file-upload");
					if (fileInput.files.length > 0) {
					  formData.append("file", fileInput.files[0]);
					}

					fetch("insertQna.jsp", {
					  method: "POST",
					  headers: {"X-User-CSRF-Token": "<%=Security.UserRequestGuard.token(session)%>"},
                      body: formData,
					})
				      .then(res => res.json()) // 응답을 JSON으로 파싱
				      .then(data => {
                    if(data.result === "success"){ showPopup("success-popup"); } else { showSimplePopup("저장하지 못했습니다. 다시 확인해주세요."); }
				      })
				      .catch(err => {
showSimplePopup("저장하지 못했습니다. 다시 확인해주세요.");
				      });
				}

				// 기존 단순 메시지용 팝업
				function showSimplePopup(message) {
					const popup = document.getElementById('popup');
					popup.querySelector('p').textContent = message;
					document.getElementById('overlay').style.display = 'block';
					popup.style.display = 'block';
				}

				function closePopup() {
					document.getElementById('overlay').style.display = 'none';
					document.getElementById('popup').style.display = 'none';
				}

				function closeConfirmPopup() {
					hideAllPopups();
				}

				function submitWithSuccessPopup() {
					hideAllPopups();
					writeQna();
				}

				function submitForm() {
					window.location.href = "Q&A.jsp";
				}
			</script>

			<!-- <div class="footer-bottom">
				<p>2025&copy;everyWEAR</p>
			</div> -->

		</section>
	</div>

</body>