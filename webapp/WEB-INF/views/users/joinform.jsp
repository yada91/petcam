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
	<form action="${pageContext.request.contextPath}/users/join"
		method="POST">
		<div>
			<label>id</label><input type="text" name="id">
		</div>
		<div>
			<label>pw</label><input type="password" name="password">
		</div>
		<div>
			<label>email</label><input type="text" name="email">
		</div>
		<div>
			<label>name</label><input type="text" name="name">
		</div>
		<div>
			<input type="submit" value="회원가입"> <input type="reset"
				value="취소">
		</div>
	</form>
</body>
</html>