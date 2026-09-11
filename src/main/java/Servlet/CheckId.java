package Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.UserDAO;

@WebServlet("/checkId")
public class CheckId extends HttpServlet {

	    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	        String userId = request.getParameter("userId");
	        response.setContentType("text/plain;charset=UTF-8");

	        PrintWriter out = response.getWriter();
	        
	        UserDAO userDao = new UserDAO();
	       

	        if (userId == null || userId.trim().isEmpty()) {
	            out.print("아이디를 입력하세요.");
	        } else if (userDao.idCheck(userId)) {
	            out.print("이미 사용 중인 아이디입니다.");
	        } else {
	            out.print("사용 가능한 아이디입니다!");
	        }
	    }

}
