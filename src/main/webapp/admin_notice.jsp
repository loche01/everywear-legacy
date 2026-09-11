<%@ page import="org.apache.taglibs.standard.functions.Functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="DAO.NoticeDAO" %>
<%@ page import="DTO.NoticeDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 공지사항 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/admin_notice.css">
<style>
    .notice-table tbody tr {
        border-bottom: 1px solid #e0e0e0;
        transition: background-color 0.2s;
    }
    
    .notice-table tbody tr:hover {
        background-color: #f5f7fa;
    }
    
    .notice-table {
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .notice-table th {
        border-bottom: 2px solid #d1d1d1;
    }
    
    /* 체크박스 스타일 */
    .notice-check, #selectAll {
        width: 16px;
        height: 16px;
        cursor: pointer;
        accent-color: #4CAF50;
    }
    
    /* 배지 스타일 개선 */
    .badge {
        display: inline-block;
        min-width: 60px;
        text-align: center;
    }
    
    /* 버튼 간격 및 스타일 통일 */
    .btn-sm {
        padding: 6px 12px;
        font-size: 13px;
        border-radius: 4px;
        transition: all 0.2s;
    }
    
    .btn-sm.btn-edit {
        background-color: #e8eef9;
        color: #0a2963;
        border: none;
    }
    
    .btn-sm.btn-edit:hover {
        background-color: #d1e0f6;
    }
    
    .btn-sm.btn-delete {
        background-color: #FFEBEE;
        color: #F44336;
        border: none;
    }
    
    .btn-sm.btn-delete:hover {
        background-color: #FFCDD2;
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
            case 'insert':
                alert('공지사항이 등록되었습니다.');
                break;
            case 'update':
                alert('공지사항이 수정되었습니다.');
                break;
            case 'delete':
                alert('공지사항이 삭제되었습니다.');
                break;
            case 'status':
                alert('공지사항 상태가 변경되었습니다.');
                break;
        }
        
     // alert 후 URL 파라미터 제거 (브라우저 히스토리만 변경)
        const newUrl = window.location.origin + window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
        
    } else if (error) {
        switch(error) {
            case 'insert':
                alert('공지사항 등록에 실패했습니다.');
                break;
            case 'update':
                alert('공지사항 수정에 실패했습니다.');
                break;
            case 'delete':
                alert('공지사항 삭제에 실패했습니다.');
                break;
            case 'status':
                alert('공지사항 상태 변경에 실패했습니다.');
                break;
            case 'system':
                alert('시스템 오류가 발생했습니다. 관리자에게 문의하세요.');
                break;
        }
        
     // alert 후 URL 파라미터 제거 (브라우저 히스토리만 변경)
        const newUrl = window.location.origin + window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
        
    }
}
</script>
</head>
<body>
<%
    // 페이지네이션 설정
    int currentPage = 1;
    try {
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        if (currentPage < 1 || currentPage > Integer.MAX_VALUE / 10) {
            currentPage = 1;
        }
    } catch (NumberFormatException invalidPage) {
        currentPage = 1;
    }
    
    int itemsPerPage = 10; // 한 페이지에 표시할 항목 수
    int start = (currentPage - 1) * itemsPerPage;
    
    // 검색 파라미터 가져오기
    String searchType = request.getParameter("searchType");
    String keyword = request.getParameter("keyword");
    String searchQuery = searchType != null && keyword != null
            ? Functions.escapeXml("&searchType=" + java.net.URLEncoder.encode(searchType, "UTF-8")
                    + "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8")) : "";
    
    NoticeDAO noticeDAO = new NoticeDAO();
    List<NoticeDTO> noticeList = new ArrayList<>();
    int totalNotices = 0;
    
    // 검색 여부에 따라 다른 메서드 호출
    if (searchType != null && keyword != null && !keyword.trim().isEmpty()) {
        noticeList = noticeDAO.searchNotices(searchType, keyword, start, itemsPerPage);
        totalNotices = noticeDAO.getSearchResultCount(searchType, keyword);
    } else {
        noticeList = noticeDAO.getNoticeList(start, itemsPerPage);
        totalNotices = noticeDAO.getTotalNoticeCount();
    }
    
    int totalPages = (int) Math.ceil((double) totalNotices / itemsPerPage);
    
    // 날짜 포맷 설정
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    // 현재 페이지 표시
    request.setAttribute("currentMenu", "board");
    // 하위 메뉴로 공지사항 선택
    request.setAttribute("subMenu", "notice");
%>

