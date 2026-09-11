<!-- admin_order_delivery.jsp --> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminDeliveryDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>배송 상태 변경 | everyWEAR</title> 
  <link rel="icon" type="image/png" href="images/fav-icon.png">
  <link rel="stylesheet" href="css/admin_order.css">
  <style>
    /* 모달 스타일 */
    .order-modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.5);
    }
    
    #orderModalContent {
      background-color: #fff;
      margin: 5% auto;
      padding: 20px;
      width: 80%;
      max-width: 900px;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      max-height: 85vh;
      overflow-y: auto;
      position: relative;
    }
    
    .modal-close {
      position: absolute;
      top: 15px;
      right: 20px;
      font-size: 28px;
      font-weight: bold;
      cursor: pointer;
      color: #aaa;
    }
    
    .modal-close:hover {
      color: #333;
    }
    
    /* 모달 내부 스타일 */
    .modal-container {
      padding: 0;
      box-shadow: none;
      max-height: none;
      overflow: visible;
      margin: 0;
      width: 100%;
    }
    
    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #ddd;
      padding-bottom: 15px;
      margin-bottom: 20px;
    }
    
    .modal-header h1 {
      margin: 0;
      font-size: 24px;
      color: #0a2963;
    }
    
    .close-btn {
      display: none; /* 중복 닫기 버튼 숨김 */
    }
    
    .info-section {
      margin-bottom: 25px;
      border: 1px solid #eee;
      padding: 15px;
      border-radius: 6px;
      background-color: #f9f9f9;
    }
    
    .info-section h2 {
      margin-top: 0;
      margin-bottom: 15px;
      font-size: 18px;
      color: #0a2963;
    }
    
    .info-row {
      display: flex;
      margin-bottom: 8px;
      border-bottom: 1px solid #eee;
      padding-bottom: 8px;
    }
    
    .info-row:last-child {
      margin-bottom: 0;
      border-bottom: none;
    }
    
    .info-label {
      width: 120px;
      font-weight: bold;
      color: #555;
    }
    
    .info-value {
      flex: 1;
    }
    
    .status-badge {
      display: inline-block;
      padding: 3px 8px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 500;
      color: white;
    }
    
    .status-preparing {
      background-color: #3498db;
    }
    
    .status-shipping {
      background-color: #e67e22;
    }
    
    .status-delivered {
      background-color: #2ecc71;
    }
    
    .status-pay-complete {
      background-color: #2ecc71;
    }
    
    .status-refund {
      background-color: #e74c3c;
    }
    
    /* 페이지네이션 스타일 개선 */
    .pagination-container {
      margin-top: 20px;
      margin-bottom: 15px;
      display: flex;
      justify-content: center;
    }
    
    .pagination {
      display: flex;
      list-style: none;
      padding: 0;
      margin: 0;
      text-align: center;
    }
    
    .pagination a, 
    .pagination span.disabled {
      display: inline-block;
      padding: 5px 10px;
      margin: 0 3px;
      border: 1px solid #ddd;
      color: #666;
      text-decoration: none;
      font-size: 13px;
      transition: all 0.2s ease;
      text-align: center;
      background-color: white;
    }
    
    .pagination a:hover {
      background-color: #f0f0f0;
    }
    
    .pagination a.active {
      background-color: #1e3a5f;
      color: white;
      border-color: #1e3a5f;
      font-weight: normal;
    }
    
    .pagination .disabled {
      color: #ccc;
      background-color: #fafafa;
      cursor: not-allowed;
      border-color: #eee;
    }
    
    /* 테이블 스타일 수정 - 공지사항 테이블 스타일 적용 */
    .order-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      margin-bottom: 0;
      font-size: 13px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      border-radius: 8px;
      overflow: hidden;
      background-color: white;
    }
    
    .order-table th {
      background-color: #f5f5f5;
      font-size: 13px;
      font-weight: 600;
      color: #333;
      text-align: center;
      padding: 12px 8px;
      border-bottom: 2px solid #ddd;
    }
    
    .order-table td {
      font-size: 13px;
      padding: 12px 8px;
      text-align: center;
      border-bottom: 1px solid #e0e0e0;
    }
    
    .order-table tbody tr:hover {
      background-color: #f5f7fa;
    }
    
    .order-table .text-left {
      text-align: left;
    }
    
    /* 체크박스 스타일 */
    .check-item, #check-all {
      width: 16px;
      height: 16px;
      cursor: pointer;
      accent-color: #1e3a5f;
    }
    
    /* 상태 선택 드롭다운 */
    .status-select {
      font-size: 12px;
      padding: 6px;
      border: 1px solid #ddd;
      border-radius: 4px;
      width: 100%;
      max-width: 110px;
    }
    
    /* 테이블 액션 영역 마진 조정 */
    .order-actions {
      margin-bottom: 10px;
    }
    
    /* 컨테이너 패딩 조정 */
    .container {
      padding-bottom: 20px;
    }
    
    /* 버튼 스타일 개선 */
    .btn-detail {
      background-color: #e8eef9;
      color: #0a2963;
      padding: 6px 10px;
      border: none;
      border-radius: 4px;
      font-size: 12px;
      transition: all 0.2s;
    }
    
    .btn-detail:hover {
      background-color: #d1e0f6;
    }
    
    /* 총 배송 건수 스타일 */
    .total-count {
      margin-bottom: 15px;
      color: #333;
      font-size: 14px;
    }
    
    .total-count strong {
      color: #0a2963;
      font-weight: bold;
      font-size: 16px;
    }
    
    /* 필터 그룹 스타일 */
    .filter-group {
      margin-top: 15px;
      margin-bottom: 20px;
    }
    
    /* 간격 조정을 위한 공백 div */
    .spacer {
      height: 15px;
    }
  </style>
