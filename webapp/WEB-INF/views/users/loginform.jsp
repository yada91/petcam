<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form method="post"
		action="${pageContext.request.contextPath}/users/login">
		<div>
			id<input type="text" name="id">
		</div>
		<div>
			pw<input type="password" name="password">
		</div>
		<c:if test="${param.result eq 'fail'}">
			<p>로그인이 실패 했습니다.</p>
		</c:if>
		<div>
			<input type="submit" value="로그인">
		</div>
	</form>
</body>
</html>