package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.UserDAO;


@WebServlet("/deleteAddr")
public class DeleteAddr extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int addrId = Integer.parseInt(request.getParameter("hiddenAddrId"));
		
		UserDAO userDao = new UserDAO();
		
		if (!userDao.deleteAddr(addrId, (String)request.getSession(false).getAttribute("id"), (String)request.getSession(false).getAttribute("userType"))) { response.sendError(409, "배송지를 삭제하지 못했습니다."); return; }
		response.sendRedirect("deliveryMn.jsp");
	}

}
