<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBS</title>
    <link href="css/bootstrap.css" rel="stylesheet">
    <link rel="shortcut icon" href="favicon.ico">
    <link href="css/custom.css" rel="stylesheet">
 </head>
<body>
<%
	String userId = null; // 세션상 유저 아이디
	UserDAO userDAO = new UserDAO();
	if (session.getAttribute("userId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
		userId = (String)session.getAttribute("userId");
	}
	int userNo =  Integer.parseInt(request.getParameter("userNo"));
	
	String postNumber = null;
	String[] postParts = new String[3];
	if(userDAO.getUserFromNo(userNo).getUserAddress() != null){
		postNumber = userDAO.getUserFromNo(userNo).getUserAddress();
        int startIndex = postNumber.indexOf("(");
        int endIndex = postNumber.indexOf(")");
        postParts[0] = postNumber.substring(startIndex + 1, endIndex);
        int commaIndex = postNumber.indexOf(",");
        postParts[2] = postNumber.substring(commaIndex + 2);
        postParts[1] = postNumber.substring(endIndex + 2, commaIndex);
		
	}
	
	if(userId == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");//이전(로그인) 페이지로 돌려보냄
		script.println("</script>");
	}

	if(!userId.equals("admin") && !userDAO.getUserFromNo(userNo).getUserId().equals(userId)){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}
%>
	<jsp:include page="nav.jsp"/>	
	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="p-3">
	  <ol class="breadcrumb">
	    <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
	    <li class="breadcrumb-item active" aria-current="page">정보관리</li>
	  </ol>
	</nav>
	<div class="container">
	    <div class="row">
	      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
	        <div class="card card-signin my-5 shadow p-3 mb-5 bg-white rounded">
	          <div class="card-body py-5">
	            <h3 class="card-title text-center py-3 fw-semibold">회원정보</h3>
	            <form class="form-signin" method="post" action="userUpdateAction.jsp?userNo=<%= userNo %>">
            	  <div class="d-flex justify-content-end">
            	  	<span class="text-danger text-right"> *&nbsp;</span> 필수입력
            	  </div>
	              <div class="form-floating">
	                <input type="text" id="id" name="userId" class="form-control my-1" maxlength="20" placeholder="" value="<%=userDAO.getUserFromNo(userNo).getUserId() %>" required readonly>
	              	<label for="floatingInput">아이디<span style="color:red;"> * </span></label>
	              </div>
	              <div class="form-floating">
	                <input type="password" id="pwd" name="userPassword" class="form-control my-1" placeholder="" required>
	                <span id="password-toggle" class="password-toggle-icon">👁️</span>
	              	<label for="floatingInput">비밀번호<span style="color:red;"> * </span></label>
	              </div>
	              <div class="form-floating">
	                <input type="password" id="pwdcheck" name="userPasswordcheck" class="form-control my-1" placeholder="" required>
	                <span id="password-toggle-check" class="password-toggle-icon">👁️</span>
	              	<label for="floatingInput">비밀번호 확인<span style="color:red;"> * </span></label>
	              </div>
	              <span id="passwordMatchStatus" style=""></span>
	              <div class="form-floating">
	                <input type="text" name="userName" class="form-control my-1" placeholder="" value="<%=userDAO.getUserFromNo(userNo).getUserName() %>" required>
	              	<label for="floatingInput">이름<span style="color:red;"> * </span></label>
	              </div>
	              <div class="form-floating">
	                <input type="text" name="userPhone" class="form-control my-1" placeholder="" oninput="oninputPhone(this)" value="<%=userDAO.getUserFromNo(userNo).getUserPhone() %>"  required>
	              	<label for="floatingInput">연락처 (숫자만 입력)<span style="color:red;"> * </span></label>
	              </div>
	              <div class="form-floating mb-3">
	                <input type="text" name="userEmail" class="form-control my-1" placeholder="" value="<%=userDAO.getUserFromNo(userNo).getUserEmail() %>" required>
	              	<label for="floatingInput">이메일<span style="color:red;"> * </span></label>
	              </div>
	              <div class="form-floating">
	                <input type="text" name="userTitle" class="form-control my-1" placeholder="" 
	                	<% if(userDAO.getUserFromNo(userNo).getUserTitle() != null){%>
	                		value="<%= userDAO.getUserFromNo(userNo).getUserTitle() %>"
	                	<% }%> >
	              	<label for="floatingInput">직함</label>
	              </div>
	              <div class="form-floating mb-3">
	                <input type="text" name="userTeam" class="form-control my-1" placeholder="" 
	                	<% if(userDAO.getUserFromNo(userNo).getUserTeam() != null){%>
	                		value="<%=userDAO.getUserFromNo(userNo).getUserTeam() %>"
	                	<% }%> >
	              	<label for="floatingInput">소속</label>
	              </div>
	              <div class="form-label-group mb-3">
	              	  <div class="input-group">
						  <input type="text" class="form-control" name = "postAddr1" id="sample6_postcode" placeholder="우편번호" aria-label="Example text with button addon" aria-describedby="button-addon1" value="<%=postParts[0] %>"readonly>
						  <button class="btn btn-outline-secondary" type="button" id="button-addon1" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">우편번호찾기</button>
				      </div>
		              <div class="form-floating">
		                <input type="text" id="sample6_address" name = "postAddr2"  class="form-control my-1" placeholder="" value="<%=postParts[1] %>" readonly>
	              		<label for="floatingInput">주소</label>
		              </div>
		              <div class="form-floating">
		                <input type="text" id="sample6_detailAddress" name = "postAddr3" class="form-control my-1" placeholder=""  value="<%=postParts[2] %>">
	              		<label for="floatingInput">상세주소</label>
		              </div>
	              </div>
	              <hr>	
					<div class="d-grid gap-2 ">
					  <button class="btn btn-primary" type="submit">회원정보 변경하기</button>
					  <button class="btn btn-secondary" onclick="location.href='login.jsp'" type="button">메인페이지로 돌아가기</button>
					  <button type="button" class="btn btn-outline-secondary" onclick = "deleteComment()">회원 탈퇴하기</button>
					</div>
	              	<div class="my-4">
	              	</div>
	            </form>
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
	    function sample6_execDaumPostcode() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                var addr = ''; // 주소 변수
	                var extraAddr = ''; // 참고항목 변수
	
	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }
	
	                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                if(data.userSelectedType === 'R'){
	                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있고, 공동주택일 경우 추가한다.
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                
	                }
	
	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('sample6_postcode').value = data.zonecode;
	                document.getElementById("sample6_address").value = addr;
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById("sample6_detailAddress").focus();
	            }
	        }).open();
	    }

		function deleteComment() {	
		      var userConfirmed = confirm('정말로 탈퇴하시겠습니까?');
	      if (userConfirmed) {
	        location.href = 'deleteUserAction.jsp?userNo=<%=userNo %>';
	      }
		}
        const passwordInput = document.getElementById('pwd');
        const passwordToggle = document.getElementById('password-toggle');

        passwordToggle.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            // 비밀번호 보기 아이콘 변경
            passwordToggle.textContent = type === 'password' ? '👁️‍🗨️' : '👁️';
        });
        

        const passwordInputCheck = document.getElementById('pwdcheck');
        const passwordToggleCheck = document.getElementById('password-toggle-check');

        passwordToggleCheck.addEventListener('click', function() {
            const typecheck = passwordInputCheck.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInputCheck.setAttribute('type', typecheck);
            // 비밀번호 보기 아이콘 변경
            passwordToggleCheck.textContent = typecheck === 'password' ? '👁️‍🗨️' : '👁️';
        });

        document.getElementById("pwdcheck").addEventListener("keyup", function() {
            var password = document.getElementById("pwd").value;
            var passwordCheck = this.value;

            if (password === passwordCheck) {
                document.getElementById("passwordMatchStatus").style.color = "green";
                document.getElementById("passwordMatchStatus").innerText = "비밀번호가 일치합니다.";
            } else {
                document.getElementById("passwordMatchStatus").style.color = "red";
                document.getElementById("passwordMatchStatus").innerText = "비밀번호가 일치하지 않습니다.";
            }
        });
</script>
</body>
</html>