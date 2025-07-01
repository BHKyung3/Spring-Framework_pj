<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../includes/header.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/dist/css/main.css' />" />

<input type="hidden" id="testid" value="${testid}" />
<c:choose>
    <c:when test="${not empty pageContext.request.userPrincipal}">
        <input type="hidden" id="replyer" value="<sec:authentication property='principal.username' />" />
    </c:when>
    <c:otherwise>
        <input type="hidden" id="replyer" value="" />
    </c:otherwise>
</c:choose>



<div class="container">

    <!-- ✅ 테스트 영역 -->
    <div id="test-section">
        <h2>심리테스트</h2>
        <div id="question-box"></div>
        <div id="choices-box"></div>
    </div>

    <!-- ✅ 결과 영역 -->
    <div id="result-section" style="display: none;">
        <h2>테스트 결과</h2>
        <div id="result-box"></div>
        <button onclick="restartTest()">다시 테스트하기</button>
    </div>

    <hr>

    <form action="/test/list" method="get" style="margin-bottom: 20px;">
        <button type="submit">목록</button>
    </form>

    <!-- ✅ 댓글 영역 -->
    <div id="comment-section">
        <h3>댓글</h3>
        <form id="comment-form">
            <textarea id="comment-content" rows="3" cols="50" placeholder="댓글을 입력하세요"></textarea>
            <button type="submit">작성</button>
        </form>
        <div id="comment-list"></div>
        <div class="panel-footer"></div>
    </div>
</div>

<!-- ✅ JS -->
<script type="text/javascript">
    $(document).ready(function(){


        let testidValue = $("#testid").val();

        console.log("문서 로딩됨");
        console.log("testidValue:", testidValue);

        let pageNum = 1;
        let replyUL = $("#comment-list");
        let replyPageFooter = $(".panel-footer");
        let loggedInUser = $("#replyer").val(); // 로그인 사용자 ID 가져오기

        showList(1);

        function showList(page){
            console.log("showList 실행됨");

            replyService.getList(
                {testid: testidValue, page: page || 1},
                function(replyCnt, list){
                    console.log("댓글 목록 도착:", list);
                    if(page == -1){
                        pageNum = Math.ceil(replyCnt / 10.0);
                        showList(pageNum);
                        return;
                    }

                    let str = "";
                    if(!list || list.length === 0){
                        replyUL.html("<p>댓글이 없습니다.</p>");
                        showReplyPage(replyCnt);
                        return;
                    }

                    for(let i = 0; i < list.length; i++){
                        // *** 핵심 수정: 'reply' 변수를 여기서 정의합니다! ***
                        let reply = list[i]; // <--- 이 줄을 추가해야 합니다.

                        let loginUser = $("#replyer").val();
                        // isOwner 판단 로직도 이제 reply가 정의되었으므로 정상 작동합니다.
                        let isOwner = (loginUser && reply.replyer === loginUser); // 로그인하지 않은 경우 (loginUser가 비어있을 때) isOwner는 false가 되도록 합니다.

                        str += `
                    <div class="reply-box" data-replyid="${reply.replyid}">
                        <p><strong>${reply.replyer}</strong> <small>${replyService.displayTime(reply.replyDate)}</small></p>
                        <p class="reply-text">${reply.reply}</p>
                        ${isOwner ? '<button class="edit-btn">수정</button><button class="delete-btn">삭제</button>' : ''}
                    </div>
                `;
                    }

                    replyUL.html(str);
                    showReplyPage(replyCnt);
                }
            );
        }

        // 댓글 등록 → 화면에 바로 추가
        $("#comment-form").on("submit", function(e){
            e.preventDefault();
            let content = $("#comment-content").val();
            if(!content) {
                alert("댓글을 입력하세요.");
                return;
            }
            // 댓글 등록 전 로그인 여부 확인
            let replyer = $("#replyer").val();
            if (!replyer) {
                alert("로그인 후 댓글을 작성할 수 있습니다.");
                return;
            }

            let reply = { // 이 'reply' 객체를 replyService.add 함수에 전달
                reply: content,
                replyer: loggedInUser, // 로그인 사용자 ID 사용
                testid: testidValue
            };

            replyService.add(reply, function(result, sentReplyData){
                alert("댓글 등록 완료");
                $("#comment-content").val("");

                // 등록된 댓글에도 수정/삭제 버튼 권한 로직 적용
                let isOwnerForNew = (loggedInUser && sentReplyData.replyer === loggedInUser);
                let newComment = `
                    <div class="reply-box" data-replyid="${result}">
                        <p><strong>${sentReplyData.replyer}</strong> <small>방금 전</small></p>
                        <p class="reply-text">${sentReplyData.reply}</p>
                        ${isOwnerForNew ? '<button class="edit-btn">수정</button><button class="delete-btn">삭제</button>' : ''}
                    </div>
                `;
                $("#comment-list").prepend(newComment);
            });
        });

        // 댓글 수정
        $("#comment-list").on("click", ".edit-btn", function(){
            let box = $(this).closest(".reply-box");
            let replyText = box.find(".reply-text").text();

            box.find(".reply-text").replaceWith(`<textarea class="edit-area">${replyText}</textarea>`);
            $(this).replaceWith(`<button class="save-btn">저장</button>`);
        });

        $("#comment-list").on("click", ".save-btn", function(){
            let box = $(this).closest(".reply-box");
            let newReply = box.find(".edit-area").val();
            let replyid = box.data("replyid");

            replyService.update({ replyid: replyid, reply: newReply }, function(result){
                alert("수정 완료");

                box.find(".edit-area").replaceWith(`<p class="reply-text">${newReply}</p>`);
                box.find(".save-btn").replaceWith(`<button class="edit-btn">수정</button>`);
            });
        });

        // 댓글 삭제
        $("#comment-list").on("click", ".delete-btn", function(){
            if(!confirm("정말 삭제하시겠습니까?")) return;

            let box = $(this).closest(".reply-box");
            let replyid = box.data("replyid");

            replyService.remove(replyid, function(result){
                alert("삭제 완료");
                box.remove();
            });
        });

        // 페이징 처리
        function showReplyPage(replyCnt){
            let endNum = Math.ceil(pageNum / 10.0) * 10;
            let startNum = endNum - 9;
            let prev = startNum !== 1;
            let next = endNum * 10 < replyCnt;

            let str = "<ul class='pagination pull-right'>";
            if(prev){
                str += `<li class='page-item'><a class='page-link' href='${startNum-1}'>Previous</a></li>`;
            }

            for(let i = startNum; i <= endNum; i++){
                let active = pageNum == i ? "active" : "";
                str += `<li class='page-item ${active}'><a class='page-link' href='${i}'>${i}</a></li>`;
            }

            if(next){
                str += `<li class='page-item'><a class='page-link' href='${endNum+1}'>Next</a></li>`;
            }

            str += "</ul>";
            replyPageFooter.html(str);
        }

        replyPageFooter.on("click", "li a", function(e){
            e.preventDefault();
            pageNum = $(this).attr("href");
            showList(pageNum);
        });
    });
</script>

<!-- ✅ 외부 JS (replyService 정의되어 있어야 함) -->
<script src="<c:url value='/resources/js/test.js'/>"></script>
<script src="<c:url value='/resources/js/reply.js'/>"></script>

<script>
    $(document).ready(function () {
        testService.getQuestion(1, renderQuestion);
    });
</script>

<%@ include file="../includes/footer.jsp" %>