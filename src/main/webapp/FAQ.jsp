<%@page import="DTO.FaqDTO"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="faqDao" class="DAO.FaqDAO" />
<%
Vector<FaqDTO> flist = faqDao.showFaq();
int totalData = flist.size(); // 총 데이터 수 = 20
int itemsPerPage = 7; // 한 페이지당 8개
int totalPage = (int) Math.ceil((double) totalData / itemsPerPage);

int currentPage = 1;
if (request.getParameter("page") != null) {
	currentPage = Integer.parseInt(request.getParameter("page"));
}

int start = (currentPage - 1) * itemsPerPage;
int end = start + itemsPerPage;
if (end > totalData)
	end = totalData;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="icon" type="image/png" href="images/fav-icon.png">
<link rel="stylesheet" type="text/css" href="css/FAQ.css?v=318">

</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<section class="content2">
	<h3>FAQ</h3>
	</section>

	<div class="container">
		<aside class="sidebar2">
			<ul>
				<li><a href="board.jsp">BOARD</a></li>
				<li><a href="FAQ.jsp">FAQ</a></li>
				<li><a href="Q&A.jsp">Q&A</a></li>
			</ul>
		</aside>

	<section class="content">
	<% for (int i = start; i < end; i++) {
	     FaqDTO faq = flist.get(i);
	%>
	  <div class="faq-item">
	    <div class="question">
	      <span><%=faq.getFaq_title()%></span>
	      <span class="arrow">▼</span>
	    </div>
	    <div class="faq-content">
	      <%=faq.getFaq_content()%>
	    </div>
	  </div>
	<% } %>

    
       <!-- 🔻 페이징 처리 -->
	<div class="pagination" id="pagination">
	  <% if (currentPage > 1) { %>
	    <a href="FAQ.jsp?page=<%= currentPage - 1 %>">Prev</a>
	  <% } else { %>
	    <span class="invisible-button">Prev</span>
	  <% } %>
	
	  <% for (int i = 1; i <= totalPage; i++) { %>
	    <a href="FAQ.jsp?page=<%= i %>" class="<%= (i == currentPage ? "active" : "") %>">
	      <%= i %>
	    </a>
	  <% } %>
	
	  <% if (currentPage < totalPage) { %>
	    <a href="FAQ.jsp?page=<%= currentPage + 1 %>">Next</a>
	  <% } else { %>
	    <span class="invisible-button">Next</span>
	  <% } %>
	</div>

			<div class="footer-bottom">
				<p>2025&copy;everyWEAR</p>
			</div>
		</section>
	</div>
	
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(function () {
    $(".question").on("click", function () {
      const $item = $(this).closest(".faq-item");
      const $content = $item.find(".faq-content");

      if ($item.hasClass("active")) {
        $item.removeClass("active");
        $content.stop().slideUp(300);
      } else {
        $(".faq-item").removeClass("active").find(".faq-content").stop().slideUp(300);
        $item.addClass("active");
        $content.stop().slideDown(300);
      }
    });
  });
</script>





</body>