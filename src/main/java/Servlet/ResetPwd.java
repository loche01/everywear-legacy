package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.UserDAO;
import Security.PasswordResetGrant;


@WebServlet("/resetPwd")
public class ResetPwd extends HttpServlet {
	private static final long serialVersionUID = 1L;


	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (!"POST".equals(request.getMethod())) {
			response.setHeader("Allow", "POST");
			response.setStatus(405);
			return;
		}
		super.service(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-store");
		String id = PasswordResetGrant.consume(request, PasswordResetGrant.FORGOT);
		if (id == null) { response.sendError(403, "비밀번호 재설정 인증이 필요합니다."); return; }
		String pwd = request.getParameter("newPassword");
		if (!PasswordResetGrant.validPassword(pwd, request.getParameter("confirmPassword"))) {
			response.sendError(400, "새 비밀번호를 확인해주세요."); return;
		}
		if (!new UserDAO().updatePwd(id, pwd)) {
			response.sendError(409, "비밀번호를 변경하지 못했습니다. 다시 인증해주세요."); return;
		}
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}

}
