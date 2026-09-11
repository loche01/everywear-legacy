package Servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.*;

import org.json.JSONObject;

import DAO.UserDAO;

@WebServlet("/GoogleLoginServlet")
public class GoogleLoginServlet extends HttpServlet {
    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
    // 개인 도메인을 코드에 두지 않는다. 배포 환경에서 EVERYWEAR_GOOGLE_REDIRECT_URI 로 주입한다.
    private static final String REDIRECT_URI = System.getenv("EVERYWEAR_GOOGLE_REDIRECT_URI");

    private static boolean isConfigured() {
        return CLIENT_ID != null && !CLIENT_ID.isBlank()
                && CLIENT_SECRET != null && !CLIENT_SECRET.isBlank()
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
            response.sendRedirect("login.jsp?error=googleConfig");
            return;
        }

        try {
            // 1. access_token 요청
            String tokenURL = "https://oauth2.googleapis.com/token";
            String params = "code=" + code
                          + "&client_id=" + CLIENT_ID
                          + "&client_secret=" + CLIENT_SECRET
                          + "&redirect_uri=" + REDIRECT_URI
                          + "&grant_type=authorization_code";

            String tokenResponse = sendPostRequest(tokenURL, params);
            JSONObject tokenJson = new JSONObject(tokenResponse);
            String accessToken = tokenJson.getString("access_token");

            // 2. 사용자 정보 요청
            String userInfoResponse = sendGetRequest("https://www.googleapis.com/oauth2/v2/userinfo", accessToken);
            JSONObject userJson = new JSONObject(userInfoResponse);
            String email = userJson.getString("email");
            String name = userJson.getString("name");

            HttpSession session = request.getSession();
            String sessionId = (String) session.getAttribute("id");
            String sessionType = (String) session.getAttribute("userType");

            UserDAO userDao = new UserDAO();
            

            if ("Google".equals(sessionType) && email.equals(sessionId)) {
                // 동일한 Google 로그인 세션이 이미 존재함
                System.out.println("세션 로그인 상태");
                response.sendRedirect("main2.jsp");
                return;
            }
            
			 String redirect = (String)session.getAttribute("redirect");
			 System.out.println(redirect);

            if (userDao.isSocialUserExists(email, "Google")) {
                // 이미 가입한 구글 계정
            	if(userDao.showSocialAccountState(email, "Google").equals("정상")) {
		            request.changeSessionId();
            		session.setAttribute("id", email);
            		session.setAttribute("userType", "Google");
            		System.out.println("이미 가입한 계정");
            		userDao.insertLog(email, "Google", "로그인");
            		 if (redirect != null && !redirect.equals("")) {
                         response.sendRedirect(redirect);
                     } else {
                         response.sendRedirect("main2.jsp");
                     }
            	} else if(userDao.showSocialAccountState(email, "Google").equals("휴먼")) {
            		response.sendRedirect("login.jsp?error=human");
            	} else if(userDao.showSocialAccountState(email, "Google").equals("탈퇴")) {
            		response.sendRedirect("login.jsp?error=resign");
            	}
            } else {
                // 첫 가입
                request.changeSessionId();
                session.setAttribute("id", email);
                session.setAttribute("userType", "Google");
                System.out.println("첫 가입");
                response.sendRedirect("signup.jsp?social=Google");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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
