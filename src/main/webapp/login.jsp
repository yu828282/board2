<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		String cookie = null;
		Cookie[] cookies = request.getCookies(); //쿠키생성
		if(cookies != null && cookies.length > 0){
			for (int i = 0; i < cookies.length; i++){
				if (cookies[i].getName().equals("userId")){ // 내가 원하는 쿠키명 찾아서 값 저장
					cookie = cookies[i].getValue();
				}
			}
		}
	%>
	<jsp:include page="nav.jsp"/>
	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="p-3">
	  <ol class="breadcrumb">
	    <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
	    <li class="breadcrumb-item active" aria-current="page">로그인</li>
	  </ol>
	</nav>
	<div class="container">
	    <div class="row">
	      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
	        <div class="card card-signin my-5 shadow p-3 mb-5 bg-white rounded">
	          <div class="card-body py-5">
	            <h3 class="card-title text-center py-3 fw-semibold">로그인 하기</h3>
	            <form class="form-signin" method="post" action="loginAction.jsp">
	              <div class="form-label-group">
	                <input type="text" id="id" name="userId" class="form-control my-1" maxlength="20" placeholder="아이디를 입력해주세요" <% if(cookie != null){ %> value="<%= cookie %>" <%}%>required autofocus>
	              </div>
	              <div class="form-label-group">
	                <input type="password" id="pwd" name="userPassword" class="form-control my-1" placeholder="비밀번호를 입력해주세요" required>
	              	<span id="password-toggle" class="password-toggle-icon-login">👁️‍🗨️</span>
	              </div>
              	<div class="form-label-group">
				    <input class="form-check-input" type="checkbox" value="rememberId" id="remember" name="rememberId">
				    <label class="form-check-label" for="remember">ID 저장하기</label>
              	</div>
	              <hr>	
					<div class="d-grid gap-2 ">
					  <button class="btn btn-primary" type="submit">로그인 하기</button>
					  <button class="btn btn-secondary" onclick="location.href='join.jsp'" type="button">회원가입 하기</button>
					</div>
	              	<div class="my-4 form-check">
	              		<a href="findPw.jsp" class="float-end">비밀번호 찾기</a>
	              		<span class="float-end">,&nbsp;또는&nbsp;</span>
	              		<a href="findId.jsp" class="float-end">아이디 찾기</a>
	              	</div>
	            </form>
	          </div>
	        </div>
	      </div>
	    </div>
	</div>	
    <script src="js/bootstrap.bundle.min.js"></script>
	<script>

        const passwordInput = document.getElementById('pwd');
        const passwordToggle = document.getElementById('password-toggle');

        passwordToggle.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            // 비밀번호 보기 아이콘 변경
            passwordToggle.textContent = type === 'password' ? '👁️‍🗨️' : '👁️';
        });
</script>
</body>
</html>