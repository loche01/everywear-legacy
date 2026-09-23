<%@page import="java.text.DecimalFormat"%>
<%@page import="DTO.UserDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="DTO.UserAddrDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="uDao" class="DAO.UserDAO"/>
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
		UserDTO userDto = uDao.getOneUser(userId, userType);
		int couponCnt = uDao.showOneUserCoupon(userId, userType);
        DecimalFormat formatter = new DecimalFormat("#,###");

        String point = formatter.format(userDto.getUser_point());
		
		UserAddrDTO defaultAddr = uDao.showOneAddr(userId, userType);
		Vector<UserAddrDTO> restAddr = uDao.showRestAddr(userId, userType);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/deliveryMn.css?v=20260918">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section2 class="content2">
	<h3>배송지 관리</h3>
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
		<div id="addrList">
			<% if(defaultAddr != null){ %>
			<div class="address-default">
				<label><strong><%=defaultAddr.getAddr_label()%></strong> <span>기본 배송지</span></label>
				<div class="vede">
					<button type="button" class="modifyBtn" onclick="modifyBtn('<%=defaultAddr.getAddr_label()%>', '<%=defaultAddr.getAddr_zipcode()%>', '<%=defaultAddr.getAddr_road()%>', '<%=defaultAddr.getAddr_detail()%>', '<%=defaultAddr.getAddr_isDefault()%>', '<%=defaultAddr.getAddr_id()%>')">수정</button>
				</div>
			</div>
			<div class="address-default2">
				<p><%=userDto.getUser_name()%> | <%=userDto.getUser_phone()%></p>
				<label><%=defaultAddr.getAddr_road()%>, <%=defaultAddr.getAddr_detail()%> (<%=defaultAddr.getAddr_zipcode()%>)</label>
			</div>
			
		
			<% } else { %>
			<p>등록된 기본 배송지가 없습니다. 배송지를 추가하거나 기존 배송지를 수정하여 기본 배송지로 지정할 수 있습니다.</p>
			<% } %>
			<%for(UserAddrDTO addr : restAddr){ %>
			<hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
			<div class="address-default">
				<label><strong><%=addr.getAddr_label()%></strong></label>
				<div class="vede">
					<button type="button" class="modifyBtn" onclick="modifyBtn('<%=addr.getAddr_label()%>', '<%=addr.getAddr_zipcode()%>', '<%=addr.getAddr_road()%>', '<%=addr.getAddr_detail()%>', '<%=addr.getAddr_isDefault()%>', '<%=addr.getAddr_id()%>')">수정</button>
					<button type="button" class="deleteBtn"  onclick="openModal('<%=addr.getAddr_id()%>')">삭제</button>
				</div>
			</div>
			<div class="address-default2">
				<p><%=userDto.getUser_name()%> | <%=userDto.getUser_phone()%></p>
				<label><%=addr.getAddr_road()%>, <%=addr.getAddr_detail()%> (<%=addr.getAddr_zipcode()%>)</label>
			</div>
		
			<%} %>
		</div>
		
		
			<!-- 배송지 관리 본문 시작 -->
			<div id="writeAddr" class="order-content" style="display: none">
				<form action="addAddr" method="post" id="add">
<input type="hidden" name="userCsrfToken" value="<%=Security.UserRequestGuard.token(session)%>">
					<!-- 기본 배송지 -->
					<div class="delivery-box">
						<p>배송지명</p>
						<input type="text" class="addrLabel" id="addrLabel" name="addrLabel" placeholder="예) 우리집">
					
						<p>배송지</p>
						<div class="delivery-inputs">
							<input type="text" id="zipcode" class="input-zipcode" name="zipcode" placeholder="우편 번호" readonly>
							<button type="button" id="searchAddressBtn" class="btn-search">주소 검색</button>
						</div>
						<div class="delivery-inputs">
						<input type="text" id="address1" class="input-full" name="address1" placeholder="주소" readonly> 
						</div>
						<div class="delivery-inputs">
						<input type="text" id="address2" class="input-full" name="address2" placeholder="상세주소 입력">
						</div>
						
						<label class="circle-checkbox" id="circle-checkbox">
						  <input type="checkbox" id="idDefault" name="isDefault">
						  <span class="checkmark">
						    <i class="check-icon">✔</i>
						  </span>
						  기본 배송지 지정
						</label>
	
					</div>
					<input type="hidden" id="addrId" name="addrId">
				</form>
			</div>

			
			<div class="add-btn-container">
				<button type="button" onclick="addAddrBtn()" id="addAddr">배송지 추가</button>
			</div>
			
		</section>
	</div>
	
	<div id="deleteModal" class="modal">
	  <div class="modal-content">
	    <p><strong>배송지를 삭제하시겠습니까?</strong></p>
	    <div class="buttons">
	      <button type="button" class="cancel" onclick="closeModal()">취소</button>
	      <button type="button" class="delete" id="delete" onclick="deleteAddr()">삭제하기</button>
	    </div>
	  </div>
	</div>
	
	<form action="deleteAddr" method="post" id="deleteAddr">
