<!-- login.jsp -->
<%@page import="java.net.URLEncoder"%>
<%@page import="DAO.UserDAO"%>
<%@page import="Security.RedirectSanitizer"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
		String redirect = RedirectSanitizer.sanitize(
				request.getParameter("redirect"), request.getContextPath());
		session.setAttribute("redirect", redirect);
		String escapedRedirect = RedirectSanitizer.escapeHtmlAttribute(redirect);
		String errorMessage = "";
		String error = request.getParameter("error");
		int fail = 0;
		
		try{
			fail = Integer.parseInt(request.getParameter("fail"));
		} catch(Exception e){}
		
		if ("noUser".equals(error)) {
		    errorMessage = "아이디가 존재하지 않습니다.";
		} else if ("wrong".equals(error)) {
		    errorMessage = "비밀번호가 틀렸습니다 ( " + fail + " / 5 )";
		} else if("resign".equals(error)){
			errorMessage = "이미 탈퇴한 계정입니다.";
		} else if("human".equals(error)){
			errorMessage = "6개월 이상 접속하지 않아 휴먼계정으로 전환되었습니다.";
			} else if("lock".equals(error)){
				errorMessage = "5회 이상 로그인 실패로 인해 계정이 잠금상태가 되었습니다.";
			} else if("naverConfig".equals(error)){
				errorMessage = "Naver 로그인은 외부 애플리케이션 설정이 필요합니다.";
			} else if("naver".equals(error)){
				errorMessage = "Naver 로그인 처리 중 문제가 발생했습니다.";
			} else if("googleConfig".equals(error)){
				errorMessage = "Google 로그인은 외부 애플리케이션 설정이 필요합니다.";
			} else if("kakaoConfig".equals(error)){
				errorMessage = "Kakao 로그인은 외부 애플리케이션 설정이 필요합니다.";
			} else if("kakao".equals(error)){
				errorMessage = "Kakao 로그인 처리 중 문제가 발생했습니다.";
			} else if("google".equals(error)){
				errorMessage = "Google 로그인 처리 중 문제가 발생했습니다.";
			} else if("socialEmail".equals(error)){
				errorMessage = "소셜 계정의 이메일 제공에 동의해야 로그인할 수 있습니다.";
			}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인 | everyWEAR</title>
<link rel="stylesheet" type="text/css" href="css/login.css?v=20260918">
  <link rel="stylesheet" type="text/css" href="css/header.css">
  <link rel="icon" type="image/png" href="images/fav-icon.png">
</head>
<body>


<%@ include file="includes/loginHeader.jsp" %>

<div class="login-container">
<form action="login" method="post" autocomplete="off">
  <label for="userId">ID</label>
  <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required>

  <label for="password">PWD</label>
  <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>

  <!-- 아이디/비밀번호 찾기 영역 -->
  <div class="find-links">
  <%if("human".equals(error) || "lock".equals(error)){ %>
   	<a href="lockOutAccount.jsp">잠긴 계정 풀기</a>
   	<span class="divider-bar">|</span>
  <%} %>
    <a href="findId.jsp">아이디 찾기</a>
    <span class="divider-bar">|</span>
    <a href="findPwd.jsp">비밀번호 찾기</a>
  </div>
<input type="hidden" name="redirect" value="<%= escapedRedirect %>">
  <button type="submit" class="login-btn">Login</button>
