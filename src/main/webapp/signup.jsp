<!-- signup.jsp -->
<%@ page import="DAO.PhoneSMS" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%!
	private String escapeHtmlAttribute(String value) {
		if (value == null) {
			return "";
		}
		return value.replace("&", "&amp;")
				.replace("\"", "&quot;")
				.replace("<", "&lt;")
				.replace(">", "&gt;");
	}
%>
<%
		String social = request.getParameter("social");
		boolean naverSignup = "Naver".equals(social);
		String socialName = naverSignup ? (String) session.getAttribute("socialName") : "";
		String socialEmail = naverSignup ? (String) session.getAttribute("socialEmail") : "";
		String socialPhone = naverSignup ? (String) session.getAttribute("socialPhone") : "";
		String socialGender = naverSignup ? (String) session.getAttribute("socialGender") : "";
		String socialBirth = naverSignup ? (String) session.getAttribute("socialBirth") : "";

		String phone1 = "010";
		String phone2 = "";
		String phone3 = "";
		if (socialPhone != null && !socialPhone.isBlank()) {
			String phoneDigits = socialPhone.replaceAll("\\D", "");
			if (phoneDigits.length() == 11) {
				phone1 = phoneDigits.substring(0, 3);
				phone2 = phoneDigits.substring(3, 7);
				phone3 = phoneDigits.substring(7);
			} else if (phoneDigits.length() == 10) {
				phone1 = phoneDigits.substring(0, 3);
				phone2 = phoneDigits.substring(3, 6);
				phone3 = phoneDigits.substring(6);
			}
		}

		String birthYear = "";
		String birthMonth = "";
		String birthDay = "";
		if (socialBirth != null && socialBirth.matches("\\d{4}-\\d{2}-\\d{2}")) {
			String[] birthParts = socialBirth.split("-");
			birthYear = birthParts[0];
			birthMonth = birthParts[1];
			birthDay = birthParts[2];
		}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입 | everyWEAR</title>
  <link rel="stylesheet" type="text/css" href="css/signup.css">
  <link rel="icon" type="image/png" href="images/fav-icon.png">
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<style>
  .terms-section {
    font-size: 14px;
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 20px;
  }

  .term-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .term-item label {
    display: flex;
    align-items: center;
    gap: 6px;
    margin: 0;
  }

  .term-item a {
    color: blue;
    text-decoration: underline;
    white-space: nowrap;
    font-size: 13px;
  }
  
 .phone-group {
    display: flex;
    align-items: center;
    gap: 5px;
    margin-top: 4px;
    margin-bottom: 10px;
  }

.phone-group input {
  width: 109px;
  height: 42px;
  padding: 0 10px;
  border: 1px solid #ccc;
  border-radius: 10px;
  background-color: #f7fbff;
  text-align: center;
  font-size: 15px;
}


  .verify-btn {
    margin-top: 5px;
    width: 100%;
    padding: 10px;
    background-color: black;
    color: white;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    font-weight: bold;
  }

  .auth-box {
    margin-top: 15px;
  }

.auth-box input {
  height: 42px;
  padding: 0 12px;
  font-size: 15px;
  border-radius: 10px;
  border: 1px solid #dcdcdc;
  background-color: #f7fbff;
}


  .auth-btns {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
    gap: 10px;
  }

  .resend-btn {
    flex: 1;
    padding: 10px;
    border-radius: 10px;
    border: 1px solid #dcdcdc;
    background-color: white;
    cursor: pointer;
  }

  .confirm-btn {
    flex: 1;
    padding: 10px;
    border-radius: 10px;
    background-color: black;
    color: white;
    border: none;
    cursor: pointer;
    font-weight: bold;
  }
  
  /* 모달 */
  .modal {
  display: none;
  position: fixed;
  z-index: 9999;
  left: 0; top: 0;
  width: 100%; height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
}

.modal-content {
  background-color: #fff;
  margin: 10% auto;
  padding: 20px;
  width: 80%;
   width: 600px;    /* 고정 너비 */
  height: 400px;   /* 고정 높이 */
  border-radius: 8px;
  position: relative;
  max-height: 80vh;
  overflow-y: auto;
}

.modal-content2 {
  background-color: #fff;
  margin: 10% auto;
  padding: 20px;
  width: 80%;
   width: 600px;    /* 고정 너비 */
  height: 500px;   /* 고정 높이 */
  border-radius: 8px;
  position: relative;
  max-height: 80vh;
  overflow-y: auto;
}

