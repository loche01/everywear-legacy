<!-- reviewDetail.jsp -->
<%@page import="DTO.ProductImgDTO"%>
<%@page import="DTO.ProductDTO"%>
<%@page import="DTO.ReviewImgDTO"%>
<%@page import="java.util.List"%>
<%@page import="DTO.ReviewDTO"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="reDao" class="DAO.ReviewDAO"/>
<jsp:useBean id="pDao" class="DAO.ProductDAO"/>
<%
		String userId = (String)session.getAttribute("id");
		String userType = (String)session.getAttribute("userType");
		String redirect = request.getParameter("redirect");
		if(userId == null || userId == ""){
			// 현재 페이지 경로를 얻기 위한 코드
			String fullUrl = request.getRequestURI();
			String queryString = request.getQueryString();
			if (queryString != null) {
				fullUrl += "?" + queryString;
			}
		
			response.sendRedirect("login.jsp?redirect=" + java.net.URLEncoder.encode(fullUrl, "UTF-8"));
			return;
		}

		int r_id = Integer.parseInt(request.getParameter("r_id"));
		if(r_id == 0){
		}
		ReviewDTO rDto = reDao.getReviewById(r_id);
		List<ReviewImgDTO> rilist = reDao.getReviewImages(r_id);
		
		ProductDTO pDto = pDao.getProductByReview(r_id);
		String size = pDao.getProductByReviewSize(r_id);
		Vector<String> pilist = pDao.getProductByReviewImg(r_id);
		
		String rating = "";
		for(int j = 0; j<rDto.getR_rating(); j++){
			rating += "★";
			if(j == rDto.getR_rating() -1){
				for(int k = 0; k< (5-rDto.getR_rating()); k++)
					rating += "☆";
			}
		}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/reviewDetail.css?v=578">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section class="content2">
	<h3>REVIEW</h3>
	</section>

	<div class="container">
		<aside class="sidebar2">
			<ul>
				<li><a href="board.jsp">BOARD</a></li>
				<li><a href="FAQ.jsp">FAQ</a></li>
				<li><a href="Q&A.jsp">Q&A</a></li>
				<li><a href="review.jsp">REVIEW</a></li>
			</ul>
		</aside>

		<section class="content">

			<div class="form-container">
				<form action="submitQna.jsp" method="post"
					enctype="multipart/form-data" onsubmit="return false;">
					
				<table class="notice-table">
					<tr>
						<td class="pdInfo">
							<div class="product-box">
								<img src="<%=pilist.get(0)%>" alt="<%=pDto.getP_name()%>" class="product-img">
								<div class="product-info">
									<strong><%=pDto.getP_name()%></strong><br> <%=pDto.getP_color()%><br>
								</div>
							</div>
						</td>
						<td class="date"><%=rDto.getCreated_at()%><br><%=rating%>
						</td>
					</tr>
				</table>
					
					
					<div class="star-rating" id="starRating">
					<%for(int i = 1; i<=rDto.getR_rating(); i++){ %>
						<span class="star" data-value="<%=i%>">★</span>
					<%} %>
					<%for(int i = rDto.getR_rating(); i<5;i++){ %>
						<span class="star" data-value="<%=i+1%>">☆</span>
					<%} %>
					</div>

				<label for="content">내용 *</label>
				<textarea name="content" id="content" rows="6" placeholder="내용을 입력해주세요."><%=rDto.getR_content()%></textarea>
				
				<label>사진 첨부</label>
				
				<!-- 기존 이미지들 -->
				<div class="preview-wrapper" id="preview-wrapper"
				     style="display: grid; grid-template-columns: repeat(5, 100px); gap: 10px; margin-top: 10px; align-items: start;">
				  <% for(ReviewImgDTO imgDto : rilist) { %>
				    <div class="preview-image-box">
				      <img src="review_images/<%= imgDto.getRi_url()%>" alt="리뷰 이미지"
				           style="width: 100%; height: 100%; object-fit: cover; border-radius: 6px;">
				    </div>
				  <% } %>
				
				  <!-- 업로드 박스도 div로 감싸서 정렬 맞춤 -->
				  <div class="preview-image-box">
					  <label class="upload-box">
					    <span>＋</span>
					    <input type="file" name="reviewImage" id="fileInput" accept="image/*" multiple hidden>
					  </label>
				  </div>
				 </div>
				 
				 <div id="image-count" class="image-count">0 / 5 장 업로드됨</div>

				<div class="write-btn-wrapper2">
					<!-- 수정 버튼 -->
					<button type="button" class="write-btn2" onclick="submitReview()">수정</button>
					<button type="button" class="write-btn2" onclick="openDeleteModal('<%=rDto.getR_id()%>')">삭제</button>
					<button type="button" class="write-btn2" onclick="window.history.back()">목록</button>
				</div>
		
				</form>
			</div>

			<div class="footer-bottom">
				<p>2025&copy;everyWEAR</p>
			</div>

		</section>
	</div>
	
	<input type="hidden" id="hidden_rid">
	
		<!-- 삭제 모달 -->
	<div id="deleteModal" class="modal" style="display: none;">
	  <div class="modal-content">
	    <p>정말 삭제하시겠습니까?</p>
	    <div class="modal-buttons">
	      <button class="modalBtn1" id="modalBtn1" onclick="closeModal()">취소</button>
	      <button id="deleteQna" class="modalBtn2" onclick="deleteQna()">삭제</button>
	      <!-- <a id="confirmDelete" href="#">삭제</a> -->
	    </div>
	  </div>
	</div>
	
