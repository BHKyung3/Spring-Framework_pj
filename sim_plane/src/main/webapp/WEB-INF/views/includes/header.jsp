<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>simplane</title>

    <!-- CSS Links -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <link href="/resources/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
    <link href="/resources/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <style>
        body { margin: 0; padding: 0; font-family: "마른 고딕"; }
        ul, ol, li { list-style: none; margin: 0; padding: 0; }

        header { width: 1300px; height: 150px; margin: 0 auto; }
        #logo { float: left; width: 130px; height: 70px; margin: 30px 0 0 10px; }
        #logo > img { width: 140px; height: 90px; margin: 30px 0 0 100px; }

        #login { width: 250px; height: 30px; float: right; margin: 20px 0 0 0px; }
        #login ul { font-size: 12px; color: #666; }
        #login li { float: left; margin: 0 5px; }
        #login li a { text-decoration: none; color: #666; }

        input { align-items: center; width: 300px; padding: 10px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px; }
        button { padding: 5px 10px; font-size: 16px; cursor: pointer; }

        .seach { display: flex; align-items: center; width: 400px; border: 2px solid lightslategray; border-radius: 20px; padding: 10px 15px 0 0; }

        nav { float: right; width: 740px; height: 30px; margin: 70px 0 0 0; text-align: right }
        nav ul { font-family: "Arial"; font-weight: bold; display: inline-block; }
        nav ul li { float: left; padding: 0 20px; display: inline-block; }
        nav ul li a { text-decoration: none; color: #333; }
        nav ul li a:hover { color: green; }

        .popup-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .hidden {
            display: none !important;
        }
    </style>
</head>

<body>
<header>
    <div id="logo"><a href="/">로고</a></div>
    <div id="login">
        <ul>
            <sec:authorize access="!isAuthenticated()">
                <li><a href="<c:url value='/login' />">로그인</a></li>
                <li>|</li>
                <li><a href="<c:url value='/signup' />">회원가입</a></li>
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
                <li>
                    <a href="#" onclick="document.getElementById('logoutForm').submit(); return false;">로그아웃</a>
                    <form id="logoutForm" action="<c:url value='/logout' />" method="post" style="display:none;"></form>
                </li>
            </sec:authorize>
        </ul>
    </div>

    <nav>
        <ul>
            <li><a href="/test/list">심리테스트</a></li>
            <li><a href="/fortune/list">운세</a></li>
            <li><a href="#">궁합</a></li>
            <li><a href="#" id="openFortuneCookieModalLink">포춘쿠키</a></li>
            <li><a href="/board/list">문의게시판</a></li>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
                <li><a href="/test/createTest">테스트생성</a></li>
            </sec:authorize>
        </ul>
    </nav>
</header>

<div id="fortuneCookieModalWrapper" class="popup-overlay hidden"></div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script src="${pageContext.request.contextPath}/resources/js/header.js"></script>

</body>
</html>