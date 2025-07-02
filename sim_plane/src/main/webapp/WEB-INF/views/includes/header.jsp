<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!--프레임워크 태그라이브러리 선언 "sec"-->
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>simplane</title>

    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <link href="/resources/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">

    <link href="/resources/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">

    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">


    <title>Document</title>
    <style>
        /* 기존 header.jsp의 CSS는 여기에 그대로 있어요 */
        body{margin: 0; padding: 0; font-family: "맑은 고딕";}
        ul,ol,li {list-style: none; margin: 0; padding: 0;}

        header{width: 1300px; height: 150px; margin: 0 auto; }
        #logo {float: left; width: 130px; height: 70px; margin: 30px 0 0 10px;}
        #logo > img {width: 140px; height: 90px; margin: 30px 0 0 100px;}

        #login {width:250px; height:30px; float:right;  margin:20px 0 0 0px;}
        #login ul {font-size:12px; color:#666;}
        #login li {float:left; margin:0 5px; }
        #login li a {text-decoration:none; color:#666;}

        input{align-items: center; width: 300px; padding: 10px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px;}
        button {padding: 5px 10px; font-size: 16px; cursor: pointer;}

        .seach{display: flex; align-items: center; width: 400px;
            border: 2px solid lightslategray; border-radius: 20px; padding: 10px 15px 0 0;}

        nav{float:right; width: 740px; height: 30px; margin: 70px 0 0 0; text-align: right}
        nav ul{font-family: "Arial"; font-weight: bold; display: inline-block;}
        nav ul li{float: left; padding: 0 20px; display: inline-block;}
        nav ul li a{text-decoration: none; color: #333;}
        nav ul li a:hover{color: green;}

        /* home.jsp의 CSS 부분은 header.jsp가 아닌 home.jsp에 직접 두는 것이 더 좋습니다.
           혹시 header.jsp에 있다면 그대로 두세요. (예: #slider, section, article 등) */

        /* !!! 모달 틀 (어두운 배경)에 대한 스타일 (header.jsp에 통합) !!! */
        .popup-overlay {
            display: none; /* 처음에는 안 보이게 숨겨둬요! */
            position: fixed; /* 화면에 딱 고정시켜서 스크롤해도 움직이지 않게 해요. */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7); /* 검은색으로, 70% 투명하게 만들어요. */
            display: flex; /* 자식 요소들(팝업 내용)을 유연하게 배치하기 위해 사용해요. */
            justify-content: center; /* 가로 방향으로 가운데 정렬 */
            align-items: center; /* 세로 방향으로 가운데 정렬 */
            z-index: 1000; /* 다른 요소들 위에 보이도록 가장 높은 순서로 정해요. */
        }

        /* 요소를 숨길 때 사용하는 마법의 클래스예요. */
        .hidden {
            display: none !important; /* 이 클래스가 있으면 요소가 화면에서 완전히 사라져요. !important는 다른 스타일보다 우선순위를 높여줘요. */
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

                    <form id="logoutForm" action="<c:url value='/logout' />" method="post" style="display:none;">
                    </form>
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <div id="fortuneCookieModalWrapper" class="popup-overlay hidden">
    </div>

    <script>
        const fortuneCookieModalWrapper = document.getElementById('fortuneCookieModalWrapper');

        // 부모 창(home.jsp를 포함하는 header.jsp)에서 모달을 닫는 함수를 전역으로 정의해요.
        // cookie.jsp의 스크립트에서 window.parent.closeFortuneCookieModal()로 호출할 거예요.
        function closeFortuneCookieModal() {
            fortuneCookieModalWrapper.classList.add('hidden'); // 모달 틀 숨기기
            document.body.style.overflow = ''; // 뒷 배경 스크롤 허용
            fortuneCookieModalWrapper.innerHTML = ''; // 모달 내용 비우기 (다음 번에 다시 불러올 때 깨끗하게)
        }

        // 1. "포춘쿠키" 메뉴 링크를 클릭했을 때 모달을 열고 cookie.jsp 내용을 불러와요.
        document.getElementById('openFortuneCookieModalLink').addEventListener('click', async function(event) {
            event.preventDefault(); // 기본 링크 동작(페이지 이동)을 막아요.

            // 모달 열기 전에 이전 내용이 있다면 비워줘요.
            fortuneCookieModalWrapper.innerHTML = '';

            // 모달 틀을 보이게 해요.
            fortuneCookieModalWrapper.classList.remove('hidden');
            document.body.style.overflow = 'hidden'; // 뒷 배경 스크롤 방지

            try {
                // '/cookie/modalContent' 주소로 cookie.jsp의 HTML 내용을 요청해요.
                const response = await fetch('/cookie/modalContent');
                if (!response.ok) {
                    throw new Error('모달 내용을 불러오는데 실패했습니다.');
                }
                const modalHtml = await response.text(); // HTML 내용을 텍스트로 받아와요.

                // 받아온 HTML 내용을 모달 틀 안에 삽입해요.
                fortuneCookieModalWrapper.innerHTML = modalHtml;

                // 모달 어두운 배경 클릭 시 닫기
                fortuneCookieModalWrapper.onclick = function(event) {
                    if (event.target === fortuneCookieModalWrapper) { // 클릭된 요소가 모달 틀 자체일 때만 닫기
                        closeFortuneCookieModal();
                    }
                };

            } catch (error) {
                console.error('모달 내용을 불러오는 중 오류 발생:', error);
                fortuneCookieModalWrapper.innerHTML = '<div class="popup-content"><p>모달 내용을 불러올 수 없습니다.</p><button class="close-button" onclick="closeFortuneCookieModal()">닫기</button></div>';
            }
        });
    </script>

</header>