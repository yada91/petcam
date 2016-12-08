<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%
	pageContext.setAttribute("newLine", "\n");
%>
<!doctype html>
<html>
<head>
<title>photo</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link href="${pageContext.request.contextPath }/assets/css/lightbox.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath }/assets/css/photo.css"
	rel="stylesheet" type="text/css">
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath }/assets/js/jquery/jquery-1.9.0.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	var dialog;
	$(function() {
		dialog = $("#dialog-form").dialog({
			autoOpen : false,
			height : 300,
			width : 250,
			modal : true,
			buttons : {
				"upload" : function() {
					$("#dialog-form form").submit();
				},
				Cancel : function() {
					dialog.dialog("close");
				}
			},
			close : function() {
			}
		});
		$("#upload-image").click(function(event) {
			//event.preeventDefault();
			dialog.dialog("open");
		});
		$("#upload-image1")
				.click(
						function(event) {
							//event.preeventDefault();
							window.location.href = "${pageContext.request.contextPath }/users/loginform";
						});
	});
</script>
<script type="text/javascript">
	$(function() {
		var params = {
			// Request parameters
			"visualFeatures" : "Categories",
			"details" : "{string}",
			"language" : "en",
		};

		$.ajax(
				{
					url : "https://api.projectoxford.ai/vision/v1.0/analyze?"
							+ $.param(params),
					beforeSend : function(xhrObj) {
						// Request headers
						xhrObj.setRequestHeader("Content-Type",
								"application/json");
						xhrObj.setRequestHeader("Ocp-Apim-Subscription-Key",
								"d132a58c2f9f4a7bb94fc55ef53175ed");
					},
					type : "POST",
					// Request body
					data : "{" +
                    "\"url\":\"" + imgPath + "\"}",
				}).done(function(data) {
			alert("success");
		}).fail(function() {
			alert("error");
		});
	});
</script>
</head>
<body>
	<div id="container">
		<div id="content">
			<div id="photo">

				<div>
					<h1>갤러리</h1>
					<c:choose>
						<c:when test="${authUser eq null}">
							<span id="upload-image1">이미지 올리기</span>
						</c:when>
						<c:otherwise>
							<span id="upload-image">이미지 올리기</span>
						</c:otherwise>
					</c:choose>

				</div>

				<ul>
					<c:forEach items="${list }" var="vo">
						<c:choose>
							<c:when test="${vo.extName eq 'mp4'}">
								<video width="320" height="240" controls preload="auto">

									<source
										src="${pageContext.request.contextPath }/photo/assets/${vo.saveFileName}"
										type="video/mp4" />
								</video>
							</c:when>
							<c:otherwise>
								<li><a class="image"
									href="${pageContext.request.contextPath }/photo/assets/${vo.saveFileName}"
									data-lightbox="roadtrip" data-title="${vo.comments }"> <img
										src="${pageContext.request.contextPath }/photo/assets/${vo.saveFileName}"></a>
									<c:if test="${authUser.no == vo.usersNo}">
										<a
											href="${pageContext.request.contextPath }/photo/delete?no=${vo.no}"
											class="del-button" title="삭제">삭제</a>
									</c:if></li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div id="dialog-form" title="upload form" style="display: none">
			<form method="post"
				action="${pageContext.request.contextPath }/photo/upload"
				enctype="multipart/form-data">
				<input type="file" name="file"> <br> comments:<input
					type="text" name="comments">
			</form>
		</div>
	</div>
	<script
		src="${pageContext.request.contextPath }/assets/js/lightbox/lightbox.js"></script>
</body>
</html>