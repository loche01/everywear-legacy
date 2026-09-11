<%@ page import="org.apache.taglibs.standard.functions.Functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="DTO.NoticeDTO, DAO.NoticeDAO, DAO.AdminDAO" %>
<%
    // 공지사항 ID 가져오기
    int noticeId = 0;
    boolean isNewNotice = false;
    NoticeDTO notice = null;
    String adminId = "";
    String adminName = "";
    String title = "";
    String content = "";
    String isPinned = "N"; // 기본값은 일반

    try {
        // id 파라미터가 있으면 수정 모드, 없으면 새 작성 모드
        String idParam = request.getParameter("id");
        if (idParam != null) {
            noticeId = Integer.parseInt(idParam);
            if (noticeId <= 0) {
                throw new NumberFormatException();
            }
            
            // 공지사항 상세 정보 가져오기 (관리자용)
            NoticeDAO noticeDAO = new NoticeDAO();
            notice = noticeDAO.getNoticeForAdmin(noticeId);
            
            if (notice == null) {
                response.sendRedirect("admin_notice.jsp");
                return;
            }
            
            // 작성자 이름 가져오기
            AdminDAO adminDAO = new AdminDAO();
            adminId = notice.getAdmin_id();
            adminName = adminDAO.getAdminName(adminId);
            
            // 공지사항 정보 설정
            title = notice.getNoti_title();
            content = notice.getContent();
            isPinned = notice.getNoti_isPinned();
        } else {
            // 새 공지사항 작성 모드
            isNewNotice = true;
            
            // 현재 로그인한 관리자 정보 가져오기 (실제로는 세션에서 가져와야 함)
            adminId = (String) session.getAttribute("adminId");
            
            if (adminId == null) {
                // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
                response.sendRedirect("admin_login.jsp");
                return;
            }
            
            AdminDAO adminDAO = new AdminDAO();
            adminName = adminDAO.getAdminName(adminId);
        }
    } catch (Exception e) {
        response.sendRedirect("admin_notice.jsp");
        return;
    }
    
    // 현재 페이지 표시
    request.setAttribute("currentMenu", "board");
    // 하위 메뉴로 공지사항 선택
    request.setAttribute("subMenu", "notice");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%= isNewNotice ? "공지사항 작성" : "공지사항 수정" %> | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/admin_notice.css">
<style>
    .form-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }
    
    .form-group input[type="text"] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    
    .form-group textarea {
        width: 100%;
        height: 300px;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        resize: vertical;
        white-space: pre-wrap;
        font-family: Arial, sans-serif;
        font-size: 14px;
        line-height: 1.5;
    }
    
    .radio-group {
        display: flex;
        gap: 20px;
    }
    
    .button-group {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 30px;
    }
</style>
</head>
<body>

<!-- 헤더 포함 -->
<jsp:include page="/includes/admin_header.jsp" />

    <main>
        <div class="container">
            <h2><%= isNewNotice ? "공지사항 작성" : "공지사항 수정" %></h2>
            
            <div class="form-container">
                <form action="NoticeServlet" method="post">
                    <input type="hidden" name="adminCsrfToken" value="<%= Functions.escapeXml((String) session.getAttribute("adminCsrfToken")) %>">
                    <input type="hidden" name="action" value="<%= isNewNotice ? "insert" : "update" %>">
                    <% if (!isNewNotice) { %>
                    <input type="hidden" name="noticeId" value="<%= noticeId %>">
                    <% } %>
                    
                    <div class="form-group">
                        <label for="noticeTitle">제목</label>
                        <input type="text" id="noticeTitle" name="noticeTitle" value="<%= Functions.escapeXml(title) %>" placeholder="제목을 입력하세요" required>
                    </div>
                    
                    <div class="form-group">
                        <label>작성자</label>
                        <div style="padding: 10px; background-color: #f5f5f5; border-radius: 4px;">
                            <%= Functions.escapeXml(adminName) %> (<%= Functions.escapeXml(adminId) %>)
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="noticeContent">내용</label>
                        <textarea id="noticeContent" name="noticeContent" placeholder="내용을 입력하세요" required><%= Functions.escapeXml(content) %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>공지 상태</label>
                        <div class="radio-group">
                            <label>
                                <input type="radio" name="noticeStatus" value="N" <%= "Y".equals(isPinned) ? "" : "checked" %>> 일반
                            </label>
                            <label>
                                <input type="radio" name="noticeStatus" value="Y" <%= "Y".equals(isPinned) ? "checked" : "" %>> 중요
                            </label>
                        </div>
                    </div>
                    
                    <div class="button-group">
                        <% if (isNewNotice) { %>
                        <button type="button" class="btn" onclick="location.href='admin_notice.jsp'">취소</button>
                        <% } else { %>
                        <button type="button" class="btn" onclick="location.href='admin_notice_view.jsp?id=<%= noticeId %>'">취소</button>
                        <% } %>
                        <button type="submit" class="btn btn-primary">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    
<!-- 푸터 포함 -->
<jsp:include page="/includes/admin_footer.jsp" />

</body>
</html> 