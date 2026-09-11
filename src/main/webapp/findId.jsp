<!-- findId.jsp -->

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이디 찾기 | everyWEAR</title>
  <link rel="stylesheet" type="text/css" href="css/find.css">
<link rel="icon" type="image/png" href="images/fav-icon.png">
</head>
<body>

<%@ include file="includes/loginHeader.jsp" %>

<div class="find-id-container">
  <h2>아이디 찾기</h2>

  <form id="findIdForm" action="findIdResult.jsp" method="post">

    <!-- 인증 방식 -->
    <label>본인확인 인증</label>
    <div class="radio-group">
      <input type="radio" name="authType" id="phone" value="phone" checked>
      <label for="phone">휴대폰번호</label>
      <input type="radio" name="authType" id="email" value="email">
      <label for="email">이메일</label>
    </div>

    <!-- 이름 입력 -->
    <label for="name">이름</label>
    <input type="text" id="name" name="name" placeholder="이름을 입력하세요" required>

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

<!-- 이메일 -->
<div class="email-input-group" id="emailInputGroup" style="display: none">
<label for="emailId">이메일로 찾기</label>
  <input type="text" id="emailId" placeholder="이메일 아이디 입력">
  <span class="at-symbol">@</span>
  <select id="emailDomain">
    <option value="">선택</option>
    <option value="gmail.com">gmail.com</option>
    <option value="naver.com">naver.com</option>
    <option value="daum.net">daum.net</option>
    <option value="nate.com">nate.com</option>
  </select>
</div>
<input type="hidden" id="email1" name="email">
<!-- 본인확인 grant (verifyCode.jsp 성공 시 채워짐) -->
<input type="hidden" id="otpGrant" name="otpGrant">

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
  const emailId = document.getElementById("emailId");
  const emailDomain = document.getElementById("emailDomain");
  const emailFull = document.getElementById("email1");

  const form = document.getElementById("findIdForm");
  form.addEventListener("submit", function(e) {
    if (emailRadio.checked) {
      const id = emailId.value.trim();
      const domain = emailDomain.value;
      if (!id || !domain) {
        alert("이메일 아이디와 도메인을 모두 입력해주세요.");
        e.preventDefault();
        return;
      }
      emailFull.value = `${id}@${domain}`;
    }
  });
</script>

