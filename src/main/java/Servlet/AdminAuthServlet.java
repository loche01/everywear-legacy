package Servlet;

import DAO.AdminDAO;
import DAO.GmailSend;
import Security.VerificationGrant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.SecureRandom;

@WebServlet("/AdminAuthServlet")
public class AdminAuthServlet extends HttpServlet {

    private static final SecureRandom RANDOM = new SecureRandom();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 독립 relay endpoint 로 호출되지 않도록 요청 형태부터 제한한다.
        if (!VerificationGrant.isPostForm(request)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String adminId = VerificationGrant.single(request, "adminId");
        String email = VerificationGrant.normalizeEmail(VerificationGrant.single(request, "email"));

        if (adminId == null || adminId.isBlank() || adminId.length() > 30 || email == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
            return;
        }

        HttpSession session = request.getSession();
        if (VerificationGrant.cooldownRemaining(session) > 0) {
            response.setStatus(429);
            out.print("{\"success\": false, \"message\": \"잠시 후 다시 시도해주세요.\"}");
            return;
        }

        // 수신 주소는 요청자가 정하지 않는다. DB 에 등록된 관리자 주소와 일치할 때만 발송한다.
        if (!new AdminDAO().isVerificationRecipient(adminId, email)) {
            session.removeAttribute("verifyCode");
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"success\": false, \"message\": \"입력하신 정보가 일치하지 않습니다.\"}");
            return;
        }

        String code = String.format(java.util.Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
        try {
            // 발송 실패를 성공으로 위장하지 않는다(예외를 던지는 sendVerification 사용).
            GmailSend.sendVerification(email, code, "[everyWEAR 관리자 인증번호]");
        } catch (Exception e) {
            session.removeAttribute("verifyCode");
            getServletContext().log("Admin verification delivery failed.");
            response.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
            out.print("{\"success\": false, \"message\": \"메일 전송 실패\"}");
            return;
        }

        session.setAttribute("verifyCode", code);
        session.setMaxInactiveInterval(300); // 300초 = 5분
        VerificationGrant.markSent(session);
        out.print("{\"success\": true}");
    }
}
