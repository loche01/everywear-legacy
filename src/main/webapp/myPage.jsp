<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.UserCouponDTO"%>
<%@page import="DTO.UserDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="userDao" class="DAO.UserDAO"/>
<%
		String userId = (String) session.getAttribute("id");
		String userType = (String) session.getAttribute("userType");
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
		UserDTO userDto = userDao.getOneUser(userId, userType);
		int couponCnt = userDao.showOneUserCoupon(userId, userType);
		String[] phoneParts = userDto.getUser_phone() == null ? new String[0] : userDto.getUser_phone().split("-");
		String phone2 = phoneParts.length == 3 ? phoneParts[1] : "";
		String phone3 = phoneParts.length == 3 ? phoneParts[2] : "";
		
        DecimalFormat formatter = new DecimalFormat("#,###");

        String point = formatter.format(userDto.getUser_point());
        
        String pwd = userDto.getUser_pwd() == null ? "" : "●●●●●●●●";
        
        String[] birthParts = userDto.getUser_birth() == null ? new String[0] : userDto.getUser_birth().split("-");
        String year = birthParts.length == 3 ? birthParts[0] : "";
        String month = birthParts.length == 3 ? birthParts[1] : "";
        String day = birthParts.length == 3 ? birthParts[2] : "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/myPage.css?v=5646574">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section2 class="content2">
	<h2>회원 정보 수정</h2>
	</section2>

	<div class="container">
		<div class="user-box">
			<p class="username"><%=userDto.getUser_name()%> 님</p>
			<div class="user-info">
				<div class="label">적립금</div>
				<div class="value"><%=point%> ￦</div>
				<div class="label"><a href="coupon.jsp">쿠폰</a></div>
				<div class="value"><%=couponCnt%> 개</div>
			</div>
		</div>
		
		
		<aside class="sidebar2">
		<br>
			<ul>
				<li><a href="myPage.jsp">회원 정보 수정</a></li>
				<li><a href="orderHistory2.jsp">주문 내역</a></li>
				<li><a href="cart2.jsp">장바구니</a></li>
				<li><a href="wishList2.jsp">찜 상품</a></li>
				<li><a href="postMn.jsp">게시물 관리</a></li>
				<li><a href="deliveryMn.jsp">배송지 관리</a></li>
			</ul>
		</aside>

		<section class="content">
			<div class="edit-content">
				<div class="form">
					<%if(userType.equals("일반")){ %>
					<h3>내 계정</h3>
					<!-- ID -->
					<div class="form-group">
						<label>ID <span style="color: red;">*</span></label>
						<div class="id-box">
							<input type="text" name="name" id="name" value="<%=userId%>" readonly>
						</div>
					</div>

					<!-- 기존 비밀번호 -->
					<div class="form-group" id="originPwd">
						<label>비밀번호</label>
						<div class="pwd-group">
							<!-- 휴대전화 입력 스타일을 재활용 -->
							<input type="text" name="password" id="password" value="<%=pwd%>" readonly>
							<button type="button" class="btn-change" id="btn-change" onclick="togglePasswordChange()">수정</button>
						</div>
					</div>


					<!-- 새 비밀번호 입력 영역 (처음엔 숨김) -->
					<div id="newPwBox" style="display: none;">
						<div class="newPwd-group">
							<label>이전 비밀번호</label> 
							<input type="password" id="oldPassword" placeholder="영문, 숫자, 특수문자 조합 4-16자">
							
							<div id="pwCheck"></div>
						</div>
					
						<!-- 새 비밀번호 -->
						<div class="newPwd-group">
							<label>새 비밀번호</label> 
							<input type="password" id="newPassword" placeholder="영문, 숫자, 특수문자 조합 4-16자">
							
							<div id="newPwCheck"></div>
						</div>

						<div class="button-group">
							<button type="button" class="btn1" onclick="pwdCancel()">취소</button>
							<button type="button" class="btn2" id="btn2">수정</button>
						</div>
					</div>
					<%}else if(userType.equals("Kakao")){ %>
					<h3>내 계정</h3>
					<!-- ID -->
					<div class="form-group">
						<label>ID <span style="color: red;">*</span></label>
						<div class="id-box">
						  	<img src="images/kakao.png" alt="아이콘" class="input-icon">
							<input type="text" name="name" id="name" value="<%=userId%>" readonly>
						</div>
					</div>
					<%}else if(userType.equals("Google")){ %>
					<h3>내 계정</h3>
					<!-- ID -->
					<div class="form-group">
						<label>ID <span style="color: red;">*</span></label>
						<div class="id-box">
						  	<img src="images/Google.png" alt="아이콘" class="input-icon">
							<input type="text" name="name" id="name" value="<%=userId%>" readonly>
						</div>
					</div>
					<%} %>

					<h3>개인 정보</h3>
					<!-- 이름 -->
					<div class="name">
						<label id="name">이름</label> 
						<div class="name-group">
							<input type="text" value="<%=userDto.getUser_name()%>" id="nameBox" placeholder="이름을 입력하세요" readonly>
							<button type="button" class="btn-change" id="btn-change2" onclick="nameChange()">수정</button>
						</div>
					</div>

					<!-- 휴대전화 -->
					<div class="name">
						<label>휴대전화</label>
						<div class="phone-group">
							<input type="text" id="phone1" value="010" readonly> - 
							<input type="text" id="phone2" value="<%=phone2%>" maxlength="4" readonly> - 
							<input type="text" id="phone3" value="<%=phone3%>" maxlength="4" readonly>
							<button type="button" class="btn-change" id="phone-change" onclick="phoneChange()">수정</button>
						</div>
						<button type="button" id="authBtn" class="authBtn" style="display: none;" onclick="showAuthBox()">인증</button>

						<div id="authBox" style="display: none;">
							<!-- 인증번호 입력 영역 (처음엔 숨김) -->
							<div class="authBox">
						  		<input type="text" id="authCode" class="authBox" placeholder="인증번호를 입력하세요">
					  		</div>
						  	<div class="auth-btns">
						    	<button type="button" class="resend-btn" onclick="showAuthBox()">재전송</button>
						    	<button type="button" class="confirm-btn" onclick="checkCode()">확인</button>
						  	</div>
					  	</div>

					</div>

					<%if(userType.equals("일반")){ %>
					<!-- 이메일 -->
					<div class="email">
						<label>이메일</label> 
						<div class="email2" id="email2">
							<input type="email" value="<%=userDto.getUser_email() == null || userDto.getUser_email().isEmpty() ? "" : userDto.getUser_email()%>">
							<button type="button" class="btn-change" id="email-change" onclick="emailChange()">수정</button>
						</div>
					</div>
					
					<div  id="email-input-group" style="display: none;">
						<div class="email-input-group">
						  <input type="text" id="emailId" placeholder="이메일 아이디 입력">
						  <span>@</span>
						  <select id="emailDomain">
						    <option value="">선택</option>
						    <option value="gmail.com">gmail.com</option>
						    <option value="naver.com">naver.com</option>
						    <option value="daum.net">daum.net</option>
						    <option value="hanmail.net">hanmail.net</option>
						    <option value="nate.com">nate.com</option>
						  </select>
						</div>
						<div>
							<button type="button" class="emailBtn" onclick="handleEmailSubmit()">수정</button>
						</div>
					</div>
					<%} %> 

					<!-- 성별 -->
					 <div class="gender">
					    <table class="gender-hw">
					    	<tr>
					    		<td width="65px"><label >성별</label></td>
					    		<td width="65px"></td>
					    		<td width="130px"><label>키</label></td>
					    		<td width="130px"><label>몸무게</label></td>
					    	</tr>
					    	<tr>
								<td><input type="radio" id="male" name="gender" value="남자" <%="남자".equals(userDto.getUser_gender()) ? "checked" : ""%> disabled><span style="font-size: 15px">남자</span></td>
								<td><input type="radio" id="female" name="gender" value="여자" <%="여자".equals(userDto.getUser_gender()) ? "checked" : ""%> disabled><span style="font-size: 15px">여자</span></td>
					    		<td><input type="text" id="height" name="height" maxlength="3" placeholder="키 (cm)" value="<%=userDto.getUser_height() == 0 ? "" : userDto.getUser_height() + "cm"%>" readonly></td>
					    		<td><input type="text"  id="weight" name="weight" maxlength="3" placeholder="몸무게 (kg)" value="<%=userDto.getUser_weight() == 0 ? "" : userDto.getUser_weight() + "kg"%>" readonly></td>
					    	</tr>
					    </table>
					    <button type="button" class="genderBtn" id="genderBtn" onclick="genderChange()">수정</button>
					</div>

					<!-- 생년월일 -->
					<div class="birth">
						<label>생년월일</label>
						<div class="birth2">
					        <input type="text" name="year" id="year" maxlength="4" placeholder="년" value="<%=year%>" readonly>
					        <span class="birth-label"> - </span>
					        <input type="text" name="month" id="month" maxlength="2" placeholder="월" value="<%=month%>" readonly>
					        <span class="birth-label"> - </span>
					        <input type="text" name="day" id="day" maxlength="2" placeholder="일" value="<%=day%>" readonly>
					        <span class="birth-label"></span>
					        <button type="button" class="birthBtn" id="birthBtn" onclick="birthChange()">수정</button>
						</div>
					</div>

					<a id="openModalBtn" class="withdraw-link">회원탈퇴</a>
					
					<!-- 탈퇴 모달 -->
					<div id="withdrawalModal" class="modal">
					  <div class="modal-content">
					    <h3>회원 탈퇴</h3>
					    
					    <label for="reason">탈퇴 사유</label>
					    <select id="reason">
					      <option value="">사유를 선택해주세요</option>
					      <option value="쇼핑몰 이용이 불편함">쇼핑몰 이용이 불편함</option>
					      <option value="원하는 상품 부족">원하는 상품 부족</option>
					      <option value="개인정보 보안 우려">개인정보 보안 우려</option>
					      <option value="마케팅 메시지 과다 수신">마케팅 메시지 과다 수신</option>
					      <option value="단순 변심 / 더 이상 이용하지 않음">단순 변심 / 더 이상 이용하지 않음</option>
					      <option value="기타">기타</option>
					    </select>
					
					    <label for="detail">상세 사유</label>
					    <textarea id="detail" rows="4" placeholder="상세한 이유를 입력해주세요."></textarea>
					
					    <div class="modal-buttons">
					      <button class="cancel" onclick="closeModal()">취소</button>
					      <button class="confirm" onclick="submitWithdrawal()">확인</button>
					    </div>
					  </div>
					</div>
					
					
				</div>
			</div>
		</section>
	</div>
	
	<script>
	const userType = '<%= session.getAttribute("userType") %>';
  let isPwdChecked = true;
  
  if(userType === "일반"){
	function togglePasswordChange(){
		document.getElementById("originPwd").style.display = "none";
		document.getElementById("newPwBox").style.display = "block";
		
	  function validatePasswords() {
		    const pw = document.getElementById("oldPassword").value;
		    const newPw = document.getElementById("newPassword").value;
		    const regex = /^(?=.*[!@#$%^&*(),.?":{}|<>]).{4,16}$/;
		    const pwCheck = document.getElementById("pwCheck");
		    const newPwCheck = document.getElementById("newPwCheck");

 		    if (pw === "") {
		      document.getElementById("oldPassword").style.borderBottom = "1px solid #ccc";
		      pwCheck.textContent = "";        // ← 이 부분 추가!
		      pwCheck.className = "";
		      isPwdChecked = false;
		    } else if (!regex.test(pw)) {
		    	document.getElementById("oldPassword").style.borderBottom = "1px solid #FF0000"; // 빨간 밑줄 적용
 		    	pwCheck.textContent = "4자 이상 16자 이하이며, 특수문자 1개 이상을 포함";
		    	pwCheck.className = "not-match";
		      isPwdChecked = false;
		    } else{
		    	document.getElementById("oldPassword").style.borderBottom = "1px solid #ccc";
  		    	pwCheck.textContent = "";
		    	 isPwdChecked = false; 
		    }
 		    
 		    if(newPw === ""){
 			      document.getElementById("newPassword").style.borderBottom = "1px solid #ccc";
 			      newPwCheck.textContent = "";        // ← 이 부분 추가!
 			      newPwCheck.className = "";
 			      isPwdChecked = false;
 		    }else if(!regex.test(newPw)){
		    	document.getElementById("newPassword").style.borderBottom = "1px solid #FF0000"; // 빨간 밑줄 적용
		    	newPwCheck.textContent = "4자 이상 16자 이하이며, 특수문자 1개 이상을 포함";
		    	newPwCheck.className = "not-match";
		    	 isPwdChecked = false; 
		    } else{
		    	document.getElementById("newPassword").style.borderBottom = "1px solid #ccc";
		    	newPwCheck.textContent = "";
		    	 isPwdChecked = true; 
		    }
 		    
 		    if(isPwdChecked)	
 		    	document.getElementById("btn2").onclick=pwdUpdate;


		  }
	  
	 	 document.getElementById("oldPassword").addEventListener("input", validatePasswords);
	 	 document.getElementById("newPassword").addEventListener("input", validatePasswords);
		

	}
  }
  
  function pwdCancel(){
	  document.getElementById("oldPassword").value = "";
      document.getElementById("oldPassword").style.borderBottom = "1px solid #ccc";
      pwCheck.textContent = "";        // ← 이 부분 추가!
	  document.getElementById("newPassword").value = "";
		document.getElementById("originPwd").style.display = "block";
		document.getElementById("newPwBox").style.display = "none";
  }
  
  function pwdUpdate(){
	  const oldPwd = document.getElementById("oldPassword");
	  const newPwd = document.getElementById("newPassword");
	  
	   fetch("isPwd2.jsp", {method: "POST", body: new URLSearchParams({
	     password: oldPwd.value, newPassword: newPwd.value, userCsrfToken: "<%=Security.UserRequestGuard.token(session)%>"
	   })})
      .then(res => res.json())
      .then(data => {
        if (data.result === "success") {		//변경 성공
        	location.reload();
        } else if(data.result === "fail") {	//기존 비번 오류
          alert("일치하지 않은 비밀번호입니다.");
        } else if(data.result == "cant"){	//변경 실패
        	alert("비밀번호 변경을 실패하였습니다.");
        }
      });
	   
  }
  
  function nameChange(){
	  document.getElementById("name").innerText="이름 변경";
	  document.getElementById("nameBox").readOnly = false;
	  document.getElementById("nameBox").focus();
	  document.getElementById("btn-change2").onclick = nameChange2;
	  document.getElementById("nameBox").style.borderBottom = "1px solid #000";
}
  
  function nameChange2(){
	  const name = document.getElementById("nameBox");
	  
	  fetch("nameChange.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "name=" + encodeURIComponent(name.value) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
      .then(res => res.json())
      .then(data => {
        if (data.result === "success") {		//변경 성공
        	alert("변경되었습니다.")
        	location.reload();
        } else if(data.result === "fail") {	//기존 비번 오류
          
        }
      });
  }
  
  function phoneChange(){
	  document.getElementById("phone-change").style.display = "none";
	  document.getElementById("phone2").readOnly = false;
	  document.getElementById("phone3").readOnly = false;
	  document.getElementById("phone2").style.borderBottom = "1px solid #000";
	  document.getElementById("phone3").style.borderBottom = "1px solid #000";
	  document.getElementById("authBtn").style.display = "block";
  }
	
	
	  /* 생년월일 숫자만 입력 가능 */
	  document.querySelectorAll('.birth-group input').forEach(input => {
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
	  
	  
	  /* 신체정보 숫자만 입력 가능 */
		  ['height', 'weight'].forEach(id => {
		    document.getElementById(id).addEventListener('input', (e) => {
		      e.target.value = e.target.value.replace(/[^0-9]/g, '');
		    });
		  });
	  
		  document.addEventListener("DOMContentLoaded", function () {
			    const heightInput = document.getElementById("height");
			    const weightInput = document.getElementById("weight");

			    function isValidHeight(value) {
			      const num = Number(value);
			      return !isNaN(num) && num >= 50 && num <= 250; // 키는 50~250cm
			    }

			    function isValidWeight(value) {
			      const num = Number(value);
			      return !isNaN(num) && num >= 10 && num <= 300; // 몸무게는 10~300kg
			    }

			    function validateInput(input, validator, fieldName) {
			      input.addEventListener("blur", function () {
			        const value = input.value.trim();
			        if (value === "") return; // 비어있으면 검사 안 함

			        if (!validator(value)) {
			          /* alert(`${fieldName} 값이 올바르지 않습니다.`); */
			          alert(fieldName + " 값이 올바르지 않습니다");
			          input.value = "";
			          input.focus();
			        }
			      });
			    }

			    validateInput(heightInput, isValidHeight, "키");
			    validateInput(weightInput, isValidWeight, "몸무게");
			  });
		  
		  	function showAuthBox() {
			    // 휴대전화 번호 결합
			  const p1 = document.getElementById('phone1').value.trim();
			  const p2 = document.getElementById('phone2').value.trim();
			  const p3 = document.getElementById('phone3').value.trim();
			  const p = p1+p2+p3;
			    if (!p.match(/^010\d{4}\d{4}$/)) {
			      alert("전화번호 형식이 올바르지 않습니다.");
			      return;
			    }
			    // 인증 버튼 숨기고 인증번호 입력창 보이기
			    document.getElementById("authBtn").style.display = "none";
			    document.getElementById("authBox").style.display = "block";
			    
			    fetch("sendSMS.jsp", {
			      method: "POST",
			      headers: { "Content-Type": "application/x-www-form-urlencoded" },
			      body: new URLSearchParams({ purpose: "CHANGE_PHONE", phone: p })
			    })
			      .then(res => res.json())
			      .then(data => {
			        if (data.result === "success") {
			          alert("인증번호가 전송되었습니다.");
			          document.getElementById("authBox").style.display = "block";
			        } else if (data.result === "cooldown") {
			          alert("잠시 후 다시 시도해주세요.");
			        } else {
			          alert("전송 실패");
			        }
			      })
			      .catch(() => alert("전송 실패"));
		  }
	  		
		function checkCode(){
			const writeCode = document.getElementById('authCode').value.trim();
			
		    // 휴대전화 번호 결합
			  const p1 = document.getElementById('phone1').value.trim();
			  const p2 = document.getElementById('phone2').value.trim();
			  const p3 = document.getElementById('phone3').value.trim();
			  const p = p1+p2+p3;
			 fetch("verifyCode3.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "code=" + encodeURIComponent(writeCode) + "&phone=" + encodeURIComponent(p) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
			    .then(res => res.json())
			    .then(data => {
			      if (data.result === "success") {
			        alert("확인되었습니다.");
			        location.reload();
			        isPhoneChecked = true;
			      } else {
			        alert("인증번호가 틀렸습니다.");
			        isPhoneChecked = false;
			      }
			    });
		}

		  // 숫자만 입력되게
		  ['phone2', 'phone3', 'authCode'].forEach(id => {
		    document.getElementById(id).addEventListener('input', (e) => {
		      e.target.value = e.target.value.replace(/[^0-9]/g, '');
		    });
		  });
		  
		  
		  function emailChange(){
			  document.getElementById("email2").style.display = "none";
			  document.getElementById("email-input-group").style.display = "block";
		  }
		  
		  function handleEmailSubmit() {
			 let email = "";

			  const emailId = document.getElementById("emailId").value.trim();
			  const emailDomain = document.getElementById("emailDomain").value.trim();

			  if (emailId && emailDomain) {
			    email = emailId + "@" + emailDomain;
			  } else {
			    email = "";
			  }
			  
			 fetch("updateEmail.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "email=" + encodeURIComponent(email) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
			    .then(res => res.json())
			    .then(data => {
			      if (data.result === "success") {
			        alert("변경되었습니다.");
			        location.reload();
			      } else {
			        alert("변경에 실패하였습니다.");
			      }
			    });

			}
		  
		  function genderChange(){
			  document.getElementById("male").disabled = false;
			  document.getElementById("female").disabled = false;
			  document.getElementById("height").value = "";
			  document.getElementById("weight").value = "";
			  document.getElementById("height").readOnly = false;
			  document.getElementById("weight").readOnly = false; 
			  document.getElementById("genderBtn").onclick = genderChange2;
			  document.getElementById("height").style.borderBottom = "1px solid #000";
			  document.getElementById("weight").style.borderBottom = "1px solid #000";
			 
		  }
		  
		  function genderChange2(){
			  const gender = document.querySelector('input[name="gender"]:checked');
			  const height = document.getElementById("height");
			  const weight = document.getElementById("weight");
			  
			 fetch("updateGender.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "gender=" + encodeURIComponent(gender.value) +
					 "&height=" + encodeURIComponent(height.value) + "&weight=" +  encodeURIComponent(weight.value) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
			    .then(res => res.json())
			    .then(data => {
			      if (data.result === "success") {
			        alert("변경되었습니다.");
			        location.reload();
			      } else {
			        alert("변경에 실패하였습니다.");
			      }
			    });
		  }
		  
		  function birthChange(){
			  document.getElementById("year").readOnly = false;
			  document.getElementById("month").readOnly = false;
			  document.getElementById("day").readOnly = false;
			  document.getElementById("year").style.borderBottom = "1px solid #000";
			  document.getElementById("month").style.borderBottom = "1px solid #000";
			  document.getElementById("day").style.borderBottom = "1px solid #000";
			  document.getElementById("birthBtn").onclick = birthChange2;
		  }
		  
		  function birthChange2(){
			  const year = document.getElementById("year");
			  const month = document.getElementById("month");
			  const day = document.getElementById("day");
			  
			  const birth = year.value + "-" + month.value + "-" + day.value;
			  
			 fetch("updateBirth.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "birth=" + encodeURIComponent(birth) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
			    .then(res => res.json())
			    .then(data => {
			      if (data.result === "success") {
			        alert("변경되었습니다.");
			        location.reload();
			      } else {
			        alert("변경에 실패하였습니다.");
			      }
			    });
		  }
		  
		  
		  
		  // 모달 열기
		  document.getElementById("openModalBtn").addEventListener("click", function () {
		    document.getElementById("withdrawalModal").style.display = "flex";
		  });

		  // 모달 닫기
		  function closeModal() {
		    document.getElementById("withdrawalModal").style.display = "none";
		  }

		  // 탈퇴 제출
		  function submitWithdrawal() {
		    const reason = document.getElementById("reason").value;
		    const detail = document.getElementById("detail").value;

		    if (!reason) {
		      alert("탈퇴 사유를 선택해주세요.");
		      return;
		    }

		    // 여기서 서버로 전송하거나 확인창 띄우기
		    fetch("resign.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "reason=" + encodeURIComponent(reason) + "&detail=" + encodeURIComponent(detail) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
			    .then(res => res.json())
			    .then(data => {
			      if (data.result === "success") {
			    	alert("정상적으로 탈퇴되었습니다.");
				    closeModal();
			    	location.href="main2.jsp"
			        
			      } else {
			        alert("탈퇴에 실패하였습니다.");
			        closeModal();
			      }
			    });

		    // 실제 탈퇴 처리 서블릿으로 이동하거나 fetch로 전송 가능
		  }
	
	</script>

</body>