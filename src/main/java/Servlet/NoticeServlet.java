package Servlet;

import java.io.IOException;
import java.util.Set;
import java.util.TreeSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.NoticeDAO;
import DTO.NoticeDTO;

@WebServlet("/NoticeServlet")
public class NoticeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Set<String> MUTATIONS = Set.of("insert", "update", "delete", "updateStatus");

    private String adminId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object value = session == null ? null : session.getAttribute("adminId");
        return value instanceof String && !((String) value).isBlank() ? (String) value : null;
    }

    private String parameter(HttpServletRequest request, String name) {
        String[] values = request.getParameterValues(name);
        if (values == null || values.length != 1 || values[0] == null) {
            throw new IllegalArgumentException();
        }
        return values[0];
    }

    private int positiveId(String value) {
        String id = value.trim();
        if (!id.matches("[1-9][0-9]{0,9}")) {
            throw new IllegalArgumentException();
        }
        return Integer.parseInt(id);
    }

    private int[] csvIds(String value) {
        if (value.length() > 2000) {
            throw new IllegalArgumentException();
        }
        String[] parts = value.split(",", -1);
        if (parts.length == 0 || parts.length > NoticeDAO.MAX_BATCH_IDS) {
            throw new IllegalArgumentException();
        }
        Set<Integer> ids = new TreeSet<>();
        for (String part : parts) {
            if (!ids.add(positiveId(part))) {
                throw new IllegalArgumentException();
            }
        }
        return ids.stream().mapToInt(Integer::intValue).toArray();
    }

    private void error(HttpServletResponse response, int status) throws IOException {
        response.setStatus(status);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write(status == 400 ? "요청 값을 확인해주세요." : "요청을 처리할 수 없습니다.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (adminId(request) == null) {
            error(response, 401);
            return;
        }
        try {
            if (request.getParameterValues("action") == null) {
                response.sendRedirect("admin_notice.jsp");
                return;
            }
            String action = parameter(request, "action");
            if (MUTATIONS.contains(action)) {
                response.setHeader("Allow", "POST");
                error(response, 405);
                return;
            }
            if (!"getContent".equals(action)) {
                throw new IllegalArgumentException();
            }
            int id = positiveId(parameter(request, "id"));
            // 관리자 내용 조회는 조회수를 변경하지 않는다.
            NoticeDTO notice = new NoticeDAO().getNoticeForAdmin(id);
            if (notice == null) {
                error(response, 404);
                return;
            }
            response.setContentType("text/plain; charset=UTF-8");
            response.setHeader("X-Content-Type-Options", "nosniff");
            response.getWriter().write(notice.getContent() == null ? "" : notice.getContent());
        } catch (IllegalArgumentException e) {
            error(response, 400);
        } catch (Exception e) {
            e.printStackTrace();
            error(response, 500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String adminId = adminId(request);
        if (adminId == null) {
            error(response, 401);
            return;
        }
        try {
            String action = parameter(request, "action");
            if (!MUTATIONS.contains(action)) {
                throw new IllegalArgumentException();
            }
            boolean success;
            String resultAction = action;
            if ("insert".equals(action) || "update".equals(action)) {
                String title = parameter(request, "noticeTitle").trim();
                String content = parameter(request, "noticeContent");
                String pinned = parameter(request, "noticeStatus");
                if (!NoticeDAO.isValidContent(title, content, pinned) || adminId.length() > 20) {
                    throw new IllegalArgumentException();
                }
                NoticeDTO notice = new NoticeDTO();
                notice.setAdmin_id(adminId);
                notice.setNoti_title(title);
                notice.setContent(content);
                notice.setNoti_isPinned(pinned);
                if ("update".equals(action)) {
                    notice.setNoti_id(positiveId(parameter(request, "noticeId")));
                }
                NoticeDAO dao = new NoticeDAO();
                success = "insert".equals(action) ? dao.insertNotice(notice) : dao.updateNotice(notice);
            } else if ("delete".equals(action)) {
                int[] ids = csvIds(parameter(request, "deleteIds"));
                success = new NoticeDAO().deleteNotices(ids);
            } else {
                int[] ids = csvIds(parameter(request, "statusIds"));
                String status = parameter(request, "statusValue");
                if (!"Y".equals(status) && !"N".equals(status)) {
                    throw new IllegalArgumentException();
                }
                success = new NoticeDAO().updateNoticeStatuses(ids, status);
                resultAction = "status";
            }
            // 실패 원인은 서버에만 기록하고 URL에는 고정 코드만 보낸다.
            response.sendRedirect("admin_notice.jsp?" + (success ? "success=" : "error=") + resultAction);
        } catch (IllegalArgumentException e) {
            error(response, 400);
        } catch (Exception e) {
            e.printStackTrace();
            error(response, 500);
        }
    }
}