</head>
<body>
<jsp:include page="includes/admin_header.jsp" />
<jsp:include page="includes/admin_styles.jsp" />
<main>
  <div class="container">
<%
// 페이징 변수 설정
int pageSize = 10; // 한 페이지에 표시할 배송 정보 수
int currentPage = 1;
if (request.getParameter("page") != null) {
    currentPage = Integer.parseInt(request.getParameter("page"));
}
int start = (currentPage - 1) * pageSize;

// 검색 파라미터
String searchTrackingNum = request.getParameter("trackingNum");
String statusFilter = request.getParameter("status");
String sortOrder = request.getParameter("sort") != null ? request.getParameter("sort") : "latest";

// DAO 객체 생성
AdminDeliveryDAO deliveryDAO = new AdminDeliveryDAO();
List<Map<String, Object>> deliveryList = null;
int totalDeliveries = 0;

// 검색 조건에 따라 다른 메소드 호출
if (searchTrackingNum != null && !searchTrackingNum.isEmpty()) {
    deliveryList = deliveryDAO.searchDeliveryByTrackingNumber(searchTrackingNum);
    totalDeliveries = deliveryList.size();
} else if (statusFilter != null && !statusFilter.equals("all") && !statusFilter.isEmpty()) {
    String statusValue = "";
    if ("ready".equals(statusFilter)) statusValue = "배송준비중";
    else if ("shipping".equals(statusFilter)) statusValue = "배송중";
    else if ("delivered".equals(statusFilter)) statusValue = "배송완료";
    
    deliveryList = deliveryDAO.getDeliveryListByStatus(statusValue);
    totalDeliveries = deliveryList.size();
} else {
    deliveryList = deliveryDAO.getDeliveryList(start, pageSize);
    totalDeliveries = deliveryDAO.getTotalDeliveryCount();
}

// 날짜 포맷 설정
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

// 메시지 처리
String message = request.getParameter("message");
%>

<div class="order-header">
  <h2>배송 상태 변경</h2>
  
<% if (message != null && !message.isEmpty()) { %>
  <div class="alert <%= message.contains("실패") || message.contains("오류가") ? "alert-danger" : "alert-success" %>">
    <%= message.contains("실패") || message.contains("오류가") ? "<strong>오류!</strong> " : "<strong>성공!</strong> " %><%= message %>
  </div>
<% } %>
</div>

