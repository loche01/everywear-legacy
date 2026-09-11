<%@ page import="org.apache.taglibs.standard.functions.Functions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DTO.UserDTO"%>
<%@ page import="java.util.List"%>
<%
UserDAO dao = new UserDAO();
String reason = request.getParameter("reason");
if (reason == null)
	reason = "";

List<UserDTO> list;
int totalCount;

if (!reason.trim().isEmpty()) {
	list = dao.getWithdrawalUserList(1, 1000, reason); // 페이징 X, 전체 가져옴
	totalCount = list.size();
} else {
	list = dao.getWithdrawalUserList(1, 1000);
	totalCount = dao.getWithdrawalUserCount();
}
int no = 1;

//현재 페이지 표시
request.setAttribute("currentMenu", "member");
request.setAttribute("subMenu", "member_manage");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>탈퇴 회원 목록 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" href="css/admin_member.css">
</head>
<body>
	<!-- 헤더 -->
	<jsp:include page="includes/admin_header.jsp" />

	<main>
		<div class="container">
			<table class="user-table">
				<thead>
					<tr>
						<th colspan="7">
							<div
								style="display: flex; justify-content: space-between; align-items: center;">
								<span>※ 탈퇴회원 목록입니다. (총 <%=totalCount%>명)
								</span>
								<form method="get" action="admin_wdmember_manage.jsp"
									style="margin: 0;">
									<select name="reason" onchange="this.form.submit()">
										<option value="" <%=reason.equals("") ? "selected" : ""%>>전체
											사유</option>
										<option value="쇼핑몰 이용이 불편함"
											<%=reason.equals("쇼핑몰 이용이 불편함") ? "selected" : ""%>>쇼핑몰
											이용이 불편함</option>
										<option value="원하는 상품 부족"
											<%=reason.equals("원하는 상품 부족") ? "selected" : ""%>>원하는
											상품 부족</option>
										<option value="개인정보 보안 우려"
											<%=reason.equals("개인정보 보안 우려") ? "selected" : ""%>>개인정보
											보안 우려</option>
										<option value="마케팅 메시지 과다 수신"
											<%=reason.equals("마케팅 메시지 과다 수신") ? "selected" : ""%>>마케팅
											메시지 과다 수신</option>
										<option value="단순 변심 / 더 이상 이용하지 않음"
											<%=reason.equals("단순 변심 / 더 이상 이용하지 않음") ? "selected" : ""%>>단순
											변심</option>
										<option value="관리자 처리"
											<%=reason.equals("관리자 처리") ? "selected" : ""%>>관리자
											처리</option>
										<option value="기타" <%=reason.equals("기타") ? "selected" : ""%>>기타</option>
									</select>
								</form>
							</div>
						</th>
					</tr>
					<tr>
						<th>No.</th>
						<th>회원 ID</th>
						<th>이름</th>
						<th>등급</th>
						<th>탈퇴일</th>
						<th>탈퇴 사유</th>
						<th>상세 사유</th>
					</tr>
				</thead>
				<tbody>
					<%
					if (list != null && !list.isEmpty()) {
						for (UserDTO user : list) {
					%>
					<tr data-user-id="<%=Functions.escapeXml(user.getUser_id())%>"
						data-user-type="<%=Functions.escapeXml(user.getUser_type())%>"
						onclick="openPopup(this.dataset.userId, this.dataset.userType)"
						style="cursor: pointer;">
						<td><%=no++%></td>
						<td><%=user.getUser_id()%></td>
						<td><%=user.getUser_name()%></td>
						<td><%=user.getUser_rank()%></td>
						<td><%=user.getUser_wd_date()%></td>
						<td><%=user.getUser_wd_reason() == null ? "-" : user.getUser_wd_reason()%></td>
						<td>
							<%
							String detail = user.getUser_wd_detail_reason();
							out.print(detail == null || detail.trim().isEmpty()
									? "-"
									: (detail.length() > 20 ? detail.substring(0, 20) + "..." : detail));
							%>
						</td>
					</tr>
					<%
					}
					} else {
					%>
					<tr>
						<td colspan="7" style="text-align: center;">표시할 데이터가 없습니다.</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
	</main>
	
	<!-- 푸터 포함 -->
	<jsp:include page="/includes/admin_footer.jsp" />
	
	<script>
		function openPopup(id, type) {
			const url = "withdrawalDetail.jsp?user_id=" + encodeURIComponent(id)
				+ "&user_type=" + encodeURIComponent(type);
			window.open(url, "탈퇴회원상세", "width=500,height=430,left=200,top=200");
		}
	</script>
</body>
</html>
