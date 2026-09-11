package Filter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.HexFormat;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminAuthFilter implements Filter {
    private static final String CSRF_TOKEN = "adminCsrfToken";
    private static final SecureRandom CSRF_RANDOM = new SecureRandom();
    private static final Set<String> CSRF_PROTECTED_PATHS = Set.of(
            "/admin_update_payment_status.jsp",
            "/admin_update_tracking.jsp",
            "/admin_update_delivery_status.jsp",
            "/admin_create_refund.jsp",
            "/admin_update_refund_status.jsp");

    private static final Set<String> PROTECTED_SERVLETS = Set.of(
            "/AdminProductServlet",
            "/ProductServlet",
            "/NoticeServlet",
            "/AdminLogout");

    private static final Set<String> UNAUTHORIZED_RESPONSE_PATHS = Set.of(
            "/admin_order_modal.jsp",
            "/crm/basic.jsp",
            "/crm/detail.jsp",
            "/crm/delivery.jsp",
            "/crm/post.jsp",
            "/crm/deliveryDelete.jsp",
            "/crm/updateUserInfo.jsp");

    // CRM 관리자 화면 중 순수 mutation 경로: POST + 관리자 CSRF 필수, GET/기타는 405.
    private static final Set<String> CRM_MUTATION_PATHS = Set.of(
            "/crm/deliveryDelete.jsp",
            "/crm/updateUserInfo.jsp");

    // CRM 관리자 화면 중 GET 화면 + POST mutation 혼합 경로: GET 화면 유지, POST mutation만 CSRF.
    private static final Set<String> CRM_MIXED_PATHS = Set.of(
            "/crm/deliveryAdd.jsp",
            "/crm/deliveryModify.jsp");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getServletPath();

        if (!isProtectedPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        Object adminIdValue = session == null ? null : session.getAttribute("adminId");
        boolean authenticated = adminIdValue instanceof String
                && !((String) adminIdValue).trim().isEmpty();

        if (authenticated) {
            if ("/withdrawalDetail.jsp".equals(path)) {
                httpResponse.setHeader("Cache-Control", "no-store");
                httpRequest.setCharacterEncoding("UTF-8");
                String method = httpRequest.getMethod();
                if (!"GET".equals(method) && !"HEAD".equals(method) && !"POST".equals(method)) {
                    httpResponse.setHeader("Allow", "GET, HEAD, POST");
                    httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }
                String[] actions = httpRequest.getParameterValues("action");
                if (actions != null && actions.length != 1) {
                    httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                String action = actions == null ? null : actions[0];
                if (!"POST".equals(method)) {
                    if ("restore".equals(action)) {
                        httpResponse.setHeader("Allow", "POST");
                        httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                        return;
                    }
                    if (action != null) {
                        httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                    ensureCsrfToken(session);
                } else {
                    if (!"restore".equals(action)) {
                        httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                    String type = httpRequest.getContentType();
                    if (type == null || !"application/x-www-form-urlencoded".equalsIgnoreCase(type.split(";", 2)[0].trim())
                            || !hasValidCsrfToken(httpRequest, session)) {
                        httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                }
                chain.doFilter(request, response);
                return;
            }
            if ("/NoticeServlet".equals(path)) {
                httpRequest.setCharacterEncoding("UTF-8");
                String method = httpRequest.getMethod();
                if (!"GET".equals(method) && !"HEAD".equals(method) && !"POST".equals(method)) {
                    httpResponse.setHeader("Allow", "GET, HEAD, POST");
                    httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }
                String[] actions = httpRequest.getParameterValues("action");
                if (actions != null && actions.length != 1) {
                    httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                String action = actions == null ? null : actions[0];
                boolean mutation = "insert".equals(action) || "update".equals(action)
                        || "delete".equals(action) || "updateStatus".equals(action);
                if (!"POST".equals(method)) {
                    if (mutation) {
                        httpResponse.setHeader("Allow", "POST");
                        httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                        return;
                    }
                    if (action != null && !"getContent".equals(action)) {
                        httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                } else {
                    if (!mutation) {
                        httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                    String type = httpRequest.getContentType();
                    if (type == null || !"application/x-www-form-urlencoded".equalsIgnoreCase(type.split(";", 2)[0].trim())
                            || !hasValidCsrfToken(httpRequest, session)) {
                        httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                }
                ensureCsrfToken(session);
                chain.doFilter(request, response);
                return;
            }
            if ("/ProductServlet".equals(path)) {
                String method = httpRequest.getMethod();
                String action = httpRequest.getParameter("action");
                boolean isMutation = "insert".equals(action) || "update".equals(action)
                        || "delete".equals(action);
                if ("GET".equals(method) || "HEAD".equals(method)) {
                    if (isMutation) {
                        httpResponse.setHeader("Allow", "POST");
                        httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                        return;
                    }
                } else if ("POST".equals(method)) {
                    if (!isMutation) {
                        httpResponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                    if (!hasValidCsrfToken(httpRequest, session)) {
                        httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        httpResponse.setCharacterEncoding("UTF-8");
                        httpResponse.setContentType("text/plain; charset=UTF-8");
                        httpResponse.getWriter().write("요청을 확인할 수 없습니다. 화면을 새로고침한 뒤 다시 시도해주세요.");
                        return;
                    }
                } else {
                    httpResponse.setHeader("Allow", "GET, POST");
                    httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }
                ensureCsrfToken(session);
                chain.doFilter(request, response);
                return;
            }
            if (CRM_MUTATION_PATHS.contains(path)) {
                httpResponse.setHeader("Cache-Control", "no-store");
                httpRequest.setCharacterEncoding("UTF-8");
                if (!"POST".equals(httpRequest.getMethod())) {
                    httpResponse.setHeader("Allow", "POST");
                    httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }
                String type = httpRequest.getContentType();
                if (type == null
                        || !"application/x-www-form-urlencoded".equalsIgnoreCase(type.split(";", 2)[0].trim())
                        || !hasValidCsrfToken(httpRequest, session)) {
                    httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                ensureCsrfToken(session);
                chain.doFilter(request, response);
                return;
            }
            if (CRM_MIXED_PATHS.contains(path)) {
                httpResponse.setHeader("Cache-Control", "no-store");
                httpRequest.setCharacterEncoding("UTF-8");
                String method = httpRequest.getMethod();
                if ("GET".equals(method) || "HEAD".equals(method)) {
                    ensureCsrfToken(session);
                    chain.doFilter(request, response);
                    return;
                }
                if (!"POST".equals(method)) {
                    httpResponse.setHeader("Allow", "GET, POST");
                    httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }
                String type = httpRequest.getContentType();
                if (type == null
                        || !"application/x-www-form-urlencoded".equalsIgnoreCase(type.split(";", 2)[0].trim())
                        || !hasValidCsrfToken(httpRequest, session)) {
                    httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                ensureCsrfToken(session);
                chain.doFilter(request, response);
                return;
            }
            if ("/crm/reviewAdmin.jsp".equals(path)) {
                // review_comment / review_report 미복구로 관리자 리뷰 상세관리는 Legacy 에서 안전 비활성화한다.
                httpResponse.setHeader("Cache-Control", "no-store");
                String method = httpRequest.getMethod();
                if ("GET".equals(method) || "HEAD".equals(method)) {
                    chain.doFilter(request, response);
                    return;
                }
                httpResponse.setHeader("Allow", "GET");
                httpResponse.setStatus(410); // Gone
                httpResponse.setCharacterEncoding("UTF-8");
                httpResponse.setContentType("text/plain; charset=UTF-8");
                httpResponse.getWriter().write("Legacy 복구 범위에서 관리자 리뷰 상세관리는 지원하지 않습니다.");
                return;
            }
            if (CSRF_PROTECTED_PATHS.contains(path)) {
                if (!"POST".equals(httpRequest.getMethod())) {
                    httpResponse.setHeader("Allow", "POST");
                    httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                    return;
                }
                if ("/admin_create_refund.jsp".equals(path)
                        || "/admin_update_refund_status.jsp".equals(path)) {
                    httpRequest.setCharacterEncoding("UTF-8");
                }
                if (!hasValidCsrfToken(httpRequest, session)) {
                    httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    httpResponse.setCharacterEncoding("UTF-8");
                    httpResponse.setContentType("text/plain; charset=UTF-8");
                    httpResponse.getWriter().write("요청을 확인할 수 없습니다. 화면을 새로고침한 뒤 다시 시도해주세요.");
                    return;
                }
            } else {
                ensureCsrfToken(session);
            }
            chain.doFilter(request, response);
            return;
        }

        if (requiresUnauthorizedResponse(httpRequest, path)) {
            httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            httpResponse.setCharacterEncoding("UTF-8");
            httpResponse.setContentType("text/plain; charset=UTF-8");
            httpResponse.getWriter().write("관리자 인증이 필요합니다.");
            return;
        }

        httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin_login.jsp");
    }

    private void ensureCsrfToken(HttpSession session) {
        synchronized (session) {
            if (!(session.getAttribute(CSRF_TOKEN) instanceof String)) {
                byte[] bytes = new byte[32];
                CSRF_RANDOM.nextBytes(bytes);
                session.setAttribute(CSRF_TOKEN, HexFormat.of().formatHex(bytes));
            }
        }
    }

    private boolean hasValidCsrfToken(HttpServletRequest request, HttpSession session) {
        // These endpoints accept form bodies only; never accept a token from the URL.
        String query = request.getQueryString();
        String contentType = request.getContentType();
        if (query != null && !query.isEmpty() || contentType == null) {
            return false;
        }
        String media = contentType.split(";", 2)[0].trim();
        if (!"application/x-www-form-urlencoded".equalsIgnoreCase(media)
                && !"multipart/form-data".equalsIgnoreCase(media)) {
            return false;
        }
        Object expected = session.getAttribute(CSRF_TOKEN);
        String[] supplied = request.getParameterValues(CSRF_TOKEN);
        if (!(expected instanceof String) || supplied == null || supplied.length != 1
                || supplied[0] == null || !supplied[0].matches("[0-9a-f]{64}")) {
            return false;
        }
        return MessageDigest.isEqual(((String) expected).getBytes(StandardCharsets.US_ASCII),
                supplied[0].getBytes(StandardCharsets.US_ASCII));
    }

    private boolean isProtectedPath(String path) {
        if (path == null || path.isEmpty()) {
            return false;
        }

        if ("/withdrawalDetail.jsp".equals(path) || PROTECTED_SERVLETS.contains(path)) {
            return true;
        }

        if (path.startsWith("/admin_") && path.endsWith(".jsp")) {
            return !"/admin_login.jsp".equals(path);
        }

        if (path.startsWith("/includes/admin_") && path.endsWith(".jsp")) {
            return true;
        }

        return path.startsWith("/crm/") && path.endsWith(".jsp");
    }

    private boolean requiresUnauthorizedResponse(HttpServletRequest request, String path) {
        String method = request.getMethod();
        boolean safeMethod = "GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method);

        if (!safeMethod || CSRF_PROTECTED_PATHS.contains(path)
                || path.startsWith("/admin_update_") || "/AdminLogout".equals(path)) {
            return true;
        }

        if ("/ProductServlet".equals(path) && "delete".equals(request.getParameter("action"))) {
            return true;
        }

        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(requestedWith)) {
            return true;
        }

        return UNAUTHORIZED_RESPONSE_PATHS.contains(path);
    }

    @Override
    public void destroy() {
    }
}
