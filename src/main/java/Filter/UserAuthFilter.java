package Filter;

import Security.UserRequestGuard;
import java.io.IOException;
import java.util.Set;
import javax.servlet.*;
import javax.servlet.http.*;

public class UserAuthFilter implements Filter {
    private static final Set<String> MUTATIONS = Set.of("/UserLogout", "/isPwd.jsp", "/isPwd2.jsp",
            "/addCart.jsp", "/addToCart.jsp", "/addWish.jsp", "/deleteCart.jsp", "/deleteCartItems.jsp", "/updateCart.jsp", "/deleteWish.jsp", "/nameChange.jsp", "/updateEmail.jsp", "/updateGender.jsp", "/updateBirth.jsp", "/verifyCode3.jsp", "/resign.jsp", "/insertQna.jsp", "/insertQna2.jsp", "/updateQna.jsp", "/deleteQna.jsp", "/deleteReview.jsp", "/addAddr", "/modifyAddr", "/deleteAddr", "/deleteQna");
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        if (MUTATIONS.contains(req.getServletPath())) {
            req.setCharacterEncoding("UTF-8");
            if (!UserRequestGuard.authorize(req, res)) return;
            String media = req.getContentType()==null ? "" : req.getContentType().split(";",2)[0].trim();
            boolean upload=Set.of("/insertQna.jsp","/insertQna2.jsp","/updateQna.jsp").contains(req.getServletPath());
            String expected=upload ? "multipart/form-data" : "/deleteCartItems.jsp".equals(req.getServletPath()) ? "application/json" : "application/x-www-form-urlencoded";
            if(!expected.equalsIgnoreCase(media)){res.setStatus(415);return;}
        } else if (UserRequestGuard.authenticated(req.getSession(false))) {
            UserRequestGuard.token(req.getSession(false));
        }
        try { chain.doFilter(request, response); }
        catch (RuntimeException | ServletException error) {
            if (!MUTATIONS.contains(req.getServletPath()) || res.isCommitted()) throw error;
            res.resetBuffer(); res.setStatus(400); res.setContentType("application/json; charset=UTF-8");
            res.getWriter().write("{\"result\":\"fail\"}");
        }
    }
}