<!-- 테이블 상단 영역 -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; margin-top: 20px;">
  <!-- 총 배송 건수 표시 -->
  <div class="total-count" style="margin: 0;">
    총 <strong><%= totalDeliveries %></strong>개의 배송 정보가 있습니다.
  </div>
  
  <!-- 검색 필터 -->
  <div class="filter-group" style="margin: 0;">
    <form action="admin_order_delivery.jsp" method="get" id="searchForm" class="search-form">
      <select class="custom-select" id="status-filter" name="status">
        <option value="all" <%= statusFilter == null || statusFilter.equals("all") ? "selected" : "" %>>전체</option>
        <option value="ready" <%= "ready".equals(statusFilter) ? "selected" : "" %>>배송준비중</option>
        <option value="shipping" <%= "shipping".equals(statusFilter) ? "selected" : "" %>>배송중</option>
        <option value="delivered" <%= "delivered".equals(statusFilter) ? "selected" : "" %>>배송완료</option>
      </select>
      
      <input type="text" id="search-input" name="trackingNum" placeholder="송장번호 입력" class="search-input" value="<%= searchTrackingNum != null ? searchTrackingNum : "" %>">
      <button type="submit" class="btn btn-primary">검색</button>
    </form>
    <div>
      <button type="button" class="btn" onclick="location.href='admin_order_delivery.jsp'">초기화</button>
    </div>
  </div>
</div>

<form action="admin_update_delivery_status.jsp" method="post" id="deliveryStatusForm">
<input type="hidden" name="adminCsrfToken" value="<%= session.getAttribute("adminCsrfToken") %>">
<input type="hidden" name="bulkUpdate" id="bulkUpdate" value="false">
<input type="hidden" name="bulkStatus" id="bulkStatus" value="">

<table class="order-table">
<thead>
  <tr>
    <th><input type="checkbox" id="check-all" title="전체 선택"></th>
    <th>주문번호</th>
    <th>주문자명</th>
    <th>수령인명</th>
    <th>배송주소</th>
    <th>송장번호</th>
    <th>택배사명</th>
    <th>배송상태</th>
    <th>배송시작일</th>
    <th>배송완료일</th>
    <th>배송메모</th>
    <th>상세보기</th>
  </tr>
</thead>
<tbody>
<% 
if (deliveryList != null && !deliveryList.isEmpty()) {
    int rowNum = 1;
    for (Map<String, Object> delivery : deliveryList) {
        String dStatus = (String)delivery.get("d_status");
        String statusValue = "";
        if ("배송준비중".equals(dStatus)) statusValue = "ready";
        else if ("배송중".equals(dStatus)) statusValue = "shipping";
        else if ("배송완료".equals(dStatus)) statusValue = "delivered";
%>
  <tr>
	  <td><input type="checkbox" class="check-item" name="deliveryIds" value="<%= delivery.get("d_id") %>">
	    <input type="hidden" name="order_<%= delivery.get("d_id") %>" value="<%= delivery.get("o_id") %>"></td>
	  <td><%= delivery.get("o_num") %></td>
	  <td><%= delivery.get("o_name") %></td>
	  <td><%= delivery.get("recv_name") %></td>
	  <td class="text-left">
	    (<%= delivery.get("recv_zipcode") %>)<br>
	    <%= delivery.get("recv_addr_road") %><br>
	    <%= delivery.get("recv_addr_detail") %>
	  </td>
	  <td><%= delivery.get("d_tracking_num") != null ? delivery.get("d_tracking_num") : "-" %></td>
	  <td><%= delivery.get("d_courier") != null ? delivery.get("d_courier") : "-" %></td>
	  <td>
		  <select class="status-select" name="status_<%= delivery.get("d_id") %>" data-delivery-id="<%= delivery.get("d_id") %>">
		    <option value="배송준비중" <%= "배송준비중".equals(dStatus) ? "selected" : "" %>>배송준비중</option>
		    <option value="배송중" <%= "배송중".equals(dStatus) ? "selected" : "" %>>배송중</option>
		    <option value="배송완료" <%= "배송완료".equals(dStatus) ? "selected" : "" %>>배송완료</option>
		  </select>
		</td>
	  <td><%= delivery.get("started_at") != null ? sdf.format(delivery.get("started_at")) : "-" %></td>
	  <td><%= delivery.get("completed_at") != null ? sdf.format(delivery.get("completed_at")) : "-" %></td>
	  <td><%= delivery.get("d_memo") != null ? delivery.get("d_memo") : "-" %></td>
	  <td>
	    <button type="button" class="btn btn-sm btn-detail order-detail-btn" data-order-id="<%= delivery.get("o_id") %>">상세보기</button>
	  </td>
	</tr>
<%
        rowNum++;
    }
} else {
%>
  <tr>
    <td colspan="12" class="text-center">배송 정보가 없습니다.</td>
  </tr>
<%
}
%>
</tbody>
</table>

