<!-- updateUserInfo.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="DAO.UserDAO, DTO.UserDTO, java.sql.SQLException, java.util.Set" %>
<%!
    // 현재 detail.jsp 화면에서 실제로 사용하는 값만 허용한다. 기존 문자열은 그대로 유지한다.
    private static final Set<String> ACCOUNT_STATES = Set.of(
            "정상", "휴먼", "이용 정지", "탈퇴", "로그인 연속 실패로 인한 잠금");
    private static final Set<String> RANKS = Set.of("그린", "오렌지", "퍼플", "에메랄드", "블랙");
    private static final Set<String> YN = Set.of("Y", "N");

    private static String single(String[] values) {
        if (values == null || values.length != 1) {
            return null;
        }
        String v = values[0] == null ? null : values[0].trim();
        return (v == null || v.isEmpty()) ? null : v;
    }

    private static Integer parseRange(String[] values, int min, int max) {
        String v = single(values);
        if (v == null || !v.matches("-?[0-9]{1,4}")) {
            return null;
        }
        try {
            int n = Integer.parseInt(v);
            return (n < min || n > max) ? null : n;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static boolean validBirth(String y, String m, String d) {
        if (y == null || m == null || d == null
                || !y.matches("[0-9]{4}") || !m.matches("[0-9]{1,2}") || !d.matches("[0-9]{1,2}")) {
            return false;
        }
        int year = Integer.parseInt(y);
        int month = Integer.parseInt(m);
        int day = Integer.parseInt(d);
        int currentYear = java.time.Year.now().getValue();
        if (year < 1900 || year > currentYear || month < 1 || month > 12) {
            return false;
        }
        boolean leap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
        int[] days = {31, leap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        return day >= 1 && day <= days[month - 1];
    }
%>
<%
request.setCharacterEncoding("UTF-8");
response.setHeader("Cache-Control", "no-store");

// AdminAuthFilter 에서 POST + 관리자 CSRF 를 이미 강제한다. 여기서는 입력 검증만 수행한다.
String id = single(request.getParameterValues("user_id"));
String type = single(request.getParameterValues("user_type"));
String name = single(request.getParameterValues("user_name"));
String phone1 = single(request.getParameterValues("phone1"));
String phone2 = single(request.getParameterValues("phone2"));
String email = single(request.getParameterValues("user_email"));
String gender = single(request.getParameterValues("user_gender"));
String birthY = single(request.getParameterValues("birth_y"));
String birthM = single(request.getParameterValues("birth_m"));
String birthD = single(request.getParameterValues("birth_d"));
String accountState = single(request.getParameterValues("user_account_state"));
String lockState = single(request.getParameterValues("user_lock_state"));
String marketingState = single(request.getParameterValues("user_marketing_state"));
String userRank = single(request.getParameterValues("user_rank"));
Integer height = parseRange(request.getParameterValues("user_height"), 0, 300);
Integer weight = parseRange(request.getParameterValues("user_weight"), 0, 500);

// 이메일은 비어 있을 수 있으나, 입력된 경우 형식과 길이를 검증한다.
if (email == null) {
    email = "";
}
boolean emailValid = email.isEmpty()
        || (email.length() <= 100 && email.matches("[^@\\s]+@[^@\\s]+\\.[^@\\s]+"));

boolean valid = id != null && id.length() <= 30
        && type != null && type.length() <= 10
        && name != null && name.length() <= 30
        && phone1 != null && phone1.matches("[0-9]{3,4}")
        && phone2 != null && phone2.matches("[0-9]{4}")
        && emailValid
        && ("남자".equals(gender) || "여자".equals(gender))
        && validBirth(birthY, birthM, birthD)
        && height != null && weight != null
        && accountState != null && ACCOUNT_STATES.contains(accountState)
        && lockState != null && YN.contains(lockState)
        && marketingState != null && YN.contains(marketingState)
        && userRank != null && RANKS.contains(userRank);

if (!valid) {
    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "입력값이 올바르지 않습니다.");
    return;
}

String phone = "010-" + phone1 + "-" + phone2;
String birth = birthY + "-" + birthM + "-" + birthD;

UserDTO user = new UserDTO();
user.setUser_id(id);
user.setUser_name(name);
user.setUser_phone(phone);
user.setUser_email(email);
user.setUser_gender(gender);
user.setUser_birth(birth);
user.setUser_height(height);
user.setUser_weight(weight);
user.setUser_account_state(accountState);
user.setUser_marketing_state(marketingState);
user.setUser_rank(userRank);

if ("탈퇴".equals(accountState)) {
    user.setUser_lock_state("Y");
    user.setUser_wd_date(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()));
    user.setUser_wd_reason("관리자 처리");
    user.setUser_wd_detail_reason("CRM에서 직접 탈퇴 처리됨");
} else {
    user.setUser_lock_state(lockState); // 탈퇴가 아닐 때만 적용
}

UserDAO dao = new UserDAO();
boolean updated;
try {
    // updateUser: user_id + user_type 대상 1행만 수정. 0행과 DB 예외를 구분한다.
    updated = dao.updateUser(user, id, type);
} catch (SQLException e) {
    application.log("CRM user update failed.");
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "처리 중 오류가 발생했습니다.");
    return;
}

if (!updated) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "대상 회원을 찾을 수 없습니다.");
    return;
}

String target = "userCRM.jsp?user_id=" + java.net.URLEncoder.encode(id, "UTF-8")
        + "&user_type=" + java.net.URLEncoder.encode(type, "UTF-8");
out.println("<script>");
out.println("alert('회원 정보가 수정되었습니다.');");
out.println("window.location.href = '" + target + "';");
out.println("</script>");
%>
