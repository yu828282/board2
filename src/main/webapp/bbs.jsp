<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="user.UserDAO" %>
<%@ page import="file.FileDAO" %>
<%@ page import="file.Files" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBS</title>
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/custom.css" rel="stylesheet">
    <link rel="shortcut icon" href="favicon.ico">
 </head>
<body>
<%	
	UserDAO userDAO = new UserDAO();	
	FileDAO fileDAO = new FileDAO();	

	request.setCharacterEncoding("utf-8");
	String searchPart = request.getParameter("searchPart");//post 값에서 가져오기!
	String searchWord = request.getParameter("searchWord");
	
	int pageNumber = 1;
	if(request.getParameter("pageNumber") != null){
		pageNumber = Integer.parseInt(request.getParameter("pageNumber")); //string 을 int로
	}
	BbsDAO bbsDAO = new BbsDAO();
	ArrayList<Bbs> list = null;
	ArrayList<Files> fileList = null;
	if(searchWord != null && searchPart != null){
		list = bbsDAO.getBbsSearch(searchPart, searchWord, pageNumber);
	}else{
		list = bbsDAO.getList(pageNumber);
	}
	int total = 0;
	if(searchWord != null && searchPart != null){
		total = bbsDAO.getSearchTotal(searchPart, searchWord);
	}else{
		total = bbsDAO.getTotal();
	}
	
	int totalPage = (int)Math.ceil(total / (double)10);
	int startPage = ((int) Math.ceil(pageNumber / 5.0) -1 ) * 5 + 1;
	int endPage = startPage + 5 - 1;
%>
	<jsp:include page="nav.jsp"/>
	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="p-3">
	  <ol class="breadcrumb">
	    <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
	    <li class="breadcrumb-item active" aria-current="page">게시판</li>
	  </ol>
	</nav>
	<div class="container my-5 py-5">
 		<caption>총 <%= total %>건의 게시물이 있습니다.</caption>
		<table class="table table-hover">
		  <thead class="table-primary">
		    <tr>
		      <th scope="col" >No.</th>
		      <th scope="col">제목</th>
		      <th scope="col">작성자</th>
		      <th scope="col">작성시간</th>
		      <th scope="col">첨부</th>
		    </tr>
		  </thead>
			<tbody class="table-group-divider">
			<%
				for(int i=0; i<list.size(); i++){
				fileList = fileDAO.getList(list.get(i).getBbsNo());
			%>
		    <tr>
		      <td scope="row" class="text-center"><%= list.get(i).getBbsNo() %></td>
		      <td><a href="view.jsp?bbsId=<%= list.get(i).getBbsNo() %>" class="text-decoration-none custom-a-link"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
		      <td><%= list.get(i).getUserId()%></td>
		      <td><%= list.get(i).getBbsDate()%></td>
		      <td><% if(fileList.size() > 0){ %> 📂 <% } %></td>
		    </tr>
		    <% 
		    	} 
		    %>
		  </tbody>
		</table>
		<nav aria-label="Page navigation example">
		  <ul class="pagination justify-content-center">
	      <% if(searchWord == null && searchPart == null){ %>
		    <li class="page-item">
		    	<a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="bbs.jsp?pageNumber=1">처음</a>
	    	</li>
		    <li class="page-item">
		      <a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="bbs.jsp?pageNumber=<%= pageNumber - 1%>" aria-label="Previous">
		        <span aria-hidden="true">&laquo;</span>
		      </a>
		    </li>
		    <%}else{ %>
		    <li class="page-item">
		    	<a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="bbs.jsp?searchPart=<%=searchPart %>&searchWord=<%=searchWord %>&pageNumber=1">처음</a>
	    	</li>
		    <li class="page-item">
		      <a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="bbs.jsp?searchPart=<%=searchPart %>&searchWord=<%=searchWord %>&pageNumber=<%=pageNumber-1 %>" aria-label="Previous">
		        <span aria-hidden="true">&laquo;</span>
		      </a>
		    </li>
		    <%} %>
		    <% 
			if(startPage < 1){
				startPage = 1;
			}
			if(endPage > totalPage){
				endPage = totalPage;
			}
			for(int i=startPage; i<=endPage; i++){
			%>
    		<li class="page-item <%if(i == pageNumber){%>active <%}%> "><a class="page-link" href="bbs.jsp?pageNumber=<%=i %>"><%=i %></a></li>
			<% }//for문 종료	
			if(searchWord == null && searchPart == null){ 
			%>				
		    <li class="page-item <% if(endPage == pageNumber){ %>disabled<%}%>">
		      <a class="page-link" href="bbs.jsp?pageNumber=<%= pageNumber + 1%>" aria-label="Next">
		        <span aria-hidden="true">&raquo;</span>
		      </a>
		    </li>
		    <li class="page-item <%if(endPage == pageNumber){%>disabled<%}%>">
		    	<a class="page-link" href="bbs.jsp?pageNumber=<%=totalPage %>">맨끝</a>
	    	</li>	
		    <%}else{ %>			
		    <li class="page-item <% if(endPage == pageNumber){ %>disabled<%}%>">
		      <a class="page-link" href="bbs.jsp?searchPart=<%=searchPart %>&searchWord=<%=searchWord %>&pageNumber=<%= pageNumber + 1 %>" aria-label="Next">
		        <span aria-hidden="true">&raquo;</span>
		      </a>
		    </li>
		    <li class="page-item <%if(endPage == pageNumber){%>disabled<%}%>">
		    	<a class="page-link" href="bbs.jsp?searchPart=<%=searchPart %>&searchWord=<%=searchWord %>&pageNumber=<%=totalPage %>">맨끝</a>
	    	</li>	
		    <%} %>			
		  </ul>
		</nav>
	<div class="container text-left">
		<form method="get" name="search" action="bbs.jsp">
		 <div class="row justify-content-end">
		    <div class="col-5">
		    </div>
		    <div class="col-2 px-0">
			    <select name="searchPart" class="form-select">
					<option value="bbsTitle">제목</option>
					<option value="bbsContent">내용</option>
					<option value="userId">작성자 Id</option>
				</select>
		    </div>
		    <div class="col-3 px-1">
		      <input type="text" class="form-control" id="" placeholder="검색어 입력" name="searchWord" value="<%if(searchWord != null && searchPart != null){ %><%= searchWord %><% } %>" />
		    </div>
		    <div class="col px-0">
		    	<button type="submit" class="btn custom-button">
			    	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
						<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
					</svg>
		    	</button>
		    </div>
		  </div>
		</form>
	</div>
	<div class="d-grid gap-2 d-md-flex justify-content-end my-1">
		<% if((String)session.getAttribute("userId") != null){ %>
		<button type="button" class="btn custom-button" onclick="location.href='write.jsp'">글쓰기</button>
		<% } %>
	</div>	
	</div>	
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>