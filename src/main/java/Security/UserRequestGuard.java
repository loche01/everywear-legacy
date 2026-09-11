package Security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.HexFormat;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public final class UserRequestGuard {
    private static final SecureRandom RANDOM = new SecureRandom();
    private UserRequestGuard() { }

    public static boolean authenticated(HttpSession session) {
        if (session == null) return false;
        Object id = session.getAttribute("id"), type = session.getAttribute("userType");
        return id instanceof String && !((String) id).isBlank()
                && type instanceof String && !((String) type).isBlank();
    }

    public static String token(HttpSession session) {
        if (!authenticated(session)) return "";
        synchronized (session) {
            Object existing = session.getAttribute("userCsrfToken");
            if (existing instanceof String && ((String) existing).matches("[0-9a-f]{64}")) return (String) existing;
            byte[] bytes = new byte[32];
            RANDOM.nextBytes(bytes);
            String value = HexFormat.of().formatHex(bytes);
            session.setAttribute("userCsrfToken", value);
            return value;
        }
    }

    public static boolean validToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (!authenticated(session) || request.getQueryString() != null) return false;
        Object expected = session.getAttribute("userCsrfToken");
        if (!(expected instanceof String)) return false;
        String type = request.getContentType();
        if (type == null) return false;
        String media = type.split(";", 2)[0].trim();
        if ("multipart/form-data".equalsIgnoreCase(media) || "application/json".equalsIgnoreCase(media)) {
            java.util.Enumeration<String> headers = request.getHeaders("X-User-CSRF-Token");
            if (headers == null || !headers.hasMoreElements()) return false;
            String value = headers.nextElement();
            return !headers.hasMoreElements() && value != null && value.matches("[0-9a-f]{64}")
                    && MessageDigest.isEqual(((String) expected).getBytes(StandardCharsets.US_ASCII), value.getBytes(StandardCharsets.US_ASCII));
        }
        if (!"application/x-www-form-urlencoded".equalsIgnoreCase(media)) return false;
        for (String[] item : request.getParameterMap().values()) if (item == null || item.length != 1) return false;
        String[] values = request.getParameterValues("userCsrfToken");
        if (values == null || values.length != 1 || values[0] == null || !values[0].matches("[0-9a-f]{64}")) return false;
        return MessageDigest.isEqual(((String) expected).getBytes(StandardCharsets.US_ASCII), values[0].getBytes(StandardCharsets.US_ASCII));
    }

    public static boolean authorize(HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-store");
        if (!"POST".equals(request.getMethod())) {
            response.setHeader("Allow", "POST"); response.setStatus(405); return false;
        }
        if (!authenticated(request.getSession(false))) { response.setStatus(401); return false; }
        if (!validToken(request)) { response.setStatus(403); return false; }
        return true;
    }
}