.close-btn {
  position: absolute;
  right: 20px; top: 10px;
  font-size: 24px;
  cursor: pointer;
}


.info-table {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
  font-size: 13px;
  table-layout: fixed;
}

.info-table th, .info-table td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: left;
  vertical-align: top;
  word-break: break-word;
}

.info-table th {
  background-color: #f9f9f9;
  font-weight: bold;
}
  
</style>
<body>


<%@ include file="includes/loginHeader.jsp" %>

<div class="signup-container">
  <h2>회원가입</h2>

  <form id="register" action="signup" method="post" onsubmit="return handleEmailSubmit()">

<%if(social == null){ %>
    <!-- 아이디 -->
    <label for="userId">아이디 <span style="color: red;">*</span></label>
    <div class="address-group">
	    <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required>
		<button type="button" class="search-btn" id="checking" onclick="checkId()">중복 체크</button>
	</div>
	<div id="checkResult"></div>
		

    <!-- 비밀번호 -->
    <label for="password">비밀번호 <span style="color: red;">*</span></label>
    <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
    
    <div id="pwCheck"></div>

    <!-- 비밀번호 확인 -->
    <label for="confirmPassword">비밀번호 확인 <span style="color: red;">*</span></label>
    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>

    <div id="pwCheckMsg"></div>
<%} %>
    <!-- 이름 -->
    <label for="name">이름 <span style="color: red;">*</span></label>
    <input type="text" id="name" name="name" placeholder="이름을 입력하세요"
           value="<%= escapeHtmlAttribute(socialName) %>" required>

<%if(social==null){ %>
    <!-- 이메일 -->
<label for="emailId">이메일(선택사항)</label>
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
<!-- 서버로 전달할 hidden 필드 -->
<input type="hidden" id="email" name="email">
<%} else if(naverSignup && socialEmail != null && !socialEmail.isBlank()){ %>
<input type="hidden" id="email" name="email" value="<%= escapeHtmlAttribute(socialEmail) %>">
<%} %>


    <!-- 추천인 -->
    <label for="referrer">추천인 아이디(선택사항)</label>
    <input type="text" id="referrer" name="referrer" placeholder="추천인 아이디를 입력하세요">

    <!-- 주소 -->
    <label for="address">주소 <span style="color: red;">*</span></label>
    <div class="address-group">
      <input type="text" id="zipcode" name="zipcode" placeholder="우편번호" readonly>
      <button type="button" id="addrSearch" class="search-btn" onclick="execDaumPostcode()">주소 검색</button>
    </div>
    <input type="text" style="margin-top: 10px" id="address1" name="address1" placeholder="기본 주소" required readonly>
    <input type="text" id="address2" name="address2" placeholder="나머지 주소">

    <div>
	    <table class="gender-hw">
	    	<tr>
	    		<td width="65px"><label >성별 <span style="color: red;">*</span></label></td>
	    		<td width="65px"></td>
	    		<td width="130px"><label>키(선택사항)</label></td>
	    		<td width="130px"><label>몸무게(선택사항)</label></td>
	    	</tr>
	    	<tr>
					<td><input type="radio" id="male" name="gender" value="남자" <%= "남자".equals(socialGender) ? "checked" : "" %> required><span style="font-size: 15px">남자</span></td>
					<td><input type="radio" id="female" name="gender" value="여자" <%= "여자".equals(socialGender) ? "checked" : "" %>><span style="font-size: 15px">여자</span></td>
	    		<td><input type="text" id="height" name="height" maxlength="3" placeholder="키 (cm)"></td>
	    		<td><input type="text"  id="weight" name="weight" maxlength="3" placeholder="몸무게 (kg)"></td>
	    	</tr>
	    </table>
	</div>

	<br>
    <!-- 생년월일 -->
    <label for="birth">생년월일 <span class="required" style="color: red;">*</span></label>
    <div class="birth-container">
        <input type="text" name="year" id="year" maxlength="4" placeholder="년" value="<%= birthYear %>" required>
        <span class="birth-label">년</span>
        <input type="text" name="month" id="month" maxlength="2" placeholder="월" value="<%= birthMonth %>" required>
        <span class="birth-label">월</span>
        <input type="text" name="day" id="day" maxlength="2" placeholder="일" value="<%= birthDay %>" required>
        <span class="birth-label">일</span>
    </div>

	<!-- 휴대전화 -->
	<label for="phone1">휴대전화 <span style="color: red;">*</span></label>
	<div class="phone-group">
		  <input type="text" id="phone1" name="phone1" maxlength="3" value="<%= phone1 %>" readonly>
	  <span>-</span>
		  <input type="text" id="phone2" name="phone2" maxlength="4" placeholder="1234" value="<%= phone2 %>" required>
	  <span>-</span>
		  <input type="text" id="phone3" name="phone3" maxlength="4" placeholder="5678" value="<%= phone3 %>" required>
	</div>
	<button type="button" id="sendCodeBtn" class="verify-btn" onclick="showAuthBox()">인증</button>
	
	<!-- 인증번호 입력 박스 (초기에는 숨김) -->
	<div id="authBox" class="auth-box" style="display: none;">
	  <label for="authCode">인증번호</label>
	  <input type="text" id="authCode" placeholder="인증번호를 입력하세요">
	  <div class="auth-btns">
	    <button type="button" class="resend-btn" onclick="showAuthBox()">재전송</button>
	    <button type="button" class="confirm-btn" onclick="checkCode()">확인</button>
	  </div>
	</div>
	
	<!-- 최종 전송용 hidden input -->
	<input type="hidden" id="phone" name="phone">
	<!-- 휴대전화 본인확인 grant (verifyCode.jsp 성공 시 채워짐) -->
	<input type="hidden" id="otpGrant" name="otpGrant">

