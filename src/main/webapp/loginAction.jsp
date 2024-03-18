<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userId"/>
<jsp:setProperty name="user" property="userPassword"/>
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
	UserDAO userDAO = new UserDAO();	
	if(session.getAttribute("userId") != null){
		userId = (String) session.getAttribute("userId");
	}	
	String rememberId = request.getParameter("rememberId");// 체크박스의 체크여부
	if (userId != null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인이 되어 있습니다.')");
		script.println("location.href = 'main.jsp'");//로그인 성공 시 main.jsp로 이동
		script.println("</script>");
	}
	
	int result = userDAO.login(user.getUserId(), user.getUserPassword());
	if(result == 1){
		session.setAttribute("userId", user.getUserId());
		Cookie cookie = new Cookie("userId", user.getUserId());// 일단 쿠키 생성
		if (rememberId != null) { // 체크박스 체크여부에 따라 쿠키 저장 확인
			cookie.setMaxAge(7*24*60*60); //초 단위, 1주일 유효 
			response.addCookie(cookie); //저장
		} else {
			cookie.setMaxAge(0); //유효시간을 0으로 만들어 자동삭제
			response.addCookie(cookie);
		}
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}else if(result == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다.')");
		script.println("history.back()");
		script.println("</script>");		
	}else if(result == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.')");
		script.println("history.back()");
		script.println("</script>");		
	}else if(result == -2){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다. 관리자에게 문의해주세요.')");
		script.println("history.back()");
		script.println("</script>");		
	}
	%>
</body>
</html>