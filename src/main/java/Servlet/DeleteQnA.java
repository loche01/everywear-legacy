package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.QnaDAO;

/**
 * Servlet implementation class DeleteQnA
 */
@WebServlet("/deleteQna")
public class DeleteQnA extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			String i_id = request.getParameter("i_id");
			
			QnaDAO qDao = new QnaDAO();
			
			if (!qDao.deleteQna(Integer.parseInt(i_id), (String)request.getSession(false).getAttribute("id"), (String)request.getSession(false).getAttribute("userType"), request)) { response.sendError(409, "게시물을 삭제하지 못했습니다."); return; }
			
			response.sendRedirect("Q&A.jsp");
	}


}
