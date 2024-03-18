<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
	String userName = request.getParameter("userName");
	String userPhone = request.getParameter("userPhone");
	UserDAO userDAO = new UserDAO();		
	String userId = userDAO.findUserId(userName, userPhone);
	
	if(userName == null || userPhone == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력되지 않은 사항이 없습니다.')");
		script.println("history.back()");
		script.println("</script>");		
	}else if(userId == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('회원 정보가 없습니다.')");
		script.println("history.back()");
		script.println("</script>");		
	}
	
	%>
	<jsp:include page="nav.jsp"/>	
	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="p-3">
	  <ol class="breadcrumb">
	    <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
	    <li class="breadcrumb-item active" aria-current="page">아이디, 비밀번호 찾기</li>
	  </ol>
	</nav>
	<div class="container">
	    <div class="row">
	      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
	        <div class="card card-signin my-5 shadow p-3 mb-5 bg-white rounded">
	          <div class="card-body py-5">
	            <h3 class="card-title text-center py-3 fw-semibold">아이디 찾기</h3>
	            회원님의 아이디는 <b><%= userId  %></b> 입니다. 
	          </div>
	              <hr>	
					<div class="d-grid gap-2 ">
					  <button class="btn btn-primary" type="submit">로그인 하기</button>
					  <button class="btn btn-secondary" onclick="location.href='findPw.jsp'" type="button">비밀번호 찾기</button>
					</div>
	        </div>
	      </div>
	    </div>
	</div>	
	<script>function oninputPhone(target) {
    target.value = target.value
        .replace(/[^0-9]/g, '')
        .replace(/(^02.{0}|^01.{1}|[0-9]{3,4})([0-9]{3,4})([0-9]{4})/g, "$1-$2-$3");
	}
	</script>
    <script src="js/bootstrap.bundle.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
</script>
</body>
</html>