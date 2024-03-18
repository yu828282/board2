<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment" %>
<jsp:useBean id="comment" class="comment.Comment" scope="page"/>
<jsp:setProperty name="comment" property="commentContent" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userId = null;
		if(session.getAttribute("userId") != null){
			userId = (String) session.getAttribute("userId");
		}
		if (userId == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
			script.println("location.href = 'login.jsp'");//로그인 성공 시 main.jsp로 이동
			script.println("</script>");
		}else{
			CommentDAO commentDAO = new CommentDAO();
			if(comment.getCommentContent() == null){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글을 입력해주세요.')");
					script.println("history.back()");//이전 페이지로
					script.println("</script>");
				}else{
		             int bbsId = 0; 
		             if (request.getParameter("bbsId") != null){
		                bbsId = Integer.parseInt(request.getParameter("bbsId"));
		             }		             
		             if (bbsId == 0){
		                PrintWriter script = response.getWriter();
		                script.println("<script>");
		                script.println("alert('유효하지 않은 글입니다.')");
						script.println("history.back()");//이전 페이지로
		                script.println("</script>");
		             }
					int result = commentDAO.write(comment.getCommentContent(), userId, bbsId);
					if(result == -1){
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글쓰기에 실패했습니다.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else{
						PrintWriter script = response.getWriter();
						script.println("<script>");
		                   script.println("location.href=document.referrer;"); //링크 이동 전 페이지로 이동
						script.println("</script>");
					}
				}
		}
	%>
</body>
</html>