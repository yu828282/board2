<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment" %>
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
		}
		int commentId = 0;
		if(request.getParameter("commentId")!=null)
			commentId=Integer.parseInt(request.getParameter("commentId"));

		if(commentId ==0){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 댓글입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		Comment comment_old = new CommentDAO().getComment(commentId);
		int bbsNo = comment_old.getBbsNo();
		
		if(!userId.equals(comment_old.getUserId())){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		String commentContent = null;
		CommentDAO commentDAO = new CommentDAO();
		if(request.getParameter("new_commentContent")==null){ 
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('댓글을 입력해주세요')");
            script.println("location.href=document.referrer;");
			script.println("</script>");
		}else{
			commentContent = request.getParameter("new_commentContent");
		
		int result = commentDAO.update(commentContent, commentId);
		if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('수정에 실패했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}else{
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("location.href= \'view.jsp?bbsId="+bbsNo+"\'");
			script.println("</script>");
			}
		}
		
	%>
</body>
</html>