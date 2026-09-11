<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// Legacy 복구 범위에서 관리자 리뷰 상세관리는 지원하지 않는다.
// recovery DB 에 review_comment / review_report 가 미복구 상태이고, deleteReview mutation 은
// 실제 review / review_image 를 삭제할 수 있으므로 이 경로를 안전 비활성화한다.
// mutation(POST) 요청은 AdminAuthFilter 에서 DAO 호출 없이 410 으로 거부된다.
response.setHeader("Cache-Control", "no-store");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 상세 관리</title>
<link rel="stylesheet" href="CRM.css/userCRM.css">
</head>
<body>
	<div class="container">
		<h2>📝 리뷰 상세 관리</h2>
		<p>Legacy 복구 범위에서 관리자 리뷰 상세관리는 지원하지 않습니다.</p>
		<p style="color:#777; font-size:13px;">
			리뷰 댓글 / 리뷰 신고 데이터가 복구되지 않아 이 화면의 조회·수정·삭제 기능은 비활성화되었습니다.
		</p>
		<div style="margin-top: 20px; text-align: right;">
			<button class="btn btn-back" onclick="window.close()">닫기 ✖</button>
		</div>
	</div>
</body>
</html>