package Servlet;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.GmailSend;
import DAO.UserDAO;
import DTO.UserAddrDTO;
import DTO.UserDTO;
import Security.VerificationGrant;

@WebServlet("/signup")
public class Signup extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();

		UserDAO userDao = new UserDAO();

		String type = "일반";
		if(session.getAttribute("userType")!=null)
			type = (String)session.getAttribute("userType");

		String id = null;
		if(VerificationGrant.single(request, "userId") == null)
			id = (String)session.getAttribute("id");
		else
			id = VerificationGrant.single(request, "userId");

		String pwd = VerificationGrant.single(request, "password");

		String name = VerificationGrant.single(request, "name");
		String email = "";

		if(VerificationGrant.single(request, "email") != null)
			email = VerificationGrant.single(request, "email");
		else if(!"일반".equals(type))
			email = (String)session.getAttribute("id");

		String referrerId = request.getParameter("referrer");
		String zipcode = request.getParameter("zipcode");
		String road = request.getParameter("address1");
		String detail = request.getParameter("address2");
		String gender = request.getParameter("gender");

		// 휴대전화 본인확인: 최종 제출된 번호로 발급·검증된 1회용 grant 가 있어야만 가입시킨다.
		String phone1 = VerificationGrant.single(request, "phone1");
		String phone2 = VerificationGrant.single(request, "phone2");
		String phone3 = VerificationGrant.single(request, "phone3");
		String canonicalPhone = phone1 == null || phone2 == null || phone3 == null
				? null : VerificationGrant.normalizePhone(phone1 + phone2 + phone3);

		Integer height = parseBounded(VerificationGrant.single(request, "height"), 0, 300);
		Integer weight = parseBounded(VerificationGrant.single(request, "weight"), 0, 500);
		String birth = normalizeBirth(VerificationGrant.single(request, "year"),
				VerificationGrant.single(request, "month"), VerificationGrant.single(request, "day"));

		if (id == null || id.isBlank() || id.length() > 30
				|| name == null || name.isBlank() || name.length() > 10
				|| ("일반".equals(type) && (pwd == null || pwd.isBlank()))
				|| (email != null && !email.isBlank() && VerificationGrant.normalizeEmail(email) == null)
				|| canonicalPhone == null || birth == null || height == null || weight == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "입력값이 올바르지 않습니다.");
			return;
		}

		if (!VerificationGrant.consume(request, VerificationGrant.SIGNUP_PHONE, canonicalPhone)) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "휴대전화 본인확인이 필요합니다.");
			return;
		}

		String phone = canonicalPhone.substring(0, 3) + "-" + canonicalPhone.substring(3, 7)
				+ "-" + canonicalPhone.substring(7);
		String marketing = "N";
		if(request.getParameter("marketing") != null)
			marketing = "Y";


		UserDTO user = new UserDTO();
		user.setUser_id(id);
		user.setUser_pwd(pwd);
		user.setUser_type(type);
		user.setUser_name(name);
		user.setUser_birth(birth);
		user.setUser_gender(gender);
		user.setUser_height(height);
		user.setUser_weight(weight);
		user.setUser_email(email);
		user.setUser_phone(phone);
		user.setUser_marketing_state(marketing);
		user.setUser_point(0);
		
		UserAddrDTO userAddr = new UserAddrDTO();
		userAddr.setAddr_zipcode(zipcode);
		userAddr.setAddr_road(road);
		userAddr.setAddr_detail(detail);
		
		try {
			userDao.registerUser(user, userAddr, referrerId);
		} catch (SQLException e) {
			getServletContext().log("Signup transaction failed.");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
					"회원가입 처리에 실패했습니다.");
			return;
		}
		
		if(email != null && !email.trim().isEmpty()) {
		GmailSend mail = new GmailSend();
		String title = "Welcome to everyWEAR 👟";
		String content = "<html><body>"
			    + "지금, 당신의 스타일이 달라집니다.<br><br>"
			    + "<strong>everyWEAR에 오신 걸 진심으로 환영합니다 🎉</strong><br><br>"
			    + "회원가입이 완료되었어요!<br>"
			    + "앞으로 everyWEAR만의 감각적인 스타일과 특별한 혜택을<br>"
			    + "가장 먼저 만나보실 수 있습니다.<br><br>"
			    + "매주 업데이트되는 유니섹스 아이템,<br>"
			    + "회원 전용 할인과 이벤트,<br>"
			    + "그리고 당신만을 위한 스타일 큐레이션까지!<br><br>"
			    + "매일의 옷장을 더 설레게 만들 새로운 선택들.<br>"
			    + "이제, everyWEAR와 함께 시작해보세요 🖤<br><br>"
			    + "🖤 감각적인 유니섹스 신상품<br>"
			    + "🖤 전용 할인 쿠폰 및 시즌 이벤트<br>"
			    + "🖤 나만을 위한 스타일 추천 서비스<br><br>"
			    + "당신의 일상에 스타일을 더하는 브랜드,<br>"
			    + "<strong>everyWEAR</strong>가 함께하겠습니다.<br><br>"
			    + "Stay trendy,<br>"
			    + "<strong>everyWEAR</strong>"
			    + "</body></html>";
		
			mail.send(title, content, email);
		}

		
		response.sendRedirect("login.jsp");
	}

	// 비숫자·범위초과 입력에서 HTTP 500 이 나지 않도록 안전하게 파싱한다. 빈 값은 0.
	private static Integer parseBounded(String raw, int min, int max) {
		if (raw == null || raw.isBlank()) return 0;
		String value = raw.trim();
		if (!value.matches("[0-9]{1,4}")) return null;
		int parsed = Integer.parseInt(value);
		return parsed < min || parsed > max ? null : parsed;
	}

	// 기존 저장 형식(yyyy-MM-dd, 한 자리는 0 패딩)을 유지하면서 실재하는 날짜만 허용한다.
	private static String normalizeBirth(String year, String month, String day) {
		if (year == null || month == null || day == null
				|| !year.matches("[0-9]{4}") || !month.matches("[0-9]{1,2}") || !day.matches("[0-9]{1,2}")) return null;
		try {
			java.time.LocalDate birth = java.time.LocalDate.of(Integer.parseInt(year),
					Integer.parseInt(month), Integer.parseInt(day));
			if (birth.getYear() < 1900 || birth.isAfter(java.time.LocalDate.now())) return null;
			return String.format(java.util.Locale.ROOT, "%04d-%02d-%02d",
					birth.getYear(), birth.getMonthValue(), birth.getDayOfMonth());
		} catch (java.time.DateTimeException e) {
			return null;
		}
	}

}
