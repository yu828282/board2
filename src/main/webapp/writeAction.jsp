<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="file.FileDAO" %>
<%@ page import="file.Files" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBS</title>
 </head>
<body> 
	<% 	
	request.setCharacterEncoding("UTF-8");
	String directory = application.getRealPath("/upload/"); //이미지 저장 주소
	int maxSize = 1024 * 1024 * 100; //100메가바이트만 저장
	String encoding = "UTF-8";
	MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
	
	String bbsTitle = multipartRequest.getParameter("bbsTitle");
	String bbsContent = multipartRequest.getParameter("bbsContent");
	String userId = null;
	UserDAO userDAO = new UserDAO();	
	BbsDAO bbsDAO = new BbsDAO();
	FileDAO fileDAO = new FileDAO();
	int resultFile = 0;	
	
	String fileName = null;
	String fileRealName = null;
	long fileSize = 0;
	if(multipartRequest.getOriginalFileName("bbsFile") != null){
		fileName = multipartRequest.getOriginalFileName("bbsFile").replaceAll("\\s+","%20"); //파일의 원래 이름
		fileRealName =  multipartRequest.getFilesystemName("bbsFile").replaceAll("\\s+","%20");  //서버에 실제 업로드된 파일의 이름
	}
	//
	String nextExist = "";
	Enumeration files = multipartRequest.getFileNames(); //일명을 배열로 받기 

 	while(files.hasMoreElements()){				//첨부파일 끝까지 계속 반복
 		nextExist = (String)files.nextElement();
 		fileName = multipartRequest.getOriginalFileName(nextExist); 	 //원본 파일명	 비어있으면 오류가 난다..
 		fileRealName = multipartRequest.getFilesystemName(nextExist);	  	//리네임
 	 	if(fileName != null){
 	 		File file = multipartRequest.getFile(nextExist); 			 //파일담기 	 		
 	 		if(file.exists()){  			//파일이 존재하는가
 	 			fileSize = file.length();
 	 			System.out.println("원본파일명 : " + fileName);
 	 			System.out.println("파일명 : " + file.getName());		
 	 			resultFile = fileDAO.write(bbsDAO.getNext(), fileName.replaceAll("\\s+","%20"), fileRealName.replaceAll("\\s+","%20"), fileSize);
 	 		}
 		}
 	  }
	//파일첨부 부분
	
	
	if(session.getAttribute("userId") != null){
		userId = (String) session.getAttribute("userId");
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 필요합니다.')");
		script.println("location.href = 'login.jsp'");//로그인 성공 시 main.jsp로 이동
		script.println("</script>");
	}			
	if(bbsTitle == null || bbsContent == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력되지 않은 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");		
	}else{
		int result = bbsDAO.write(bbsTitle, userId, bbsContent);
		if(resultFile == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('파일 저장에 오류가 발생했습니다. 관리자에게 문의해주세요.')");
			script.println("history.back()");
			script.println("</script>");	
		}else if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글 저장에 오류가 발생했습니다. 관리자에게 문의해주세요.')");
				script.println("history.back()");
				script.println("</script>");		
		}else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('게시글이 작성되었습니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}		
	}	
	%>
</body>
</html>