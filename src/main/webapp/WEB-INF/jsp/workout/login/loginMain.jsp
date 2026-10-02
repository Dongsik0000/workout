<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title>로그인 | 운동 기록</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/login.css'/>">
    <script defer src="<c:url value='/resources/js/app/login/login.js'/>"></script>
</head>
<body class="auth-body">
<div class="auth-shell">
    <div class="auth-rack">
        <jsp:include page="/WEB-INF/layout/route-art.jsp"/>
    </div>
    <main class="auth-main">
        <p class="auth-brand">운동 기록</p>
        <h1>로그인</h1>
        <p class="auth-intro">달린 거리와 오늘의 운동을 한곳에 기록하세요.</p>
        <form id="loginForm" class="auth-form" novalidate>
            <label class="field">
                <span>아이디</span>
                <input name="username" type="text" autocomplete="username" required>
            </label>
            <label class="field">
                <span>비밀번호</span>
                <input name="password" type="password" autocomplete="current-password" required>
            </label>
            <button class="button primary block" type="submit">로그인</button>
        </form>
        <p class="auth-switch">처음이라면 <a href="<c:url value='/signup'/>">회원가입</a></p>
    </main>
</div>
</body>
</html>
