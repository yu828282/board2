<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>
<jsp:setProperty name="bbs" property="userId"/>
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
	int bbsId = 0;	
	BbsDAO bbsDAO = new BbsDAO();	
	
	if (request.getParameter("bbsId") != null) {
		bbsId = Integer.parseInt(request.getParameter("bbsId"));
	}	
	if(session.getAttribute("userId") != null){
		userId = (String) session.getAttribute("userId");
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 필요합니다.')");
		script.println("location.href = 'login.jsp'");//로그인 성공 시 main.jsp로 이동
		script.println("</script>");
	}		
	if(!userId.equals(bbsDAO.getBbs(bbsId).getUserId())){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	if (bbsId == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글 입니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	
	int result = bbsDAO.delete(bbsId);	
	if(result == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다. 관리자에게 문의해주세요.')");
		script.println("history.back()");
		script.println("</script>");		
		
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('게시글이 삭제되었습니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}		
	%>
</body>
</html>