<input type="hidden" name="userCsrfToken" value="<%=Security.UserRequestGuard.token(session)%>">
		<input type="hidden" id="hiddenAddrId" name="hiddenAddrId">
	</form>

	<!-- Daum 주소 API -->
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<script>
	function addAddrBtn(){
		document.getElementById("addrList").style.display = "none";
		document.getElementById("writeAddr").style.display = "block";
		document.getElementById("addAddr").onclick = addAddr;
	}
	
	function addAddr(){
		const label = document.getElementById("addrLabel");
		const zipcode = document.getElementById("zipcode");
		const addr1 = document.getElementById("address1");
		const addr2 = document.getElementById("address2");
		
		if(!zipcode.value){
			alert("주소를 선택해주세요.");
			zipcode.focus();
			return;
		}
		
		document.getElementById("add").submit();
	}
	
	function modifyBtn(label, zipcode, road, detail, isDefault, addrId){
		document.getElementById("addrList").style.display = "none";
		document.getElementById("writeAddr").style.display = "block";
		document.getElementById("addAddr").innerText = "배송지 수정";
		document.getElementById("add").action = "modifyAddr";
		document.getElementById("addAddr").onclick = addAddr;
		
		document.getElementById("addrLabel").value = label;
		document.getElementById("zipcode").value = zipcode;
		document.getElementById("address1").value = road;
		document.getElementById("address2").value = detail;
		document.getElementById("addrId").value = addrId;
		
		if(isDefault === 'Y'){
			document.getElementById("idDefault").checked = true;
			document.getElementById("circle-checkbox").style.display = "none";
		}

	}
	
	  function openModal(id) {
		  event.preventDefault();
		    document.getElementById("deleteModal").style.display = "flex";
		    document.getElementById("hiddenAddrId").value = id;
		  }

		  function closeModal() {
		    document.getElementById("deleteModal").style.display = "none";
		  }

		  function deleteAddr() {
			closeModal();
		    document.getElementById("deleteAddr").submit();
		  }
	
  // 기본 배송지 전용 수정
  function enableBasicEdit() {
    document.getElementById('alias').removeAttribute('readonly');
    document.getElementById('zipcode').removeAttribute('readonly');
    document.getElementById('address1').removeAttribute('readonly');
    document.getElementById('address2').removeAttribute('readonly');
    document.getElementById('searchAddressBtn').disabled = false;
  }

  // 다른 배송지용 수정
  function enableEdit(btn) {
  	const box = btn.closest('.delivery-box');
    const inputs = box.querySelectorAll('input');
    const searchBtn = box.querySelector('.btn-search');

    inputs.forEach(input => input.removeAttribute('readonly'));
    if (searchBtn) searchBtn.disabled = false;
  }

  // 주소 검색 기능 (다음 API)
  function openPostcode(zipcodeInput, address1Input, address2Input) {
    new daum.Postcode({
      oncomplete: function(data) {
        zipcodeInput.value = data.zonecode;
        address1Input.value = data.roadAddress;
        address2Input.focus();
      }
    }).open();
  }

  // 삭제 버튼 기능
  function deleteAddress(btn) {
    const box = btn.closest('.delivery-box');
    if (confirm("정말 삭제하시겠습니까?")) {
      box.remove();
    }
  }

  // 라디오 버튼 클릭 시 기본 배송지 승격 기능
  function promoteToDefault(radio) {
    const selectedBox = radio.closest(".delivery-box");
    const defaultContainer = document.getElementById("default-address-container");
    const otherContainer = document.getElementById("other-addresses-container");

    const currentDefault = defaultContainer.querySelector(".delivery-box");

    // 기존 기본 배송지를 다른 배송지로 이동
    if (currentDefault && currentDefault !== selectedBox) {
      const radioInput = currentDefault.querySelector('input[type="radio"]');
      radioInput.checked = false;
      radioInput.setAttribute("onclick", "promoteToDefault(this)");

      // 라벨 수정
      currentDefault.querySelector(".delivery-top label").innerHTML = 
    	  `<input type="radio" name="selected" onclick="promoteToDefault(this)"> 다른 배송지`;

      // 삭제 버튼이 없다면 추가
      const btnGroup = currentDefault.querySelector('.btn-group');
      if (!btnGroup.querySelector('.btn-delete')) {
        const deleteBtn = document.createElement('a');
        deleteBtn.href = "#";
        deleteBtn.className = "btn-delete";
        deleteBtn.textContent = "삭제";
        deleteBtn.setAttribute("onclick", "deleteAddress(this)");
        btnGroup.appendChild(deleteBtn);
      }

      otherContainer.appendChild(currentDefault);
    }

    // 선택한 박스를 기본 배송지로 승격
    radio.checked = true;
    selectedBox.querySelector(".delivery-top label").innerHTML = 
    	`<input type="radio" name="selected" checked> 기본 배송지`;

    // 삭제 버튼 제거
    const deleteBtn = selectedBox.querySelector(".btn-delete");
    if (deleteBtn) deleteBtn.remove();

    defaultContainer.appendChild(selectedBox);
  }

  	// DOMContentLoaded 후 이벤트 등록
 		window.addEventListener('DOMContentLoaded', () => {
    // 모든 주소 검색 버튼에 이벤트 등록
    document.querySelectorAll('.btn-search').forEach(btn => {
      btn.addEventListener('click', function () {
        const box = btn.closest('.delivery-box');
        const zipcode = box.querySelector('.input-zipcode');
        const address1 = box.querySelectorAll('.input-full')[0];
        const address2 = box.querySelectorAll('.input-full')[1];

        openPostcode(zipcode, address1, address2);
      });
    });
  });
	</script>
</body>