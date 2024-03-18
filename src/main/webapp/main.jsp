<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
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
	<jsp:include page="nav.jsp"/>
	<div class="container">
		<div id="carouselExampleAutoplaying" class="carousel slide pt-5 " data-bs-ride="carousel">
		  <div class="carousel-inner">
		    <div class="carousel-item custom-slide active">
		      <img src="img/main_1.jpg" class="d-block w-100 custom-slide-img" alt="..." width="1300" height="550">
	          <div class="carousel-caption text-start carousel-caption-custom">
	            <span class="fs-1 fw-bold">JSP 게시판 사이트</span>
	            <br/>
	            <span class="col-md-8 fs-4">JSP를 이용해 만든 게시판 사이트입니다.</span>
	            <br/>
	            <p><a class="btn btn-outline-light my-3 px-3 custom-slide-button" href="bbs.jsp">게시판 보기</a></p>
	          </div>
		    </div>
		    <div class="carousel-item custom-slide">
		      <img src="img/main_2.jpg" class="d-block w-100 custom-slide-img" alt="..." width="1300" height="550">
	          <div class="carousel-caption text-start carousel-caption-custom">
	            <span class="fs-1 fw-bold">JSP 게시판 사이트</span>
	            <br/>
	            <span class="col-md-8 fs-4">JSP를 이용해 만든 게시판 사이트입니다.</span>
	            <br/>
	            <p><a class="btn btn-outline-light my-3 px-3 custom-slide-button" href="bbs.jsp">게시판 보기</a></p>
	          </div>
		    </div>
		    <div class="carousel-item  custom-slide">
		      <img src="img/main_3.jpg" class="d-block w-100 custom-slide-img" alt="..." width="1300" height="550">
	          <div class="carousel-caption text-start carousel-caption-custom">
	            <span class="fs-1 fw-bold">JSP 게시판 사이트</span>
	            <br/>
	            <span class="col-md-8 fs-4">JSP를 이용해 만든 게시판 사이트입니다.</span>
	            <br/>
	            <p><a class="btn btn-outline-light my-3 px-3 custom-slide-button" href="bbs.jsp">게시판 보기</a></p>
	          </div>
		    </div>
		  </div>
		  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="prev">
		    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Previous</span>
		  </button>
		  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="next">
		    <span class="carousel-control-next-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Next</span>
		  </button>
		</div>
		<div class="p-5 my-4 bg-body-tertiary rounded-3">
		  <div class="container-fluid py-5">
		    <h1 class="display-5 fw-bold">JSP 게시판 사이트</h1>
		    <p class="col-md-8 fs-4">jsp와 MariaDB로 제작한 게시판 사이트입니다.</p>
		    <button class="btn btn-lg btn custom-button" type="button" onclick = "location.href = 'bbs.jsp'">게시판 보기</button>
		  </div>
		</div>
  <div class="container px-4 py-5" id="featured-3">
    <h2 class="pb-2 border-bottom">소개</h2>
    <div class="row g-4 py-5 row-cols-1 row-cols-lg-3">
      <div class="feature col">
        <div class="feature-icon d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-2 mb-3">
        </div>
        <h3 class="fs-2 text-body-emphasis">🪛사용기술</h3>
        <p>
        	<ul>
        		<li>Front : HTML, CSS, JavaScript, Bootstrap 5.3</li>
        		<li>Server : Java 17, ApacheTomcat 9.0</li>
        		<li>DBMS : MariaDB 11.0</li>
        		<li>개발툴 : Eclipse 4.3 </li>
        	</ul>
		</p>
      </div>
      <div class="feature col">
        <div class="feature-icon d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-2 mb-3">
        </div>
        <h3 class="fs-2 text-body-emphasis">🔧기능구현</h3>
        <p>
        	<ul>
        		<li>회원가입 CRUD</li>
        		<li>게시물 CRUD, 페이징, 검색</li>
        		<li>댓글 CRUD</li>
        		<li>첨부파일 업로드, 삭제</li>
        	</ul>
		
      </div>
      <div class="feature col">
        <div class="feature-icon d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-2 mb-3">
        </div>
        <h3 class="fs-2 text-body-emphasis">📝추가기술</h3>
        <p>
        	<ul>
        		<li>게시글 에디터 : 네이버 스마트에디터 2.8</li>
        		<li>주소 api : Daum 우편번호 서비스</li>
        	</ul>
		
      </div>
    </div>
  </div>
	<jsp:include page="footer.jsp"/>
	</div>	
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>