<!-- 테이블 액션 영역 -->
<div class="order-actions" style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
  <div>
    <button type="button" class="btn btn-sm" onclick="clearSelection()">선택 해제</button>
    <div class="bulk-action-info" id="bulk-selection-info" style="display: none; margin-top: 5px;">
      <span id="selected-count">0</span>개 항목 선택됨
    </div>
  </div>
  <div>
    <button type="submit" class="btn btn-primary" id="submitBtn">상태 변경 저장</button>
  </div>
</div>

<!-- 페이지네이션 -->
<div class="pagination-container">
  <div class="pagination" id="pagination">
    <% if (currentPage > 1) { %>
      <a href="admin_order_delivery.jsp?page=1<%= statusFilter != null ? "&status=" + statusFilter : "" %><%= searchTrackingNum != null ? "&trackingNum=" + searchTrackingNum : "" %>">처음</a>
      <a href="admin_order_delivery.jsp?page=<%= currentPage - 1 %><%= statusFilter != null ? "&status=" + statusFilter : "" %><%= searchTrackingNum != null ? "&trackingNum=" + searchTrackingNum : "" %>">이전</a>
    <% } else { %>
      <span class="disabled">처음</span>
      <span class="disabled">이전</span>
    <% } %>
    
    <%
    int totalPages = (int) Math.ceil((double) totalDeliveries / pageSize);
    int startPage = Math.max(1, currentPage - 2);
    int endPage = Math.min(totalPages, startPage + 4);
    
    for (int i = startPage; i <= endPage; i++) {
    %>
    <a href="admin_order_delivery.jsp?page=<%= i %><%= statusFilter != null ? "&status=" + statusFilter : "" %><%= searchTrackingNum != null ? "&trackingNum=" + searchTrackingNum : "" %>" 
       class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
    <% } %>
    
    <% if (currentPage < totalPages) { %>
      <a href="admin_order_delivery.jsp?page=<%= currentPage + 1 %><%= statusFilter != null ? "&status=" + statusFilter : "" %><%= searchTrackingNum != null ? "&trackingNum=" + searchTrackingNum : "" %>">다음</a>
      <a href="admin_order_delivery.jsp?page=<%= totalPages %><%= statusFilter != null ? "&status=" + statusFilter : "" %><%= searchTrackingNum != null ? "&trackingNum=" + searchTrackingNum : "" %>">마지막</a>
    <% } else { %>
      <span class="disabled">다음</span>
      <span class="disabled">마지막</span>
    <% } %>
  </div>
</div>
</form>

  </div>
</main>

<!-- 주문 상세 정보 모달 -->
<div id="orderModal" class="order-modal">
  <div id="orderModalContent">
    <!-- 모달 내용은 AJAX로 로드됨 -->
  </div>
</div>

