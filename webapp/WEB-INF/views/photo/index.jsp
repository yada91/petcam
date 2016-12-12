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
<script src="https://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	var dialog;
	var img;
	$(function() {
		dialog = $("#dialog-form")
				.dialog(
						{
							autoOpen : false,
							height : 300,
							width : 250,
							modal : true,
							buttons : {
								"upload" : function() {
									var formData = new FormData();
									formData.append("comments", $(
											"input[name=comments]").val());
									formData.append("file",
											$("input[name=file]")[0].files[0]);
									//업로드 시작
									$
											.ajax({
												url : "${pageContext.request.contextPath }/photo/upload",
												data : formData,
												processData : false,
												contentType : false,
												type : 'POST',
												success : function(response) {
													if (response.result != "success") {
														console
																.error(response.message);
														return;
													}
													img = response.data;
													setTimeout(analysis, 1000);

												},
												error : function(jqXHR, status,
														e) {
													console.log(status + ":"
															+ e);
												}
											});

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

	var analysis = function() {
		console.log("analysis start....");
		//업로드 끝
		var formData1 = new FormData();
		//formData1.append("smartCropping", "true");
		//formData1.append("comments", "18");
		//console.log( $("input[name=file]")[0].files[0] );
		formData1.append("", $("input[name=file]")[0].files[0]);

		//ms 시작
		var params = {
			"visualFeatures" : "Tags",
			"language" : "en"
		};
		$.ajax(
				{
					url : "https://api.projectoxford.ai/vision/v1.0/analyze?"
							+ $.param(params),
					processData : false,
					contentType : false,
					beforeSend : function(xhrObj) {
						xhrObj.setRequestHeader("Ocp-Apim-Subscription-Key",
								"bca72475d52c4906b7eb422ab7ac1788");
					},

					type : "POST",
					data : formData1
				}).done(function(response) {
			for (i = 0; i < response['tags'].length; i++)
					console.log(response['tags'][i].name);
		}).fail(function(response) {
			alert(JSON.stringify(response));
		});
	}
	//ms 끝
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
				<div class="col-xs-12 col-md-12">
					<p id="tags"></p>
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