<script>
  // 삭제 모달 관련
  function openDeleteModal(r_id) {
    document.getElementById("deleteModal").style.display = "flex";
    document.getElementById("hidden_rid").value = r_id;
  }

  function closeModal() {
    document.getElementById("deleteModal").style.display = "none";
  }

  function deleteQna(){
    const r_id = document.getElementById("hidden_rid");
    const redirect = "<%= (redirect != null && !redirect.equals("")) ? redirect : "main2.jsp" %>";

    fetch("deleteReview.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "r_id=" + encodeURIComponent(r_id.value) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
      .then(res => res.json())
      .then(data => {
        if (data.result === "success") {
          alert("삭제되었습니다.");
          location.href = redirect;
        } else {
          alert("삭제에 실패하였습니다.");
        }
      });
  }
</script>

<!-- 별점 클릭 및 hover 처리 -->
<script>
  let currentRating = [...document.querySelectorAll(".star")]
    .filter(star => star.textContent === "★").length;

  const stars = document.querySelectorAll(".star");
  stars.forEach((star) => {
    star.style.cursor = "pointer";

    star.addEventListener("click", () => {
      const selected = parseInt(star.getAttribute("data-value"));
      currentRating = selected;
      updateStars(currentRating);
    });

    star.addEventListener("mouseover", () => {
      const hoverValue = parseInt(star.getAttribute("data-value"));
      updateStars(hoverValue);
    });

    star.addEventListener("mouseleave", () => {
      updateStars(currentRating);
    });
  });

  function updateStars(tempRating = currentRating) {
    stars.forEach((star) => {
      const value = parseInt(star.getAttribute("data-value"));
      star.textContent = value <= tempRating ? "★" : "☆";
    });
  }
</script>

<!-- 이미지 업로드, 삭제, 개수 표시 -->
<script>
document.addEventListener("DOMContentLoaded", () => {
  const fileInput = document.getElementById("fileInput");
  const previewWrapper = document.getElementById("preview-wrapper");
  const countDisplay = document.getElementById("image-count");
  const uploadBox = previewWrapper.querySelector(".upload-box")?.parentElement;

  // 이미지 개수 및 업로드 박스 표시
  function updateUploadBoxVisibility() {
    const allBoxes = [...previewWrapper.querySelectorAll(".preview-image-box")];
    const count = allBoxes.filter(box => box.querySelector("img")).length;

    if (countDisplay) {
      countDisplay.textContent = count + "/ 5 장 업로드됨";
    }

    if (uploadBox) {
      uploadBox.style.display = (count >= 5) ? "none" : "flex";
    }
  }

  // 기존 이미지에 삭제 버튼 부여
  [...previewWrapper.querySelectorAll(".preview-image-box")].forEach(box => {
    const hasLabel = box.querySelector("label"); // 업로드 박스 제외
    if (!hasLabel && !box.querySelector(".delete-btn")) {
      const delBtn = document.createElement("button");
      delBtn.className = "delete-btn";
      delBtn.textContent = "×";
      delBtn.onclick = () => {
        box.remove();
        updateUploadBoxVisibility();
      };
      box.appendChild(delBtn);
    }
  });

  // 새 이미지 업로드
  fileInput.addEventListener("change", (e) => {
    const allBoxes = [...previewWrapper.querySelectorAll(".preview-image-box")];
    const currentCount = allBoxes.filter(box => box.querySelector("img")).length;
    const availableCount = 5 - currentCount;

    const files = Array.from(e.target.files).slice(0, availableCount);

    files.forEach((file) => {
      const reader = new FileReader();
      reader.onload = function (e) {
        const imgBox = document.createElement("div");
        imgBox.className = "preview-image-box client-added";
        imgBox.style.cssText = "position: relative; width: 100px; height: 100px;";

        const img = document.createElement("img");
        img.src = e.target.result;
        img.alt = "업로드 이미지";
        img.style.cssText = "width: 100%; height: 100%; object-fit: cover; border-radius: 6px;";

        const delBtn = document.createElement("button");
        delBtn.className = "delete-btn";
        delBtn.textContent = "×";
        delBtn.onclick = () => {
          imgBox.remove();
          updateUploadBoxVisibility();
        };

        imgBox.appendChild(img);
        imgBox.appendChild(delBtn);

        if (uploadBox) {
          previewWrapper.insertBefore(imgBox, uploadBox);
        } else {
          previewWrapper.appendChild(imgBox);
        }

        updateUploadBoxVisibility();
      };
      reader.readAsDataURL(file);
    });

    e.target.value = ''; // 같은 파일 다시 선택해도 이벤트 발생
  });

  updateUploadBoxVisibility(); // 초기 실행
  setTimeout(() => updateUploadBoxVisibility(), 50); // DOM 렌더링 이후 재확인
});
</script>

<!-- 리뷰 수정 버튼 -->
<script>
  function submitReview() {
    alert("수정되었습니다.");
  }
</script>

<!-- 로딩 완료 후 이미지 개수 정확히 반영 -->
<script>
window.onload = () => {
  const previewWrapper = document.getElementById("preview-wrapper");
  const countDisplay = document.getElementById("image-count");
  const uploadBox = previewWrapper.querySelector(".upload-box")?.parentElement;

  const allBoxes = [...previewWrapper.querySelectorAll(".preview-image-box")];
  const count = allBoxes.filter(box => box.querySelector("img")).length;

  if (countDisplay) {
    countDisplay.textContent = count + "/ 5 장 업로드됨";
  }
 

  if (uploadBox) {
    uploadBox.style.display = (count >= 5) ? "none" : "flex";
  }
};
</script>


</body>