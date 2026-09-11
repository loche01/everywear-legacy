<!-- detail.jsp -->
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="DAO.UserDAO, DTO.CRMUserInfoDTO, DTO.UserDTO, DTO.UserAddrDTO"%>
<%
String user_id = request.getParameter("user_id");
String user_type = request.getParameter("user_type");
UserDAO dao = new UserDAO();
CRMUserInfoDTO crm = dao.getCRMUserInfo(user_id, user_type);
UserDTO user = crm.getUser();
UserAddrDTO addr = crm.getAddr();

String[] birthParts = user.getUser_birth() != null ? user.getUser_birth().split("-") : new String[] { "", "", "" };
String birthY = birthParts.length > 0 ? birthParts[0] : "";
String birthM = birthParts.length > 1 ? birthParts[1] : "";
String birthD = birthParts.length > 2 ? birthParts[2] : "";
%>
<div class = "crm-section">
  <h2>👤 회원 정보 수정</h2>
<div class="detail-scroll-area">
  <form action="updateUserInfo.jsp" method="post">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="user_type" value="<%=user_type%>">
    <input type="hidden" name="adminCsrfToken" value="<%=session.getAttribute("adminCsrfToken")%>">

<table>
  <tr>
    <th style="text-align: center; vertical-align: middle;">아이디</th>
    <td style="text-align: center; vertical-align: middle;">
      <input type="text" name="user_id_display" value="<%=user.getUser_id()%>" readonly>
    </td>
    <th style="text-align: center; vertical-align: middle;">회원등급</th>
    <td>
      <select name="user_rank">
        <option value="그린" <%=user.getUser_rank().equals("그린") ? "selected" : ""%>>그린</option>
        <option value="오렌지" <%=user.getUser_rank().equals("오렌지") ? "selected" : ""%>>오렌지</option>
        <option value="퍼플" <%=user.getUser_rank().equals("퍼플") ? "selected" : ""%>>퍼플</option>
        <option value="에메랄드" <%=user.getUser_rank().equals("에메랄드") ? "selected" : ""%>>에메랄드</option>
        <option value="블랙" <%=user.getUser_rank().equals("블랙") ? "selected" : ""%>>블랙</option>
      </select>
    </td>
  </tr>

  <tr>
    <th style="text-align: center; vertical-align: middle;">이름</th>
    <td style="text-align: center; vertical-align: middle;">
      <input type="text" name="user_name" value="<%=user.getUser_name()%>">
    </td>
    <th style="text-align: center; vertical-align: middle;">계정상태</th>
    <td style="text-align: center; vertical-align: middle;">
      <select name="user_account_state" id="accountState">
        <option <%=user.getUser_account_state().equals("정상") ? "selected" : ""%>>정상</option>
        <option <%=user.getUser_account_state().equals("휴먼") ? "selected" : ""%>>휴먼</option>
        <option <%=user.getUser_account_state().equals("이용 정지") ? "selected" : ""%>>이용 정지</option>
        <option <%=user.getUser_account_state().equals("탈퇴") ? "selected" : ""%>>탈퇴</option>
        <option <%=user.getUser_account_state().equals("로그인 연속 실패로 인한 잠금") ? "selected" : ""%>>로그인 연속 실패로 인한 잠금</option>
      </select>
    </td>
  </tr>

  <tr>
    <th style="text-align: center; vertical-align: middle;">이메일</th>
    <td style="text-align: center; vertical-align: middle;">
      <input type="text" name="user_email" value="<%=user.getUser_email()%>">
    </td>
    <th style="text-align: center; vertical-align: middle;">잠금여부</th>
    <td>
      <select name="user_lock_state" id="lockState">
        <option value="N" <%=user.getUser_lock_state().equals("N") ? "selected" : ""%>>N</option>
        <option value="Y" <%=user.getUser_lock_state().equals("Y") ? "selected" : ""%>>Y</option>
      </select>
    </td>
  </tr>

  <tr>
    <th style="text-align: center; vertical-align: middle;">생년월일</th>
    <td style="text-align: center; vertical-align: middle;">
      <input type="text" id="birth_y" name="birth_y" maxlength="4" value="<%=birthY%>" style="width: 60px;"> -
      <input type="text" id="birth_m" name="birth_m" maxlength="2" value="<%=birthM%>" style="width: 40px;"> -
      <input type="text" id="birth_d" name="birth_d" maxlength="2" value="<%=birthD%>" style="width: 40px;">
    </td>
    <th style="text-align: center; vertical-align: middle;">마케팅<br>수신 동의</th>
    <td>
      <select name="user_marketing_state">
        <option value="N" <%=user.getUser_marketing_state().equals("N") ? "selected" : ""%>>N</option>
        <option value="Y" <%=user.getUser_marketing_state().equals("Y") ? "selected" : ""%>>Y</option>
      </select>
    </td>
  </tr>

  <tr>
    <th style="text-align: center; vertical-align: middle;">전화번호</th>
    <td style="text-align: center; vertical-align: middle;">
      010 -
      <input type="text" name="phone1" maxlength="4" value="<%=user.getUser_phone().split("-")[1]%>" style="width: 60px;"> -
      <input type="text" name="phone2" maxlength="4" value="<%=user.getUser_phone().split("-")[2]%>" style="width: 60px;">
    </td>
    <th style="text-align: center;">신체정보</th>
    <td style="text-align: left; vertical-align: middle;">
      <div style="margin-bottom: 8px;">
        <label><input type="radio" name="user_gender" value="남자" <%= "남자".equals(user.getUser_gender()) ? "checked" : "" %>> 남자</label>
        <label style="margin-left: 10px;"><input type="radio" name="user_gender" value="여자" <%= "여자".equals(user.getUser_gender()) ? "checked" : "" %>> 여자</label>
      </div>
      <div style="border-top: 1px solid #ccc; margin: 6px 0;"></div>
      <div style="margin-top: 6px;">
        <input type="text" name="user_height" maxlength="3" value="<%=user.getUser_height()%>" style="width: 50px;"> cm
        &nbsp;
        <input type="text" name="user_weight" maxlength="3" value="<%=user.getUser_weight()%>" style="width: 50px;"> kg
      </div>
    </td>
  </tr>

  <!-- 3. 기타 -->
<tr>
  <th style="text-align: center; vertical-align: middle;">기본<br>배송지</th>
  <td colspan="3" style="text-align: left; vertical-align: middle;">
    <div style="margin-bottom: 6px;">
      <input type="text" name="addr_road" value="<%=addr != null ? addr.getAddr_road() : ""%>" readonly style="width: 100%;">
    </div>
    <div style="display: flex; justify-content: space-between; align-items: center;">
      <input type="text" name="addr_detail" value="<%=addr != null ? addr.getAddr_detail() : ""%>" readonly style="width: 87%;">
      <button type="button" onclick="loadTab('delivery')">수정</button>
    </div>
  </td>
</tr>


</table>




    <div class="btn-submit-wrapper">
  <button type="submit" class="btn-submit">저장</button>
</div>

  </form>
</div>
</div>

