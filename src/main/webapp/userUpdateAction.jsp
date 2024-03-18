<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userNo"/>
<jsp:setProperty name="user" property="userId"/>
<jsp:setProperty name="user" property="userPassword"/>
<jsp:setProperty name="user" property="userName"/>
<jsp:setProperty name="user" property="userPhone"/>
<jsp:setProperty name="user" property="userEmail"/> 
<jsp:setProperty name="user" property="userTitle"/>
<jsp:setProperty name="user" property="userTeam"/>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBS</title>
 </head>
<body> 
	<% 
	int  userNo = Integer.parseInt(request.getParameter("userNo"));
	String  addr1= request.getParameter("postAddr1");
	String  addr2= request.getParameter("postAddr2");
	String  addr3= request.getParameter("postAddr3");
	String userAddress = "(" + addr1 + ") " + addr2 + ", " + addr3;

	
	String password = request.getParameter("userPassword");
	String passwordCheck = request.getParameter("userPasswordcheck");
	
	if(!password.equals(passwordCheck)){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 잘못되었습니다.')");
		script.println("history.back()");//이전(로그인) 페이지로 돌려보냄
		script.println("</script>");		
	}else if(user.getUserId() == null || user.getUserPassword() == null || user.getUserName() == null  
	|| user.getUserEmail() == null || user.getUserPhone() == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('필수 사항을 모두 입력해주세요.')");
		script.println("history.back()");//이전(로그인) 페이지로 돌려보냄
		script.println("</script>");
	} else{
		UserDAO userDAO = new UserDAO();
		int result = userDAO.update(user.getUserPassword(), user.getUserName(), user.getUserPhone(), user.getUserEmail(), userAddress, user.getUserTitle(), user.getUserTeam(), userNo);
		
		if(result == -1){ //오류가 발생한 경우 -> 유저 아이디 중복
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('오류가 발생했습니다. 관리자에게 문의해주세요.')");
			script.println("history.back()");//이전(로그인) 페이지로 돌려보냄
			script.println("</script>");
		}else if(result > 0){ // 정보수정 완료
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('수정이 완료되었습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
	}
	%>
</body>
</html>