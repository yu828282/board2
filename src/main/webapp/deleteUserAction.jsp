<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userId = null;
		UserDAO userDAO = new UserDAO();
		if (session.getAttribute("userId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
			userId = (String)session.getAttribute("userId");
		}
		int userNo =  Integer.parseInt(request.getParameter("userNo"));		
		
		if (userId == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
			script.println("location.href = 'login.jsp'");//로그인 성공 시 main.jsp로 이동
			script.println("</script>");
		} 

		if(!userId.equals("admin") && !userDAO.getUserFromNo(userNo).getUserId().equals(userId)){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}

		int result = userDAO.delete(userNo);
		if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('탈퇴에 실패했습니다. 관리자에게 문의해주세요')");
			script.println("history.back()");
			script.println("</script>");
		}else{
			PrintWriter script = response.getWriter();
			session.invalidate();
			script.println("<script>");
			script.println("alert('탈퇴가 완료되었습니다. 안녕히 가세요.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
			}
	%>
</body>
</html>