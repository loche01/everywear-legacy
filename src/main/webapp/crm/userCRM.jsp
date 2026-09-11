<!-- userCRM.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DTO.CRMUserInfoDTO"%>
<%
String user_id = request.getParameter("user_id");
String user_type = request.getParameter("user_type");

UserDAO dao = new UserDAO();
CRMUserInfoDTO crm = dao.getCRMUserInfo(user_id, user_type);

String rank = crm.getUser().getUser_rank();
String rankClass = "";

switch (rank) {
	case "그린" :
		rankClass = "rank-green";
		break;
	case "오렌지" :
		rankClass = "rank-orange";
		break;
	case "퍼플" :
		rankClass = "rank-purple";
		break;
	case "에메랄드" :
		rankClass = "rank-emerald";
		break;
	case "블랙" :
		rankClass = "rank-black";
		break;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CRM - 고객 상세 관리</title>
<link rel="stylesheet" href="CRM.css/userCRM.css">
<script>

// 비밀번호 ↔ 비밀번호 확인 일치검사 메소드로 detail.jsp에서 호출해서 사용함
function setupPasswordCheck() {
  const pw = document.getElementById("password");
  const confirm = document.getElementById("confirmPassword");
  const msg = document.getElementById("pwCheckMsg");

  if (!pw || !confirm || !msg) return;

  function check() {
    const a = pw.value;
    const b = confirm.value;

    if (!a && !b) {
      msg.textContent = "";
      msg.className = "";
    } else if (a === b) {
      msg.textContent = "비밀번호가 일치합니다.";
      msg.className = "match";
    } else {
      msg.textContent = "비밀번호가 일치하지 않습니다.";
      msg.className = "not-match";
    }
  }

  pw.addEventListener("input", check);
  confirm.addEventListener("input", check);
}

function setupAccountStateSync() {
	  const stateSelect = document.getElementById("accountState");
	  const lockSelect = document.getElementById("lockState");

	  if (!stateSelect || !lockSelect) return;

	  stateSelect.addEventListener("change", function () {
	    const selected = stateSelect.value.trim();

	    if (selected === "정상") {
	      lockSelect.value = "N";
	    } else {
	      lockSelect.value = "Y";
	    }
	  });
	}
	
// 생년월일 빡센 유효성 검사
function setupBirthValidation() {
	  const birthY = document.getElementById("birth_y");
	  const birthM = document.getElementById("birth_m");
	  const birthD = document.getElementById("birth_d");

	  function resetBirth() {
	    birthY.value = "";
	    birthM.value = "";
	    birthD.value = "";
	  }

	  function isLeapYear(year) {
	    return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
	  }

	  function validateDate() {
		  const y = parseInt(birthY.value, 10);
		  const m = parseInt(birthM.value, 10);
		  const d = parseInt(birthD.value, 10);

		  if (!birthY.value || !birthM.value || !birthD.value) return;

		  if (isNaN(y) || isNaN(m) || isNaN(d)) {
		    alert("숫자만 입력해주세요.");
		    resetBirth();
		    return;
		  }

		  const today = new Date();
		  const currentYear = today.getFullYear();

		  if (y < 1900 || y > currentYear) {
		    alert("연도는 1900년부터 "+currentYear+"년까지 입력 가능합니다.");
		    resetBirth();
		    return;
		  }

		  if (m < 1 || m > 12) {
		    alert("월은 1~12 사이의 숫자여야 합니다.");
		    resetBirth();
		    return;
		  }

		  const daysInMonth = [31, isLeapYear(y) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

		  if (d < 1 || d > daysInMonth[m - 1]) {
		    alert(y+"년 "+m+"월은 "+daysInMonth[m - 1]+"일까지 있습니다.");
		    resetBirth();
		    return;
		  }

		  // 👇 오늘 이후 날짜면 안 됨
		  const inputDate = new Date(y, m - 1, d); // JS는 월이 0부터 시작
		  const now = new Date();

		  if (inputDate > now) {
		    alert("생년월일은 오늘 이전 날짜까지만 입력 가능합니다.");
		    resetBirth();
		    return;
		  }
		}

	  // 각 칸에서 다른 칸으로 포커스를 이동할 때 validate
	  birthY.addEventListener("blur", validateDate);
	  birthM.addEventListener("blur", validateDate);
	  birthD.addEventListener("blur", validateDate);
	}



function loadTab(tab) {
	  const contentArea = document.getElementById("content-area");
	  let url = "";

	  // 탭에 따라 URL 및 클래스 다르게 설정
	  if (tab === 'basic') {
	    url = `basic.jsp?user_id=<%=user_id%>&user_type=<%=user_type%>`;
	    contentArea.className = "crm-content";  // ✅ 기본 구조 유지
	  } else if (tab === 'detail') {
	    url = `detail.jsp?user_id=<%=user_id%>&user_type=<%=user_type%>`;
	    contentArea.className = "detail-content";  // ✅ 회원 정보 수정 탭 전용 클래스
	  } else if (tab === 'delivery') {
	    url = `delivery.jsp?user_id=<%=user_id%>&user_type=<%=user_type%>`;
	    contentArea.className = "delivery-content";  // ✅ 배송지 탭 전용 클래스
	  } else if (tab === 'post') {
		  url = `post.jsp?user_id=<%=user_id%>&user_type=<%=user_type%>`;
		  contentArea.className = "post-content";
	  } else {
	    url = ""; // 기타 탭 미구현
	  }

	  if (!url) return;

	  fetch(url)
	    .then(res => res.text())
	    .then(html => {
	      contentArea.innerHTML = html;

	      // detail.jsp만 로딩 시 스크립트 후처리
	      if (tab === 'detail') {
	        setTimeout(() => {
	          setupPasswordCheck();
	          setupAccountStateSync();
	          setupBirthValidation();
	        }, 100);
	      }
	    });
	}



window.onload = function () {
	  const urlParams = new URLSearchParams(window.location.search);
	  const tab = urlParams.get("tab") || "basic";
	  loadTab(tab);
	}


//배송지 삭제 - deliveryDelete.jsp 는 POST + 관리자 CSRF 전용이므로 delivery.jsp 가 렌더한 form 을 제출한다.
function deleteAddr(addrId) {
  if (confirm("배송지를 삭제하시겠습니까?")) {
    var form = document.getElementById("deliveryDeleteForm_" + addrId);
    if (form) {
      form.submit();
    }
  }
}

// 배송지 수정 팝업 - 화면 정중앙에 열기
function openModifyPopup(addrId) {
  var width = 550;
  var height = 410;
  var left = (screen.width - width) / 2;
  var top = (screen.height - height) / 2;

  var url = "deliveryModify.jsp?addr_id=" + addrId + 
            "&user_id=" + "<%=user_id%>" + 
            "&user_type=" + "<%=user_type%>";
  var option = "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top;

  window.open(url, "deliveryModify", option);
}



// 배송지 추가 팝업 - 화면 정중앙에 열기
function openAddPopup() {
  const width = 550;
  const height = 410;
  const left = (screen.width - width) / 2;
  const top = (screen.height - height) / 2;

  const url = "deliveryAdd.jsp?user_id=" + "<%=user_id%>" + "&user_type=" + "<%=user_type%>";
  const option = "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top;

  window.open(url, "deliveryAdd", option);
}

// 회원 게시글 토글 탭
function toggleTab(tabName) {
	  document.getElementById("reviewTab").style.display = (tabName === "review") ? "block" : "none";
	  document.getElementById("inquiryTab").style.display = (tabName === "inquiry") ? "block" : "none";

	  const buttons = document.querySelectorAll(".tab-buttons button");
	  buttons.forEach(btn => btn.classList.remove("active"));
	  if (tabName === "review") buttons[0].classList.add("active");
	  else buttons[1].classList.add("active");
	}

</script>
</head>
<body>
	<div class="crm-header">
		<h2>EVERYWEAR 고객 관리 시스템</h2>
		<button class="close-btn" onclick="window.close()">닫기 ✖</button>
	</div>


	<div class="crm-layout">
		<div class="crm-sidebar">

			<!-- 회원 요약 정보 -->
			<div class="user-summary">
				<div>
					<strong><%=crm.getUser().getUser_name()%></strong> 님
				</div>
				<div>
					등급 : <span class="user-rank <%=rankClass%>"><%=rank%></span>
				</div>
				<div>
					포인트 :
					<%=crm.getUser().getUser_point()%>
					P
				</div>
				<div>
					최종 방문일 :
					<%=crm.getLastLoginDate() != null ? crm.getLastLoginDate() : "-"%>
				</div>
				<div>
					가입일 :
					<%=crm.getUser().getCreated_at()%>
				</div>
			</div>


			<button onclick="loadTab('basic')">CRM 홈</button>
			<button onclick="loadTab('detail')">회원 정보 수정</button>
			<button onclick="loadTab('delivery')">회원 배송지 정보</button>
			<button onclick="loadTab('post')">회원 게시글 정보</button>
			<button onclick="loadTab('')">회원 적립금/쿠폰 정보</button>
			<button onclick="loadTab('')">회원 관심상품 정보</button>
			<button onclick="loadTab('')">회원 로그인 로그</button>
			<!-- 추후 확장: 배송지, 게시글, 포인트 등 -->
		</div>

		<div id="content-area" class="crm-content">
			<!-- AJAX로 탭 내용이 여기에 삽입됨 -->
		</div>
	</div>
</body>
</html>