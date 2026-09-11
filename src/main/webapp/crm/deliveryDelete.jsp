<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="DAO.UserDAO" %>
<%!
    private static String single(String[] values) {
        if (values == null || values.length != 1) {
            return null;
        }
        String v = values[0] == null ? null : values[0].trim();
        return (v == null || v.isEmpty()) ? null : v;
    }
%>
<%
request.setCharacterEncoding("UTF-8");
response.setHeader("Cache-Control", "no-store");

// AdminAuthFilter 에서 POST + 관리자 CSRF 를 이미 강제한다. 여기서는 파라미터만 안전 처리한다.
String addrIdStr = single(request.getParameterValues("addr_id"));
String user_id = single(request.getParameterValues("user_id"));
String user_type = single(request.getParameterValues("user_type"));

int addr_id = -1;
if (addrIdStr != null && addrIdStr.matches("[0-9]{1,9}")) {
    addr_id = Integer.parseInt(addrIdStr);
}

if (addr_id <= 0 || user_id == null || user_id.length() > 30
        || user_type == null || user_type.length() > 10) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
%>
<script>
  alert("잘못된 접근입니다.");
  history.back();
</script>
<%
    return;
}

UserDAO dao = new UserDAO();
// deleteAddr(addrId, id, type): user_id + user_type 소유 + addr_isDefault='N' 인 1행만 삭제.
boolean result = dao.deleteAddr(addr_id, user_id, user_type);
String target = "userCRM.jsp?user_id=" + java.net.URLEncoder.encode(user_id, "UTF-8")
        + "&user_type=" + java.net.URLEncoder.encode(user_type, "UTF-8") + "&tab=delivery";
if (result) {
%>
<script>
  alert("배송지가 삭제되었습니다.");
  location.href = "<%=target%>";
</script>
<%
} else {
    response.setStatus(HttpServletResponse.SC_CONFLICT);
%>
<script>
  alert("배송지를 삭제할 수 없습니다. (기본 배송지이거나 대상이 존재하지 않습니다)");
  location.href = "<%=target%>";
</script>
<%
}
%>
