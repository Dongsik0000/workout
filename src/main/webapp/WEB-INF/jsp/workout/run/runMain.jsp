<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<t:layout title="러닝" page="run">
    <jsp:attribute name="script">
        <link rel="stylesheet" href="<c:url value='/resources/css/run.css'/>">
        <script defer src="<c:url value='/resources/js/app/run/run.js'/>"></script>
    </jsp:attribute>
    <jsp:body>
        <div class="page-head run-head">
            <div><p class="section-kicker">MY DAILY RUN</p><h1>오늘도, 나의 페이스로.</h1><p class="page-sub">가볍게 시작해서 차곡차곡 쌓아가는 러닝.</p></div>
            <span class="page-tag"><span></span> 야외 러닝</span>
        </div>
        <div id="resumeBanner" class="status-note run-resume" hidden>
            진행 중이던 러닝이 있어요.
            <button class="button" type="button" id="btnContinueRun">이어서 하기</button>
            <button class="button danger" type="button" id="btnDropRun">버리기</button>
        </div>
        <div class="run-layout">
            <section class="run-map-wrap" aria-label="러닝 지도">
                <div id="map" aria-label="지도 연결 대기"></div>
                <div class="map-heading"><span>내 러닝 경로</span><span class="pill" id="gpsStatus" data-level="lost" role="status">GPS 대기</span></div>
                <div class="map-placeholder">
                    <svg class="route-illustration" viewBox="0 0 400 300" fill="none" aria-hidden="true">
                        <ellipse cx="200" cy="154" rx="154" ry="91" stroke="#d9e4e6"/>
                        <ellipse cx="200" cy="154" rx="119" ry="70" stroke="#d9e4e6"/>
                        <path d="M87 179c-35-45 12-96 72-96 61 0 30 112 90 112 49 0 73-32 54-62" stroke="white" stroke-width="16" stroke-linecap="round"/>
                        <path d="M87 179c-35-45 12-96 72-96 61 0 30 112 90 112 49 0 73-32 54-62" stroke="#8da7b8" stroke-width="3" stroke-linecap="round" stroke-dasharray="1 9"/>
                        <circle cx="87" cy="179" r="10" fill="white"/><circle cx="87" cy="179" r="5" fill="#8baba2"/>
                        <ellipse cx="303" cy="148" rx="20" ry="6" fill="#c5d2da" opacity=".45"/>
                        <path d="M303 142s-22-21-22-36a22 22 0 1 1 44 0c0 15-22 36-22 36Z" fill="#3768ed"/>
                        <circle cx="303" cy="106" r="7" fill="white"/>
                    </svg>
                    <strong>새로운 경로의 시작</strong>
                    <span>지도 기능이 연결되면 달린 경로가 여기에 표시돼요.</span>
                </div>
                <p id="runNotice" class="map-notice"><span aria-hidden="true">i</span> 러닝할 때는 화면을 켜 두세요.</p>
            </section>
            <section id="runPanel" class="run-panel panel" data-state="idle" aria-label="러닝 조작">
                <div class="run-panel-top"><span class="section-kicker">RUN SESSION</span><span class="run-state-label" aria-live="polite">시작 전</span></div>
                <div class="run-idle"><h2>달릴 준비 되셨나요?</h2><p>오늘의 첫 걸음을 시작해 보세요.</p></div>
                <div class="run-live">
                    <div class="run-distance"><small>이동 거리</small><div><strong id="liveDistance">0.00</strong><span>km</span></div></div>
                    <div class="run-metrics">
                        <div><span>운동 시간</span><strong id="liveTime">00:00:00</strong></div>
                        <div><span>현재 페이스 <small>/km</small></span><strong id="livePace">--'--"</strong></div>
                    </div>
                </div>
                <div id="runResult" class="run-result">
                    <h2>오늘도 잘 달렸어요.</h2>
                    <div class="result-main"><strong id="resultDistance">0.00</strong><span>km</span></div>
                    <div class="result-metrics"><span>운동 시간<strong id="resultTime">00:00:00</strong></span><span>평균 페이스 /km<strong id="resultPace">--'--"</strong></span></div>
                    <h3>1km 구간 기록</h3>
                    <ol id="splitList" class="split-list list-clean"></ol>
                    <template id="splitItemTemplate"><li><span class="split-km">1km</span><span class="split-time">--'--"</span></li></template>
                    <p class="muted">아직 기록된 구간이 없어요.</p>
                    <label class="route-choice"><input type="checkbox" id="routePublic"><span>친구에게 지도 경로 보여 주기</span></label>
                </div>
                <div class="run-actions">
                    <button class="button primary" type="button" id="btnStart"><svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true"><path d="m7 4 9 6-9 6Z"/></svg>러닝 시작</button>
                    <button class="button" type="button" id="btnPause">일시정지</button>
                    <button class="button primary" type="button" id="btnResume">다시 시작</button>
                    <button class="button danger" type="button" id="btnStop">종료</button>
                    <button class="button primary" type="button" id="btnSave">기록 저장</button>
                    <button class="button" type="button" id="btnDiscard">버리기</button>
                </div>
                <p class="session-footnote">빠르지 않아도 괜찮아요. 나의 속도로 달려요.</p>
            </section>
        </div>
        <div class="run-support">
            <a href="<c:url value='/workout/plan'/>"><span class="support-icon"><svg class="icon" aria-hidden="true"><use href="#i-target"></use></svg></span><span><strong>오늘의 목표를 정해볼까요?</strong><small>작은 목표가 꾸준한 러닝을 만듭니다.</small></span><span class="support-arrow" aria-hidden="true">↗</span></a>
            <a href="<c:url value='/workout/record'/>"><span class="support-icon mint"><svg class="icon" aria-hidden="true"><use href="#i-today"></use></svg></span><span><strong>나의 움직임, 차곡차곡</strong><small>달력에서 하루하루의 운동을 확인하세요.</small></span><span class="support-arrow" aria-hidden="true">↗</span></a>
        </div>
        <p class="preview-note"><span>미리보기</span>지금은 화면 동작을 체험할 수 있어요. 실제 GPS 기록과 저장은 준비 중입니다.</p>
    </jsp:body>
</t:layout>
