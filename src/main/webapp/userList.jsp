<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
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
	String userId = null;
	UserDAO userDAO = new UserDAO();
	if (session.getAttribute("userId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
		userId = (String)session.getAttribute("userId");
	}
	System.out.println(userId.equals("admin"));

	request.setCharacterEncoding("utf-8");
	String searchPart = request.getParameter("searchPart");//post 값에서 가져오기!
	String searchWord = request.getParameter("searchWord");
	
	int pageNumber = 1;
	if(request.getParameter("pageNumber") != null){
		pageNumber = Integer.parseInt(request.getParameter("pageNumber")); //string 을 int로
	}
	ArrayList<User> list = null;
	if(searchWord != null){
		list = userDAO.getUserSearch(searchWord, pageNumber);
	}else{
		list = userDAO.getList(pageNumber);
	}
	int total = 0;
	if(searchWord != null){
		total = userDAO.getSearchTotal(searchWord);
	}else{
		total = userDAO.getTotal();
	}
	
	int totalPage = (int)Math.ceil(total / (double)10);
	int startPage = ((int) Math.ceil(pageNumber / 5.0) -1 ) * 5 + 1;
	int endPage = startPage + 5 - 1;
%>
	<jsp:include page="nav.jsp"/>
	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="p-3">
	  <ol class="breadcrumb">
	    <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
	    <li class="breadcrumb-item active" aria-current="page">유저정보</li>
	  </ol>
	</nav>
	<div class="container my-5 py-5">
 		<caption>총 <%= total %>건의 유저 정보가 있습니다..</caption>
		<table class="table table-hover">
		  <thead class="table-primary">
		    <tr>
		      <th scope="col" >No.</th>
		      <th scope="col">ID</th>
		      <th scope="col">이름</th>
		      <th scope="col">연락처</th>
		      <th scope="col">이메일</th>
		      <th scope="col">직함</th>
		      <th scope="col">소속</th>
		    </tr>
		  </thead>
			<tbody class="table-group-divider">
			<%
				for(int i=0; i<list.size(); i++){
					String title = "";
					String team = "";
					if (list.get(i).getUserTitle() != null){
						title = list.get(i).getUserTitle();
					}
					if (list.get(i).getUserTeam() != null){
						team = list.get(i).getUserTeam();
					}
			%>
		    <tr>
		      <td scope="row" class="text-center"><%= list.get(i).getUserNo() %></td>
		      <td><%if(userId.equals("admin")){ %>
		      	<a href="userInfo.jsp?userNo=<%= list.get(i).getUserNo() %>" class="text-decoration-none custom-a-link"><%= list.get(i).getUserId() %>
		      	</a><%}else{%><%= list.get(i).getUserId() %>
		      	<%}%>
	      	  </td>
		      <td><%if(userId.equals("admin")){ %><a href="userInfo.jsp?userNo=<%= list.get(i).getUserNo() %>" class="text-decoration-none custom-a-link">
		      	<%= list.get(i).getUserName()%>
		      	</a><%}else{%><%= list.get(i).getUserName() %>
		      	<%}%>
		      </td>
		      <td><%if(userId.equals("admin")){ %><a href="userInfo.jsp?userNo=<%= list.get(i).getUserNo() %>" class="text-decoration-none custom-a-link">
		      	<%= list.get(i).getUserPhone()%>
		      	</a><%}else{%><%= list.get(i).getUserPhone() %>
		      	<%}%>
		      	</td>
		      <td><%if(userId.equals("admin")){ %><a href="userInfo.jsp?userNo=<%= list.get(i).getUserNo() %>" class="text-decoration-none custom-a-link">
		      	<%= list.get(i).getUserEmail()%>
		      	</a><%}else{%><%= list.get(i).getUserEmail() %>
		      	<%}%>
		      	</td>
		      <td><%if(userId.equals("admin")){ %><a href="userInfo.jsp?userNo=<%= list.get(i).getUserNo() %>" class="text-decoration-none custom-a-link">
		      	<%= title%>
		      	</a><%}else{%><%= title%>
		      	<%}%>
      		  </td>
		      <td><%if(userId.equals("admin")){ %><a href="userInfo.jsp?userNo=<%= list.get(i).getUserNo() %>" class="text-decoration-none custom-a-link">
		      	<%= team%>
		      	</a><%}else{%><%= team%>
		      	<%}%>
		      </td>
		    </tr>
		    <% 
		    	} 
		    %>
		  </tbody>
		</table>
		<nav aria-label="Page navigation example">
		  <ul class="pagination justify-content-center">
	      <% if(searchWord == null){ %>
		    <li class="page-item">
		    	<a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="userList.jsp?pageNumber=1">처음</a>
	    	</li>
		    <li class="page-item">
		      <a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="userList.jsp?pageNumber=<%= pageNumber - 1%>" aria-label="Previous">
		        <span aria-hidden="true">&laquo;</span>
		      </a>
		    </li>
		    <%}else{ %>
		    <li class="page-item">
		    	<a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="userList.jsp?searchWord=<%=searchWord %>&pageNumber=1">처음</a>
	    	</li>
		    <li class="page-item">
		      <a class="page-link <% if(pageNumber == 1){ %>disabled<% } %>" href="userList.jsp?searchWord=<%=searchWord %>&pageNumber=<%=pageNumber-1 %>" aria-label="Previous">
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
    		<li class="page-item <%if(i == pageNumber){%>active <%}%> "><a class="page-link" href="userList.jsp?pageNumber=<%=i %>"><%=i %></a></li>
			<% }//for문 종료	
			if(searchWord == null){ 
			%>				
		    <li class="page-item <% if(endPage == pageNumber){ %>disabled<%}%>">
		      <a class="page-link" href="userList.jsp?pageNumber=<%= pageNumber + 1%>" aria-label="Next">
		        <span aria-hidden="true">&raquo;</span>
		      </a>
		    </li>
		    <li class="page-item <%if(endPage == pageNumber){%>disabled<%}%>">
		    	<a class="page-link" href="userList.jsp?pageNumber=<%=totalPage %>">맨끝</a>
	    	</li>	
		    <%}else{ %>			
		    <li class="page-item <% if(endPage == pageNumber){ %>disabled<%}%>">
		      <a class="page-link" href="userList.jsp?searchWord=<%=searchWord %>&pageNumber=<%= pageNumber + 1 %>" aria-label="Next">
		        <span aria-hidden="true">&raquo;</span>
		      </a>
		    </li>
		    <li class="page-item <%if(endPage == pageNumber){%>disabled<%}%>">
		    	<a class="page-link" href="userList.jsp?searchWord=<%=searchWord %>&pageNumber=<%=totalPage %>">맨끝</a>
	    	</li>	
		    <%} %>			
		  </ul>
		</nav>
	<div class="container text-left">
		<form method="get" name="searchWord" action="userList.jsp">
		 <div class="row justify-content-end">
		    <div class="col-3 px-1">
		      <input type="text" class="form-control" id="" placeholder="이름, 연락처 등 검색" name="searchWord" value="<%if(searchWord != null){ %><%= searchWord %><% } %>" />
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
	</div>	
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>