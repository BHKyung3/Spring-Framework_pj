<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/dist/css/main.css' />" />

<div class="container">
  <h2>게시글 수정</h2>

  <form role="form" action="/board/modify" method="post">

    <!-- 검색조건 유지용 히든 -->
    <input type="hidden" name="pageNum" value= '<c:out value="${cri.pageNum}"/>'>
    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
    <input type="hidden" name="keyword" value= <c:out value="${cri.keyword}" />>
    <input type="hidden" name="type" value="${cri.type}">

    <table class="table table-bordered">
      <tr>
        <th>번호</th>
        <td>
          <input type="text" name="boardid" class="form-control" value="${board.boardid}" readonly>
        </td>
      </tr>
      <tr>
        <th>제목</th>
        <td colspan="3">
          <input type="text" name="title" class="form-control" value="${board.title}">
        </td>
      </tr>
      <tr>
        <th>작성자</th>
        <td>
          <input type="text" name="writer" class="form-control" value="${board.writer}" readonly>
        </td>
        <th>작성일</th>
        <td>
          <fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd HH:mm:ss" />
        </td>
      </tr>
      <tr>
        <th>내용</th>
        <td colspan="3">
          <textarea name="content" class="form-control" rows="10" style="white-space: pre-wrap; background-color: white;">${board.content}</textarea>
        </td>
      </tr>
      <tr>
        <th>기존 이미지</th>
        <td colspan="3">
          <div class="uploadResult">
            <ul>
              <c:forEach var="img" items="${images}">
                <li data-file="${img.imagePath}" data-type="image">
                  <img src="/display?fileName=${img.imagePath}" width="100" />
                  <span>${fn:substringAfter(img.imagePath, '_')}</span>
                  <button type="button" class="btn btn-sm btn-danger btn-remove">삭제</button>
                  <input type="hidden" name="existingImagePaths" value="${img.imagePath}" />
                </li>
              </c:forEach>
            </ul>
          </div>
        </td>
      </tr>
      <tr>
        <th>추가 이미지</th>
        <td colspan="3">
          <input type="file" name="uploadFile" multiple>
        </td>
      </tr>
    </table>



    <button type="submit" data-oper='modify' class="btn btn-default">수정 완료</button>
    <button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
    <button type="submit" data-oper='list' class="btn btn-info">목록</button>

  </form>
</div>

<script>
  $(document).ready(function() {
    const formObj = $("form[role='form']");

    // 1. 추가 이미지 업로드 (AJAX)
    $("input[name='uploadFile']").on("change", function () {
      const formData = new FormData();
      const files = this.files;
      for (let i = 0; i < files.length; i++) {
        formData.append("uploadFile", files[i]);
      }

      $.ajax({
        url: "/uploadAjaxAction",
        processData: false,
        contentType: false,
        data: formData,
        type: "POST",
        dataType: "json",
        success: function (result) {
          showUploadedImages(result);
        }
      });
    });

    // 2. 미리보기와 hidden input 생성
    function showUploadedImages(uploadResultArr) {
      if (!uploadResultArr || uploadResultArr.length === 0) return;
      let str = "";
      uploadResultArr.forEach(function (obj) {
        const fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
        const originPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;
        str +=
                `<li data-path="${obj.uploadPath}" data-uuid="${obj.uuid}" data-filename="${obj.fileName}" data-type="${obj.image}">
          <img src="/display?fileName=${fileCallPath}" width="100"><br>
          <span>${obj.fileName}</span>
          <button type="button" class="btn btn-sm btn-danger btn-remove">삭제</button>
          <input type="hidden" name="imagePaths" value="${originPath}">
        </li>`;
      });
      $(".uploadResult ul").append(str);
    }

    // 3. 이미지 삭제(미리보기에서만 삭제, 서버 파일 삭제는 필요시 구현)
    $(".uploadResult").on("click", ".btn-remove", function () {
      const targetLi = $(this).closest("li");
      const fileName = targetLi.find("input[name='imagePaths']").val() || targetLi.data("file");
      // 서버에서도 파일 삭제하고 싶다면 아래 AJAX 요청 추가
      /*
      $.ajax({
        url: "/deleteFile",
        type: "POST",
        data: { fileName: fileName, type: "image" },
        success: function () {
          targetLi.remove();
        }
      });
      */
      targetLi.remove(); // 미리보기에서만 삭제
    });

    // 4. 수정 버튼 (AJAX)
    $("button[data-oper='modify']").on("click", function(e) {
      e.preventDefault();
      let formDataArray = formObj.serializeArray();

      // 기존 이미지
      $(".uploadResult ul li input[name='existingImagePaths']").each(function () {
        formDataArray.push({ name: "existingImagePaths", value: $(this).val() });
      });
      // 새 이미지
      $(".uploadResult ul li input[name='imagePaths']").each(function () {
        formDataArray.push({ name: "imagePaths", value: $(this).val() });
      });

      $.ajax({
        url: "/board/modify",
        type: "POST",
        data: $.param(formDataArray),
        success: function () {
          alert("수정 완료");
          location.href = "/board/list";
        },
        error: function () {
          alert("수정 실패");
        }
      });
    });

    // 5. 삭제 버튼 (form submit)
    $("button[data-oper='remove']").on("click", function(e){
      e.preventDefault();
      formObj.attr("action", "/board/remove").submit();
    });

    // 6. 목록 버튼 (form submit, GET)
    $("button[data-oper='list']").on("click", function(e){
      e.preventDefault();
      formObj.attr("action", "/board/list").attr("method","get").submit();
    });
  });

</script>


<%@ include file="../includes/footer.jsp" %>