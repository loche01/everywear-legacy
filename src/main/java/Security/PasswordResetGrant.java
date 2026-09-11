package Security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.HexFormat;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class PasswordResetGrant {
    public static final String FORGOT = "FORGOT";
    public static final String UNLOCK = "UNLOCK";
    private static final long TTL = 5 * 60 * 1000L;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final String[] KEYS = {"pwdResetUserId", "pwdResetUserType", "pwdResetFlow",
            "pwdResetOtpDigest", "pwdResetOtpExpiry", "pwdResetOtpAttempts",
            "pwdResetTokenDigest", "pwdResetExpiry"};

    private PasswordResetGrant() { }

    public static boolean isPostForm(HttpServletRequest request) {
        String type = request.getContentType();
        if (!"POST".equals(request.getMethod()) || request.getQueryString() != null
                || type == null || !"application/x-www-form-urlencoded".equalsIgnoreCase(type.split(";", 2)[0].trim())) return false;
        for (String[] values : request.getParameterMap().values()) {
            if (values == null || values.length != 1 || values[0] == null) return false;
        }
        return true;
    }

    public static String begin(HttpSession session, String id, String flow) {
        if (session == null || id == null || id.isBlank() || id.length() > 30 || !validFlow(flow))
            throw new IllegalArgumentException("Invalid reset request.");
        synchronized (session) {
            clear(session);
            String otp = String.format(java.util.Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
            session.setAttribute("pwdResetUserId", id);
            session.setAttribute("pwdResetUserType", "일반");
            session.setAttribute("pwdResetFlow", flow);
            session.setAttribute("pwdResetOtpDigest", digest(otp));
            session.setAttribute("pwdResetOtpExpiry", System.currentTimeMillis() + TTL);
            session.setAttribute("pwdResetOtpAttempts", 0);
            return otp;
        }
    }

    public static String verify(HttpSession session, String flow, String id, String otp) {
        if (session == null) return null;
        synchronized (session) {
            if (!matches(session, flow, id) || !unexpired(session, "pwdResetOtpExpiry")) return null;
            Object stored = session.getAttribute("pwdResetOtpDigest");
            Object count = session.getAttribute("pwdResetOtpAttempts");
            if (!(stored instanceof byte[]) || !(count instanceof Integer)) return null;
            int attempts = (Integer) count + 1;
            session.setAttribute("pwdResetOtpAttempts", attempts);
            if (attempts > 5 || otp == null || !otp.matches("[0-9]{6}")
                    || !MessageDigest.isEqual((byte[]) stored, digest(otp))) {
                if (attempts >= 5) clear(session);
                return null;
            }
            session.removeAttribute("pwdResetOtpDigest");
            session.removeAttribute("pwdResetOtpExpiry");
            session.removeAttribute("pwdResetOtpAttempts");
            byte[] random = new byte[32];
            RANDOM.nextBytes(random);
            String token = HexFormat.of().formatHex(random);
            session.setAttribute("pwdResetTokenDigest", digest(token));
            session.setAttribute("pwdResetExpiry", System.currentTimeMillis() + TTL);
            return token;
        }
    }

    public static String consume(HttpServletRequest request, String flow) {
        if (!isPostForm(request)) return null;
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        synchronized (session) {
            String id = request.getParameter("userId");
            String token = request.getParameter("resetToken");
            Object stored = session.getAttribute("pwdResetTokenDigest");
            if (!matches(session, flow, id) || !unexpired(session, "pwdResetExpiry")
                    || token == null || !token.matches("[0-9a-f]{64}") || !(stored instanceof byte[])
                    || !MessageDigest.isEqual((byte[]) stored, digest(token))) return null;
            String target = (String) session.getAttribute("pwdResetUserId");
            clear(session);
            return target;
        }
    }

    public static boolean validPassword(String value, String confirmation) {
        return value != null && value.equals(confirmation) && value.length() >= 4 && value.length() <= 16
                && value.chars().anyMatch(c -> "!@#$%^&*(),.?\":{}|<>".indexOf(c) >= 0);
    }

    public static void clear(HttpSession session) {
        if (session != null) synchronized (session) { for (String key : KEYS) session.removeAttribute(key); }
    }

    private static boolean validFlow(String flow) { return FORGOT.equals(flow) || UNLOCK.equals(flow); }
    private static boolean matches(HttpSession session, String flow, String id) {
        return validFlow(flow) && flow.equals(session.getAttribute("pwdResetFlow"))
                && "일반".equals(session.getAttribute("pwdResetUserType"))
                && id != null && id.equals(session.getAttribute("pwdResetUserId"));
    }
    private static boolean unexpired(HttpSession session, String key) {
        Object expiry = session.getAttribute(key);
        return expiry instanceof Long && System.currentTimeMillis() < (Long) expiry;
    }
    private static byte[] digest(String value) {
        try { return MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8)); }
        catch (NoSuchAlgorithmException e) { throw new IllegalStateException("Reset verification unavailable."); }
    }
}