<!-- 헤더 포함 -->
<jsp:include page="/includes/admin_header.jsp" />

    <main>
        <div class="container">
            <h2>공지사항 관리</h2>
            
            <!-- 상태 메시지 표시 영역 -->
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px; border: 1px solid #c3e6cb;">
                <strong>성공!</strong> 
                <% if ("insert".equals(request.getParameter("success"))) { %>
                    공지사항이 등록되었습니다.
                <% } else if ("update".equals(request.getParameter("success"))) { %>
                    공지사항이 수정되었습니다.
                <% } else if ("delete".equals(request.getParameter("success"))) { %>
                    공지사항이 삭제되었습니다.
                <% } else if ("status".equals(request.getParameter("success"))) { %>
                    공지사항 상태가 변경되었습니다.
                <% } %>
            </div>
            <% } else if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 15px; border-radius: 5px; border: 1px solid #f5c6cb;">
                <strong>오류!</strong> 
                <% if ("insert".equals(request.getParameter("error"))) { %>
                    공지사항 등록에 실패했습니다.
                <% } else if ("update".equals(request.getParameter("error"))) { %>
                    공지사항 수정에 실패했습니다.
                <% } else if ("delete".equals(request.getParameter("error"))) { %>
                    공지사항 삭제에 실패했습니다.
                <% } else if ("status".equals(request.getParameter("error"))) { %>
                    공지사항 상태 변경에 실패했습니다.
                <% } else if ("system".equals(request.getParameter("error"))) { %>
                    시스템 오류가 발생했습니다. 관리자에게 문의하세요.
                <% } %>
            </div>
            <% } %>
            
            <!-- 총 게시물 수 표시 -->
            <div style="margin-bottom: 15px; font-size: 16px; color: #333;">
                총 <strong style="color: #0a2963; font-size: 18px;"><%= totalNotices %></strong>개의 공지사항이 있습니다.
            </div>
            
            <div class="notice-control">
                <button id="addNoticeBtn" class="btn" style="background-color: #0a2963; color: white; height: 40px; border-radius: 5px; padding: 8px 20px; border: none;" onclick="location.href='admin_notice_edit.jsp'">새 공지사항 작성</button>
                <div class="search-box">
                    <form action="admin_notice.jsp" method="get" style="display: flex; align-items: center;">
                        <select id="searchType" name="searchType">
                            <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>제목</option>
                            <option value="content" <%= "content".equals(searchType) ? "selected" : "" %>>내용</option>
                        </select>
                        <input type="text" id="searchKeyword" name="keyword" placeholder="검색어 입력" value="<%= Functions.escapeXml(keyword) %>">
                        <button type="submit" id="searchBtn" class="btn" style="background-color: #0a2963; color: white; height: 40px; border-radius: 5px; padding: 8px 20px; border: none;">검색</button>
                    </form>
                </div>
            </div>
            
            <table class="notice-table" id="notice-table" style="border-spacing: 0; border-collapse: separate;">
                <thead>
                    <tr>
                        <th class="checkbox" style="padding: 15px 10px; text-align: center;"><input type="checkbox" id="selectAll" style="margin: 0 auto;"></th>
                        <th class="no" style="padding: 15px 12px;">No</th>
                        <th class="title" style="padding: 15px 20px;">제목</th>
                        <th class="date" style="padding: 15px 12px;">등록일</th>
                        <th class="views" style="padding: 15px 12px;">조회수</th>
                        <th class="status" style="padding: 15px 12px;">상태</th>
                        <th class="actions" style="padding: 15px 12px;">관리</th>
                    </tr>
                </thead>
                <tbody>
                <% if (noticeList.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">공지사항이 없습니다.</td>
                    </tr>
                <% } else { 
                     for (NoticeDTO notice : noticeList) {
                        String formattedDate = "";
                        try {
                            // DB에서 가져온 날짜를 포맷팅
                            formattedDate = sdf.format(sdf.parse(notice.getCreated_at()));
                        } catch (Exception e) {
                            formattedDate = notice.getCreated_at();
                        }
                        
                        boolean isPinned = "Y".equals(notice.getNoti_isPinned());
                %>
                    <tr>
                        <td style="padding: 15px 10px; text-align: center;"><input type="checkbox" class="notice-check" value="<%= notice.getNoti_id() %>" style="margin: 0 auto;"></td>
                        <td style="padding: 15px 12px;"><%= notice.getNoti_id() %></td>
                        <td style="padding: 15px 20px;">
                            <a href="admin_notice_view.jsp?id=<%= notice.getNoti_id() %>" class="<%= isPinned ? "important-notice" : "normal-notice" %>">
                                <%= Functions.escapeXml(notice.getNoti_title()) %>
                            </a>
                        </td>
                        <td style="padding: 15px 12px;"><%= Functions.escapeXml(formattedDate) %></td>
                        <td style="padding: 15px 12px;"><%= notice.getNoti_views() %></td>
                        <td style="padding: 15px 12px; text-align: center;">
                            <% if (isPinned) { %>
                            <span style="color: #F44336; font-size: 14px; font-weight: bold;">중요</span>
                            <% } else { %>
                            <span style="color: #0a2963; font-size: 14px; font-weight: bold;">일반</span>
                            <% } %>
                        </td>
                        <td style="padding: 15px 12px;">
                            <div style="display: flex; gap: 8px;">
                                <button class="btn btn-sm btn-edit" data-id="<%= notice.getNoti_id() %>" style="margin-right: 5px;">수정</button>
                                <button class="btn btn-sm btn-delete" data-id="<%= notice.getNoti_id() %>">삭제</button>
                            </div>
                        </td>
                    </tr>
                <% 
                     }
                   } 
                %>
                </tbody>
            </table>
            
            <div class="notice-actions">
                <button id="deleteSelectedBtn" class="btn btn-danger">선택 삭제</button>
                <button id="setImportantBtn" class="btn">중요 설정</button>
                <button id="setNormalBtn" class="btn">일반 설정</button>
            </div>
            
            <div class="pagination" id="pagination">
                <% if (currentPage > 1) { %>
                    <a href="admin_notice.jsp?page=1<%= searchQuery %>">처음</a>
                    <a href="admin_notice.jsp?page=<%= currentPage - 1 %><%= searchQuery %>">이전</a>
                <% } else { %>
                    <span class="disabled">처음</span>
                    <span class="disabled">이전</span>
                <% } %>
                
                <% 
                // 페이지 번호 표시 범위 설정
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                
                for (int i = startPage; i <= endPage; i++) { 
                %>
                    <a href="admin_notice.jsp?page=<%= i %><%= searchQuery %>"
                       class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="admin_notice.jsp?page=<%= currentPage + 1 %><%= searchQuery %>">다음</a>
                    <a href="admin_notice.jsp?page=<%= totalPages %><%= searchQuery %>">마지막</a>
                <% } else { %>
                    <span class="disabled">다음</span>
                    <span class="disabled">마지막</span>
                <% } %>
            </div>
        </div>
    </main>

    <!-- 푸터 포함 -->
    <jsp:include page="/includes/admin_footer.jsp" />

    <!-- 공지사항 작성/수정 모달 -->
    <div id="noticeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">공지사항 작성</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <form id="noticeForm" action="NoticeServlet" method="post">
                    <input type="hidden" name="adminCsrfToken" value="<%= Functions.escapeXml((String) session.getAttribute("adminCsrfToken")) %>">
                    <input type="hidden" id="noticeId" name="noticeId" value="">
                    <input type="hidden" id="action" name="action" value="insert">
                    
                    <div class="form-group">
                        <label for="noticeTitle">제목</label>
                        <input type="text" id="noticeTitle" name="noticeTitle" placeholder="제목을 입력하세요" required>
                    </div>
                    <div class="form-group">
                        <label for="noticeContent">내용</label>
                        <textarea id="noticeContent" name="noticeContent" rows="10" placeholder="내용을 입력하세요" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>공지 상태</label>
                        <div class="radio-group">
                            <label>
                                <input type="radio" name="noticeStatus" value="N" checked> 일반
                            </label>
                            <label>
                                <input type="radio" name="noticeStatus" value="Y"> 중요
                            </label>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" id="cancelBtn" class="btn">취소</button>
                        <button type="submit" id="saveNoticeBtn" class="btn btn-primary">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 삭제 확인 모달 -->
    <div id="deleteModal" class="modal">
        <div class="modal-content confirm-modal">
            <div class="modal-header">
                <h3>삭제 확인</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <p>선택한 공지사항을 삭제하시겠습니까?</p>
                <form id="deleteForm" action="NoticeServlet" method="post">
                    <input type="hidden" name="adminCsrfToken" value="<%= Functions.escapeXml((String) session.getAttribute("adminCsrfToken")) %>">
                    <input type="hidden" id="deleteIds" name="deleteIds" value="">
                    <input type="hidden" name="action" value="delete">
                    <div class="form-actions">
                        <button type="button" id="cancelDeleteBtn" class="btn">취소</button>
                        <button type="submit" id="confirmDeleteBtn" class="btn btn-danger">삭제</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 상태 변경 폼 -->
    <form id="statusForm" action="NoticeServlet" method="post" style="display: none;">
        <input type="hidden" name="adminCsrfToken" value="<%= Functions.escapeXml((String) session.getAttribute("adminCsrfToken")) %>">
        <input type="hidden" id="statusIds" name="statusIds" value="">
        <input type="hidden" id="statusValue" name="statusValue" value="">
        <input type="hidden" name="action" value="updateStatus">
    </form>

    <script>
    document.addEventListener("DOMContentLoaded", function() {
        // 모달 관련 요소
        const noticeModal = document.getElementById("noticeModal");
        const deleteModal = document.getElementById("deleteModal");
        const modalCloseButtons = document.querySelectorAll(".close");
        const cancelBtn = document.getElementById("cancelBtn");
        const modalTitle = document.getElementById("modalTitle");
        const noticeForm = document.getElementById("noticeForm");
        const statusForm = document.getElementById("statusForm");
        
        // 체크박스 관련
        const selectAllCheckbox = document.getElementById("selectAll");
        const noticeCheckboxes = document.querySelectorAll(".notice-check");
        
        // 버튼 관련
        const deleteSelectedBtn = document.getElementById("deleteSelectedBtn");
        const setImportantBtn = document.getElementById("setImportantBtn");
        const setNormalBtn = document.getElementById("setNormalBtn");
        const editButtons = document.querySelectorAll(".btn-edit");
        const deleteButtons = document.querySelectorAll(".btn-delete");
        const cancelDeleteBtn = document.getElementById("cancelDeleteBtn");
        const confirmDeleteBtn = document.getElementById("confirmDeleteBtn");
        
        // 모달 닫기
        modalCloseButtons.forEach(function(btn) {
            btn.addEventListener("click", function() {
                noticeModal.style.display = "none";
                deleteModal.style.display = "none";
            });
        });
        
        cancelBtn.addEventListener("click", function() {
            noticeModal.style.display = "none";
        });
        
        cancelDeleteBtn.addEventListener("click", function() {
            deleteModal.style.display = "none";
        });
        
        // 모달 외부 클릭 시 닫기
        window.addEventListener("click", function(event) {
            if (event.target === noticeModal) {
                noticeModal.style.display = "none";
            }
            if (event.target === deleteModal) {
                deleteModal.style.display = "none";
            }
        });
        
        // 체크박스 전체 선택/해제
        selectAllCheckbox.addEventListener("change", function() {
            noticeCheckboxes.forEach(function(checkbox) {
                checkbox.checked = selectAllCheckbox.checked;
            });
        });
        
        // 수정 버튼 클릭
        editButtons.forEach(function(btn) {
            btn.addEventListener("click", function() {
                const noticeId = this.getAttribute("data-id");
                // 수정 페이지로 이동
                location.href = "admin_notice_edit.jsp?id=" + noticeId;
            });
        });
        
        // 삭제 버튼 클릭
        deleteButtons.forEach(function(btn) {
            btn.addEventListener("click", function() {
                const noticeId = this.getAttribute("data-id");
                document.getElementById("deleteIds").value = noticeId;
                deleteModal.style.display = "block";
            });
        });
        
        // 선택 삭제 버튼 클릭
        deleteSelectedBtn.addEventListener("click", function() {
            const selectedIds = Array.from(noticeCheckboxes)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);
            
            if (selectedIds.length === 0) {
                alert("삭제할 공지사항을 선택해주세요.");
                return;
            }
            
            document.getElementById("deleteIds").value = selectedIds.join(",");
            deleteModal.style.display = "block";
        });
        
        // 중요/일반 설정 버튼
        setImportantBtn.addEventListener("click", function() {
            updateNoticeStatus("Y");
        });
        
        setNormalBtn.addEventListener("click", function() {
            updateNoticeStatus("N");
        });
        
        function updateNoticeStatus(status) {
            const selectedIds = Array.from(noticeCheckboxes)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);
            
            if (selectedIds.length === 0) {
                alert("상태를 변경할 공지사항을 선택해주세요.");
                return;
            }
            
            document.getElementById("statusIds").value = selectedIds.join(",");
            document.getElementById("statusValue").value = status;
            document.getElementById("statusForm").submit();
        }
        
        // 폼 제출 전 확인
        noticeForm.addEventListener("submit", function(e) {
            if (!document.getElementById("noticeTitle").value.trim()) {
                alert("제목을 입력해주세요.");
                e.preventDefault();
                return false;
            }
            
            if (!document.getElementById("noticeContent").value.trim()) {
                alert("내용을 입력해주세요.");
                e.preventDefault();
                return false;
            }
            
            return true;
        });
    });
    </script>

</body>
</html> 