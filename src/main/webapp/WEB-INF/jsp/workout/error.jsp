<%-- isErrorPage 를 쓰지 않는다: 켜면 Spring 이 남긴 예외 속성 때문에 JSP 가 상태를 500 으로 덮어써 404/400 이 500 이 된다 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title>오류 | 운동 기록</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/login.css'/>">
</head>
<body class="auth-body">
<main class="error-page">
    <p class="error-code"><c:out value="${pageContext.errorData.statusCode}" default="오류"/></p>
    <h1>페이지를 열 수 없어요</h1>
    <p>주소가 바뀌었거나 요청을 처리하지 못했습니다. 처음 화면에서 다시 시작해 주세요.</p>
    <a class="button primary" href="<c:url value='/'/>">처음 화면으로</a>
</main>
</body>
</html>
