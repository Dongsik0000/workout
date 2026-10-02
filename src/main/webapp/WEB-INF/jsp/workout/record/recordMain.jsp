<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<t:layout title="기록" page="record">
    <jsp:attribute name="script">
        <link rel="stylesheet" href="<c:url value='/resources/css/record.css'/>">
        <script defer src="<c:url value='/resources/js/app/record/record.js'/>"></script>
    </jsp:attribute>
    <jsp:body>
        <div class="page-head"><div><p class="section-kicker">MY ACTIVITY</p><h1>운동 기록</h1><p class="page-sub">차곡차곡 쌓이는, 나의 움직임.</p></div></div>
        <div id="friendBanner" class="status-note" hidden><strong id="friendName">친구</strong>님의 기록을 보고 있어요. <a href="<c:url value='/workout/record'/>">내 기록으로 돌아가기</a></div>
        <div class="record-layout">
            <section class="panel calendar-panel" aria-label="월별 운동 달력">
                <div class="calendar-heading">
                    <button class="icon-button" type="button" id="btnPrevMonth" aria-label="이전 달"><svg class="icon" aria-hidden="true"><use href="#i-left"></use></svg></button>
                    <h2 id="monthLabel">2026년 10월</h2>
                    <button class="icon-button" type="button" id="btnNextMonth" aria-label="다음 달"><svg class="icon" aria-hidden="true"><use href="#i-right"></use></svg></button>
                </div>
                <div class="calendar-legend"><span><i class="legend-dot exercise"></i>기타 운동</span><span><i class="legend-dot plan"></i>계획 달성</span></div>
                <div id="calendar" class="calendar-grid" aria-label="달력"></div>
                <template id="dayCellTemplate"><button class="day-cell" type="button" data-date=""><span class="day-num"></span><span class="day-run"></span><span class="day-indicators"><span class="day-exercise" hidden></span><span class="day-plan" data-plan="none"></span></span></button></template>
            </section>
            <section id="dayPanel" class="panel day-panel" aria-labelledby="dayTitle">
                <div class="row-between"><div><p class="section-kicker">선택한 날의 기록</p><h2 id="dayTitle">날짜를 선택해 주세요</h2></div><button class="button primary" type="button" id="btnAddExercise">기타 운동 추가</button></div>
                <div class="day-group"><h3>러닝</h3><ul id="dayRunList" class="list-clean"></ul><template id="runItemTemplate"><li><button class="run-item" type="button" data-id=""><span class="run-start"></span><span class="run-distance"></span><span class="run-time"></span><span class="run-pace"></span></button></li></template><p class="day-empty" data-empty-for="run">러닝 기록이 없어요.</p></div>
                <div class="day-group"><h3>기타 운동</h3><ul id="dayExerciseList" class="list-clean"></ul><template id="exerciseItemTemplate"><li data-id=""><div><strong class="exercise-name"></strong><span class="exercise-amount"></span><p class="exercise-memo"></p></div><div class="item-actions"><button class="button small" type="button" data-action="edit">수정</button><button class="button small danger" type="button" data-action="delete">삭제</button></div></li></template><p class="day-empty" data-empty-for="exercise">기타 운동 기록이 없어요.</p></div>
                <div class="day-group"><h3>계획</h3><ul id="dayPlanList" class="list-clean"></ul><template id="planItemTemplate"><li data-done="false"><span class="plan-text"></span><span class="plan-progress"></span></li></template><p class="day-empty" data-empty-for="plan">이날의 계획이 없어요.</p></div>
            </section>
        </div>
        <dialog id="runDetail" class="editor" aria-labelledby="runDetailTitle">
            <div class="editor-head"><h2 id="runDetailTitle">러닝 상세</h2><button class="icon-button" type="button" data-close aria-label="닫기"><svg class="icon" aria-hidden="true"><use href="#i-close"></use></svg></button></div>
            <div class="editor-body"><div id="detailMap" class="detail-map"></div><p id="detailRouteHidden" hidden>친구가 경로를 공개하지 않았어요.</p><span id="detailDate"></span><p class="detail-stat"><strong id="detailDistance">0.00</strong> km</p><p>시간 <span id="detailTime">00:00:00</span> · 평균 페이스 <span id="detailPace">--'--"</span> /km</p><h3>1km 구간</h3><ol id="detailSplitList" class="split-list list-clean"></ol><template id="detailSplitItemTemplate"><li><span class="split-km"></span><span class="split-time"></span></li></template><label class="route-choice"><input id="detailRoutePublic" type="checkbox">친구에게 지도 경로 보여 주기</label></div>
            <div class="editor-actions"><button class="button danger" type="button" id="btnDeleteRun">기록 삭제</button><button class="button" type="button" data-close>닫기</button></div>
        </dialog>
        <dialog id="exerciseEditor" class="editor" aria-labelledby="exerciseEditorTitle">
            <div class="editor-head"><h2 id="exerciseEditorTitle">기타 운동 추가</h2><button class="icon-button" type="button" data-close aria-label="닫기"><svg class="icon" aria-hidden="true"><use href="#i-close"></use></svg></button></div>
            <form id="exerciseForm"><div class="editor-body"><label class="field"><span>날짜</span><input type="date" name="date" required></label><label class="field"><span>종목</span><input name="name" list="exerciseNames" maxlength="50" placeholder="예: 줄넘기" required></label><datalist id="exerciseNames"><option value="줄넘기"><option value="플랭크"><option value="헬스"></datalist><fieldset class="unit-field"><legend>기록 단위</legend><div class="form-choice"><label><input type="radio" name="unit" value="COUNT" checked> 횟수</label><label><input type="radio" name="unit" value="SECOND"> 시간</label></div></fieldset><div data-unit-fields="COUNT"><label class="field"><span>횟수 (회)</span><input name="amount" inputmode="numeric" type="number" min="1"></label></div><div data-unit-fields="SECOND" hidden><div class="field-row"><label class="field"><span>분</span><input name="minutes" inputmode="numeric" type="number" min="0"></label><label class="field"><span>초</span><input name="seconds" inputmode="numeric" type="number" min="0" max="59"></label></div></div><label class="field"><span>메모 (선택)</span><textarea name="memo" rows="3"></textarea></label></div><div class="editor-actions"><button class="button" type="button" data-close>취소</button><button class="button primary" type="submit">저장</button></div></form>
        </dialog>
        <p class="preview-note"><span>미리보기</span>현재 화면을 살펴볼 수 있어요. 기록 조회와 저장 기능은 준비 중입니다.</p>
    </jsp:body>
</t:layout>
