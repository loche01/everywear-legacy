package Servlet;

import DAO.AdminDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import org.json.JSONObject;

@WebServlet("/AdminLogin")
public class AdminLogin extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 파라미터 수집
        String adminId = request.getParameter("adminId");
        String adminPwd = request.getParameter("adminPwd");
        String adminEmail = request.getParameter("adminEmail");
        String verifyCode = request.getParameter("verifyCode");

        // 2. 세션 인증코드 가져오기
        HttpSession session = request.getSession();
        String sessionCode = (String) session.getAttribute("verifyCode");

        // 3. 응답 설정
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        AdminDAO dao = new AdminDAO();

        // 4. 계정 잠금 여부 먼저 확인
        if (dao.checkLock(adminId)) {
            dao.insertLog(adminId, "잠긴계정 로그인 시도");
            json.put("success", false);
            json.put("locked", true);
            json.put("message", "계정이 잠겨있습니다. super관리자에게 문의해주세요.");
            out.print(json.toString());
            return;
        }

        // 5. 로그인 시도 (DB 비교 및 인증번호 비교 포함)
        boolean success = dao.login(adminId, adminPwd, adminEmail, verifyCode, sessionCode);

        if (success) {
            // 6. 로그인 성공
            request.changeSessionId();
            session.setAttribute("adminId", adminId);
            json.put("success", true);
            json.put("message", "로그인 성공");
        } else {
            // 7. 로그인 실패
            json.put("success", false);
            json.put("locked", false);
            json.put("message", "입력하신 정보가 일치하지 않습니다.");
        }

        out.print(json.toString());
    }
}
