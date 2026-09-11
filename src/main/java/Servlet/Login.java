package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.UserDAO;
import Security.RedirectSanitizer;


@WebServlet("/login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserDAO userDao = new UserDAO();
		
		HttpSession session = request.getSession();
		
		String redirect = RedirectSanitizer.sanitize(
				request.getParameter("redirect"), request.getContextPath());
		
		String id = request.getParameter("userId");
		String pwd = request.getParameter("password");
		
		String result = userDao.login(id, pwd);	 //(success : 로그인 성공), (fail : 로그인 실패), (none :  아이디 존재 X), (resign : 탈퇴 아이디 로그인), (human : 휴먼 계정), (lock : 5회이상 실패로 인한 잠금)
		
		if(result.equals("success")) {	//로그인 성공
			request.changeSessionId();
			session.setAttribute("id", id);		//세션에 ID 저장
			session.setAttribute("userType", "일반");
			session.removeAttribute("redirect");
			response.sendRedirect(request.getContextPath() + redirect);
		} else if(result.equals("fail")) {		//로그인 실패
			int fail = userDao.showFailLogin(id, "일반");
			response.sendRedirect("login.jsp?error=wrong&fail=" + fail);
		} else if(result.equals("none")) {		//아이디 존재 X
			response.sendRedirect("login.jsp?error=noUser");
		} else if(result.equals("resign")) {		//탈퇴 아이디 로그인
			response.sendRedirect("login.jsp?error=resign");
		} else if(result.equals("human")) {		//휴면 계정
			response.sendRedirect("login.jsp?error=human");
		} else if(result.equals("lock")){
			response.sendRedirect("login.jsp?error=lock");
		}
	}

}
