<!-- findId.jsp -->

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이디 찾기 | everyWEAR</title>
  <link rel="stylesheet" type="text/css" href="css/find.css">
  <link rel="icon" type="image/png" href="images/fav-icon.png">
  <style>
  .birth-container {
    display: flex;
    flex : 1;
    align-items: center;
    gap: 8px; /* 입력 필드 간 간격 */
}

.birth-input {
    position: relative;
    display: flex; /* ✅ 가로 정렬 */
    align-items: center;
}

.birth-input input {
    width: 60px;
    height: 32px;
    text-align: center;
    border: 1px solid #ccc;
    border-radius: 15px; /* 둥글게 */
    background-color: #f7fafd;
    font-size: 16px;
    padding-right: 18px; /* 오른쪽 공간 확보 */
}

.birth-input span {
    position: absolute;
    right: 8px; /* 년, 월, 일 위치 조정 */
    font-size: 14px;
    color: #555;
}
  </style>
</head>
<body>

<%@ include file="includes/loginHeader.jsp" %>

<div class="find-id-container">
  <h2>잠긴 계정 풀기</h2>

  <form id="lockOutForm" action="lockOutPwdResult.jsp" method="post">

    <!-- 이름 입력 -->
    <label for="name">아이디</label>
    <input type="text" id="id" name="id" placeholder="아이디 입력하세요" required> 
    
    <!-- 생년월일 -->
    <label for="birth">생년월일 <span class="required" style="color: red;">*</span></label>
    <div class="birth-container">
        <input type="text" name="year" id="year" maxlength="4" placeholder="년" required>
        <span class="birth-label">년</span>
        <input type="text" name="month" id="month" maxlength="2" placeholder="월" required>
        <span class="birth-label">월</span>
        <input type="text" name="day" id="day" maxlength="2" placeholder="일" required>
        <span class="birth-label">일</span>
    </div>

    <!-- 휴대폰번호 입력창 (기본 노출) -->
    <div id="phoneInputGroup">
      <label for="phone1">휴대폰번호로 찾기</label>
      <div class="phone-input-group">
        <input type="text" id="phone1" name="phone1" maxlength="3" value="010" readonly>
        <span>-</span>
        <input type="text" id="phone2" name="phone2" maxlength="4" placeholder="1234" required>
        <span>-</span>
        <input type="text" id="phone3" name="phone3" maxlength="4" placeholder="5678" required>
      </div>
    </div>

    <!-- 인증 버튼 -->
    <div id="authBtnBox">
      <button type="button" id="verification" class="btn black" onclick="showAuthBoxByPhone()">인증</button>
    </div>

    <!-- 인증번호 입력 영역 -->
    <div id="verifyBox" style="display:none;">
      <label for="verifyCode">인증번호</label>
      <input type="text" id="verifyCode" name="verifyCode" placeholder="인증번호를 입력하세요">

      <div class="verify-btn-group">
        <button type="button" id="reverification" class="btn white" onclick="showAuthBoxByPhone()">재전송</button>
        <button type="button" class="btn black" onclick="checkCode()">확인</button>
      </div>
    </div>

  </form>
</div>

<footer>2025©everyWEAR</footer>

<!-- 스크립트: 이메일 주소 조합 및 인증 방식 전환 -->
<script>
  /* 생년월일 숫자만 입력 가능 */
  document.querySelectorAll('.birth-container input').forEach(input => {
      input.addEventListener('input', (e) => {
          e.target.value = e.target.value.replace(/[^0-9]/g, ''); // 숫자만 입력 가능
      });
  });
  document.addEventListener("DOMContentLoaded", function () {
	  const yearInput = document.getElementById("year");
	  const monthInput = document.getElementById("month");
	  const dayInput = document.getElementById("day");

	  function isValidDate(y, m, d) {
	    const year = parseInt(y, 10);
	    const month = parseInt(m, 10);
	    const day = parseInt(d, 10);

	    // 간단한 범위 확인
	    if (isNaN(year) || isNaN(month) || isNaN(day)) return false;
	    if (year < 1900 || year > new Date().getFullYear()) return false;
	    if (month < 1 || month > 12) return false;
	    if (day < 1 || day > 31) return false;

	    // 실제 날짜 확인
	    const date = new Date(year, month - 1, day);
	    return date.getFullYear() === year &&
	           date.getMonth() === month - 1 &&
	           date.getDate() === day;
	  }

	  function validateBirthDate() {
	    const year = yearInput.value;
	    const month = monthInput.value;
	    const day = dayInput.value;

	    if (year && month && day) {
	      if (!isValidDate(year, month, day)) {
	        alert("유효하지 않은 생년월일입니다.");
	        yearInput.value = "";
	        monthInput.value = "";
	        dayInput.value = "";
	        yearInput.focus();
	      }
	    }
	  }

	  yearInput.addEventListener("blur", validateBirthDate);
	  monthInput.addEventListener("blur", validateBirthDate);
	  dayInput.addEventListener("blur", validateBirthDate);
	});
</script>

<script>
	function showAuthBoxByPhone() {
		const id = document.getElementById("id");
		const year = document.getElementById("year");
		const month = document.getElementById("month");
		const day = document.getElementById("day");
		if(!id.value){
			alert("아이디를 입력하시오.");
			return;
		}
		if(!year.value || !month.value || !day.value){
			alert("생년월일을 입력하시오.");
			return;
		}
	    // 휴대전화 번호 결합
	  const p1 = document.getElementById('phone1').value.trim();
	  const p2 = document.getElementById('phone2').value.trim();
	  const p3 = document.getElementById('phone3').value.trim();
	  const p = p1+p2+p3;
	  
	    if (!p.match(/^010\d{4}\d{4}$/)) {
	      alert("전화번호 형식이 올바르지 않습니다.");
	      return;
	    }
	    
	    fetch("sendSMSByUnlock.jsp", {
	      method: "POST",
	      body: new URLSearchParams({id: id.value.trim(), phone: p,
	        birth: year.value + "-" + month.value.padStart(2, "0") + "-" + day.value.padStart(2, "0")})
	    })
	      .then(res => res.json())
	      .then(data => {
	        if (data.result === "success") {
	          alert("인증번호가 전송되었습니다.");
	          document.getElementById('authBtnBox').style.display = 'none';
	          document.getElementById('verifyBox').style.display = 'block';
	          document.getElementById("id").readOnly = true;
	          document.getElementById("year").readOnly = true;
	          document.getElementById("month").readOnly = true;
	          document.getElementById("day").readOnly = true;
	          document.getElementById("phone2").readOnly = true;
	          document.getElementById("phone3").readOnly = true;
	        } else {
	          alert("전송 실패");
	        }
	      });
  }
	  // 숫자만 입력되게
	  ['phone2', 'phone3', 'verifyCode'].forEach(id => {
	    document.getElementById(id).addEventListener('input', (e) => {
	      e.target.value = e.target.value.replace(/[^0-9]/g, '');
	    });
	  });
	  
	function checkCode(){
		const writeCode = document.getElementById('verifyCode').value.trim();
		if (!/^[0-9]{6}$/.test(writeCode)) { alert("인증번호 6자리를 입력해주세요."); return; }
		document.getElementById("lockOutForm").submit();
	}
 

</script>

</body>
</html>