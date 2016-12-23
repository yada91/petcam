<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!doctype html>
<html>
<head>
<title>photo</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link href="${pageContext.request.contextPath }/assets/css/lightbox.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath }/assets/css/gallery.css"
	rel="stylesheet" type="text/css">
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	var videoKey="79e132a03d864e828f074a878e838898";
	var dialog;
	var file,formData;
	var tags = "";
	var header;
	var operationUrl;
	var result;
	$(function() {
		dialog = $("#dialog-form")
				.dialog({
							autoOpen : false,
							height : 200,
							width : 350,
							modal : true,
							buttons : {
								"upload" : function() {
									formData = new FormData();
									tags=$("input[name=comments]").val()+" ";
									file=$("input[name=file]")[0].files[0];
									formData.append("file",file);
								
									if("video/mp4"== file.type){
										//"{\"url\":\"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4\"}"
										 setTimeout(upload,1000);
										var geturl=	$.ajax({
								            url: "https://api.projectoxford.ai/video/v1.0/trackface?",
								        	processData : false,
											contentType : false,
								            beforeSend: function(xhrObj){
								            	xhrObj.setRequestHeader( "Content-Type","application/json" );
								                xhrObj.setRequestHeader( "Ocp-Apim-Subscription-Key",videoKey );
								            },
								            type: "POST",
								            data:"{\"url\":\"http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4\"}",
								        })
								        .done(function(XMLHttpRequest,textStatus) {
								            console.log( "success" );
								         	header =geturl.getAllResponseHeaders();
								         	operationUrl=header.split( "\n" )[1].replace( "Operation-Location:", "" ).trim();
								         	console.log( operationUrl );
								          	setTimeout( fetchVideoInfo, 1000 );
								          	
								        })
								        .fail(function () {
								            alert("error");
								        });
									}else{
									//ms 시작
									var params = {
										"visualFeatures" : "Tags",
										"language" : "en"
									};
									$.ajax({url : "https://api.projectoxford.ai/vision/v1.0/analyze?"
																+ $.param(params),
														processData : false,
														contentType : false,
														beforeSend : function(xhrObj) {
															xhrObj.setRequestHeader("Ocp-Apim-Subscription-Key","bca72475d52c4906b7eb422ab7ac1788");
														},
														type : "POST",
														data : formData
													})
											.done(function(response) {
														for (i = 0; i < response['tags'].length; i++) {
															console.log(response['tags'][i].name);
															tags += response['tags'][i].name + " ";
														}
														$("input[name=comments]").val(tags);
														setTimeout(upload,1000);
													})
											.fail(function(response) {
														alert(JSON.stringify(response));
													});
									//ms 끝
									}
								},
								Cancel : function() {
									dialog.dialog("close");
								}
							},
							close : function() {
							}
						});
		$("#upload-image").click(function(event) {
			dialog.dialog("open");
		});
		$("#upload-image1").click(function(event) {
			window.location.href = "${pageContext.request.contextPath }/users/loginform";
		});

	});

	var upload = function() {
		//업로드 시작
		formData.append("comments", tags);
		$.ajax({
			url : "${pageContext.request.contextPath }/photo/upload",
			data : formData,
			processData : false,
			contentType : false,
			type : 'POST',
			success : function(response) {
				if (response.result != "success") {
					console.error(response.message);
					return;
				}
				dialog.dialog("close");
				window.location.href = "${pageContext.request.contextPath }/photo";
			},
			error : function(jqXHR, status, e) {
				console.log(status + ":" + e);
			}
		});
		//업로드 끝
	}
	var fetchVideoInfo = function() {
		var fetchVideo=$.ajax({
            url: operationUrl,
            beforeSend: function(xhrObj){
                xhrObj.setRequestHeader( "Ocp-Apim-Subscription-Key",videoKey );
            },
        })
        .done(function(response) {
            console.log(response);
            result= response.processingResult;
            if("undefined" == result ||"" == result || null ==result ){
            	setTimeout( fetchVideoInfo, 30000 );
            }else{
            	setTimeout( fetchVideoInfo1, 1000 );
            }
           
        })
        .fail(function () {
            alert("error");
        });
	}
	var fetchVideoInfo1 = function() {
		
		$.ajax({
            url: operationUrl+"/content",
            beforeSend: function(xhrObj){
                xhrObj.setRequestHeader( "Ocp-Apim-Subscription-Key",videoKey );
            },
        })
        .done(function(response) {
        
            console.log(response);
            var result = response.split( "," )[7].replace("\"duration\":","").trim();
        	formData.append("comments", result);
            console.log(result);
          // setTimeout(upload,1000);
        })
        .fail(function () {
            alert("error");
        });
	}
</script>
</head>
<body>
	<div id="container">
		<div id="content">
			<div id="gallery">
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
								<li><video width="320" height="240" controls preload="auto">
									<source
										src="${pageContext.request.contextPath }/photo/assets/${vo.saveFileName}"
										type="video/mp4" />
								</video>
								<c:if test="${authUser.no == vo.usersNo}">
									<a href="${pageContext.request.contextPath }/photo/delete?no=${vo.no}"
											class="del-button" title="삭제">삭제</a>
									</c:if>
								</li>
							</c:when>
							<c:otherwise>
								<li>
									<a	href="${pageContext.request.contextPath }/photo/assets/${vo.saveFileName}"
										data-lightbox="gallery" data-title="${vo.comments }" class="image"
										style="background-image:url('${pageContext.request.contextPath }/photo/assets/${vo.saveFileName}')">&nbsp;</a>
									<c:if test="${authUser.no == vo.usersNo}">
									<a href="${pageContext.request.contextPath }/photo/delete?no=${vo.no}"
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
				action="${pageContext.request.contextPath }/photo/upload">
				<div><input type="file" name="file"></div>
				<div> <label>comments</label> <input
					type="text" name="comments"></div>
			</form>
		</div>
	</div>
	<script
		src="${pageContext.request.contextPath }/assets/js/lightbox/lightbox.js"></script>
</body>
</html>