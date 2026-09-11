<!-- admin_order_list.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.AdminOrderDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>관리자 - 주문 관리</title>
  <link rel="icon" type="image/png" href="images/fav-icon.png">
  <link rel="stylesheet" href="css/admin_order.css">
  <style>
    body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f8f9fa;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      background-color: #fff;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 {
      color: #333;
      margin-bottom: 20px;
      border-bottom: 2px solid #eee;
      padding-bottom: 10px;
    }
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
      border: 1px solid #e0e0e0;
    }
    .order-table th, .order-table td {
      padding: 12px 8px;
      text-align: center;
      border: 1px solid #e0e0e0;
    }
    .order-table th {
      background-color: #f5f5f5;
      font-size: 13px;
      font-weight: 600;
      color: #333;
    }
    .order-table tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    .order-table tr:hover {
      background-color: #f5f7fa;
    }
    .order-table .text-left {
      text-align: left;
    }
    .btn {
      display: inline-block;
      padding: 6px 12px;
      margin-bottom: 0;
      font-size: 14px;
      font-weight: 400;
      line-height: 1.42857143;
      text-align: center;
      white-space: nowrap;
      vertical-align: middle;
      cursor: pointer;
      border: 1px solid transparent;
      border-radius: 4px;
      color: #fff;
      background-color: #337ab7;
      border-color: #2e6da4;
      text-decoration: none;
    }
    .btn:hover {
      background-color: #286090;
    }
    .pagination {
      display: flex;
      justify-content: center;
      list-style: none;
      padding: 0;
      margin-top: 20px;
    }
    .pagination li {
      margin: 0 5px;
    }
    .pagination li a {
      display: block;
      padding: 5px 10px;
      border: 1px solid #ddd;
      color: #337ab7;
      text-decoration: none;
    }
    .pagination li.active a {
      background-color: #337ab7;
      color: white;
      border-color: #337ab7;
    }
    .pagination li a:hover:not(.active) {
      background-color: #ddd;
    }
    .search-box {
      margin-bottom: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .search-controls {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .search-box form {
      display: flex;
      align-items: center;
    }
    .search-box .search-type {
      padding: 6px 12px;
      margin-right: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      background-color: #f8f9fa;
      cursor: pointer;
      min-width: 120px;
      height: 34px;
    }
    .search-box input[type="text"] {
      padding: 6px 12px;
      margin-right: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      min-width: 250px;
      height: 20px;
    }
    .search-box button {
      padding: 6px 12px;
      background-color: #337ab7;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      height: 34px;
    }
    .search-box button:hover {
      background-color: #286090;
    }
    .status-badge {
      display: inline-block;
      padding: 3px 7px;
      border-radius: 3px;
      font-size: 12px;
      color: white;
    }
    .status-pay-complete {
      background-color: #28a745;
    }
    .status-refund {
      background-color: #dc3545;
    }
    .status-preparing {
      background-color: #ffc107;
      color: #212529;
    }
    .status-shipping {
      background-color: #17a2b8;
    }
    .status-delivered {
      background-color: #6c757d;
    }
    
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
    
    /* 상태 뱃지 스타일 */
    .status-badge {
      display: inline-block;
      padding: 3px 8px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 500;
      color: white;
    }
    
    .status-pay-complete {
      background-color: #2ecc71;
    }
    
    .status-refund {
      background-color: #e74c3c;
    }
    
    .status-preparing {
      background-color: #3498db;
    }
    
    .status-shipping {
      background-color: #e67e22;
    }
    
    .status-delivered {
      background-color: #7f8c8d;
    }
    
    /* 검색 필터 스타일 */
    .search-box {
      display: flex;
      justify-content: flex-end;
      margin-bottom: 15px;
      margin-top: 15px;
      align-items: center;
    }
    
    .search-controls {
      display: flex;
      gap: 10px;
    }
    
    .search-type {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 13px;
    }
    
    .search-box input[type="text"] {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 13px;
      min-width: 250px;
    }
    
    .btn {
      padding: 8px 15px;
      border: none;
      border-radius: 4px;
      font-size: 13px;
      cursor: pointer;
      transition: all 0.2s;
    }
    
    .btn-primary {
      background-color: #0a2963;
      color: white;
    }
    
    .btn-primary:hover {
      background-color: #051d4d;
    }
    
    /* 총 주문 수 표시 */
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
  </style>
</head>
<body>
<jsp:include page="includes/admin_header.jsp" />
<jsp:include page="includes/admin_styles.jsp" />
<main>
  <div class="container">
    <div class="order-header">
      <h2>주문 관리</h2>
    </div>
    
    <!-- 테이블 상단 영역 -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; margin-top: 20px;">
      <!-- 총 주문 수 표시 -->
      <div class="total-count" style="margin: 0;">
        <%
        // DAO 객체 생성
        AdminOrderDAO orderDAO = new AdminOrderDAO();
        
        // 페이징 변수
        int pageSize = 10; // 한 페이지에 표시할 주문 수
        int currentPage = 1;
        if(request.getParameter("page") != null) {
          currentPage = Integer.parseInt(request.getParameter("page"));
        }
        int start = (currentPage - 1) * pageSize;
        
        // 데이터 가져오기
        List<Map<String, Object>> orderList = null;
        int totalOrders = 0;
        
        // 검색 타입과 키워드 가져오기
        String searchType = request.getParameter("searchType");
        String keyword = request.getParameter("keyword");
        
        if(searchType != null && keyword != null && !keyword.trim().isEmpty()) {
          // 선택한 검색 타입으로 검색
          orderList = orderDAO.searchOrders(searchType, keyword.trim());
          totalOrders = orderList.size();
        } else {
          // 전체 주문 목록
          orderList = orderDAO.getAllOrders(start, pageSize);
          totalOrders = orderDAO.getTotalOrderCount();
        }
        
        // 화폐 포맷
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.KOREA);
        %>
        총 <strong><%= totalOrders %></strong>개의 주문 정보가 있습니다.
      </div>
      
      <!-- 검색 필터 -->
      <div class="search-box" style="margin: 0;">
        <div class="search-controls">
          <form action="admin_order_list.jsp" method="get">
            <select name="searchType" class="search-type">
              <option value="orderNumber" <%= request.getParameter("searchType") == null || "orderNumber".equals(request.getParameter("searchType")) ? "selected" : "" %>>주문번호</option>
              <option value="orderName" <%= "orderName".equals(request.getParameter("searchType")) ? "selected" : "" %>>주문자명</option>
              <option value="productName" <%= "productName".equals(request.getParameter("searchType")) ? "selected" : "" %>>상품명</option>
            </select>
            <input type="text" name="keyword" placeholder="검색어 입력..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
            <button type="submit" class="btn btn-primary">검색</button>
          </form>
          <a href="admin_order_list.jsp" class="btn">초기화</a>
        </div>
      </div>
    </div>
    
    <table class="order-table">
      <thead>
        <tr>
          <th>주문번호</th>
          <th>주문일시</th>
          <th>회원구분</th>
          <th>주문자명</th>
          <th>상품명</th>
          <th>수량</th>
          <th>결제금액</th>
          <th>결제상태</th>
          <th>배송상태</th>
          <th>환불여부</th>
          <th>상세보기</th>
        </tr>
      </thead>
      <tbody>
        <%
        if(orderList.size() > 0) {
          for(Map<String, Object> order : orderList) {
        %>
        <tr>
          <td><%= order.get("o_num") %></td>
          <td><%= order.get("created_at") %></td>
          <td><%= "Y".equals(order.get("o_isMember")) ? "회원" : "비회원" %></td>
          <td><%= order.get("o_name") %></td>
          <td><%= order.get("p_name") %></td>
          <td><%= order.get("o_quantity") %></td>
          <td><%= currencyFormat.format(order.get("o_total_amount")) %></td>
          <td>
            <% 
            String payStatus = (String)order.get("pay_status");
            if(payStatus != null) {
              if(payStatus.contains("완료") || payStatus.contains("결제")) {
                %><span class="status-badge status-pay-complete"><%= payStatus %></span><%
              } else if(payStatus.contains("환불")) {
                %><span class="status-badge status-refund"><%= payStatus %></span><%
              } else {
                %><%= payStatus %><%
              }
            } else {
              %>-<%
            }
            %>
          </td>
          <td>
            <% 
            String dStatus = (String)order.get("d_status");
            if(dStatus != null) {
              if(dStatus.contains("준비")) {
                %><span class="status-badge status-preparing"><%= dStatus %></span><%
              } else if(dStatus.contains("배송중")) {
                %><span class="status-badge status-shipping"><%= dStatus %></span><%
              } else if(dStatus.contains("완료")) {
                %><span class="status-badge status-delivered"><%= dStatus %></span><%
              } else {
                %><%= dStatus %><%
              }
            } else {
              %>-<%
            }
            %>
          </td>
          <td>
            <% 
            String rfStatus = (String)order.get("rf_status");
            if(rfStatus != null) {
              if(rfStatus.contains("신청")) {
                %><span class="status-badge status-preparing"><%= rfStatus %></span><%
              } else if(rfStatus.contains("완료")) {
                %><span class="status-badge status-refund"><%= rfStatus %></span><%
              } else {
                %><%= rfStatus %><%
              }
            } else {
              %>-<%
            }
            %>
          </td>
          <td>
            <button type="button" class="btn btn-sm btn-detail order-detail-btn" data-order-id="<%= order.get("o_id") %>">상세보기</button>
          </td>
        </tr>
        <%
          }
        } else {
        %>
        <tr>
          <td colspan="11" class="text-center">주문 내역이 없습니다.</td>
        </tr>
        <%
        }
        %>
      </tbody>
    </table>
    
    <%
    // 페이징 처리
    if(searchType == null || keyword == null || keyword.trim().isEmpty()) {
      int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
      if(totalPages > 0) {
    %>
    <!-- 페이지네이션 -->
    <div class="pagination-container">
      <div class="pagination" id="pagination">
        <% if(currentPage > 1) { %>
          <a href="admin_order_list.jsp?page=1">처음</a>
          <a href="admin_order_list.jsp?page=<%= currentPage - 1 %>">이전</a>
        <% } else { %>
          <span class="disabled">처음</span>
          <span class="disabled">이전</span>
        <% } %>
        
        <% 
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, startPage + 4);
        
        for(int i = startPage; i <= endPage; i++) { 
        %>
          <a href="admin_order_list.jsp?page=<%= i %>" class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
        <% } %>
        
        <% if(currentPage < totalPages) { %>
          <a href="admin_order_list.jsp?page=<%= currentPage + 1 %>">다음</a>
          <a href="admin_order_list.jsp?page=<%= totalPages %>">마지막</a>
        <% } else { %>
          <span class="disabled">다음</span>
          <span class="disabled">마지막</span>
        <% } %>
      </div>
    </div>
    <% 
      }
    }
    %>
  </div>
</main>

<!-- 주문 상세 정보 모달 -->
<div id="orderModal" class="order-modal">
  <div id="orderModalContent">
    <!-- 모달 내용은 AJAX로 로드됨 -->
  </div>
</div>

<script>
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
