<%@ page import="org.apache.taglibs.standard.functions.Functions" %>
<%@page import="DTO.NoticeDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="nDao" class="DAO.NoticeDAO"/>
<%
        int noti_id;
        try {
            noti_id = Integer.parseInt(request.getParameter("noti_id"));
            if (noti_id <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException invalidId) {
            response.setStatus(400);
            return;
        }
        NoticeDTO nDto = nDao.getNotice(noti_id);
        if (nDto == null) {
            response.setStatus(404);
            return;
        }
		boolean isPinned = nDao.isPinned(noti_id);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/board.css?v=165456">
</head>
<body>

	<%@ include file="includes/boardHeader.jsp"%>

	<section2 class="content2">
	<h3>BOARD</h3>
	</section2>
	
	<div class="container">
		<aside class="sidebar2">
			<ul>
				<li><a href="board.jsp">BOARD</a></li>
				<li><a href="FAQ.jsp">FAQ</a></li>
				<li><a href="Q&A.jsp">Q&A</a></li>
			</ul>
		</aside>

		<section class="content">
			<table class="notice-table">
			<%if(isPinned){ %>
				<tr class="important">
					<td class="title">※ <%=Functions.escapeXml(nDto.getNoti_title())%></td>
					<td class="date"><%=Functions.escapeXml(nDto.getCreated_at())%></td>
					<td class="views">조회수: <%=nDto.getNoti_views()%></td>
				</tr>
				<%} else{ %>
				<tr class="normal">
					<td class="title"><%=Functions.escapeXml(nDto.getNoti_title())%></td>
					<td class="date"><%=Functions.escapeXml(nDto.getCreated_at())%></td>
					<td class="views">조회수: <%=nDto.getNoti_views()%></td>
				</tr>
				<%} %>

				<!-- 본문 내용을 별도 tr로 처리 -->
				<tr>
					<td colspan="3" class="notice-content">
						<div class="notice-body">
							<!-- <p>
								<strong>■ 회원가입 안내</strong>
							</p>
							<p>회원가입 메뉴를 통해 이용약관, 개인정보보호정책 동의 및 일정 양식의 가입항목을 기입함으로써 회원에
								가입되며, 가입 즉시 서비스를 무료로 이용하실 수 있습니다.<br>
								주문하실 때에 입력해야하는 각종 정보들을 일일이
								입력하지 않으셔도 됩니다. 회원을 위한 이벤트 및 각종 할인행사에 참여하실 수 있습니다.</p>

							<p>
								<strong>■ 주문 안내</strong>
							</p>
							<p>상품주문은 다음단계로 이루어집니다.</p>
							<p>
							- Step1: 상품검색<br>
							- Step2: 장바구니에 담기<br>
							- Step3: 회원ID 로그인 또는 비회원 주문<br>
							- Step4: 주문서 작성<br>
							- Step5: 결제방법선택 및 결제<br>
							-	Step6: 주문 성공 화면 (주문번호)<br>
							</p>
							<p>
								비회원 주문인경우 6단계에서 주문번호와 승인번호(카드결제시)를 꼭 메모해
								두시기 바랍니다. 단, 회원인 경우 자동 저장되므로 따로 관리하실 필요가 없습니다.
							</p>

							<p>
								<strong>■ 결제 안내</strong>
							</p>
							<p>고액결제의 경우 안전을 위해 카드사에서 확인전화를 드릴 수도 있습니다. 확인과정에서 도난 카드의 사용이나
								타인 명의의 주문등 정상적인 주문이 아니라고 판단될 경우 임의로 주문을 보류 또는 취소할 수 있습니다.<br>
							</p>
							<p>
								무통장 입금은 상품 구매 대금은 PC뱅킹, 인터넷뱅킹, 텔레뱅킹 혹은 가까운 은행에서 직접 입금하시면 됩니다. 주문시
								입력한 입금자명과 실제입금자의 성명이 반드시 일치하여야 하며, 48시간 이내로 입금을 하셔야 하며 입금되지 않은
								주문은 자동취소 됩니다.
							</p> -->
							<p><%=Functions.escapeXml(nDto.getContent()).replace("\n", "<br>")%></p>
						</div>
					</td>
				</tr>
			</table>
			<div class="list-wrapper">
				<button class="list" onclick="window.history.back()">목록</button>
			</div>

<!-- 			<div class="pagination">
				<span>Prev</span> <span class="active">1</span> <span>2</span> <span>3</span>
				<span>4</span> <span>5</span> <span>Next</span>
			</div> -->

			<div class="footer-bottom">
				<p>2025&copy;everyWEAR</p>
			</div>
		</section>
	</div>

</body>