<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="user.UserDAO" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="file.FileDAO" %>
<%@ page import="file.Files" %>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
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
	String userId = "";
	int bbsId = 0;
	UserDAO userDAO = new UserDAO();
	CommentDAO commentDAO = new CommentDAO();
	FileDAO fileDAO = new FileDAO();
	if (session.getAttribute("userId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
		userId = (String)session.getAttribute("userId");
	}
	if (request.getParameter("bbsId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
		bbsId = Integer.parseInt(request.getParameter("bbsId"));
	}
	if(bbsId == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs.jsp'");//이전(로그인) 페이지로 돌려보냄
		script.println("</script>");
	}
	Bbs bbs = new BbsDAO().getBbs(bbsId);
%>
	<jsp:include page="nav.jsp"/>
	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="p-3">
	  <ol class="breadcrumb">
	    <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
	    <li class="breadcrumb-item"><a href="bbs.jsp">게시판</a></li>
	    <li class="breadcrumb-item active" aria-current="page">게시판 글쓰기</li>
	  </ol>
	</nav>
	<div class="container my-5 py-5">
		<table class="table table-hover">
		  <thead class="table-primary">
		    <tr>
		        <th scope="col" class="text-center">📖</th>
		        <th scope="col" class="text-center">게시글 보기</th>
	        </tr>
		  </thead>
			<tbody class="table-group-divider">
		    <tr>
		      <th scope="row" class="text-center py-3">제목</th>
		    	<td class="py-3">
					<div><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></div>
		    	</td>
		    </tr>
		    <tr>
		      <th scope="row" class="text-center py-3">글쓴이</th>
		    	<td class="py-3">
					<div><%= userDAO.getUser(bbs.getUserId()).getUserName() %> (ID : <%= bbs.getUserId() %>  )</div>
		    	</td> 
		    </tr>
		    <tr>
		      <th scope="row" class="text-center py-3">작성일</th>
		    	<td class="py-3">
					<div><%= bbs.getBbsDate() %></div>
		    	</td>
		    </tr>
		    <tr>
		      <th scope="row" class="text-center py-3">첨부</th>
		    	<td class="py-3">
				<% 
					if(fileDAO.getList(bbsId).size() > 0) {
						ArrayList<Files> fileList = fileDAO.getList(bbsId);
						for (int i = 0; i < fileList.size(); i++) {
				%>
					<a href= <%= "./upload/" + fileList.get(i).getFileRealName() %> download><%= fileList.get(i).getFileName() %></a>&nbsp;
				<% 
						}
					}else{
				%>
					<div>첨부파일 없음</div>
				<% 
					}
				%>
				</td>
			</tr>
		    <tr>
		      <th scope="row" class="text-center py-3">
		      	<div class="container text-center">
		      		<div class="row align-items-center">
   						<div class="col align-self-center">내용</div>
		      		</div>
				</div>
		      </th>
		    	<td>
					<div class="col py-5 my-5"><%= bbs.getBbsContent().replaceAll("<script", "&lt;scropt") %></div>
		    	</td>
		    </tr>
		    <tr>
		      <th></th>
		    	<td>
					<div class="d-grid gap-2 d-md-flex justify-content-end my-1">
						<button type="button" class="btn custom-button" onclick = "location.href = 'bbs.jsp'">목록으로</button>
						<button type="button" class="btn custom-button" onclick = "location.href = 'update.jsp?bbsId=<%=bbsId %>'">글 수정</button>
						<button type="button" class="btn custom-button" onclick = "deleteComment()">글 삭제</button>
					</div>	
		    	</td>
		    </tr>
		  </tbody>
		</table>
		<div class="container text-center">
		<div class="row">		
			<div><h6 class="text-start">댓글 <%=commentDAO.getTotal(bbsId) %>개</h6></div> 
			<%						
				ArrayList<Comment> list = commentDAO.getList(bbsId);
				for (int i = 0; i < list.size(); i++) {
			%>		
				<hr>
				<div class="col">
					<input class="form-control-plaintext" type="text" value="<%= list.get(i).getCommentContent()%>" readonly>
				</div>
				<div class="col text-end pb-3 text-break">
					<div><%=list.get(i).getCommentDate()%> </div>
					<div>작성 : <%=list.get(i).getUserId()%> &nbsp; &nbsp;
						<a href="#" role="button" onclick=toggleDiv(<%=i %>)>수정</a>
						<a href="commentDelete.jsp?commentId=<%= list.get(i).getCommentId() %>" role="button" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</a>
					</div>
				</div>
				<div class="container updateForm" style="display: none;">
					  <form name="updateForm" class="row" method="post" action="commentUpdate.jsp?commentId=<%= list.get(i).getCommentId() %>">  
					 	<div class="col">
				  			<input type="text" name="new_commentContent" class="form-control" id="" value="<%= list.get(i).getCommentContent()%>">
				  		</div>
					  	<div class="col">
					  		<button type="submit" class="btn btn-secondary mb-3">수정</button>
				  		</div>
					  </form>
				</div>
				
			<%
				}
				%>												                                                                        
			</div>		
		</div>
		<div class="row">
		<form method="post" action="commentWrite.jsp?bbsId=<%= bbsId %>">
			<table class="table table-borderless table-hover" style="text-align: center;">
				<thead class="table-light">
					<tr class="table-secondary">
						<th colspan="2" style="background-color:#eeeeee; text-align: center;">댓글남기기</th>
					</tr>
				</thead>
				<tbody class="table-group-divider">
					<tr>
						<td class="w-100"><input class="form-control" placeholder="글 내용" name="commentContent" maxlength="2048" /></td>
						<td style = "text-align: center;"><div class="" style=""><input type="submit" class="btn btn-secondary"></div></td>
					</tr>
				</tbody>
			</table> 
			</form>
		</div>
	<jsp:include page="footer.jsp"/>
	</div>	
    <script src="js/bootstrap.bundle.min.js"></script>
    <script>
	function toggleDiv(num) {
		
		  const div = document.getElementsByClassName('updateForm')[num]; //클래스 지정 시 리스트 반환
				  if (div.style.display === "none") {
					  div.style.display = "block";
				    } else {
			    		div.style.display = "none";
				    }
		}
	function deleteComment() {	
	      var userConfirmed = confirm('정말로 삭제하시겠습니까?');
      if (userConfirmed) {
        location.href = 'deleteAction.jsp?bbsId=<%=bbsId %>';
      }
	}
	  
	</script>
</body>
</html>