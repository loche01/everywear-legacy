<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>에브리웨어 | everyWEAR</title>
  <link rel="icon" type="image/png" href="images/fav-icon.png">
  <link rel="stylesheet" type="text/css" href="css/reviewDetail.css?v=578">
</head>
<body>

<%@ include file="includes/header.jsp" %>

<section class="content2">
  <h3>REVIEW</h3>
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
    <table class="notice-table">
  <tr>
    <td class="pdInfo">
      <div class="product-box">
        <img src="images/review-cloth1.png" alt="NM COTTON SHIRT" class="product-img">
        <div class="product-info">
          <strong>AETHER NYLON JACKET</strong><br>
          COLOR: SKY BLUE
        </div>
      </div>
    </td>
    <td class="date">
      2025-04-17
    </td>
  </tr>
</table>
    
      <form action="submitReview.jsp" method="post" enctype="multipart/form-data">

        <div class="star-rating" id="starRating">
          <% for(int i = 1; i <= 5; i++) { %>
            <span class="star" data-value="<%=i%>">☆</span>
          <% } %>
        </div>

        <label for="content">내용 *</label>
        <textarea name="content" id="content" rows="6"></textarea>

        <label>사진 첨부</label>
        <div class="preview-wrapper" id="preview-wrapper"
             style="display: grid; grid-template-columns: repeat(5, 100px); gap: 10px; margin-top: 10px; align-items: start;">
          <div class="preview-image-box">
            <label class="upload-box">
              <span>＋</span>
              <input type="file" name="reviewImage" id="fileInput" accept="image/*" multiple hidden>
            </label>
          </div>
        </div>

        <div id="image-count" class="image-count">0 / 5 장 업로드됨</div>

        <div class="write-btn-wrapper2">
          <button type="submit" class="write-btn2">등록</button>
          <button type="button" class="write-btn2" onclick="window.history.back()">취소</button>
        </div>
      </form>
    </div>

    <div class="footer-bottom">
      <p>2025&copy;everyWEAR</p>
    </div>
  </section>
</div>

<script>
  // 별점 처리
  let currentRating = 0;
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

  function updateStars(tempRating) {
    stars.forEach((star) => {
      const value = parseInt(star.getAttribute("data-value"));
      star.textContent = value <= tempRating ? "★" : "☆";
    });
  }
</script>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    const fileInput = document.getElementById("fileInput");
    const previewWrapper = document.getElementById("preview-wrapper");
    const countDisplay = document.getElementById("image-count");
    const uploadBox = previewWrapper.querySelector(".upload-box")?.parentElement;

    function updateUploadBoxVisibility() {
      const allBoxes = [...previewWrapper.querySelectorAll(".preview-image-box")];
      const count = allBoxes.filter(box => box.querySelector("img")).length;

      if (countDisplay) countDisplay.textContent = count + " / 5 장 업로드됨";
      if (uploadBox) uploadBox.style.display = (count >= 5) ? "none" : "flex";
    }

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

      e.target.value = '';
    });

    updateUploadBoxVisibility();

    // textarea placeholder 동작처럼 구현
    const textarea = document.getElementById("content");

    if (textarea.value.trim() === "") {
      textarea.value = "내용을 입력해주세요.";
      textarea.style.color = "#999";
    }

    textarea.addEventListener("focus", function () {
      if (this.value === "내용을 입력해주세요.") {
        this.value = "";
        this.style.color = "#000";
      }
    });

    textarea.addEventListener("blur", function () {
      if (this.value.trim() === "") {
        this.value = "내용을 입력해주세요.";
        this.style.color = "#999";
      }
    });
  });
</script>

</body>
</html>
