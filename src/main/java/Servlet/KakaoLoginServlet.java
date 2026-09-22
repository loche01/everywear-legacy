package Servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.*;
import java.util.Vector;

import org.json.JSONObject;

import DAO.UserDAO;

@WebServlet("/KakaoLoginServlet")
public class KakaoLoginServlet extends HttpServlet {
	private static final String CLIENT_ID = System.getenv("KAKAO_CLIENT_ID");
	// 개인 도메인을 코드에 두지 않는다. 배포 환경에서 EVERYWEAR_KAKAO_REDIRECT_URI 로 주입한다.
	private static final String REDIRECT_URI = System.getenv("EVERYWEAR_KAKAO_REDIRECT_URI");
	// REST API 키는 클라이언트 시크릿이 활성화된 상태로 발급된다. 활성화된 키는 토큰 요청에 client_secret 이 필요하다.
	private static final String CLIENT_SECRET = System.getenv("KAKAO_CLIENT_SECRET");

	private static boolean isConfigured() {
		return CLIENT_ID != null && !CLIENT_ID.isBlank()
				&& REDIRECT_URI != null && !REDIRECT_URI.isBlank();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String code = request.getParameter("code");
		if (code == null || code.isEmpty()) {
			response.sendRedirect("login.jsp");
			return;
		}

		if (!isConfigured()) {
			// 외부 OAuth 앱이 구성되지 않은 환경에서는 외부 요청을 시도하지 않는다.
			response.sendRedirect("login.jsp?error=kakaoConfig");
			return;
		}

		try {
			// 1. access_token 요청
			String tokenURL = "https://kauth.kakao.com/oauth/token";
			String params = "grant_type=authorization_code"
					+ "&client_id=" + URLEncoder.encode(CLIENT_ID, "UTF-8")
					+ "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
					+ "&code=" + URLEncoder.encode(code, "UTF-8");
			if (CLIENT_SECRET != null && !CLIENT_SECRET.isBlank()) {
				params += "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, "UTF-8");
			}

			String tokenResponse = sendPostRequest(tokenURL, params);
			JSONObject tokenJson = new JSONObject(tokenResponse);
			String accessToken = tokenJson.getString("access_token");

			// 2. 사용자 정보 요청
			String userInfoResponse = sendGetRequest("https://kapi.kakao.com/v2/user/me", accessToken);
			JSONObject userJson = new JSONObject(userInfoResponse);
			// 동의항목이 설정되지 않으면 kakao_account 자체가 응답에 없다.
			JSONObject kakaoAccount = userJson.optJSONObject("kakao_account");
			if (kakaoAccount == null) {
				kakaoAccount = new JSONObject();
			}

			String nickname = "";
			if (userJson.has("properties")) {
				nickname = userJson.getJSONObject("properties").optString("nickname", "");
			}
			// 카카오는 개인 개발자 앱에 이메일을 제공하지 않는다(비즈 앱 전환과 심사 필요).
			// 모든 앱에 항상 제공되는 회원번호로 회원을 식별하고, 이메일은 있으면 부가 정보로만 쓴다.
			long kakaoId = userJson.optLong("id", 0L);
			if (kakaoId == 0L) {
				response.sendRedirect("login.jsp?error=kakao");
				return;
			}
			String memberKey = "kakao_" + kakaoId;
			String email = kakaoAccount.optString("email", "");

			HttpSession session = request.getSession();
			String sessionId = (String) session.getAttribute("id");
			String sessionType = (String) session.getAttribute("userType");
			
			UserDAO userDao = new UserDAO();
			
			
			if ("Kakao".equals(sessionType) && memberKey.equals(sessionId)) {
			    // 동일한 Google 로그인 세션이 이미 존재함
			    System.out.println("세션 로그인 상태");
			    response.sendRedirect("main2.jsp");
			    return;
			}

			 String redirect = (String)session.getAttribute("redirect");
			 System.out.println(redirect);
			
			if (userDao.isSocialUserExists(memberKey, "Kakao")) {
			    // 이미 가입한 카카오 계정
				if(userDao.showSocialAccountState(memberKey, "Kakao").equals("정상")) {
					request.changeSessionId();
					session.setAttribute("id", memberKey);
					session.setAttribute("userType", "Kakao");
					System.out.println("이미 가입한 카카오 계정");
					userDao.insertLog(memberKey, "Kakao", "로그인");
					 if (redirect != null && !redirect.equals("")) {
			                response.sendRedirect(redirect);
			            } else {
			                response.sendRedirect("main2.jsp");
			            }				
				} else if(userDao.showSocialAccountState(memberKey, "Kakao").equals("휴먼")) {
            		response.sendRedirect("login.jsp?error=human");
            	} else if(userDao.showSocialAccountState(memberKey, "Kakao").equals("탈퇴")) {
            		response.sendRedirect("login.jsp?error=resign");
            	}
			} else {
			    // 첫 가입
			    request.changeSessionId();
			    session.setAttribute("id", memberKey);
			    session.setAttribute("userType", "Kakao");
			    session.setAttribute("socialName", nickname);
			    session.setAttribute("socialEmail", email);
			    System.out.println("첫 회원가입");
			    // 소셜로그인 전용 회원가입 화면으로 이동할 것.
			    response.sendRedirect("signup.jsp?social=Kakao");
			}

			
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("login.jsp?error=kakao");
		}
	}

	private String sendPostRequest(String urlStr, String params) throws IOException {
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

		try (OutputStream os = conn.getOutputStream()) {
			os.write(params.getBytes("utf-8"));
		}

		return getResponse(conn);
	}

	private String sendGetRequest(String urlStr, String accessToken) throws IOException {
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Authorization", "Bearer " + accessToken);

		return getResponse(conn);
	}

	private String getResponse(HttpURLConnection conn) throws IOException {
		try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
			StringBuilder response = new StringBuilder();
			String responseLine;
			while ((responseLine = br.readLine()) != null) {
				response.append(responseLine.trim());
			}
			return response.toString();
		}
	}
}
