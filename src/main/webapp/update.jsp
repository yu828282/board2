<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="user.UserDAO" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="file.FileDAO" %>
<%@ page import="file.Files" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBS</title>
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/custom.css" rel="stylesheet">
    <link rel="shortcut icon" href="favicon.ico">
	<script type="text/javascript" src="se2/js/HuskyEZCreator.js" charset="utf-8"></script>
 </head>
<body>
<%
	String userId = null;
	UserDAO userDAO = new UserDAO();
	BbsDAO bbsDAO = new BbsDAO(); 
	FileDAO fileDAO = new FileDAO();
	if (session.getAttribute("userId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
		userId = (String)session.getAttribute("userId");
	}
	int bbsId = 0;
	if (request.getParameter("bbsId") != null){
		bbsId = Integer.parseInt(request.getParameter("bbsId"));
	}
	
	if(userId == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");//이전(로그인) 페이지로 돌려보냄
		script.println("</script>");
	}
	if(bbsId == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	Bbs bbs = new BbsDAO().getBbs(bbsId);
	if(!userId.equals(bbs.getUserId())){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
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
		<form method="post" action="updateAction.jsp?bbsId=<%= bbsId %>" enctype="multipart/form-data" id="smarteditorForm" accept-charset="UTF-8">
			<table class="table table-hover">
			  <thead class="table-primary">
			    <tr>
			        <th scope="col" class="text-center">📖 No.<%= bbsId %></th>
			        <th scope="col" class="text-center">게시글 수정</th>
		        </tr>
			  </thead>
				<tbody class="table-group-divider">
			    <tr>
			      <th scope="row" class="text-center py-3">제목</th>
			    	<td>
						<input class="form-control" name = "bbsTitle" placeholder="제목을 작성해주세요" maxlength="50" value= "<%= bbs.getBbsTitle()%>"/>
			    	</td>
			    </tr>
			    <tr>
			      <th scope="row" class="text-center py-3">기존파일</th>
					<td class="py-3">
						<div class="form-check">
				<% 
							if(fileDAO.getList(bbsId).size() > 0) {
								ArrayList<Files> fileList = fileDAO.getList(bbsId);
								for (int i = 0; i < fileList.size(); i++) {
				%>
						  <input class="form-check-input" type="checkbox" name="checkedValue" value="<%=fileList.get(i).getFileNo() %>" id="myCheckbox" onchange="showAlert()">
						  <label class="form-check-label" for="flexCheckDefault">
							<a href= <%= "./upload/" + fileList.get(i).getFileRealName() %> download> <%= fileList.get(i).getFileName() %></a>&nbsp;
						  </label>		
						</div>
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
			      <th scope="row" class="text-center py-3">파일추가</th>
					<td>
						<div id="itemList"> 
					        <div class="item-container">
								<input type="file" class="form-control" id="formFile" name="bbsFile" onchange="readURL(event);" />
					        </div>
					    </div>
					 <button type="button" onclick="addItem()" class="btn btn-outline-primary">+ 파일추가하기</button>
					</td>
			    </tr>
			    <tr>
			      <th scope="row" class="text-center py-3">글쓴이</th>
			    	<td>
						<input class="form-control" name = "userId"  value="<%= userDAO.getUser(userId).getUserName() %>" readonly>
			    	</td>
			    </tr>
			    <tr>
			      <th scope="row" class="text-center py-3">
			      	<div class="container text-center">
			      		<div class="row align-items-center">
    						<div class="col">내용</div>
			      		</div>
					</div>
			      </th>
			    	<td>
						<textarea class="form-control" id="bbsContent" rows="10" name = "bbsContent" placeholder = "내용을 입력해주세요"  style="width:100%;"><%= bbs.getBbsContent()%></textarea>
			    	</td>
			    </tr>
			    <tr>
			      <th></th>
			    	<td>
						<div class="d-grid gap-2 d-md-flex justify-content-end my-1">
							<button type="submit" class="btn custom-button" onclick="save()">글수정</button>
							<button type="button" class="btn custom-button" onclick = "location.href = 'bbs.jsp'">목록으로</button>
						</div>	
			    	</td>
			    </tr>
			  </tbody>
			</table>
		</form>
	</div>		
	<script>		
	var i = 0;

    function addItem() {
        // 새로운 항목을 생성합니다.
        var newItem = document.createElement('div');
        newItem.classList.add('item-container');
        newItem.classList.add('d-flex'); 
        newItem.classList.add('flex-row'); 
        // 입력란을 추가합니다.
        var inputElement = document.createElement('input');
        i++;
        inputElement.type = 'file';
        inputElement.className = 'form-control me-1';
        inputElement.name = 'bbsFile'+i ;

        // 삭제 버튼을 추가합니다.
        var removeButton = document.createElement('button');
        removeButton.type = 'button';
        removeButton.className = 'btn btn-outline-primary';
        removeButton.textContent = '-';
        removeButton.onclick = function() {
            removeItem(this);
            i--;
        };

        // 생성한 요소들을 새로운 항목에 추가합니다.
        newItem.appendChild(inputElement);
        newItem.appendChild(removeButton);

        // itemList에 새로운 항목을 추가합니다.
        document.getElementById('itemList').appendChild(newItem);
    }

    function removeItem(button) {
        // 해당 삭제 버튼이 속한 항목을 찾아서 제거합니다.
        var itemContainer = button.parentNode;
        itemContainer.parentNode.removeChild(itemContainer);
    }		
		function save() {
			//oEditors.getById["bbsContent"].exec("SET_IR", [""]); //내용초기화
			//oEditors.getById["bbsContent"].exec("PASTE_HTML", [document.getElementById("bbsContent").value]); // 결과 textarea에 삽입
			oEditors.getById["bbsContent"].exec("UPDATE_CONTENTS_FIELD",[]); //에디터의 내용을 textarea에 업데이트
			 // 에디터의 내용에 대한 값 검증은 이곳에서
			 // document.getElementById("bbsContent").value를 이용해서 처리한다.

			 try {
				 document.getElementById("smarteditorForm").submit();
			 } catch(e) {}
			}		 
    function showAlert() {
      // 체크박스의 상태를 확인하여 alert 창 표시
      if (document.getElementById('myCheckbox').checked) {
        alert('체크박스 선택시 해당 파일이 삭제됩니다.');
      }
    }
	</script>
	<script type="text/javascript"> 
		var oEditors = [];
		nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "bbsContent",
		 sSkinURI: "se2/SmartEditor2Skin.html",
		 fCreator: "createSEditor2",
		 htParams: { fOnBeforeUnload : function(){}} // 페이지 이동 시 경고창 발생하지 않게히가
		});
		
	</script>
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>