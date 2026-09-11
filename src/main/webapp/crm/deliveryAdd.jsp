<!-- deliveryAdd.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DTO.UserAddrDTO, org.apache.taglibs.standard.functions.Functions" %>
<%!
    private static String single(String[] values) {
        if (values == null || values.length != 1) {
            return null;
        }
        String v = values[0] == null ? null : values[0].trim();
        return (v == null || v.isEmpty()) ? null : v;
    }
%>
<%
request.setCharacterEncoding("UTF-8");
response.setHeader("Cache-Control", "no-store");
UserDAO dao = new UserDAO();

// AdminAuthFilter: GET 등록 화면은 유지, POST mutation 은 POST + 관리자 CSRF 강제.
String user_id = single(request.getParameterValues("user_id"));
String user_type = single(request.getParameterValues("user_type"));

if (user_id == null || user_id.length() > 30 || user_type == null || user_type.length() > 10) {
    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "대상 회원 정보가 올바르지 않습니다.");
    return;
}

if ("POST".equals(request.getMethod())) {
    String addr_label = request.getParameter("addr_label");
    String zipcode = request.getParameter("zipcode");
    String address1 = request.getParameter("address1");
    String address2 = request.getParameter("address2");
    String addr_isDefault = request.getParameter("addr_isDefault") != null ? "Y" : "N";

    addr_label = addr_label == null ? "" : addr_label.trim();
    zipcode = zipcode == null ? "" : zipcode.trim();
    address1 = address1 == null ? "" : address1.trim();
    address2 = address2 == null ? "" : address2.trim();

    if (!zipcode.matches("[0-9]{4,6}") || address1.isEmpty()
            || address1.length() > 200 || address2.length() > 200 || addr_label.length() > 50) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "배송지 입력값이 올바르지 않습니다.");
        return;
    }

    UserAddrDTO dto = new UserAddrDTO();
    dto.setAddr_label(addr_label);
    dto.setAddr_zipcode(zipcode);
    dto.setAddr_road(address1);
    dto.setAddr_detail(address2);
    dto.setAddr_isDefault(addr_isDefault);

    // saveOwnedAddr(id, type, 0, dto): 대상 회원 존재 확인 + 기본 배송지 해제 + insert 를 단일 트랜잭션으로 처리.
    if (!dao.saveOwnedAddr(user_id, user_type, 0, dto)) {
        response.sendError(HttpServletResponse.SC_CONFLICT, "배송지를 저장하지 못했습니다.");
        return;
    }
%>
<script>
  alert("배송지 등록이 완료되었습니다.");
  if (window.opener && !window.opener.closed) {
    window.opener.loadTab('delivery');
  }
  window.close();
</script>
<%
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>배송지 등록</title>
  <link rel="stylesheet" href="CRM.css/deliveryAddMod.css">
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script>
    function execDaumPostcode() {
      new daum.Postcode({
        oncomplete: function(data) {
          document.getElementById("zipcode").value = data.zonecode;
          document.getElementById("address1").value = data.roadAddress;
          document.getElementById("address2").value = "";
          document.getElementById("address2").focus();
        }
      }).open();
    }

    function confirmSubmit() {
      return confirm("저장하시겠습니까?");
    }
  </script>
</head>
<body>

<h3>📦 배송지 등록</h3>

<form method="post" action="deliveryAdd.jsp" onsubmit="return confirmSubmit();">
  <input type="hidden" name="user_id" value="<%=Functions.escapeXml(user_id)%>">
  <input type="hidden" name="user_type" value="<%=Functions.escapeXml(user_type)%>">
  <input type="hidden" name="adminCsrfToken" value="<%=Functions.escapeXml((String) session.getAttribute("adminCsrfToken"))%>">

  <!-- 배송지 라벨 -->
  <label for="addr_label">배송지 라벨</label>
  <input type="text" id="addr_label" name="addr_label" required>

  <!-- 주소 -->
  <label for="address">주소 <span style="color: red;">*</span></label>
  <div class="address-group">
    <input type="text" id="zipcode" name="zipcode" placeholder="우편번호" readonly>
    <button type="button" id="addrSearch" class="search-btn" onclick="execDaumPostcode()">주소 검색</button>
  </div>
  <input type="text" style="margin-top: 10px" id="address1" name="address1" placeholder="기본 주소" required readonly>
  <input type="text" id="address2" name="address2" placeholder="나머지 주소">

  <!-- 기본 배송지 여부 -->
  <label style="margin-top: 10px;">
    <input type="checkbox" name="addr_isDefault" value="Y">
    기본 배송지로 설정
  </label>

  <div class="btn-box">
    <button type="submit">저장</button>
  </div>
</form>

</body>
</html>
