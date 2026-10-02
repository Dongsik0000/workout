<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"%>
<%@ attribute name="title" required="true"%>
<%@ attribute name="page" required="false"%>
<%@ attribute name="script" required="false" fragment="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%-- 로그인 후 화면의 공통 틀(메뉴 + 본문). 사용:
     <t:layout title="오늘의 운동" page="dashboard">
         <jsp:attribute name="script"><script defer src="<c:url value='/resources/js/app/dashboard/dashboard.js'/>"></script></jsp:attribute>
         <jsp:body> ...본문... </jsp:body>
     </t:layout>
     page 는 메뉴에서 현재 화면을 표시하는 값(layout/menu.jsp 의 uiPage 비교) --%>
<c:set var="uiPage" value="${page}" scope="request"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title><c:out value="${title}"/> | 운동 기록</title>
    <jsp:invoke fragment="script"/>
</head>
<body>
<jsp:include page="/WEB-INF/layout/icons.jsp"/>
<a class="skip-link" href="#main-content">본문으로 바로가기</a>
<div class="app-shell">
    <jsp:include page="/WEB-INF/layout/menu.jsp"/>
    <main class="app-main" id="main-content" tabindex="-1">
        <jsp:doBody/>
    </main>
</div>
</body>
</html>
