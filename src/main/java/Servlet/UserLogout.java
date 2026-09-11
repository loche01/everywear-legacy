package Servlet;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Security.UserRequestGuard;

@WebServlet("/UserLogout")
public class UserLogout extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        if (!UserRequestGuard.authorize(request, response)) return;
        request.getSession(false).invalidate();
        response.sendRedirect(request.getContextPath() + "/main2.jsp");
    }
}
