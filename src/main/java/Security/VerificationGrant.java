package Security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.HexFormat;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 회원가입 / 아이디 찾기 / 전화번호 변경 본인확인 OTP 상태를 관리한다.
 * PasswordResetGrant(비밀번호 재설정·잠금해제)와 같은 계약을 따르되,
 * 대상이 회원 계정이 아니라 purpose + recipient(전화번호·이메일) 조합이다.
 * 공용 세션 authCode 는 사용하지 않는다.
 */
public final class VerificationGrant {
    public static final String SIGNUP_PHONE = "SIGNUP_PHONE";
    public static final String FIND_ID_PHONE = "FIND_ID_PHONE";
    public static final String FIND_ID_EMAIL = "FIND_ID_EMAIL";
    public static final String CHANGE_PHONE = "CHANGE_PHONE";

    public static final String GRANT_PARAMETER = "otpGrant";
    public static final int EMAIL_MAX_LENGTH = 100;

    private static final long TTL = 5 * 60 * 1000L;
    private static final long COOLDOWN = 60 * 1000L;
    private static final int MAX_ATTEMPTS = 5;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final String COOLDOWN_KEY = "otpLastSentAt";
    private static final String[] KEYS = {"otpPurpose", "otpRecipient", "otpDigest", "otpExpiry", "otpAttempts",
            "otpGrantPurpose", "otpGrantRecipient", "otpGrantDigest", "otpGrantExpiry"};

    private VerificationGrant() { }

    /**
     * POST + query-string 금지 + form 인코딩. 비로그인 흐름의 구조적 가드.
     * 전체 파라미터 단일값 강제는 하지 않는다. 회원가입 폼처럼 같은 이름의 체크박스를
     * 여러 개 두는 정상 화면이 있기 때문이다. 보안상 중요한 파라미터는 single() 로 개별 확인한다.
     */
    public static boolean isPostForm(HttpServletRequest request) {
        String type = request.getContentType();
        return "POST".equals(request.getMethod()) && request.getQueryString() == null
                && type != null && "application/x-www-form-urlencoded".equalsIgnoreCase(type.split(";", 2)[0].trim());
    }

    /** 보안상 중요한 파라미터는 정확히 1개만 허용한다. 중복·누락은 null. */
    public static String single(HttpServletRequest request, String name) {
        String[] values = request.getParameterValues(name);
        return values != null && values.length == 1 ? values[0] : null;
    }

    /** 한국 휴대전화만 허용하고 canonical form(01012345678)으로 정규화한다. */
    public static String normalizePhone(String raw) {
        if (raw == null) return null;
        String value = raw.trim().replace("-", "").replace(" ", "");
        return value.matches("010[0-9]{8}") ? value : null;
    }

