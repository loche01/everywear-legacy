<!-- basic.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="DAO.UserDAO, DTO.CRMUserInfoDTO, DTO.UserDTO, DTO.UserAddrDTO"%>
<%
String user_id = request.getParameter("user_id");
String user_type = request.getParameter("user_type");

UserDAO dao = new UserDAO();
CRMUserInfoDTO crm = dao.getCRMUserInfo(user_id, user_type);

UserDTO user = crm.getUser();
UserAddrDTO addr = crm.getAddr();
%>

<div class="crm-section">
	<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
  <h2 style="margin: 0;">👤 회원 정보</h2>
  <button type="button" onclick="loadTab('detail')" style="padding: 6px 14px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">
    수정
  </button>
</div>
<table>
  <tr>
    <th>아이디</th>
    <td><%=user.getUser_id()%></td>
    <th>회원유형</th>
      <td>
    <%
      String type = user.getUser_type();
    %>
    <span style="display:inline-block; padding:2px 8px; border-radius:4px; background:#eee; font-size:12px; font-weight:600; color:#555;"><%=type%></span>
  </td>
  </tr>
  <tr>
    <th>이름</th>
    <td><%=user.getUser_name()%></td>
    <th>성별</th>
    <td><%=user.getUser_gender()%></td>
  </tr>
  <tr>
    <th>생년월일</th>
    <td><%=user.getUser_birth()%></td>
    <th>이메일</th>
    <td><%=user.getUser_email() == null ? "-" : user.getUser_email()%></td>
  </tr>
  <tr>
    <th>전화번호</th>
    <td><%=user.getUser_phone()%></td>
    <th>가입일</th>
    <td><%=user.getCreated_at()%></td>
  </tr>
  <tr>
    <th>회원등급</th>
    <td><%=user.getUser_rank()%></td>
    <th>계정상태</th>
    <td><%=user.getUser_account_state()%></td>
  </tr>
  <tr>
    <th>잠금여부</th>
    <td><%=user.getUser_lock_state()%></td>
    <th>마케팅 수신</th>
    <td><%=user.getUser_marketing_state()%></td>
  </tr>
  <tr>
    <th>키 / 몸무게</th>
    <td colspan="3"><%=user.getUser_height()%>cm / <%=user.getUser_weight()%>kg</td>
  </tr>
  <tr>
    <th>기본 배송지 주소</th>
    <td colspan="3"><%=addr != null ? addr.getAddr_road() + " " + addr.getAddr_detail() : "-"%></td>
  </tr>
  <tr>
    <th>총 결제 금액</th>
    <td><%=crm.getTotalOrderAmount()%>원</td>
  </tr>
  <tr>
      <th>최근 로그인</th>
    <td><%=crm.getLastLoginDate() != null ? crm.getLastLoginDate() : "-"%></td>
  </tr>
</table>

</div>