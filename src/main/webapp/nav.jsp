<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBS</title> 
 </head>
<body>
<%
	String userId = null;
	int userNo = 0;
	UserDAO userDAO = new UserDAO();
	if (session.getAttribute("userId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
		userId = (String)session.getAttribute("userId");
		userNo = userDAO.getUser(userId).getUserNo();
	}
	
%>
	<nav class="navbar navbar-expand-md" style="background-color: #cfe2ff;">
	  <div class="container-fluid mx-2">
	    <a class="navbar-brand" href="index.jsp">JSP 게시판</a>
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    <div class="collapse navbar-collapse justify-content-between" id="navbarNavDropdown">
	      <ul class="navbar-nav">
	        <li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="index.jsp">Home</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="bbs.jsp">게시판</a>
	        </li>
	      </ul>
	          	<% 
	          		if(userId != null){ 
	          	%>
		      <span class="navbar-text">'<%= userDAO.getUser(userId).getUserName() %>'님, 환영합니다.😄</span>
		      <%} %>
	      <ul class="navbar-nav pe-5">
	        <li class="nav-item">
	        </li>
	          	<% 
	          		if(userId == null){ 
	          	%>
	        <li class="nav-item dropdown">
	          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
	            로그인
	          </a>
	          <ul class="dropdown-menu">
	            <li><a class="dropdown-item" href="login.jsp">로그인</a></li>
	            <li><a class="dropdown-item" href="join.jsp">회원가입</a></li>     
	          	<% 
	          		}else{
	          	%>	      
	        <li class="nav-item dropdown">
	          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
	            <div class="position-relative d-inline">
	          		<img src="https://via.placeholder.com/32" alt="프로필사진" width="32" height="32" class="rounded-circle custom-icon">
          			<div class="custom-overlay-text"><%= userDAO.getUser(userId).getUserName().substring(0,1) %></div>
  				</div>
	          </a>
	          <ul class="dropdown-menu">      
	            <li><a class="dropdown-item" href="userInfo.jsp?userNo=<%= userNo %>">나의정보</a></li>	 
	            <li><a class="dropdown-item" href="userList.jsp">유저정보</a></li>	 
	            <li><a class="dropdown-item" href="logoutAction.jsp">로그아웃</a></li>  
	          	<% 
	          		}
	          	%>
	          </ul>
	        </li>
	        </ul>
	    </div>
	  </div>
	</nav>
</body>
</html>