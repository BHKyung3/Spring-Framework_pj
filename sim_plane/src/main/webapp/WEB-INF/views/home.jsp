<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ include file="./includes/header.jsp" %>
<%-- header.jsp에 <head>와 <body> 시작 태그, 그리고 모달 틀이 이미 포함되어 있어요. --%>

<style>
	#slider{width: 1100px; height: 450px; margin: 0 auto;}
	#slider img{width: 1100px; height: 450px; margin: 0 auto;}
	h4{font-size: 20px; text-align:center; margin: 50px 70px 0 0;}

	section{width: 1100px; height: 280px; margin: 0 auto;}
	article{width: 255px; height: 145px; float: left; margin: 30px 10px;}
	article h3{margin: 0; font-size: 16px; height: 40px; width: 100%;}
	article > a > img{width: 200px; height: 150px}
	article h4{margin: 0; font-size: 14px; height: 30px;}
	article p{font-family: "돋움"; font-size: 12px; color: #666;}


	article .icon img{width: 70px; height: 50px; float: left;margin: 30px 0 0 5px;}
	article .icon span{width: 200%; text-align: left; float: left; font-size: 12px; margin: 10px 0 0 0;}
	article .icon h4{margin: 68px; font-size: 14px; height: 35px;}

	footer{width: 1100px; height: 100px; margin: 0 auto;}

	footer span{font-family: "돋움"; font-size: 12px; color: #666; margin: 20px 100px 0 0; float: left;}

	.board{margin : 0 auto}

	.row{width: 1100px; margin: 0 auto;}
</style>


<div id="slider"><img src="#"></div>
<h4>~BEST 굿즈를 한번에 만나보세요~</h4>

<section>
	<article>
		<h3>짱구는못말려</h3>
		<a href="#"></a>
	</article>
	<article>
		<h3>명탐정코난</h3>
		<a href="#"></a>
	</article>
	<article>
		<h3>약사의 혼잣말</h3>
		<a href="#"></a>
	</article>
	<article>
		<h3>나혼자만 레벨업업</h3>
		<a href="#"></a>
	</article>
</section>

<%@ include file="./includes/footer.jsp" %>
<%-- footer.jsp에 </body>와 </html> 닫는 태그가 있다고 가정함. --%>