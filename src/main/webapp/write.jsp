<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
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
  <style>
  </style>
 </head>
<body>
<%
	String userId = null;
	UserDAO userDAO = new UserDAO();
	if (session.getAttribute("userId") != null){ //세션이 존재하면 아이디값을 받아서 관리할 수 있도록 저장
		userId = (String)session.getAttribute("userId");
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
		<form method="post" action="writeAction.jsp" enctype="multipart/form-data" id="smarteditorForm" accept-charset="UTF-8">
			<table class="table table-hover">
			  <thead class="table-primary">
			    <tr>
			        <th scope="col" class="text-center">#</th>
			        <th scope="col" class="text-center">게시글 작성</th>
		        </tr>
			  </thead>
				<tbody class="table-group-divider">
			    <tr>
			      <th scope="row" class="text-center py-3">제목</th>
			    	<td>
						<input class="form-control" name = "bbsTitle" placeholder="제목을 작성해주세요" maxlength="50"/>
			    	</td>
			    </tr>
			    <tr>
			      <th scope="row" class="text-center py-3">첨부파일</th>
					<td>
						<div id="itemList"> 
					        <div class="item-container">
								<input type="file" class="form-control" id="formFile" name="bbsFile" onchange="readURL(event);" />
								<div id="preview" style="display: flex;"></div>
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
						<textarea class="form-control" id="bbsContent" rows="10" name = "bbsContent" placeholder = "내용을 입력해주세요"  style="width:100%;"></textarea>
			    	</td>
			    </tr>
			    <tr>
			      <th></th>
			    	<td>
						<div class="d-grid gap-2 d-md-flex justify-content-end my-1">
							<button type="submit" class="btn custom-button" onclick="save()" >글쓰기</button>
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
			 // 에디터의 내용이 textarea에 적용된다.
			oEditors.getById["bbsContent"].exec("UPDATE_CONTENTS_FIELD", []);

			 // 에디터의 내용에 대한 값 검증은 이곳에서
			 // document.getElementById("bbsContent").value를 이용해서 처리한다.

			 try {
				 document.getElementById("smarteditorForm").submit();
			 } catch(e) {}
			}		
	</script>
	<script type="text/javascript"> 
		var oEditors = [];
		nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "bbsContent",
		 sSkinURI: "se2/SmartEditor2Skin.html",
		 fCreator: "createSEditor2"
		});
		
	</script>
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>