    /** 단일 mailbox 만 허용하고 소문자로 정규화한다. CR/LF/제어문자는 거부한다. */
    public static String normalizeEmail(String raw, int maxLength) {
        if (raw == null) return null;
        String value = raw.trim();
        if (value.isEmpty() || value.length() > maxLength) return null;
        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);
            if (c < 0x20 || c == 0x7F) return null;
        }
        value = value.toLowerCase(java.util.Locale.ROOT);
        return value.matches("[^\\s@]+@[^\\s@]+\\.[^\\s@]+") ? value : null;
    }

    public static String normalizeEmail(String raw) {
        return normalizeEmail(raw, EMAIL_MAX_LENGTH);
    }

    public static String normalizeRecipient(String purpose, String raw) {
        if (FIND_ID_EMAIL.equals(purpose)) return normalizeEmail(raw);
        if (validPurpose(purpose)) return normalizePhone(raw);
        return null;
    }

    public static boolean validPurpose(String purpose) {
        return SIGNUP_PHONE.equals(purpose) || FIND_ID_PHONE.equals(purpose)
                || FIND_ID_EMAIL.equals(purpose) || CHANGE_PHONE.equals(purpose);
    }

    /** 같은 세션의 연속 발송을 억제한다. 남은 대기 시간(ms)을 돌려준다. */
    public static long cooldownRemaining(HttpSession session) {
        if (session == null) return 0L;
        Object last = session.getAttribute(COOLDOWN_KEY);
        if (!(last instanceof Long)) return 0L;
        long elapsed = System.currentTimeMillis() - (Long) last;
        return elapsed >= COOLDOWN || elapsed < 0 ? 0L : COOLDOWN - elapsed;
    }

    /** 발송이 실제로 성공한 뒤에만 호출한다. */
    public static void markSent(HttpSession session) {
        if (session != null) session.setAttribute(COOLDOWN_KEY, System.currentTimeMillis());
    }

    /** pending OTP 를 새로 만들고 평문 코드를 돌려준다. 코드는 발송에만 쓰고 응답에 넣지 않는다. */
    public static String begin(HttpSession session, String purpose, String recipient) {
        if (session == null || !validPurpose(purpose) || recipient == null || recipient.isBlank())
            throw new IllegalArgumentException("Invalid verification request.");
        synchronized (session) {
            clear(session);
            String otp = String.format(java.util.Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
            session.setAttribute("otpPurpose", purpose);
            session.setAttribute("otpRecipient", recipient);
            session.setAttribute("otpDigest", digest(otp));
            session.setAttribute("otpExpiry", System.currentTimeMillis() + TTL);
            session.setAttribute("otpAttempts", 0);
            return otp;
        }
    }

    /** 성공하면 pending OTP 를 즉시 소비하고 verified grant token 을 돌려준다. */
    public static String verify(HttpSession session, String purpose, String recipient, String otp) {
        if (session == null) return null;
        synchronized (session) {
            if (!pendingMatches(session, purpose, recipient) || !unexpired(session, "otpExpiry")) return null;
            Object stored = session.getAttribute("otpDigest");
            Object count = session.getAttribute("otpAttempts");
            if (!(stored instanceof byte[]) || !(count instanceof Integer)) return null;
            int attempts = (Integer) count + 1;
            session.setAttribute("otpAttempts", attempts);
            if (attempts > MAX_ATTEMPTS || otp == null || !otp.matches("[0-9]{6}")
                    || !MessageDigest.isEqual((byte[]) stored, digest(otp))) {
                if (attempts >= MAX_ATTEMPTS) clear(session);
                return null;
            }
            session.removeAttribute("otpDigest");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("otpAttempts");
            session.removeAttribute("otpPurpose");
            session.removeAttribute("otpRecipient");
            byte[] random = new byte[32];
            RANDOM.nextBytes(random);
            String token = HexFormat.of().formatHex(random);
            session.setAttribute("otpGrantPurpose", purpose);
            session.setAttribute("otpGrantRecipient", recipient);
            session.setAttribute("otpGrantDigest", digest(token));
            session.setAttribute("otpGrantExpiry", System.currentTimeMillis() + TTL);
            return token;
        }
    }

    /** 최종 mutation 에서 호출한다. 성공하면 grant 는 즉시 폐기되어 재사용할 수 없다. */
    public static boolean consume(HttpServletRequest request, String purpose, String recipient) {
        if (!isPostForm(request)) return false;
        HttpSession session = request.getSession(false);
        return consumeToken(session, purpose, recipient, single(request, GRANT_PARAMETER));
    }

    public static boolean consumeToken(HttpSession session, String purpose, String recipient, String token) {
        if (session == null) return false;
        synchronized (session) {
            Object stored = session.getAttribute("otpGrantDigest");
            if (!grantMatches(session, purpose, recipient) || !unexpired(session, "otpGrantExpiry")
                    || token == null || !token.matches("[0-9a-f]{64}") || !(stored instanceof byte[])
                    || !MessageDigest.isEqual((byte[]) stored, digest(token))) return false;
            clear(session);
            return true;
        }
    }

    /** pending OTP 와 verified grant 를 모두 제거한다. 재발송 쿨다운 기록은 남긴다. */
    public static void clear(HttpSession session) {
        if (session != null) synchronized (session) { for (String key : KEYS) session.removeAttribute(key); }
    }

    private static boolean pendingMatches(HttpSession session, String purpose, String recipient) {
        return validPurpose(purpose) && purpose.equals(session.getAttribute("otpPurpose"))
                && recipient != null && recipient.equals(session.getAttribute("otpRecipient"));
    }

    private static boolean grantMatches(HttpSession session, String purpose, String recipient) {
        return validPurpose(purpose) && purpose.equals(session.getAttribute("otpGrantPurpose"))
                && recipient != null && recipient.equals(session.getAttribute("otpGrantRecipient"));
    }

    private static boolean unexpired(HttpSession session, String key) {
        Object expiry = session.getAttribute(key);
        return expiry instanceof Long && System.currentTimeMillis() < (Long) expiry;
    }

    private static byte[] digest(String value) {
        try { return MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8)); }
        catch (NoSuchAlgorithmException e) { throw new IllegalStateException("Verification unavailable."); }
    }
}