<%if(social == null || social != null){ %>
    <!-- 약관 동의 -->
<div class="terms-section">
  <h3>약관 동의</h3>

  <div class="term-item">
    <label><input type="checkbox" id="checkAll"> 약관 전체 동의하기(선택 동의 포함)</label>
  </div>

  <div class="term-item">
    <label><input type="checkbox" id="neceCheck" name="neceCheck" class="term-check" required> 만 14세 이상입니다. (필수)</label>
  </div>

  <div class="term-item">
    <label><input type="checkbox" name="neceCheck" class="term-check" required> 에브리웨어 이용 약관 (필수)</label>
    <a href="#" class="open-modal" data-target="modal-terms" style="color:gray;">자세히</a>
  </div>

  <div class="term-item">
    <label><input type="checkbox" name = "marketing" class="term-check"> 광고성 정보 수신 동의 (선택)</label>
    <a href="#" class="open-modal" data-target="modal-marketing" style="color:gray;">자세히</a>
  </div>
</div>


<div class="modal" id="modal-terms">
  <div class="modal-content">
    <span class="close-btn">&times;</span>
    <h1 align="center">everyWEAR 이용약관</h1>
    <div class="modal-body">
      <p><strong>제1 조 (목적)</strong></p>
      <p>이 약관은 everyWEAR 회사(전자상거래 사업자)가 운영하는 everyWEAR 사이버 몰(이하 “몰”이라 한다)에서 제공하는 인터넷 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리․의무 및 책임사항을 규정함을 목적으로 합니다.※「PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다.」</p>
      <p><strong>제2 조 (정의)</strong></p>
      <p>① “몰”이란 everyWEAR 회사가 재화 또는 용역(이하 “재화 등”이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.<br>② “이용자”란 “몰”에 접속하여 이 약관에 따라 “몰”이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.<br>③ ‘회원’이라 함은 “몰”에 회원등록을 한 자로서, 계속적으로 “몰”이 제공하는 서비스를 이용할 수 있는 자를 말합니다.<br>④ ‘비회원’이라 함은 회원에 가입하지 않고 “몰”이 제공하는 서비스를 이용하는 자를 말합니다.</p>
      <p><strong>제3조 (약관 등의 명시와 설명 및 개정)</strong></p>
      <p>① “몰”은 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지 주소(소비자의 불만을 처리할 수 있는 곳의 주소를 포함), 전화번호․모사전송번호․전자우편주소, 사업자등록번호, 통신판매업 신고번호, 개인정보관리책임자등을 이용자가 쉽게 알 수 있도록 사이버몰의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.<br>② “몰은 이용자가 약관에 동의하기에 앞서 약관에 정하여져 있는 내용 중 청약철회․배송책임․환불조건 등과 같은 중요한 내용을 이용자가 이해할 수 있도록 별도의 연결화면 또는 팝업화면 등을 제공하여 이용자의 확인을 구하여야 합니다.<br>③ “몰”은 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및 전자거래기본법」, 「전자금융거래법」, 「전자서명법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매 등에 관한 법률」, 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.<br>④ “몰”이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 몰의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 "몰“은 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.<br>⑤ “몰”이 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에 의한 개정약관의 공지기간 내에 “몰”에 송신하여 “몰”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.<br>⑥ 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다.</p>
      <p><strong>제4조(서비스의 제공 및 변경)</strong></p>
      <p>① “몰”은 다음과 같은 업무를 수행합니다.  1. 재화 또는 용역에 대한 정보 제공 및 구매계약의 체결  2. 구매계약이 체결된 재화 또는 용역의 배송  3. 기타 “몰”이 정하는 업무<br>② “몰”은 재화 또는 용역의 품절 또는 기술적 사양의 변경 등의 경우에는 장차 체결되는 계약에 의해 제공할 재화 또는 용역의 내용을 변경할 수 있습니다. 이 경우에는 변경된 재화 또는 용역의 내용 및 제공일자를 명시하여 현재의 재화 또는 용역의 내용을 게시한 곳에 즉시 공지합니다.<br>③ “몰”이 제공하기로 이용자와 계약을 체결한 서비스의 내용을 재화등의 품절 또는 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 주소로 즉시 통지합니다.<br>④ 전항의 경우 “몰”은 이로 인하여 이용자가 입은 손해를 배상합니다. 다만, “몰”이 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.</p>
      <p><strong>제5조(서비스의 중단)</strong></p>
      <p>① “몰”은 컴퓨터 등 정보통신설비의 보수점검․교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.<br>② “몰”은 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, “몰”이 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.<br>③ 사업종목의 전환, 사업의 포기, 업체 간의 통합 등의 이유로 서비스를 제공할 수 없게 되는 경우에는 “몰”은 제8조에 정한 방법으로 이용자에게 통지하고 당초 “몰”에서 제시한 조건에 따라 소비자에게 보상합니다. 다만, “몰”이 보상기준 등을 고지하지 아니한 경우에는 이용자들의 마일리지 또는 적립금 등을 “몰”에서 통용되는 통화가치에 상응하는 현물 또는 현금으로 이용자에게 지급합니다.</p>
      <p><strong>제6조(회원가입)</strong></p>
      <p>① 이용자는 “몰”이 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.<br>② “몰”은 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.  <br> 1. 가입신청자가 이 약관 제7조제3항에 의하여 이전에 회원자격을 상실한 적이 있는 경우, 다만 제7조제3항에 의한 회원자격 상실 후 3년이 경과한 자로서 “몰”의 회원재가입 승낙을 얻은 경우에는 예외로 한다.  <br> 2. 등록 내용에 허위, 기재누락, 오기가 있는 경우  <br> 3. 기타 회원으로 등록하는 것이 “몰”의 기술상 현저히 지장이 있다고 판단되는 경우<br>③ 회원가입계약의 성립 시기는 “몰”의 승낙이 회원에게 도달한 시점으로 합니다.<br>④ 회원은 회원가입 시 등록한 사항에 변경이 있는 경우, 상당한 기간 이내에 “몰”에 대하여 회원정보 수정 등의 방법으로 그 변경사항을 알려야 합니다.</p>
      <p><strong>제7조(회원 탈퇴 및 자격 상실 등)</strong></p>
      <p>① 회원은 “몰”에 언제든지 탈퇴를 요청할 수 있으며 “몰”은 즉시 회원탈퇴를 처리합니다.<br>② 회원이 다음 각 호의 사유에 해당하는 경우, “몰”은 회원자격을 제한 및 정지시킬 수 있습니다.  <br> 1. 가입 신청 시에 허위 내용을 등록한 경우  <br> 2. “몰”을 이용하여 구입한 재화 등의 대금, 기타 “몰”이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우  <br> 3. 다른 사람의 “몰” 이용을 방해하거나 그 정보를 도용하는 등 전자상거래 질서를 위협하는 경우  <br> 4. “몰”을 이용하여 법령 또는 이 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우<br>③ “몰”이 회원 자격을 제한․정지 시킨 후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 “몰”은 회원자격을 상실시킬 수 있습니다.<br>④ “몰”이 회원자격을 상실시키는 경우에는 회원등록을 말소합니다. 이 경우 회원에게 이를 통지하고, 회원등록 말소 전에 최소한 30일 이상의 기간을 정하여 소명할 기회를 부여합니다.</p>
    </div>
  </div>
</div>

<div class="modal" id="modal-marketing">
	<div class="modal-content2">
		<span class="close-btn">&times;</span>
	    <h1 align="center">개인 정보 수집 및 마케팅 동의</h1>
	    <div class="modal-body">
	          <p>everyWEAR(주)(이하 회사)는 마케팅 정보 전송 및 개인 맞춤형 광고 제공을 위하여 아래와 같이 개인정보를 수집 · 이용 및 제공합니다.</p>
	    	<h3>개인정보 수집 및 이용 내역</h3>
      <table class="info-table">
        <thead>
          <tr>
            <th>항목</th>
            <th>수집 및 이용 목적</th>
            <th>필수여부</th>
            <th>보유 및 이용기간</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>이름, 생년월일, 성별, 휴대폰 번호, 이메일 주소, 서비스 이용 기록(구매 기록, 방문 기록, 검색 기록 등)</td>
            <td>마케팅 정보 전송, 개인 맞춤형 상품·서비스 혜택 정보 제공</td>
            <td>선택</td>
            <td>해당 개인정보 수집/이용 거부 시까지</td>
          </tr>
        </tbody>
      </table>
      <p>개인정보의 수집 및 이용에 대한 동의를 거부하시더라도 서비스의 이용은 가능합니다.</p>
      <p><strong>다만, 동의 전까지 위 정보를 통한 마케팅 정보 수신 및 개인 맞춤형 광고를 제공 받을 수 없습니다.</strong></p>
	    </div>
	</div>
</div>
<%} %>
	<%if(social == null){ %>
    <button type="button" class="signup-btn" onclick="register()">회원가입</button>
    <%} else{ %>
    <button type="button" class="signup-btn" onclick="registerSocial()">회원가입</button>
    <%} %>
  </form>
</div>

<footer>2025©everyWEAR</footer>

<!-- ✅ Script 영역 -->
<script>
let isIdChecked = false;  // 중복확인 여부 저장
let isPwdChecked = false;	//비밀번호 일치 여부 저장
let isPhoneChecked = false;	//휴대폰 인증 여부 저장

function register(){
	const name = document.getElementById("name").value;
	const addr = document.getElementById("zipcode").value;
	const gender = document.querySelector('input[name="gender"]:checked');
	const year = document.getElementById("year").value;
	const month = document.getElementById("month").value;
	const day = document.getElementById("day").value;
	  if (!isIdChecked) {
		    alert("아이디 중복 확인을 먼저 해주세요!");
		    document.getElementById("checking").focus();
		    return;
	  }
	 if(!isPwdChecked){
		  alert("비밀번호가 일치하지 않습니다!");
		  document.getElementById("password").focus();
		  return;
	  } 
	if(name == null || name == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("name").focus();
		return;
	} 
	if(addr == null || addr == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("addrSearch").focus();
		return;
	} 
	if(gender == null || gender == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("male").focus();
		return;
	} 
	if(year == null || year == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("year").focus();
		return;
	} 
	if(month == null || month == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("month").focus();
		return;
	} 
	if(day == null || day == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("day").focus();
		return;
	}
	 if(!isPhoneChecked){
		  alert("휴대전화 인증을 해주세요!");
		  document.getElementById("phone3").focus();
		  return;
	  } 
	 if (!checkRequiredTerms()) {
	      alert("모든 필수 약관에 동의해야 합니다.");
	      document.getElementById("neceCheck").focus();
		  return;
	  }
	 handleEmailSubmit();
	  document.getElementById("register").submit();
}

function registerSocial(){
	const name = document.getElementById("name").value;
	const addr = document.getElementById("zipcode").value;
	const gender = document.querySelector('input[name="gender"]:checked');
	const year = document.getElementById("year").value;
	const month = document.getElementById("month").value;
	const day = document.getElementById("day").value;

	if(name == null || name == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("name").focus();
		return;
	} 
	if(addr == null || addr == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("addrSearch").focus();
		return;
	} 
	if(gender == null || gender == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("male").focus();
		return;
	} 
	if(year == null || year == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("year").focus();
		return;
	} 
	if(month == null || month == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("month").focus();
		return;
	} 
	if(day == null || day == ""){
		alert("필수 항목을 입력해주세요!");
		document.getElementById("day").focus();
		return;
	}
	 if(!isPhoneChecked){
		  alert("휴대전화 인증을 해주세요!");
		  document.getElementById("phone3").focus();
		  return;
	  } 
	 if (!checkRequiredTerms()) {
	      alert("모든 필수 약관에 동의해야 합니다!");
	      document.getElementById("neceCheck").focus();
		  return;
	  }
	 
	  document.getElementById("register").submit();
}

//필수약관 체크 여부
function checkRequiredTerms() {
	  const requiredChecks = document.getElementsByName("neceCheck");

	  for (let checkbox of requiredChecks) {
	    if (!checkbox.checked) {
	      return false;
	    }
	  }
	  return true;
	}


	//아이디 중복 체크
function checkId() {
	  const userIdInput = document.getElementById("userId");
	  const userId = userIdInput.value;
	  const resultDiv = document.getElementById("checkResult");

	  if (userId == "") {
	    resultDiv.innerText = "아이디를 입력하세요.";
	    resultDiv.style.color = "red";
	    return;
	  }

	  fetch("checkId?userId=" + encodeURIComponent(userId))
	    .then(response => response.text())
	    .then(data => {
	      resultDiv.innerText = data;

	      if (data.includes("사용 중")) {
	        // 이미 사용 중인 아이디
	        resultDiv.style.color = "red";
	        isIdChecked = false;
	      } else if (data.includes("사용 가능")) {
	        // 사용 가능한 아이디
	        resultDiv.style.color = "green";
	        isIdChecked = true;
	      } else {
	        // 기타 메시지
	        resultDiv.style.color = "black";
	        isIdChecked = false;
	      }
	    })
	    .catch(error => {
	      resultDiv.innerText = "서버 에러가 발생했습니다.";
	      resultDiv.style.color = "red";
	      console.error("에러:", error);
	    });
	  document.getElementById("userId").addEventListener("input", () => {
		  isIdChecked = false;
		  document.getElementById("checkResult").innerText = ""; // 결과 초기화
		});
    }


  // 비밀번호 일치 확인
document.addEventListener("DOMContentLoaded", function () {
  const params = new URLSearchParams(window.location.search);
  const social = params.get("social");

  // social 파라미터가 없을 때만 비밀번호 확인 로직 실행
  if (!social) {
	  const passwordInput = document.getElementById("password");
	  const confirmPasswordInput = document.getElementById("confirmPassword");
	  const pwCheckMsg = document.getElementById("pwCheckMsg");
	  const pwCheck = document.getElementById("pwCheck");

	  function validatePasswords() {
	    const pw = passwordInput.value;
	    const confirmPw = confirmPasswordInput.value;
	    const regex = /^(?=.*[!@#$%^&*(),.?":{}|<>]).{4,16}$/;

	    if (pw === "") {
	        pwCheck.textContent = "";        // ← 이 부분 추가!
	        pwCheck.className = "";
	      pwCheckMsg.textContent = "";
	      pwCheckMsg.className = "";
	      isPwdChecked = false;
	      return;
	    }

	    if (!regex.test(pw)) {
	    	pwCheck.textContent = "4자 이상 16자 이하이며, 특수문자 1개 이상을 포함";
	    	pwCheck.className = "not-match";
	      isPwdChecked = false;
	      return;
	    } else{
	    	pwCheck.textContent = "조건에 맞는 비밀번호입니다!";
	    	pwCheck.className = "match";
	    	 isPwdChecked = false;
	    }
	    

	    if (pw !== confirmPw) {
	    	if(confirmPw === ""){
		  	      pwCheckMsg.textContent = "";
			      pwCheckMsg.className = "";
			      isPwdChecked = false;
			      return;
	    	}
	      pwCheckMsg.textContent = "비밀번호가 일치하지 않습니다.";
	      pwCheckMsg.className = "not-match";
	      isPwdChecked = false;
	      return;
	    } else {
	      pwCheckMsg.textContent = "비밀번호가 일치합니다.";
	      pwCheckMsg.className = "match";
	      isPwdChecked = true;
	      return;
	    }
	    
	  }

	  passwordInput.addEventListener("input", validatePasswords);
	  confirmPasswordInput.addEventListener("input", validatePasswords);
  }
});
  
  

  // 다음 주소 검색 API
  function execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function(data) {
        document.getElementById("zipcode").value = data.zonecode;
        document.getElementById("address1").value = data.roadAddress;
        document.getElementById("address2").focus();
      }
    }).open();
  }

  function handleEmailSubmit() {
	  const params = new URLSearchParams(window.location.search);
	  const social = params.get("social");
	  
	  if (social) return true; // 소셜이면 그냥 통과

	  const emailId = document.getElementById("emailId").value.trim();
	  const emailDomain = document.getElementById("emailDomain").value.trim();

	  if (emailId && emailDomain) {
	    document.getElementById("email").value = emailId + "@" + emailDomain;
	  } else {
	    document.getElementById("email").value = null;
	  }

	  return true;
	}

  
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
		    document.getElementById("sendCodeBtn").style.display = "none";
		    document.getElementById("authBox").style.display = "block";
		    
		    fetch("sendSMS.jsp", {
		      method: "POST",
		      headers: { "Content-Type": "application/x-www-form-urlencoded" },
		      body: new URLSearchParams({ purpose: "SIGNUP_PHONE", phone: p })
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
	    const p = document.getElementById('phone1').value.trim()
	            + document.getElementById('phone2').value.trim()
	            + document.getElementById('phone3').value.trim();
		 fetch("verifyCode.jsp", {
		    method: "POST",
		    headers: { "Content-Type": "application/x-www-form-urlencoded" },
		    body: new URLSearchParams({ purpose: "SIGNUP_PHONE", recipient: p, code: writeCode })
		 })
		    .then(res => res.json())
		    .then(data => {
		      if (data.result === "success") {
		        alert("확인되었습니다.");
		        isPhoneChecked = true;
			    document.getElementById("otpGrant").value = data.otpGrant;
			    document.getElementById("authBox").style.display = "none";
			    document.getElementById("phone2").readOnly = true;
			    document.getElementById("phone3").readOnly = true;
		      } else {
		        alert("인증번호가 틀렸습니다.");
		        isPhoneChecked = false;
		      }
		    })
		    .catch(() => { alert("인증번호가 틀렸습니다."); isPhoneChecked = false; });
	}

	  // 숫자만 입력되게
	  ['phone2', 'phone3', 'authCode'].forEach(id => {
	    document.getElementById(id).addEventListener('input', (e) => {
	      e.target.value = e.target.value.replace(/[^0-9]/g, '');
	    });
	  });

	  // 번호를 바꾸면 이전 본인확인 결과는 무효다(서버도 recipient 로 다시 검증한다).
	  ['phone2', 'phone3'].forEach(id => {
	    document.getElementById(id).addEventListener('input', () => {
	      isPhoneChecked = false;
	      document.getElementById("otpGrant").value = "";
	    });
	  });


  
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
  
  
  /* 약관 전체 동의 */
  document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("checkAll").addEventListener("change", function () {
      const isChecked = this.checked;
      const termCheckboxes = document.querySelectorAll(".term-check");
      termCheckboxes.forEach(cb => {
        cb.checked = isChecked;
      });
    });

    const termCheckboxes = document.querySelectorAll(".term-check");
    termCheckboxes.forEach(cb => {
      cb.addEventListener("change", function () {
        const allChecked = Array.from(termCheckboxes).every(checkbox => checkbox.checked);
        document.getElementById("checkAll").checked = allChecked;
      });
    });
  });
  
  
  /* 모달 영역 */
    document.addEventListener("DOMContentLoaded", function () {
    const modalTriggers = document.querySelectorAll(".open-modal");
    const closeButtons = document.querySelectorAll(".close-btn");

    modalTriggers.forEach(trigger => {
      trigger.addEventListener("click", function (e) {
        e.preventDefault();
        const modalId = this.getAttribute("data-target");
        document.getElementById(modalId).style.display = "block";
      });
    });

    closeButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        this.closest(".modal").style.display = "none";
      });
    });

    window.addEventListener("click", function (e) {
      if (e.target.classList.contains("modal")) {
        e.target.style.display = "none";
      }
    });
  });

</script>

</body>
</html>
