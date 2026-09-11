package Security;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

public final class RedirectSanitizer {
    public static final String DEFAULT_PATH = "/main2.jsp";

    private RedirectSanitizer() {
    }

    public static String sanitize(String candidate, String contextPath) {
        if (candidate == null || candidate.isBlank() || !candidate.equals(candidate.trim())) {
            return DEFAULT_PATH;
        }

        String decoded = candidate;
        for (int i = 0; i < 3; i++) {
            if (containsDangerousValue(decoded)) {
                return DEFAULT_PATH;
            }
            try {
                String next = URLDecoder.decode(decoded, StandardCharsets.UTF_8);
                if (next.equals(decoded)) {
                    break;
                }
                decoded = next;
            } catch (IllegalArgumentException e) {
                return DEFAULT_PATH;
            }
        }
        if (containsDangerousValue(decoded) || containsParentSegment(decoded)) {
            return DEFAULT_PATH;
        }

        try {
            URI uri = new URI(candidate);
            if (uri.isAbsolute() || uri.getRawAuthority() != null || uri.getRawFragment() != null) {
                return DEFAULT_PATH;
            }

            String path = uri.getRawPath();
            if (path == null || path.isEmpty()) {
                return DEFAULT_PATH;
            }
            if (!path.startsWith("/")) {
                path = "/" + path;
            }

            String normalizedContext = normalizeContextPath(contextPath);
            if (!normalizedContext.isEmpty()) {
                if (path.equals(normalizedContext)) {
                    path = "/";
                } else if (path.startsWith(normalizedContext + "/")) {
                    path = path.substring(normalizedContext.length());
                }
            }

            if (path.startsWith("//") || containsParentSegment(path)) {
                return DEFAULT_PATH;
            }
            return path + (uri.getRawQuery() == null ? "" : "?" + uri.getRawQuery());
        } catch (URISyntaxException e) {
            return DEFAULT_PATH;
        }
    }

    public static String escapeHtmlAttribute(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }

    private static String normalizeContextPath(String contextPath) {
        if (contextPath == null || contextPath.isBlank() || "/".equals(contextPath)) {
            return "";
        }
        return contextPath.startsWith("/") ? contextPath : "/" + contextPath;
    }

    private static boolean containsDangerousValue(String value) {
        if (value.startsWith("//") || value.indexOf('\\') >= 0
                || value.indexOf('\r') >= 0 || value.indexOf('\n') >= 0) {
            return true;
        }
        for (int i = 0; i < value.length(); i++) {
            if (Character.isISOControl(value.charAt(i))) {
                return true;
            }
        }
        int colon = value.indexOf(':');
        if (colon > 0) {
            String scheme = value.substring(0, colon);
            if (scheme.matches("[A-Za-z][A-Za-z0-9+.-]*")) {
                return true;
            }
        }
        return false;
    }

    private static boolean containsParentSegment(String value) {
        String path = value;
        int query = path.indexOf('?');
        if (query >= 0) {
            path = path.substring(0, query);
        }
        for (String segment : path.split("/", -1)) {
            if ("..".equals(segment)) {
                return true;
            }
        }
        return false;
    }
}
