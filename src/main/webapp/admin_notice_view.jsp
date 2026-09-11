<%@ page import="org.apache.taglibs.standard.functions.Functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="DTO.NoticeDTO, DAO.NoticeDAO, DAO.AdminDAO" %>
<%
    // 공지사항 ID 가져오기
    int noticeId = 0;
    try {
        noticeId = Integer.parseInt(request.getParameter("id"));
        if (noticeId <= 0) {
            throw new NumberFormatException();
        }
    } catch (Exception e) {
        response.sendRedirect("admin_notice.jsp");
        return;
    }
    
    // 공지사항 상세 정보 가져오기 (관리자용)
    NoticeDAO noticeDAO = new NoticeDAO();
    NoticeDTO notice = noticeDAO.getNoticeForAdmin(noticeId);
    
    if (notice == null) {
        response.sendRedirect("admin_notice.jsp");
        return;
    }
    
    // 작성자 이름 가져오기
    AdminDAO adminDAO = new AdminDAO();
    String adminId = notice.getAdmin_id();
    String adminName = adminDAO.getAdminName(adminId);
    
    // 공지사항 정보 설정
    String title = notice.getNoti_title();
    String content = notice.getContent();
    String createdAt = notice.getCreated_at();
    int views = notice.getNoti_views();
    boolean isImportant = "Y".equals(notice.getNoti_isPinned());
    
    // 현재 페이지 표시
    request.setAttribute("currentMenu", "board");
    // 하위 메뉴로 공지사항 선택
    request.setAttribute("subMenu", "notice");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항 상세 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/admin_notice.css">
<style>
    .notice-view {
        margin-top: 20px;
    }
    
    .notice-view .notice-header {
        border-bottom: 1px solid #ddd;
        padding-bottom: 15px;
        margin-bottom: 20px;
    }
    
    .notice-view .notice-title {
        font-size: 20px;
        font-weight: bold;
        margin-bottom: 10px;
    }
    
    .notice-view .notice-info {
        color: #777;
        font-size: 14px;
    }
    
    .notice-view .notice-info span {
        margin-right: 15px;
    }
    
    .notice-view .notice-content {
        min-height: 300px;
        line-height: 1.6;
        margin-bottom: 30px;
    }
    
    .button-group {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 30px;
    }
</style>
<script>
// 페이지 로드 시 상태 메시지 표시
window.onload = function() {
    // URL 파라미터 읽기
    var urlParams = new URLSearchParams(window.location.search);
    var success = urlParams.get('success');
    var error = urlParams.get('error');
    
    if (success) {
        switch(success) {
            case 'view':
                console.log('공지사항을 확인합니다.');
                break;
        }
    } else if (error) {
        switch(error) {
            case 'notfound':
                alert('공지사항을 찾을 수 없습니다.');
                location.href = 'admin_notice.jsp';
                break;
            case 'system':
                alert('시스템 오류가 발생했습니다. 관리자에게 문의하세요.');
                break;
        }
    }
}
</script>
</head>
<body>

<!-- 헤더 포함 -->
<jsp:include page="/includes/admin_header.jsp" />

    <main>
        <div class="container">
            <h2>공지사항 상세</h2>
            
            <div class="notice-view">
                <div class="notice-header">
                    <div class="notice-title">
                        <% if (isImportant) { %>
                        <span class="badge important">중요</span>
                        <% } else { %>
                        <span class="badge normal">일반</span>
                        <% } %>
                        <%= Functions.escapeXml(title) %>
                    </div>
                    <div class="notice-info">
                        <span>등록일: <%= Functions.escapeXml(createdAt) %></span>
                        <span>조회수: <%= views %></span>
                        <span>작성자: <%= Functions.escapeXml(adminName) %></span>
                    </div>
                </div>
                
                <div class="notice-content">
                    <%= Functions.escapeXml(content).replace("\n", "<br>") %>
                </div>
            </div>
            
            <div class="button-group">
                <button class="btn btn-primary" onclick="location.href='admin_notice.jsp'">목록</button>
                <button class="btn" onclick="location.href='admin_notice_edit.jsp?id=<%= noticeId %>'">수정</button>
                <button class="btn btn-danger" onclick="deleteNotice()">삭제</button>
            </div>
        </div>
    </main>

<!-- 푸터 포함 -->
<jsp:include page="/includes/admin_footer.jsp" />

    <!-- 삭제 확인 모달 -->
    <div id="deleteModal" class="modal">
        <div class="modal-content confirm-modal">
            <div class="modal-header">
                <h3>삭제 확인</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <p>이 공지사항을 삭제하시겠습니까?</p>
                <form id="deleteForm" action="NoticeServlet" method="post">
                    <input type="hidden" name="adminCsrfToken" value="<%= Functions.escapeXml((String) session.getAttribute("adminCsrfToken")) %>">
                    <input type="hidden" name="deleteIds" value="<%= noticeId %>">
                    <input type="hidden" name="action" value="delete">
                    <div class="form-actions">
                        <button type="button" id="cancelDeleteBtn" class="btn">취소</button>
                        <button type="submit" id="confirmDeleteBtn" class="btn btn-danger">삭제</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {
        const deleteModal = document.getElementById("deleteModal");
        const closeBtn = document.querySelector(".close");
        const cancelDeleteBtn = document.getElementById("cancelDeleteBtn");
        
        // 삭제 모달 닫기
        function closeModal() {
            deleteModal.style.display = "none";
        }
        
        closeBtn.addEventListener("click", closeModal);
        
        cancelDeleteBtn.addEventListener("click", closeModal);
        
        // 모달 외부 클릭 시 닫기
        window.addEventListener("click", function(event) {
            if (event.target === deleteModal) {
                closeModal();
            }
        });
    });
    
    // 삭제 모달 열기
    function deleteNotice() {
        document.getElementById("deleteModal").style.display = "block";
    }
    </script>

</body>
</html> 