<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>포춘쿠키</title>
  <link href="/resources/css/fortuneCookie.css" rel="stylesheet">
  <style>
    /* 팝업창의 흰색 박스 (실제 내용물이 들어가는 부분) 스타일이에요. */
    .popup-content {
      display: flex;
      flex-direction: column; /* 아이템들을 세로로 정렬 */
      align-items: center; /* 가로 방향으로 가운데 정렬 */
      background-color: white; /* 배경은 하얀색 */
      padding: 20px; /* 안쪽 여백 */
      border-radius: 10px; /* 모서리를 둥글게 만들어요. */
      text-align: center; /* 글자나 그림을 가운데 정렬 */
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 그림자 효과를 줘서 입체감을 높여요. */
      max-width: 400px; /* 팝업창의 최대 너비 */
      width: 90%; /* 화면 크기에 따라 너비를 조절해요. */
      box-sizing: border-box; /* 패딩이 너비에 포함되도록 해요. */
    }

    /* 포춘쿠키 그림의 스타일이에요. */
    .fortune-cookie-image {
      width: 150px; /* 그림 너비 */
      height: auto; /* 너비에 맞춰 높이 자동 조절 */
      cursor: pointer; /* 마우스 커서가 손가락 모양으로 변하게 해서 클릭할 수 있다는 걸 알려줘요. */
      margin-bottom: 20px; /* 그림 아래에 여백을 줘요. */
      user-select: none; /* 드래그해서 선택되지 않도록 해요. */
      -webkit-user-drag: none; /* iOS Safari에서 드래그 안 되게 해요. */
    }

    /* 명언이 표시될 부분의 스타일이에요. */
    .fortune-message {
      font-size: 1.2em; /* 글자 크기 */
      color: #333; /* 글자 색상 */
      min-height: 50px; /* 명언이 짧아도 이만큼의 공간을 항상 차지하도록 해서 레이아웃이 흔들리지 않게 해요. */
      display: flex; /* 명언 텍스트를 세로 가운데 정렬하기 위해 사용해요. */
      align-items: center; /* 세로 가운데 정렬 */
      justify-content: center; /* 가로 가운데 정렬 */
      line-height: 1.4; /* 줄 간격을 조절해서 글자가 너무 다닥다닥 붙지 않게 해요. */
    }

    /* 닫기 버튼 스타일 */
    .close-button {
      background-color: #f44336; /* 빨간색 배경 */
      color: white; /* 흰색 글씨 */
      border: none; /* 테두리 없음 */
      padding: 8px 15px; /* 안쪽 여백 */
      border-radius: 5px; /* 모서리 둥글게 */
      cursor: pointer; /* 마우스 올리면 손가락 모양 */
      font-size: 1em; /* 글자 크기 */
      margin-top: 20px; /* 위에 여백 */
      transition: background-color 0.3s ease; /* 색상 변화를 부드럽게 */
    }

    .close-button:hover {
      background-color: #d32f2f; /* 마우스 올렸을 때 더 진한 빨간색 */
    }
  </style>
</head>
<body>
<div class="popup-content" id="fortuneCookieContent">
  <img src="/resources/images/fortune_cookie.png" alt="포춘쿠키" class="fortune-cookie-image" id="cookieImageInModal">

  <p id="fortuneMessageInModal" class="fortune-message"></p>

  <button class="close-button" id="closeButtonInModal">닫기</button>
</div>

<script>
  let modalClickCount = 0;
  const modalCookieImage = document.getElementById('cookieImageInModal');
  const modalFortuneMessage = document.getElementById('fortuneMessageInModal');
  const modalCloseButton = document.getElementById('closeButtonInModal');

  // 포춘쿠키 그림을 클릭했을 때 실행되는 동작을 정의해요.
  if (modalCookieImage) {
    modalCookieImage.addEventListener('click', function() {
      modalClickCount++;

      if (modalClickCount === 2) {
        getFortuneMessageForModal();
      }
    });
  }

  // 닫기 버튼을 클릭했을 때 실행될 함수예요.
  if (modalCloseButton) {
    modalCloseButton.addEventListener('click', function() {
      // 부모 창의 closeFortuneCookieModal 함수를 호출해야 해요!
      if (window.parent && typeof window.parent.closeFortuneCookieModal === 'function') {
        window.parent.closeFortuneCookieModal();
      }
    });
  }

  // 서버(스프링)에서 명언을 가져오는 함수예요. (이전과 동일)
  async function getFortuneMessageForModal() {
    try {
      const response = await fetch('/cookie/random');

      if (!response.ok) {
        throw new Error('명언을 불러오는데 실패했어요.');
      }

      const data = await response.json();
      modalFortuneMessage.textContent = data.content;

    } catch (error) {
      console.error('명언을 불러오는 중 오류 발생:', error);
      modalFortuneMessage.textContent = '명언을 불러올 수 없습니다. 다시 시도해주세요.';
    }
  }
</script>
</body>
</html>