</form>
    <% if (!errorMessage.isEmpty()) { %>
        <p style="font-size: 12px; color: red;"><%= errorMessage %><br></p>
    <% } else{%>
    	<p style="font-size: 12px;">&nbsp;</p>
    <%} %>
  <div class="divider">Or</div>

    <%
        String clientId = System.getenv("GOOGLE_CLIENT_ID");
        String redirectUri = System.getenv("EVERYWEAR_GOOGLE_REDIRECT_URI");
        boolean googleConfigured = clientId != null && !clientId.isBlank()
                && redirectUri != null && !redirectUri.isBlank();
        String authUrl = "#";
        if (googleConfigured) {
            authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                    + "?scope=" + URLEncoder.encode("openid email profile", "UTF-8")
                    + "&access_type=online"
                    + "&response_type=code"
                    + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                    + "&client_id=" + URLEncoder.encode(clientId, "UTF-8")
                    + "&prompt=select_account";
        }
    %>
    
    
    <%
        String clientId_k = System.getenv("KAKAO_CLIENT_ID");
        String redirectUri_k = System.getenv("EVERYWEAR_KAKAO_REDIRECT_URI");
        boolean kakaoConfigured = clientId_k != null && !clientId_k.isBlank()
                && redirectUri_k != null && !redirectUri_k.isBlank();
        String authUrl_k = "#";
        if (kakaoConfigured) {
            authUrl_k = "https://kauth.kakao.com/oauth/authorize?response_type=code"
                    + "&client_id=" + URLEncoder.encode(clientId_k, "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(redirectUri_k, "UTF-8")
                    + "&prompt=select_account";
        }
    %>
    
	<%-- Naver 로그인 버튼은 이번 UI 복원 범위에서 제외했다(사용자 확정 요구사항).
	     NaverLoginServlet.java, Security 계층, images/Naver.png 는 삭제하지 않고 그대로 둔다.
	     재도입 시 everyWEAR_recovered 36a9cb2:src/main/webapp/login.jsp 의 아래 블록을
	     그대로 복원하면 된다:

	    String clientId_n = System.getenv("EVERYWEAR_NAVER_CLIENT_ID");
	    String redirectURI_n = System.getenv("EVERYWEAR_NAVER_REDIRECT_URI");
	    boolean naverConfigured = clientId_n != null && !clientId_n.isBlank()
	            && redirectURI_n != null && !redirectURI_n.isBlank();
	    String apiURL_n = "#";

	    if (naverConfigured) {
	        String state = java.util.UUID.randomUUID().toString();
	        session.setAttribute("naverOAuthState", state);
	        apiURL_n = "https://nid.naver.com/oauth2.0/authorize?response_type=code"
	                + "&client_id=" + URLEncoder.encode(clientId_n, "UTF-8")
	                + "&redirect_uri=" + URLEncoder.encode(redirectURI_n, "UTF-8")
	                + "&state=" + URLEncoder.encode(state, "UTF-8");
	    } else {
	        session.removeAttribute("naverOAuthState");
	    }
	--%>




  <div class="social-login">
    <a class="social-btn google" href="<%=authUrl%>" aria-disabled="<%= !googleConfigured %>"
       <%= googleConfigured ? "" : "onclick=\"return false;\" title=\"외부 Google 앱 설정 필요\"" %>>
      <img src="images/Google.png" alt="Google">
      <span>Sign in with Google</span>
    </a>
    <br>
    <a class="social-btn kakao" href="<%=authUrl_k%>" aria-disabled="<%= !kakaoConfigured %>"
       <%= kakaoConfigured ? "" : "onclick=\"return false;\" title=\"외부 Kakao 앱 설정 필요\"" %>>
      <img src="images/kakao.png" alt="Kakao">
      <span>Sign in with Kakao</span>
    </a>
    <%-- Naver 로그인 버튼: 이번 UI 복원 범위 제외. images/Naver.png 는 미사용 자산으로 보존. --%>
  </div>

  <a href="guestOrder.jsp" class="guest-order" aria-disabled="true" onclick="return false;" title="비회원 주문 조회 기능은 준비 중입니다.">비회원 주문 조회</a>

  <div class="signup-section">
    Don't you have an account? <a href="signup.jsp">Sign up</a>
  </div>

  <a href="admin_login.jsp" class="admin-login-link">관리자 로그인</a>
</div>

<footer>2025©everyWEAR</footer>

</body>
</html>
