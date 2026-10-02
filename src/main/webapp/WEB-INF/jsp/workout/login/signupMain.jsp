<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title>회원가입 | 운동 기록</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/login.css'/>">
    <script defer src="<c:url value='/resources/js/app/login/signup.js'/>"></script>
</head>
<body class="auth-body">
<div class="auth-shell">
    <div class="auth-rack">
        <jsp:include page="/WEB-INF/layout/route-art.jsp"/>
    </div>
    <main class="auth-main">
        <p class="auth-brand">운동 기록</p>
        <h1>회원가입</h1>
        <p class="auth-intro">가입 코드를 받은 사람만 가입할 수 있어요.</p>
        <form id="signupForm" class="auth-form" novalidate>
            <label class="field">
                <span>아이디</span>
                <input name="username" type="text" maxlength="50" autocomplete="username" required>
            </label>
            <label class="field">
                <span>비밀번호</span>
                <input name="password" type="password" minlength="8" autocomplete="new-password" required aria-describedby="pwHint">
                <small id="pwHint">8자 이상</small>
            </label>
            <label class="field">
                <span>비밀번호 확인</span>
                <input name="passwordConfirm" type="password" autocomplete="new-password" required>
            </label>
            <label class="field">
                <span>가입 코드</span>
                <input name="signupCode" type="text" autocomplete="off" required>
            </label>
            <button class="button primary block" type="submit">가입하기</button>
        </form>
        <p class="auth-switch">이미 계정이 있다면 <a href="<c:url value='/login'/>">로그인</a></p>
    </main>
</div>
</body>
</html>
