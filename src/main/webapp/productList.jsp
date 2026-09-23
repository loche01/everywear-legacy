<%@page import="DTO.ProductDetailDTO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="DTO.ProductDTO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<jsp:useBean id="pDao" class="DAO.ProductDAO"/>
<%
// 카테고리 파라미터 처리
String categoryParam = request.getParameter("cat");
if (categoryParam == null) {
	categoryParam = "all";
}

String subCategoryParam = request.getParameter("subCat");
if (subCategoryParam == null) {
	subCategoryParam = "";
}

DecimalFormat formatter = new DecimalFormat("#,###");


Vector<ProductDTO> plist = new Vector<ProductDTO>();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>에브리웨어 | everyWEAR</title>
<link rel="stylesheet" type="text/css" href="css/productList.css">
<link rel="icon" type="image/png" href="images/fav-icon.png">
</head>
<body>

	<%@ include file="includes/header.jsp"%>

	<!-- 대분류 카테고리 -->
	<nav class="sub-nav">
		<ul>
			<li><a href="productList.jsp?cat=all"
				class="<%=categoryParam.equals("all") ? "active" : ""%>">ALL</a></li>
			<li><a href="productList.jsp?cat=outer"
				class="<%=categoryParam.equals("outer") ? "active" : ""%>">OUTER</a></li>
			<li><a href="productList.jsp?cat=top"
				class="<%=categoryParam.equals("top") ? "active" : ""%>">TOP</a></li>
			<li><a href="productList.jsp?cat=bottom"
				class="<%=categoryParam.equals("bottom") ? "active" : ""%>">BOTTOM</a></li>
			<li><a href="productList.jsp?cat=acc"
				class="<%=categoryParam.equals("acc") ? "active" : ""%>">ACC</a></li>
		</ul>
	</nav>

	<%-- 중분류 카테고리 렌더링 --%>
	<%
	String[] subCats = null;

	switch (categoryParam) {
		case "outer" :
			subCats = new String[]{"HEAVY OUTER", "HOODED ZIP-UP", "JACKET", "JUMPER", "VEST", "WIND BREAKER"};
			break;
		case "top" :
			subCats = new String[]{"HOODIE", "KNIT/CARDIGAN", "LONG SLEEVE", "SHIRT", "SLEEVESS", "SWEAT SHIRT", "T-SHIRT"};
			break;
		case "bottom" :
			subCats = new String[]{"DENIM", "PANTS", "SHORTS", "TRAINING PANTS"};
			break;
		case "acc" :
			subCats = new String[]{"BAG", "ETC", "HEADGEAR", "KEYRING"};
			break;
		default :
			subCats = new String[0];
	}
	%>

	<!-- 중분류 카테고리 - JavaScript가 동적으로 그릴 영역 -->
	<nav class="sub-nav2" id="subCategoryNav" style="display: none;">
		<ul id="subCategoryList"></ul>
	</nav>


	<!-- <nav class="items">
		<ul>
			<li><a>ITEMS()</a></li>
		</ul>
	</nav> -->

	<!-- 정렬 옵션 -->
	<div class="sort-options">
		<label for="sort-select" class="label-bold" id="itemCnt">ITEMS() </label> 
		<!-- <select id="sort-select">
			<option value="" disabled selected hidden>SORT BY</option>
			<option value="new">NEW</option>
			<option value="popular">POPULAR</option>
			<option value="low">LOW PRICE</option>
			<option value="high">HIGH PRICE</option>
		</select> -->
	</div>

	<div class="container">
		<div class="product-list" id="productList">
			<%
			if (categoryParam != null && categoryParam.equals("all")) {
				plist = pDao.getAllPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			}
			%>
			<%
			if (subCategoryParam == null || subCategoryParam.equals("")) {
				if(categoryParam.equals("outer")){
					plist = pDao.getOUTERPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
			} else if(categoryParam.equals("top")){
				plist = pDao.getTOPPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(categoryParam.equals("bottom")){
				plist = pDao.getBOTTOMPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(categoryParam.equals("acc")){
				plist = pDao.getACCPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} 
		} else if(subCategoryParam != null && !subCategoryParam.equals("")){
				if(subCategoryParam.equals("HEAVY OUTER")){
					plist = pDao.getHEAVY_OUTERPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>	
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
				} else if(subCategoryParam.equals("HOODED ZIP-UP")){
					plist = pDao.getHOODED_ZIP_UPPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
				} else if(subCategoryParam.equals("JACKET")){
					plist = pDao.getJACKETPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
				} else if(subCategoryParam.equals("JUMPER")){
					plist = pDao.getJUMPERPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
				} else if(subCategoryParam.equals("VEST")){
					plist = pDao.getVESTPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
				} else if(subCategoryParam.equals("WIND BREAKER")){
					plist = pDao.getWIND_BREAKERPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
				}else if(subCategoryParam.equals("HOODIE")){
					plist = pDao.getHOODIEPd();
					Vector<String> ilist = null;
					for(int i = 0; i<plist.size(); i++){
						ProductDTO pDto = plist.get(i);
						ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("KNIT/CARDIGAN")){
				plist = pDao.getKNIT_CARDIGANPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("LONG SLEEVE")){
				plist = pDao.getLONG_SLEEVEPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("SHIRT")){
				plist = pDao.getSHIRTPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("SLEEVESS")){
				plist = pDao.getSLEEVESSPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("SWEAT SHIRT")){
				plist = pDao.getSWEAT_SHIRTPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("T-SHIRT")){
				plist = pDao.getT_SHIRTPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("DENIM")){
				plist = pDao.getDENIMPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("PANTS")){
				plist = pDao.getPANTSPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("SHORTS")){
				plist = pDao.getSHORTSPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("TRAINING PANTS")){
				plist = pDao.getTRAINING_PANTSPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("BAG")){
				plist = pDao.getBAGPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("ETC")){
				plist = pDao.getETCPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("HEADGEAR")){
				plist = pDao.getHEADGEARPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("KEYRING")){
				plist = pDao.getKEYRINGPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
				}
			} else if(subCategoryParam.equals("MUFFLER")){
				plist = pDao.getMUFFLERPd();
				Vector<String> ilist = null;
				for(int i = 0; i<plist.size(); i++){
					ProductDTO pDto = plist.get(i);
					ilist = pDao.getPdImg(pDto.getP_id());
			%>
			<div class="product" onclick="openDetail('<%=pDto.getP_id()%>')">
				<img src="<%=(ilist != null && !ilist.isEmpty()) ? ilist.get(0) : "images/product-placeholder.svg"%>">
				<p class="product-name"><%=pDto.getP_name()%></p>
				<p class="product-price">KRW <%=formatter.format(pDto.getP_price())%></p>
			</div>
			<%
					}
				}
			}//--서브 카테고리가 있는 경우
			%>
		</div>

		<div class="resizer" id="resizer"></div>
<%-- 		<%
			int p_id = 0;
			Vector<String> ilist = null;
			ProductDTO pDto = null;
			Vector<ProductDetailDTO> pdlist = null;
			if(request.getParameter("p_id") == null || request.getParameter("p_id").equals("")){
				p_id = 0;
			} else if(request.getParameter("p_id") != null && !request.getParameter("p_id").equals("")){
				p_id = Integer.parseInt(request.getParameter("p_id"));
				ilist = pDao.getPdImg(p_id);
				pDto = pDao.getOnePd(p_id);
				pdlist = pDao.getOneProductDetail(p_id);
			}
		%> --%>

		<div class="detail-panel" id="detailPanel">
			<span class="close-btn" id="closeBtn" onclick="closeDetail()">×</span>
			<span class="expand-btn" id="expandBtn" onclick="toggleFullView()">🔳</span>

			<div class="left-panel">
				<div class="product-detail-wrapper">
					<img src="" alt="SLASH ZIPPER JACKET"
						class="product-image" />
					<h2 class="product-name"></h2>
					<div class="price"></div>

					<div class="section">
						<label class="section-title">COLOR</label>
						<div class="color-options">
							<div class="color-circle" style="background-color: #61584F;"></div>
							<div class="color-circle" style="background-color: #2A2B32;"></div>
						</div>
					</div>

					<div class="section">
						<label class="section-title">SIZE</label>
						<div class="size-options">
							<button class="size-btn disabled"></button>
							<button class="size-btn"></button>
							<button class="size-btn"></button>
						</div>
					</div>

					<div class="selection-preview">
						
					</div>

					<div class="notify-btn">
						<button></button>
					</div>

					<div class="total-price"></div>

					<div class="buy-buttons">
						<button class="btn outline"></button>
						<button class="btn filled"></button>
						<button class="btn wishlist-btn" id="wishlistBtn">🤍</button>
					</div>

					<div class="section">
						<h4 class="guide-title">SIZE(cm) / GUIDE</h4>
						<p>
							S - Length 58.5 / Shoulder 47 / Chest 57 / Arm 62<br> M -
							Length 61 / Shoulder 49 / Chest 59.5 / Arm 63<br> L - Length
							63.5 / Shoulder 51 / Chest 62 / Arm 64
						</p>
						<p>
							MODEL<br>MAN : 181CM(L SIZE)
						</p>
						<p>
							COTTON 65%<br>NYLON 35%
						</p>
						<p>
							WAIST SNAP<br>2WAY ZIPPER (YKK社)
						</p>
					</div>

					<div class="info-note">
						* 워싱 제품 특성상 개체 차이가 존재 합니다.<br> * Object differences exist due
						to the nature of the washed product.<br> <br> * 두꼬운 포리벡
						특성상 옷에 슬립제가 무다나올 수 있습니다.<br> * 어두운 색 계열의 상품 구매 시 보이는 슬립제는 불량의
						사유가 아니라는 것을 알려드립니다.<br> * The slip agent on dark clothes is
						not defective.
					</div>
					<div class="inner-panel right-panel" style="display: none;"
						id="abc">
						
						<img src="images/product-placeholder.svg"> <img
							src="images/product-placeholder.svg"> <img
							src="images/product-placeholder.svg">
					</div>
				</div>
			</div>
			<div class="inner-panel right-panel">
				
				
			</div>
		</div>

	</div>
	
	<form action="pay.jsp" method="post" id="goPayForm">
		<input type="hidden" id="hidden_pd_id" name="pd_id">
		<input type="hidden" name="quantity" value="1">
	</form>
	
	<form action="pdDetail.jsp" method="get" id="goPdDetail">
		<input type="hidden" id="hiddenPID" name="p_id">
	</form>

	<script>
  	const resizer = document.getElementById('resizer');
  	const detailPanel = document.getElementById('detailPanel');
  	const productList = document.getElementById('productList');
  	const container = document.querySelector('.container');

  	let isResizing = false;

  	resizer.addEventListener('mousedown', (e) => {
    	isResizing = true;
    	document.body.style.userSelect = 'none'; // ✅ 드래그 시 텍스트 선택 방지
    	document.addEventListener('mousemove', resize);
    	document.addEventListener('mouseup', stopResize);
  	});

  	function resize(e) {
    	if (isResizing) {
      	const newWidth = window.innerWidth - e.clientX;
      	if (newWidth > 500 && newWidth < window.innerWidth * 1) {
        	detailPanel.style.width = newWidth + 'px';
        	
         	// ✅ 너비 기준으로 column-layout 클래스 추가/제거
          if (newWidth < 600) {
          	detailPanel.classList.add('column-layout');
          	document.getElementById("abc").style.display = "";
          } else {
            detailPanel.classList.remove('column-layout');
            document.getElementById("abc").style.display = "none";
          }
     		}
    	}
  	}

  	function stopResize() {
    	isResizing = false;
    	document.body.style.userSelect = ''; // ✅ 드래그 종료 시 원복
    	document.removeEventListener('mousemove', resize);
    	document.removeEventListener('mouseup', stopResize);
  	}

  	
  	function openDetail(p_id) {
  	  // 주소창만 바꾸기 (새로고침 안 함)
  	  const currentUrl = new URL(window.location);
  	  currentUrl.searchParams.set("p_id", p_id);
  	  history.pushState({}, '', currentUrl); // 새로고침 안 일어남

  	  // 패널 열기
  	  const container = document.querySelector('.container');
  	  const detailPanel = document.getElementById('detailPanel');
  	  container.classList.add('detail-open');

  	  // Ajax로 상세정보 받아오기
  	  fetch("/JSPTP/getProductDetail.jsp?p_id=" + p_id)
  	    .then(res => res.text())
  	    .then(html => {
  	      detailPanel.innerHTML = html;
  	    });
  	}



  	function closeDetail() {
    	container.classList.remove('detail-open');      // ✅ 클래스 제거로 상세창 숨김
  	}
  	
  	let isFullView = false;

/*   	function toggleFullView() {
  	  const expandBtn = document.getElementById('expandBtn');

  	  if (!isFullView) {
  	    container.classList.add('fullscreen-mode');
  	    expandBtn.textContent = '↩';       // ✅ 버튼 아이콘 바꾸기
  	    isFullView = true;
  	  } else {
  	    container.classList.remove('fullscreen-mode');
  	    expandBtn.textContent = '🔳';       // ✅ 원래 아이콘으로 복귀
  	    isFullView = false;
  	  }
  	} */
  	
  	function toggleFullView(p_id) {
  		document.getElementById("hiddenPID").value = p_id;
  		document.getElementById("goPdDetail").submit();
  	}

	</script>

	<script>
  	document.querySelectorAll('.sub-nav ul li a').forEach(item => {
    	item.addEventListener('click', function (e) {
/*     		e.preventDefault(); */
    		
      	const selectedText = this.textContent.trim().toLowerCase();
      	const subNav = document.getElementById('subCategoryNav');

      	if (selectedText === 'all') {
        	subNav.style.display = 'none';
      	} else {
        	subNav.style.display = 'block';
      	}

      	// 액티브 클래스 토글
      	document.querySelectorAll('.sub-nav ul li a').forEach(a => a.classList.remove('active'));
      	this.classList.add('active');
    	});
  	});
	</script>

	<script>
  // ✅ 대분류 클릭 시 중분류 토글 + active 처리
  document.querySelectorAll('.sub-nav ul li a').forEach(item => {
    item.addEventListener('click', function (e) {
      // e.preventDefault(); // ❌ 제거: 파라미터 이동을 위해 필요 없음

      const selectedText = this.textContent.trim().toLowerCase();
      const subNav = document.getElementById('subCategoryNav');

      if (selectedText === 'all') {
        subNav.style.display = 'none';
      } else {
        subNav.style.display = 'block';
      }

      // active 토글
      document.querySelectorAll('.sub-nav ul li a').forEach(a => a.classList.remove('active'));
      this.classList.add('active');
    });
  });
</script>

	<script>
  // ✅ 카테고리별 중분류 정의
  const subCategories = {
    outer: ["HEAVY OUTER", "HOODED ZIP-UP", "JACKET", "JUMPER", "VEST", "WIND BREAKER"],
    top: ["HOODIE", "KNIT/CARDIGAN", "LONG SLEEVE", "SHIRT", "SLEEVESS", "SWEAT SHIRT", "T-SHIRT"],
    bottom: ["DENIM", "PANTS", "SHORTS", "TRAINING PANTS"],
    acc: ["BAG", "ETC", "HEADGEAR", "KEYRING", "MUFFLER"],
    etc: ["BELT/NECKLACE", "GLOVES/SOCKS", "OTHERS"]
  };

  // ✅ 파라미터 가져오는 함수
  function getParameterByName(name) {
    const url = window.location.href;
    name = name.replace(/[\\[\\]]/g, '\\$&');
    const regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)');
    const results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
  }

  // ✅ 중분류 렌더링
  function renderSubCategories(category) {
    const subNav = document.getElementById('subCategoryNav');
    const subList = document.getElementById('subCategoryList');
    const currentSub = getParameterByName('subCat'); // 현재 선택된 subCat

    if (!category || category === 'all') {
      subNav.style.display = 'none';
      subList.innerHTML = '';
      return;
    }

    const subs = subCategories[category];
    if (subs && subs.length > 0) {
      subList.innerHTML = '';
      subs.forEach(sub => {
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.href = "productList.jsp?cat=" + category + "&subCat=" + encodeURIComponent(sub);
        a.textContent = sub;

        // ✅ 현재 파라미터 subCat과 일치하면 active
        if (sub === currentSub) {
          a.classList.add('active');
        }

        li.appendChild(a);
        subList.appendChild(li);
      });
      subNav.style.display = 'block';
    } else {
      subList.innerHTML = '';
      subNav.style.display = 'none';
    }
  }

  // ✅ 페이지 로드시 렌더링 실행
  document.addEventListener("DOMContentLoaded", function () {
    const currentCategory = getParameterByName('cat');
    renderSubCategories(currentCategory);
    document.getElementById("itemCnt").textContent = "ITEMS(" + <%=plist.size()%> + ")";
  });
</script>


	<script>
/*  		document.addEventListener("DOMContentLoaded", () => {
    	const wishlistBtn = document.getElementById("wishlistBtn");

    	wishlistBtn.addEventListener("click", () => {
      	wishlistBtn.classList.toggle("active");
      	wishlistBtn.textContent = wishlistBtn.classList.contains("active") ? "❤" : "🤍";
    	});
  	}); */
	</script>
				<script>
				 let selectedSize = null;
				function addToBag(p_id, btnEl){
					<%
					String user_id = (String)session.getAttribute("id");
					if(user_id == null || user_id.equals("") ){
					%>
					alert("회원만 장바구니에 담을 수 있습니다.");
					return;
					<%}%>
				    if (!selectedSize) {
				        alert("사이즈를 선택해주세요.");
				        return false;
				      }

				     fetch("addCart.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "p_id=" + encodeURIComponent(p_id) + "&size=" + encodeURIComponent(selectedSize) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
				     .then(res => {
				       if (!res.ok) {
				         const error = new Error("cart request failed");
				         error.status = res.status;
				         throw error;
				       }
				       return res.json();
				     })
				     .then(data => {
				       if (data.result === "success") {
				    	   // alert()는 눈에 띄지 않을 수 있어 버튼 자체에 즉시 시각 피드백을 준다.
				    	   if (btnEl) {
				    	     const original = btnEl.textContent;
				    	     btnEl.textContent = "담았습니다 ✓";
				    	     btnEl.disabled = true;
				    	     setTimeout(() => { btnEl.textContent = original; btnEl.disabled = false; }, 1500);
				    	   } else {
				    	     alert("장바구니에 추가되었습니다!");
				    	   }
				       } else {
				 		alert("장바구니에 넣을 수 없습니다.");
				       }
				     })
				     .catch(error => {
				       if (error && error.status === 401) {
				         alert("로그인이 필요합니다.");
				       } else {
				         alert("장바구니에 넣을 수 없습니다.");
				       }
				     });
				}
				
				function buyNow(p_id){
				    if (!selectedSize) {
				        alert("사이즈를 선택해주세요.");
				        return false;
				      }
				    
				    fetch('getPdId.jsp', {
				        method: 'POST',
				        headers: {
				          'Content-Type': 'application/x-www-form-urlencoded'
				        },
				        body: "p_id=" + encodeURIComponent(p_id) + "&size=" + encodeURIComponent(selectedSize)
				      })
				      .then(response => response.json())
				      .then(data => {
				        const pd_id = data.pd_id;

				        // 👉 여기서 페이지에 반영하거나, 다른 함수로 넘기기
				        document.getElementById("hidden_pd_id").value = pd_id;
				        document.getElementById("goPayForm").submit();
				      })
				      .catch(error => console.error('에러 발생:', error));
				}
				
				function sizeCheck(name, size){
					selectedSize = size;
					document.getElementById("selectedSize").innerHTML = name + " 옵션 : " + size + "<span class='remove' onclick='deleteSelect()'> X</span>";
					const price = document.getElementById("price").textContent;
					document.getElementById("tprice").textContent = price;

				}
				
				function deleteSelect(){
					selectedSize = null;
					document.getElementById("selectedSize").innerHTML = "";
					document.getElementById("tprice").textContent = "KRW 0";
				}
				
				function addToWish(p_id){
					<%
					String u_id = (String)session.getAttribute("id");
					if(u_id == null || u_id.equals("") ){
					%>
					alert("회원만 찜할 수 있습니다.");
					return;
					<%}%>
				    if (!selectedSize) {
				        alert("사이즈를 선택해주세요.");
				        return false;
				      }
				    
				     const removingWish = document.getElementById("wishlistBtn").classList.contains("active"); /* ❤️ 상태면 해제, 🤍 상태면 찜 */ fetch(removingWish ? "deleteWish.jsp" : "addWish.jsp", {method: "POST", headers: {"Content-Type":"application/x-www-form-urlencoded"}, body: "p_id=" + encodeURIComponent(p_id) + "&size=" + encodeURIComponent(selectedSize) + "&userCsrfToken=<%=Security.UserRequestGuard.token(session)%>"})
				     .then(res => res.json())
				     .then(data => {
				       if (data.result === "success") {
				    	   alert(removingWish ? "찜이 해제되었습니다." : "해당 상품이 찜되었습니다!");
				    		const wishlistBtn = document.getElementById("wishlistBtn");
				          	wishlistBtn.classList.toggle("active");
				          	wishlistBtn.textContent = wishlistBtn.classList.contains("active") ? "❤" : "🤍";
				       } else {
				 		alert("찜할 수 없습니다.");
				       }
				     });	
				}
			</script>

</body>
</html>