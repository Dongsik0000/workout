<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<t:layout title="계획" page="plan">
    <jsp:attribute name="script"><link rel="stylesheet" href="<c:url value='/resources/css/plan.css'/>"><script defer src="<c:url value='/resources/js/app/plan/plan.js'/>"></script></jsp:attribute>
    <jsp:body>
        <div class="page-head"><div><p class="section-kicker">ONE STEP AT A TIME</p><h1>운동 계획</h1><p class="page-sub">작은 목표 하나가, 꾸준한 내일을 만듭니다.</p></div></div>
        <div class="plan-layout">
            <section class="panel plan-main" aria-labelledby="planDateTitle">
                <div class="plan-head"><div><p class="section-kicker">DAILY GOALS</p><h2 id="planDateTitle">이날의 계획</h2></div><div class="date-nav"><button class="icon-button" type="button" id="btnPrevDay" aria-label="전날"><svg class="icon" aria-hidden="true"><use href="#i-left"></use></svg></button><label class="sr-only" for="planDate">계획 날짜</label><input type="date" id="planDate"><button class="icon-button" type="button" id="btnNextDay" aria-label="다음날"><svg class="icon" aria-hidden="true"><use href="#i-right"></use></svg></button></div></div>
                <ul id="planList" class="plan-list list-clean"></ul>
                <template id="planRowTemplate"><li data-id="" data-done="false"><div class="plan-row-copy"><span class="plan-text"></span><span class="plan-progress"></span><div class="plan-bar"><span></span></div></div><div class="item-actions"><button class="button small" type="button" data-action="edit">수정</button><button class="button small danger" type="button" data-action="delete">삭제</button></div></li></template>
                <div id="planEmpty" class="empty"><svg class="empty-art" viewBox="0 0 144 110" fill="none" aria-hidden="true"><ellipse cx="72" cy="91" rx="48" ry="7" fill="#ecf0f7"/><circle cx="71" cy="54" r="48" fill="#f4f7fc"/><circle cx="71" cy="52" r="32" fill="white" stroke="#c1cfed" stroke-width="1.5"/><circle cx="71" cy="52" r="21" stroke="#c1cfed"/><circle cx="71" cy="52" r="9" fill="#eaf0fd"/><path d="m71 52 24-24m-1 0 1-9 7 7 8-1-6 10-9-1" stroke="#779ceb" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg><h3>오늘의 작은 목표를 정해볼까요?</h3><p>가볍게 1km 달리기부터.<br>할 수 있는 만큼만 계획해 보세요.</p></div>
                <button class="button primary" type="button" id="btnAddPlan">＋ 목표 추가하기</button>
            </section>
            <aside class="panel plan-aside"><span class="guide-tag">나를 위한 작은 약속</span><h2>처음부터<br>멀리 가지 않아도 돼요.</h2><p class="muted">나에게 맞는 목표로<br>오늘의 운동을 시작해 보세요.</p><ol class="plan-tips"><li><span>01</span><div><strong>가볍게 달리기</strong><p>무리 없는 거리부터 시작해요.</p></div></li><li><span>02</span><div><strong>다양하게 움직이기</strong><p>횟수나 시간으로 목표를 정해요.</p></div></li></ol></aside>
        </div>
        <dialog id="planEditor" class="editor" aria-labelledby="planEditorTitle">
            <div class="editor-head"><h2 id="planEditorTitle">목표 추가</h2><button class="icon-button" type="button" data-close aria-label="닫기"><svg class="icon" aria-hidden="true"><use href="#i-close"></use></svg></button></div>
            <form id="planForm"><div class="editor-body">
                <fieldset class="plan-fieldset"><legend>운동 종류</legend><div class="form-choice"><label><input type="radio" name="kind" value="RUN" checked> 러닝</label><label><input type="radio" name="kind" value="EXERCISE"> 기타 운동</label></div></fieldset>
                <div data-kind-fields="RUN"><label class="field"><span>목표 거리 (km)</span><input name="targetKm" type="number" min="0.1" step="0.1" inputmode="decimal" placeholder="예: 5.0"></label></div>
                <div data-kind-fields="EXERCISE" hidden><div class="stack"><label class="field"><span>운동 종목</span><input name="exerciseName" list="exerciseNames" maxlength="50" placeholder="예: 줄넘기"></label><datalist id="exerciseNames"><option value="줄넘기"><option value="플랭크"><option value="헬스"></datalist><fieldset class="plan-fieldset"><legend>기록 단위</legend><div class="form-choice"><label><input type="radio" name="unit" value="COUNT" checked> 횟수</label><label><input type="radio" name="unit" value="SECOND"> 시간</label></div></fieldset><div data-unit-fields="COUNT"><label class="field"><span>목표 횟수 (회)</span><input name="targetAmount" type="number" min="1" inputmode="numeric"></label></div><div data-unit-fields="SECOND" hidden><div class="field-row"><label class="field"><span>분</span><input name="minutes" type="number" min="0" inputmode="numeric"></label><label class="field"><span>초</span><input name="seconds" type="number" min="0" max="59" inputmode="numeric"></label></div></div></div></div>
            </div><div class="editor-actions"><button class="button" type="button" data-close>취소</button><button class="button primary" type="submit">저장</button></div></form>
        </dialog>
        <p class="preview-note"><span>미리보기</span>현재 화면을 살펴볼 수 있어요. 기록 조회와 저장 기능은 준비 중입니다.</p>
    </jsp:body>
</t:layout>
