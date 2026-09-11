package Servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

import org.json.JSONObject;

import DAO.UserDAO;
import Security.RedirectSanitizer;

@WebServlet("/NaverLoginServlet")
public class NaverLoginServlet extends HttpServlet {
    private static final String CLIENT_ID = System.getenv("EVERYWEAR_NAVER_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("EVERYWEAR_NAVER_CLIENT_SECRET");
    private static final String REDIRECT_URI = System.getenv("EVERYWEAR_NAVER_REDIRECT_URI");
    private static final String USER_TYPE = "Naver";
    private static final String OAUTH_STATE_SESSION_KEY = "naverOAuthState";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        HttpSession session = request.getSession(false);
        String sessionState = session == null ? null : (String) session.getAttribute(OAUTH_STATE_SESSION_KEY);

        if (request.getParameter("error") != null) {
            response.sendRedirect("login.jsp?error=naver");
            return;
        }

        if (code == null || code.isBlank() || state == null || sessionState == null
                || !state.equals(sessionState)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Naver OAuth state.");
            return;
        }
        session.removeAttribute(OAUTH_STATE_SESSION_KEY);

        if (!isConfigured()) {
            response.sendRedirect("login.jsp?error=naverConfig");
            return;
        }

        try {
            String tokenParams = "grant_type=authorization_code"
                    + "&client_id=" + encode(CLIENT_ID)
                    + "&client_secret=" + encode(CLIENT_SECRET)
                    + "&redirect_uri=" + encode(REDIRECT_URI)
                    + "&code=" + encode(code)
                    + "&state=" + encode(state);
            String tokenResponse = postForm("https://nid.naver.com/oauth2.0/token", tokenParams);
            JSONObject tokenObj = new JSONObject(tokenResponse);

            String accessToken = tokenObj.optString("access_token", "");
            if (accessToken.isBlank()) {
                response.sendRedirect("login.jsp?error=naver");
                return;
            }

            String userInfoResponse = get("https://openapi.naver.com/v1/nid/me", "Bearer " + accessToken);
            JSONObject userObj = new JSONObject(userInfoResponse);
            JSONObject res = userObj.optJSONObject("response");
            if (res == null) {
                response.sendRedirect("login.jsp?error=naver");
                return;
            }

            String providerId = res.optString("id", "").trim();
            if (providerId.isEmpty()) {
                response.sendRedirect("login.jsp?error=naver");
                return;
            }

            String id = "naver_" + providerId;
            String name = res.optString("name", "");
            String email = res.optString("email", "");
            String phone = res.optString("mobile", "");
            String gender = normalizeGender(res.optString("gender", ""));
            String birth = normalizeBirth(
                    res.optString("birthyear", ""),
                    res.optString("birthday", ""));

            UserDAO userDAO = new UserDAO();
            if (!userDAO.isSocialUserExists(id, USER_TYPE)) {
                request.changeSessionId();
                session.setAttribute("id", id);
                session.setAttribute("userType", USER_TYPE);
                setIfPresent(session, "socialName", name);
                setIfPresent(session, "socialEmail", email);
                setIfPresent(session, "socialPhone", phone);
                setIfPresent(session, "socialGender", gender);
                setIfPresent(session, "socialBirth", birth);
                response.sendRedirect("signup.jsp?social=Naver");
                return;
            }

            String accountState = userDAO.showSocialAccountState(id, USER_TYPE);
            if ("휴먼".equals(accountState)) {
                response.sendRedirect("login.jsp?error=human");
                return;
            }
            if ("탈퇴".equals(accountState)) {
                response.sendRedirect("login.jsp?error=resign");
                return;
            }
            if (!"정상".equals(accountState)) {
                response.sendRedirect("login.jsp?error=naver");
                return;
            }

            request.changeSessionId();
            session.setAttribute("id", id);
            session.setAttribute("userType", USER_TYPE);
            userDAO.insertLog(id, USER_TYPE, "로그인");

            String redirect = (String) session.getAttribute("redirect");
            session.removeAttribute("redirect");
            String safeRedirect = RedirectSanitizer.sanitize(redirect, request.getContextPath());
            response.sendRedirect(request.getContextPath() + safeRedirect);
        } catch (Exception e) {
            getServletContext().log("Naver OAuth callback failed.");
            response.sendRedirect("login.jsp?error=naver");
        }
    }

    private boolean isConfigured() {
        return CLIENT_ID != null && !CLIENT_ID.isBlank()
                && CLIENT_SECRET != null && !CLIENT_SECRET.isBlank()
                && REDIRECT_URI != null && !REDIRECT_URI.isBlank();
    }

    private String get(String apiURL, String authHeader) throws IOException {
        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
        con.setConnectTimeout(5000);
        con.setReadTimeout(5000);
        if (authHeader != null) {
            con.setRequestProperty("Authorization", authHeader);
        }

        try {
            return readResponse(con);
        } finally {
            con.disconnect();
        }
    }

    private String postForm(String apiURL, String params) throws IOException {
        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setDoOutput(true);
        con.setConnectTimeout(5000);
        con.setReadTimeout(5000);
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream output = con.getOutputStream()) {
            output.write(params.getBytes(StandardCharsets.UTF_8));
        }

        try {
            return readResponse(con);
        } finally {
            con.disconnect();
        }
    }

    private String readResponse(HttpURLConnection con) throws IOException {
        int responseCode = con.getResponseCode();
        InputStream stream = responseCode >= 200 && responseCode < 300
                ? con.getInputStream() : con.getErrorStream();
        if (stream == null) {
            return "";
        }

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            return response.toString();
        }
    }

    private String encode(String value) throws UnsupportedEncodingException {
        return URLEncoder.encode(value, StandardCharsets.UTF_8.name());
    }

    private String normalizeGender(String gender) {
        if ("M".equalsIgnoreCase(gender)) {
            return "남자";
        }
        if ("F".equalsIgnoreCase(gender)) {
            return "여자";
        }
        return "";
    }

    private String normalizeBirth(String year, String monthAndDay) {
        if (year.matches("\\d{4}") && monthAndDay.matches("\\d{2}-\\d{2}")) {
            return year + "-" + monthAndDay;
        }
        return "";
    }

    private void setIfPresent(HttpSession session, String key, String value) {
        if (value != null && !value.isBlank()) {
            session.setAttribute(key, value);
        } else {
            session.removeAttribute(key);
        }
    }
}
