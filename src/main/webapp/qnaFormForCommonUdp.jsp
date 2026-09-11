<%@page import="DTO.InquiryImgDTO"%>
<%@page import="DTO.InquiryDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="qDao" class="DAO.QnaDAO"/>
<%
		String user_id = (String)session.getAttribute("id");
		String i_id = request.getParameter("i_id");
		if(user_id == null || i_id == null){
			response.sendRedirect("Q&A.jsp");
			return;			
		}
		InquiryDTO qna = qDao.showOneQna(Integer.parseInt(i_id));
		if(qna == null || !user_id.equals(qna.getUser_id()) || !java.util.Objects.equals(session.getAttribute("userType"),qna.getUser_type())) { response.sendError(403,"게시물을 수정할 수 없습니다."); return; }
        InquiryImgDTO qnaImg = qDao.showOneQnaImage(Integer.parseInt(i_id));
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
						id="title" maxlength="30" placeholder="30자 이내로 입력해주세요." value="<%=qna.getI_title()%>" required>

							<label><input type="checkbox" name="private" id="private" <%=qna.getI_isPrivate().equals("Y") ? "checked" : ""%>> 비공개</label>
							<label for="content">내용 *</label>
							<textarea name="content" id="content" rows="6"
							 placeholder="내용을 입력해주세요." required><%=qna.getI_content()%></textarea>

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
					
					<input type="hidden" id="hidden_id" value="<%=Integer.parseInt(i_id)%>">
					
					<% if (qnaImg != null && qnaImg.getIi_url() != null) { %>
						<script>
						window.addEventListener('DOMContentLoaded', function () {
						  const previewImage = document.getElementById('preview-image');
						  const previewWrapper = document.getElementById('preview-wrapper');
						  const photoBox = document.getElementById('photo-box');
						  const fileNameText = document.getElementById('file-name');
						
						  // 서버 이미지 경로 (웹 경로 기준으로 표시!)
						  previewImage.src = "Q&A_images/<%= qnaImg.getIi_url() %>";
						  previewWrapper.style.display = 'block';
						  photoBox.style.display = 'none';
						  fileNameText.innerText = "<%= qnaImg.getIi_url() %>";
						});
						</script>
					<% } %>
					

					<script>
						let removeExistingImage = false;
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
                                removeExistingImage = false;
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
                            removeExistingImage = true;
							fileNameText.innerText = '';
							previewWrapper.style.display = 'none';
							photoBox.style.display = 'flex';
						});
					</script>

				</form>
			</div>

			<div class="write-btn-wrapper">
				<button type="button" class="write-btn1" onclick="window.history.back()">취소하기</button>
				<button type="button" class="write-btn" onclick="validateForm()">수정하기</button>
			</div>

			<div id="overlay"></div>

			<div id="popup">
				<h3>Q&A</h3>
				<p></p>
				<button onclick="closePopup()">확인</button>
			</div>

			<!-- 확인 전 팝업 -->
			<div id="confirm-popup" style="display: none;">
				<p>수정하시겠습니까?</p>
				<button class="cancel-btn" onclick="closeConfirmPopup()">취소</button>
				<button onclick="submitWithSuccessPopup()">확인</button>
			</div>

			<!-- 작성 완료 팝업 -->
			<div id="success-popup" style="display: none;">
				<p>수정되었습니다.</p>
				<button onclick="submitForm()">확인</button>
			</div>


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
				
				function updateQna(){
					const formData = new FormData();
					formData.append("title", document.getElementById("title").value);
					formData.append("content", document.getElementById("content").value);
					formData.append("private", document.getElementById("private").checked ? "on" : "");
					formData.append("i_id", document.getElementById("hidden_id").value);
                    formData.append("removeImage", removeExistingImage ? "Y" : "N");

					const fileInput = document.getElementById("file-upload");
					if (fileInput.files.length > 0) {
					  formData.append("file", fileInput.files[0]);
					}

					fetch("updateQna.jsp", {
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
					updateQna();
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