<script>
  // 상단 체크박스를 클릭하면 모든 하위 체크박스 토글
  document.getElementById("check-all").addEventListener("change", function () {
    const isChecked = this.checked;
    const checkboxes = document.querySelectorAll(".check-item");
    checkboxes.forEach(cb => cb.checked = isChecked);
    updateSelectionInfo();
  });
  
  // 개별 체크박스 선택 시 선택 정보 업데이트
  document.addEventListener('DOMContentLoaded', function() {
    const checkboxes = document.querySelectorAll(".check-item");
    checkboxes.forEach(cb => {
      cb.addEventListener('change', updateSelectionInfo);
    });
    
    // 초기 선택 정보 업데이트
    updateSelectionInfo();
    
    // 폼 제출 이벤트 처리
    const deliveryForm = document.getElementById('deliveryStatusForm');
    const submitBtn = document.getElementById('submitBtn');
    
    submitBtn.addEventListener('click', function(e) {
      e.preventDefault();
      if (validateForm()) {
        deliveryForm.submit();
      }
    });
  });
  
  // 선택된 항목 수 표시 업데이트
  function updateSelectionInfo() {
    const checkedBoxes = document.querySelectorAll(".check-item:checked");
    const selectionInfo = document.getElementById('bulk-selection-info');
    const selectedCount = document.getElementById('selected-count');
    
    if (checkedBoxes.length > 0) {
      selectedCount.textContent = checkedBoxes.length;
      selectionInfo.style.display = 'block';
    } else {
      selectionInfo.style.display = 'none';
    }
  }
  
  // 선택 해제 함수
  function clearSelection() {
    const checkboxes = document.querySelectorAll(".check-item");
    checkboxes.forEach(cb => cb.checked = false);
    document.getElementById("check-all").checked = false;
    updateSelectionInfo();
  }
  
  // 폼 유효성 검사
  function validateForm() {
    const checkedBoxes = document.querySelectorAll(".check-item:checked");
    if (checkedBoxes.length === 0) {
      // 체크된 항목이 없으면 개별 상태 변경 모드로 저장
      document.getElementById("bulkUpdate").value = "false";
      return true;
    } else {
      // 일괄 변경 모드 확인
      const checkedValue = confirm("선택한 " + checkedBoxes.length + "개 항목의 배송 상태를 일괄 변경하시겠습니까?");
      if (checkedValue) {
        // 일괄 상태 선택
        const status = prompt("변경할 상태를 입력하세요 (배송준비중, 배송중, 배송완료)", "배송준비중");
        if (status === null || status === "") {
          return false;
        }
        
        if (status !== "배송준비중" && status !== "배송중" && status !== "배송완료") {
          alert("잘못된 상태값입니다. '배송준비중', '배송중', '배송완료' 중 하나를 입력해주세요.");
          return false;
        }
        
        document.getElementById("bulkUpdate").value = "true";
        document.getElementById("bulkStatus").value = status;
        return true;
      }
      return false;
    }
  }
  
  // 검색 입력창 포커스 관련
  const searchInput = document.getElementById("search-input");
  const defaultPlaceholder = "송장번호 입력";

  searchInput.addEventListener("focus", function () {
    this.setAttribute("placeholder", "");
  });

  searchInput.addEventListener("blur", function () {
    if (this.value.trim() === "") {
      this.setAttribute("placeholder", defaultPlaceholder);
    }
  });
  
  // 주문 상세정보 모달 열기
  function openOrderModal(orderId) {
    var modal = document.getElementById('orderModal');
    var modalContent = document.getElementById('orderModalContent');
    
    // 모달 로딩 중 표시
    modalContent.innerHTML = '<div style="text-align: center; padding: 50px;"><p>로딩 중...</p></div>';
    modal.style.display = 'block';
    
    // AJAX 요청
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          modalContent.innerHTML = xhr.responseText + '<span class="modal-close" onclick="closeOrderModal()">&times;</span>';
        } else {
          modalContent.innerHTML = '<div style="text-align: center; padding: 50px;"><p>오류가 발생했습니다</p></div><span class="modal-close" onclick="closeOrderModal()">&times;</span>';
        }
      }
    };
    xhr.open('GET', 'admin_order_modal.jsp?o_id=' + orderId, true);
    xhr.send();
  }
  
  // 주문 상세정보 모달 닫기
  function closeOrderModal() {
    document.getElementById('orderModal').style.display = 'none';
  }
  
  // 상세보기 버튼에 클릭 이벤트 리스너 추가
  document.addEventListener('DOMContentLoaded', function() {
    var buttons = document.querySelectorAll('.order-detail-btn');
    
    for(var i = 0; i < buttons.length; i++) {
      buttons[i].addEventListener('click', function() {
        var orderId = this.getAttribute('data-order-id');
        openOrderModal(orderId);
      });
    }
  });
  
  // 모달 외부 클릭 시 닫기
  window.onclick = function(event) {
    var modal = document.getElementById('orderModal');
    if (event.target == modal) {
      modal.style.display = 'none';
    }
  };
</script>

</body>
</html>