<script>
	function showAuthBoxByPhone() {
		const name = document.getElementById("name");
		if(!name.value){
			alert("이름을 입력하시오.");
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
	    
	    fetch("sendSMS.jsp", {
	      method: "POST",
	      headers: { "Content-Type": "application/x-www-form-urlencoded" },
	      body: new URLSearchParams({ purpose: "FIND_ID_PHONE", phone: p })
	    })
	      .then(res => res.json())
	      .then(data => {
	        if (data.result === "success") {
	          alert("인증번호가 전송되었습니다.");
	          document.getElementById('authBtnBox').style.display = 'none';
	          document.getElementById('verifyBox').style.display = 'block';
	          document.getElementById("name").readOnly = true;
	          document.getElementById("phone2").readOnly = true;
	          document.getElementById("phone3").readOnly = true;
	        } else if (data.result === "cooldown") {
	          alert("잠시 후 다시 시도해주세요.");
	        } else {
	          alert("전송 실패");
	        }
	      })
	      .catch(() => alert("전송 실패"));
  }
	  // 숫자만 입력되게
	  ['phone2', 'phone3', 'verifyCode'].forEach(id => {
	    document.getElementById(id).addEventListener('input', (e) => {
	      e.target.value = e.target.value.replace(/[^0-9]/g, '');
	    });
	  });
	  
	function checkCode(){
		const writeCode = document.getElementById('verifyCode').value.trim();
		const byEmail = emailRadio.checked;
		const purpose = byEmail ? "FIND_ID_EMAIL" : "FIND_ID_PHONE";
		const recipient = byEmail
		    ? document.getElementById("email1").value.trim()
		    : document.getElementById('phone1').value.trim()
		      + document.getElementById('phone2').value.trim()
		      + document.getElementById('phone3').value.trim();

		 fetch("verifyCode.jsp", {
		    method: "POST",
		    headers: { "Content-Type": "application/x-www-form-urlencoded" },
		    body: new URLSearchParams({ purpose: purpose, recipient: recipient, code: writeCode })
		 })
		    .then(res => res.json())
		    .then(data => {
		      if (data.result === "success") {
		        alert("확인되었습니다.");
		        document.getElementById("otpGrant").value = data.otpGrant;
		        document.getElementById("findIdForm").submit();
		        }else {
		        alert("인증번호가 틀렸습니다.");
		      }
		    })
		    .catch(() => alert("인증번호가 틀렸습니다."));
	}
  
 function handleEmailSubmit() {
    const emailId = document.getElementById("emailId").value.trim();
    const emailDomain = document.getElementById("emailDomain").value.trim();
    if (emailId && emailDomain) {
    	document.getElementById("email1").value = emailId + "@" + emailDomain;
    } else {
    	document.getElementById("email1").value = null;
    }
    return true;
  }
	  
function showAuthBoxByEmail(){
	const name = document.getElementById("name");
	if(name.value == null || name.value == ""){
		alert("이름을 입력하시오.");
		return;
	}
	if(handleEmailSubmit()){
	    const email = document.getElementById("email1").value;
	    if (!email) {
	        alert("이메일을 입력하시오.");
	        return;
	    }
	    // 서버 응답을 확인한 뒤에만 전송 성공으로 안내한다.
	    fetch("sendEmail.jsp", {
	        method: "POST",
	        headers: {
	            "Content-Type": "application/x-www-form-urlencoded"
	        },
	        body: new URLSearchParams({ purpose: "FIND_ID_EMAIL", email: email })
	    })
	    .then(res => res.json())
	    .then(data => {
	        if (data.result === "success") {
	            alert("인증번호가 이메일로 전송되었습니다!");
	            document.getElementById('authBtnBox').style.display = 'none';
	            document.getElementById('verifyBox').style.display = 'block';
	            document.getElementById("name").readOnly = true;
	            document.getElementById("emailId").readOnly = true;
	            document.getElementById("emailDomain").disabled = true;
	        } else if (data.result === "cooldown") {
	            alert("잠시 후 다시 시도해주세요.");
	        } else {
	            alert("인증번호 전송에 실패했습니다.");
	        }
	    })
	    .catch(err => {
	        console.error(err);
	        alert("인증번호 전송 중 오류가 발생했습니다.");
	    });
	}
}

  // 요소 가져오기
  const phoneRadio = document.getElementById("phone");
  const emailRadio = document.getElementById("email");
  const phoneInputGroup = document.getElementById("phoneInputGroup");
  const emailInputGroup = document.getElementById("emailInputGroup");
  const authBtnBox = document.getElementById("authBtnBox");
  const verifyBox = document.getElementById("verifyBox");

  // 라디오 버튼 변경 시 실행
  phoneRadio.addEventListener("change", toggleAuthInput);
  emailRadio.addEventListener("change", toggleAuthInput);

  function toggleAuthInput() {
    // 입력창 전환
  if (phoneRadio.checked) {
    phoneInputGroup.style.display = "block";
    if (emailInputGroup) emailInputGroup.style.display = "none";
    document.getElementById("verification").onclick = showAuthBoxByPhone;
    document.getElementById("reverification").onclick = showAuthBoxByPhone;
    document.getElementById("name").readOnly = false;
    document.getElementById("phone2").readOnly = false;
    document.getElementById("phone3").readOnly = false;
    document.getElementById("name").value = "";
    document.getElementById("phone2").value = "";
    document.getElementById("phone3").value = "";
  } else if (emailRadio.checked) {
    if(phoneInputGroup)phoneInputGroup.style.display = "none";
    emailInputGroup.style.display = "block";
    document.getElementById("verification").onclick = showAuthBoxByEmail;
    document.getElementById("reverification").onclick = showAuthBoxByEmail;
    document.getElementById("name").readOnly = false;
    document.getElementById("emailId").readOnly = false;
    document.getElementById("emailDomain").disabled = false;
    document.getElementById("name").value = "";
    document.getElementById("emailId").value = "";
    document.getElementById("emailDomain").value = "";
  }
    // ✅ 인증 상태 초기화
    verifyBox.style.display = "none";
    authBtnBox.style.display = "block";
  }

  // 페이지 로드시 초기 세팅
  window.addEventListener("DOMContentLoaded", toggleAuthInput);
</script>

</body>
</html>