<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<header class="app-sidebar">
    <a class="brand" href="<c:url value='/workout/run'/>">
        <svg class="mark" aria-hidden="true"><use href="#i-route-mark"></use></svg>
        <span class="brand-name">운동 기록<small>YOUR DAILY PACE</small></span>
    </a>
    <p class="nav-caption">MY WORKOUT</p>
    <nav class="app-nav" id="tabNav" aria-label="주 메뉴">
        <a class="nav-item" data-tab="run" href="<c:url value='/workout/run'/>" aria-current="${requestScope.uiPage eq 'run' ? 'page' : 'false'}">
            <svg class="icon" aria-hidden="true"><use href="#i-run"></use></svg><span>러닝</span>
        </a>
        <a class="nav-item" data-tab="record" href="<c:url value='/workout/record'/>" aria-current="${requestScope.uiPage eq 'record' ? 'page' : 'false'}">
            <svg class="icon" aria-hidden="true"><use href="#i-today"></use></svg><span>기록</span>
        </a>
        <a class="nav-item" data-tab="plan" href="<c:url value='/workout/plan'/>" aria-current="${requestScope.uiPage eq 'plan' ? 'page' : 'false'}">
            <svg class="icon" aria-hidden="true"><use href="#i-target"></use></svg><span>계획</span>
        </a>
        <a class="nav-item" data-tab="friend" href="<c:url value='/workout/friend'/>" aria-current="${requestScope.uiPage eq 'friend' ? 'page' : 'false'}">
            <svg class="icon" aria-hidden="true"><use href="#i-people"></use></svg><span>친구</span>
        </a>
        <a class="nav-item" data-tab="rank" href="<c:url value='/workout/rank'/>" aria-current="${requestScope.uiPage eq 'rank' ? 'page' : 'false'}">
            <svg class="icon" aria-hidden="true"><use href="#i-rank"></use></svg><span>순위</span>
        </a>
    </nav>
    <p class="sidebar-note"><strong>나만의 속도로, 꾸준하게.</strong>오늘의 움직임을 남겨 보세요.</p>
    <div class="profile">
        <svg class="icon" aria-hidden="true"><use href="#i-user"></use></svg>
        <span class="profile-name"><c:out value="${sessionScope.username}"/></span>
        <button class="icon-button" type="button" data-logout aria-label="로그아웃">
            <svg class="icon" aria-hidden="true"><use href="#i-logout"></use></svg>
        </button>
    </div>
</header>
