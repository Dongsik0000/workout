# UI 요청 프롬프트

다른 AI 에게 화면 시안을 요청할 때 쓰는 프롬프트. 프로젝트에는 이미 공통 CSS와 JSP 레이아웃이 있으며, 2026-10-02 러닝 중심 UI 작업본이 마련되었다. 아래 프롬프트를 다시 사용할 때는 기존 파일을 참고 자료로 제공하고 변경점만 요청한다. JS 가 연결할 `id` · `data-*` 는 유지한다.

## 확정한 디자인 방향

- 밝은 배경, 진한 글자, 선명한 파란색. 바벨 대신 경로선과 거리 숫자를 시각 요소로 사용한다.
- 러닝 화면은 지도와 거리·시간·페이스를 함께 읽기 쉽게 배치한다. 진행 중·일시정지 중에는 모바일 하단 탭을 숨긴다.
- 시작 전에는 지도·GPS·시작 버튼을 중심에 놓고 오늘의 계획은 보조 정보로 둔다.
- 달력 날짜 칸에는 거리와 상태 표시만 간결하게 두고, 상세 기록은 아래 패널에 표시한다.
- 순위는 목록형이며 1~3위와 본인 행만 강조한다. PC는 사이드바와 넓은 지도·정보 패널을 사용한다.
- 앱 이름은 우선 `운동 기록`을 유지한다. 로그인 화면은 사진 대신 경로선과 거리 숫자로 구성한다.

## 사용 순서

화면을 한 번에 다 요청하면 결과가 길어져 잘리기 쉽다. 아래 4번에 나눠 요청한다.

| 순서 | 붙여 넣을 내용 | 받을 파일 |
|---|---|---|
| 요청 1 | 공통 프롬프트 + 기존 `common.css`, `login.css` + 요청 1 | `login.html`, `signup.html`, `login.css` 변경안, 공통 CSS 변경안 |
| 요청 2 | 공통 프롬프트 + **프로젝트의 현재 common.css** + 요청 2 | `run.html`, `css/run.css`, `js/run-ui.js` |
| 요청 3 | 공통 프롬프트 + 현재 common.css + 요청 3 | `record.html`, `css/record.css`, `js/record-ui.js` |
| 요청 4 | 공통 프롬프트 + 현재 common.css + 요청 4 | `plan.html`, `friend.html`, `rank.html`, 각 CSS · JS |

모든 요청에 `src/main/webapp/resources/css/common.css`의 현재 내용을 함께 제공한다. 생성된 파일로 기존 CSS를 통째로 덮어쓰지 않는다.

---

## 공통 프롬프트

```text
지인 몇 명이 함께 쓰는 런닝 중심 운동 기록 웹 앱의 화면(HTML/CSS)을 만들어 주세요.

[서비스 설명]
- 메인은 런닝: 휴대폰 브라우저에서 GPS 로 뛴 경로와 거리를 기록하고 지도에 그린다
- 맨몸·줄넘기·헬스 같은 기타 운동은 종목·횟수 또는 시간·메모로 직접 기록한다
- 날짜별 운동 계획(예: 런닝 5km, 줄넘기 500회)을 세우고 달성 여부를 본다
- 친구를 맺은 사람끼리 이번 주·이번 달 런닝 거리와 운동한 날 수로 순위를 겨룬다
- 화면: 로그인, 회원가입, 런닝(메인), 기록(달력), 계획, 친구, 순위
- 로그인 후 화면은 아래쪽 탭으로 이동: 런닝 | 기록 | 계획 | 친구 | 순위

[원하는 분위기] ← 이 줄은 원하는 대로 고쳐서 사용
- 밝고 깔끔한 런닝 앱 느낌, 야외 햇빛 아래에서도 잘 읽히는 높은 대비

[기술 조건 — 꼭 지켜 주세요]
1. 순수 HTML + CSS + JavaScript 만 사용. React·Vue·Tailwind·jQuery·빌드 도구 금지
2. 외부 CDN 금지. 글꼴은 시스템 글꼴 사용
3. JavaScript 는 화면 동작(탭·창 열고 닫기·입력칸 보이기/숨기기)만. 서버 통신·데이터 계산은 넣지 않음
4. 예시 데이터는 HTML 에 직접 적어 보여 주고, 반복되는 항목은 <template> 요소로도 한 벌 만들어 둘 것
   (나중에 제 JS 가 <template> 을 복제해 실제 데이터를 채웁니다)
5. 아래 [필수 id · 속성] 의 이름은 그대로 사용. 바꾸거나 빼지 말 것. 스타일용 class 는 자유
6. 상태는 속성으로 구분하고 CSS 로 스타일링: 예) [data-state="running"], [hidden], [aria-pressed="true"]
7. 모바일 우선(가로 375px 기준). PC 화면은 기존 왼쪽 사이드바를 유지하고, 넓은 지도·정보 패널을 나란히 배치
8. 접근성: 모든 입력칸에 label, 아이콘만 있는 버튼에는 aria-label, 키보드 초점 표시, 터치 영역 최소 44px
9. 빈 상태(기록 없음)·불러오는 중·오류 상태의 모습도 각 화면에 포함
10. 파일마다 코드 블록 하나씩, 블록 위에 파일 이름을 적을 것. 경로는 css/…, js/… 상대 경로

[공통으로 쓰는 요소]
- 메뉴: PC에서는 왼쪽 사이드바, 모바일에서는 아래쪽 탭. <nav id="tabNav"> 안에 링크 5개, 각 링크에 data-tab="run|record|plan|friend|rank".
  현재 화면 링크에는 aria-current="page"
- 로그아웃 버튼: data-logout 속성
- 지도 자리: 지도 SDK 는 넣지 말고, 지정한 id 의 빈 <div> 에 크기와 회색 배경만 줄 것

[알림창 · 불러오는 중 — 기존 common.css 스타일을 재사용하고 필요한 변경점만 제안]
제 JS 가 아래 구조를 직접 만들어 body 끝에 붙이고, 열 때 .is-open 클래스를 붙입니다.
.manage-modal 은 평소에 숨기고 .is-open 일 때 화면 가운데에 보이게 해 주세요.

1) 확인 알림 (성공 안내)
<div class="manage-modal manage-complete-modal is-open">
  <div class="manage-modal-backdrop"></div>
  <section class="manage-modal-dialog manage-complete-dialog">
    <div class="manage-complete-body">
      <div class="manage-complete-icon-wrap"><div class="manage-complete-icon"></div></div>
      <h3 class="manage-complete-title">저장했어요</h3>
      <p class="manage-complete-desc">설명 (비어 있을 수 있음)</p>
      <button class="manage-complete-button">확인</button>
    </div>
  </section>
</div>

2) 오류 알림
<div class="manage-modal manage-modal-light route-error-demo-modal is-open">
  <div class="manage-modal-backdrop"></div>
  <section class="manage-modal-dialog">
    <div class="route-error-demo-body">
      <div class="route-error-demo-icon"><span></span><span></span></div>
      <h3 class="common-warn-title">오류 제목</h3>
      <p class="common-warn-desc">오류 설명</p>
    </div>
    <div class="manage-modal-actions route-error-demo-actions">
      <button class="manage-modal-btn primary route-error-demo-button">확인</button>
    </div>
  </section>
</div>

3) 확인/취소 질문
<div class="manage-modal manage-modal-light common-confirm-modal is-open">
  <div class="manage-modal-backdrop"></div>
  <section class="manage-modal-dialog">
    <div class="manage-modal-head route-confirm-demo-head">
      <div class="route-confirm-demo-copy">
        <h3 class="common-confirm-title">런닝을 끝낼까요?</h3>
        <p class="common-confirm-desc">설명</p>
      </div>
      <button class="manage-modal-close" aria-label="팝업 닫기"></button>
    </div>
    <div class="manage-modal-actions route-confirm-demo-actions">
      <button class="manage-modal-btn ghost">취소</button>
      <button class="manage-modal-btn primary common-confirm-ok">확인</button>
    </div>
  </section>
</div>

4) 불러오는 중 (위치를 잡은 영역 위에 덮임)
<div class="line-manage-loading">
  <div class="line-manage-loading-inner">
    <div class="spinner-wrap"><div class="krds-spinner"></div></div>
    <h1 class="loading-title">불러오는 중..</h1>
  </div>
</div>

[편집 창]
기록 추가·수정 창은 <dialog> 요소로 만들고, 닫기 버튼에는 data-close 속성을 붙여 주세요.
열고 닫기는 dialog.showModal() / dialog.close() 를 씁니다.
```

---

## 요청 1 — 공통 스타일, 로그인, 회원가입

```text
[이번 요청] login.html, signup.html, 기존 css/login.css 변경안, 필요한 css/common.css 변경안

기존 common.css의 변수, 버튼, 입력칸, 카드, 빈 상태, PC 사이드바·모바일 탭, 편집 창과 알림창 스타일을 재사용해 주세요.
바벨 느낌을 러닝 경로선 중심으로 바꾸는 데 필요한 CSS 변경점만 별도로 제안해 주세요.

[login.html — 로그인]
- 앱 이름과 짧은 소개 한 줄
- <form id="loginForm">
    <input name="username"> 아이디 (autocomplete="username")
    <input name="password" type="password"> 비밀번호 (autocomplete="current-password")
    로그인 버튼 (type="submit")
- 회원가입 화면으로 가는 링크 (href="signup.html")

[signup.html — 회원가입]
- 가입 코드를 받은 사람만 가입할 수 있다는 안내
- <form id="signupForm">
    <input name="username"> 아이디 (최대 50자)
    <input name="password" type="password"> 비밀번호 (8자 이상 안내)
    <input name="passwordConfirm" type="password"> 비밀번호 확인
    <input name="signupCode"> 가입 코드
    가입하기 버튼 (type="submit")
- 로그인 화면으로 가는 링크 (href="login.html")

두 화면에는 아래쪽 탭이 없습니다.
```

---

## 요청 2 — 런닝 (메인)

```text
[이번 요청] run.html, css/run.css, js/run-ui.js
(아래에 프로젝트의 현재 common.css 를 붙여 넣었습니다. 기존 클래스를 우선 재사용해 주세요.)

[run.html — 런닝, 메인 화면]
뛰는 중에 지도와 거리·시간·페이스가 모두 잘 보여야 합니다: 지도는 넓게, 수치는 높은 대비로, 버튼은 최소 56px이며 한 손 엄지로 닿는 아래쪽에 배치합니다. 모바일에서 running·paused 상태에는 하단 탭을 숨깁니다.

화면 구성
- 지도: <div id="map"> 화면 대부분을 차지 (회색 배경, 높이 지정)
- GPS 상태 표시: <span id="gpsStatus" data-level="good|weak|lost"> 예) "GPS 양호" / "GPS 약함" / "위치를 찾는 중"
- 안내 문구: <p id="runNotice"> 예) "화면을 켜 둔 채로 뛰어 주세요"
- 런닝 패널: <section id="runPanel" data-state="idle|running|paused|finished">
  data-state 값에 따라 보이는 것을 CSS 로 바꿔 주세요. 상태 4가지 모습을 모두 디자인해 주세요.
    idle      : 시작 버튼만 크게
    running   : 실시간 수치 + 일시정지·종료 버튼
    paused    : 실시간 수치(흐리게 또는 "일시정지됨" 표시) + 다시 시작·종료 버튼
    finished  : 결과 확인 영역
- 실시간 수치 (running·paused)
    <strong id="liveDistance">3.42</strong> km
    <span id="liveTime">00:25:13</span> 시간
    <span id="livePace">7'22"</span> 현재 페이스(/km)
- 버튼
    <button id="btnStart">시작</button>
    <button id="btnPause">일시정지</button>
    <button id="btnResume">다시 시작</button>
    <button id="btnStop">종료</button>
- 결과 확인 영역 <div id="runResult"> (finished)
    <strong id="resultDistance">5.03</strong> km, <span id="resultTime">00:38:41</span>, <span id="resultPace">7'41"</span>
    1km 구간 목록 <ol id="splitList">
      <template id="splitItemTemplate">
        <li><span class="split-km">1km</span> <span class="split-time">7'35"</span></li>
      </template>
    경로 공개 선택: <input type="checkbox" id="routePublic"> "친구에게 지도 경로 보여 주기"
    <button id="btnSave">저장</button> <button id="btnDiscard">버리기</button>
- 이어서 하기 안내 (평소 hidden): <div id="resumeBanner" hidden>
    "진행 중이던 런닝이 있어요." <button id="btnContinueRun">이어서 하기</button> <button id="btnDropRun">버리기</button>
- 아래쪽 탭 (#tabNav, 런닝에 aria-current="page"), 로그아웃(data-logout)

js/run-ui.js 에는 디자인 확인용으로 data-state 를 idle → running → paused → finished 로 바꿔 보는
임시 버튼 동작만 넣어 주세요. (실제 동작은 제가 따로 연결합니다)
```

---

## 요청 3 — 기록 (달력)

```text
[이번 요청] record.html, css/record.css, js/record-ui.js
(아래에 프로젝트의 현재 common.css 를 붙여 넣었습니다. 기존 클래스를 우선 재사용해 주세요.)

[record.html — 기록 달력]
직접 만든 월 달력이 중심입니다. 날짜 칸에 그날의 기록이 한눈에 보여야 합니다.

화면 구성
- 친구 달력 표시 (평소 hidden): <div id="friendBanner" hidden> "<span id="friendName">minsu</span>님의 기록" + 내 기록으로 돌아가는 링크
- 월 이동: <button id="btnPrevMonth" aria-label="이전 달">, <h2 id="monthLabel">2026년 10월</h2>, <button id="btnNextMonth" aria-label="다음 달">
- 달력: <div id="calendar"> 요일 머리(월 화 수 목 금 토 일, 월요일 시작) + 날짜 칸 6주
  <template id="dayCellTemplate">
    <button class="day-cell" data-date="2026-10-03">
      <span class="day-num">3</span>
      <span class="day-run">5.0km</span>          (런닝 없으면 비어 있음)
      <span class="day-exercise"></span>          (기타 운동 있으면 점 표시, 없으면 hidden)
      <span class="day-plan" data-plan="none|done|partial|missed"></span>  (계획 달성 표시)
    </button>
  </template>
  날짜 칸 상태: .is-today(오늘), aria-pressed="true"(선택됨), .is-outside(다른 달 날짜)
- 하루 상세 패널: <section id="dayPanel">
    <h3 id="dayTitle">10월 3일 (토)</h3>
    런닝 목록 <ul id="dayRunList">
      <template id="runItemTemplate">
        <li><button class="run-item" data-id="12">
          <span class="run-start">07:10</span> <span class="run-distance">5.03km</span>
          <span class="run-time">38:41</span> <span class="run-pace">7'41"</span>
        </button></li>
      </template>
    기타 운동 목록 <ul id="dayExerciseList">
      <template id="exerciseItemTemplate">
        <li data-id="7">
          <span class="exercise-name">줄넘기</span> <span class="exercise-amount">500회</span>
          <p class="exercise-memo">2단 뛰기 50회 포함</p>
          <button data-action="edit">수정</button> <button data-action="delete">삭제</button>
        </li>
      </template>
    계획 목록 <ul id="dayPlanList">
      <template id="planItemTemplate">
        <li data-done="true"><span class="plan-text">런닝 5km</span> <span class="plan-progress">5.03 / 5km</span></li>
      </template>
    <button id="btnAddExercise">기타 운동 추가</button>   (친구 달력일 때는 숨김)
    빈 상태: "이날은 기록이 없어요"

- 런닝 상세 창: <dialog id="runDetail">
    <div id="detailMap"> (회색 지도 자리)
    <p id="detailRouteHidden" hidden>친구가 경로를 공개하지 않았어요</p>
    <span id="detailDate">10월 3일 07:10</span>
    <strong id="detailDistance">5.03</strong> km, <span id="detailTime">38:41</span>, <span id="detailPace">7'41"</span>
    1km 구간 <ol id="detailSplitList"> (요청 2 의 #splitItemTemplate 과 같은 모양, 이 화면에도 template 을 하나 두기)
    본인 기록일 때만: <input type="checkbox" id="detailRoutePublic"> 경로 공개, <button id="btnDeleteRun">삭제</button>
    닫기 버튼 data-close

- 기타 운동 추가·수정 창: <dialog id="exerciseEditor"> 안에 <form id="exerciseForm">
    <input type="date" name="date">
    <input name="name" list="exerciseNames"> 종목 (예: 줄넘기, 플랭크, 헬스)  <datalist id="exerciseNames">
    단위 선택 라디오 name="unit": value="COUNT"(횟수) / value="SECOND"(시간)
    횟수일 때: <input name="amount" inputmode="numeric"> 회
    시간일 때: <input name="minutes" inputmode="numeric"> 분 <input name="seconds" inputmode="numeric"> 초
    (단위 라디오에 따라 횟수/시간 입력칸이 바뀌는 동작은 js/record-ui.js 에 넣어 주세요)
    <textarea name="memo"> 메모 (선택)
    저장 버튼 (type="submit"), 취소 버튼 data-close

- 아래쪽 탭 (#tabNav, 기록에 aria-current="page")

js/record-ui.js: 날짜 칸 클릭 시 선택 표시, 런닝 항목 클릭 시 #runDetail 열기, 추가 버튼으로 #exerciseEditor 열기,
data-close 로 창 닫기, 단위 라디오에 따른 입력칸 전환 — 화면 동작만.
```

---

## 요청 4 — 계획, 친구, 순위

```text
[이번 요청] plan.html, friend.html, rank.html 과 각각의 css/*.css, js/*-ui.js
(아래에 프로젝트의 현재 common.css 를 붙여 넣었습니다. 기존 클래스를 우선 재사용해 주세요.)

[plan.html — 일별 계획]
- 날짜 이동: <button id="btnPrevDay" aria-label="전날">, <input type="date" id="planDate">, <button id="btnNextDay" aria-label="다음날">
- 목표 목록 <ul id="planList">
    <template id="planRowTemplate">
      <li data-id="3" data-done="false">
        <span class="plan-text">줄넘기 500회</span>
        <span class="plan-progress">300 / 500회</span>   (진행 막대가 있어도 좋음)
        <button data-action="edit">수정</button> <button data-action="delete">삭제</button>
      </li>
    </template>
  달성한 목표(data-done="true")는 눈에 띄게
- 빈 상태: <div id="planEmpty" hidden> "이날은 계획이 없어요" + 추가 버튼으로 유도
- <button id="btnAddPlan">목표 추가</button>
- 목표 추가·수정 창: <dialog id="planEditor"> 안에 <form id="planForm">
    종류 라디오 name="kind": value="RUN"(런닝) / value="EXERCISE"(기타 운동)
    런닝일 때: <input name="targetKm" inputmode="decimal"> km
    기타 운동일 때: <input name="exerciseName" list="exerciseNames"> 종목 <datalist id="exerciseNames">
                   단위 라디오 name="unit": value="COUNT"(횟수) / value="SECOND"(시간)
                   횟수: <input name="targetAmount" inputmode="numeric"> 회
                   시간: <input name="minutes" inputmode="numeric"> 분 <input name="seconds" inputmode="numeric"> 초
    저장(type="submit"), 취소(data-close)
  (종류·단위 라디오에 따라 입력칸이 바뀌는 동작은 js/plan-ui.js 에)
- 아래쪽 탭 (계획에 aria-current="page")

[friend.html — 친구]
- 검색: <form id="friendSearchForm"> <input name="username"> 아이디 검색, 검색 버튼(type="submit")
  결과 <div id="searchResult">
    <template id="searchItemTemplate">
      <div class="search-item">
        <span class="friend-name">minsu</span>
        <button data-action="request">친구 요청</button>
        <span class="search-state" hidden>이미 친구예요 / 요청을 보냈어요</span>
      </div>
    </template>
  결과 없음: "그런 아이디가 없어요"
- 받은 요청 <ul id="receivedList">, 개수 배지 <span id="receivedCount">2</span>
    <template id="receivedItemTemplate">
      <li data-id="5"><span class="friend-name">jihye</span>
        <button data-action="accept">수락</button> <button data-action="decline">거절</button></li>
    </template>
- 보낸 요청 <ul id="sentList">
    <template id="sentItemTemplate">
      <li data-id="6"><span class="friend-name">dongha</span> <button data-action="cancel">취소</button></li>
    </template>
- 친구 목록 <ul id="friendList">
    <template id="friendItemTemplate">
      <li data-id="8" data-user-id="21"><span class="friend-name">minsu</span>
        <a data-action="calendar" href="record.html?userId=21">기록 보기</a>
        <button data-action="delete">삭제</button></li>
    </template>
- 목록마다 빈 상태 문구 (예: "아직 친구가 없어요. 아이디로 찾아 요청해 보세요")
- 아래쪽 탭 (친구에 aria-current="page")

[rank.html — 순위]
- 기간 전환: <button data-period="WEEK" aria-pressed="true">이번 주</button> <button data-period="MONTH" aria-pressed="false">이번 달</button>
  <p id="periodLabel">9/28(월) ~ 10/4(일)</p>
- 런닝 거리 순위 <ol id="distanceRank">
- 운동한 날 수 순위 <ol id="daysRank">
  두 목록 모두 같은 template 사용:
    <template id="rankItemTemplate">
      <li data-me="false"><span class="rank-no">1</span> <span class="rank-name">minsu</span> <span class="rank-value">23.4km</span></li>
    </template>
  1~3위는 돋보이게, 내 순위(data-me="true")는 강조
- 친구가 없을 때: <div id="rankEmpty" hidden> "친구를 추가하면 함께 순위를 볼 수 있어요" + friend.html 링크
- 아래쪽 탭 (순위에 aria-current="page")

각 *-ui.js: 창 열고 닫기, 라디오에 따른 입력칸 전환, 기간 버튼 aria-pressed 전환 — 화면 동작만.
```

---

## 받은 UI 를 프로젝트에 옮기는 방법

| 받은 파일 | 옮길 곳 |
|---|---|
| `xxx.html` | `src/main/webapp/WEB-INF/jsp/workout/<기능>/<기능>Main.jsp` (로그인·가입은 `.../login/loginMain.jsp`, `signupMain.jsp`) |
| `css/*.css` | `src/main/webapp/resources/css/` |
| `js/*-ui.js` | `src/main/webapp/resources/js/app/<기능>/` |

1. HTML 맨 위에 JSP 머리말을 붙인다:
   ```jsp
   <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   <%@ include file="/common/taglib.jsp"%>
   ```
2. `<head>` 의 `<meta charset>` · `<meta viewport>` 를 지우고 `<jsp:include page="/WEB-INF/layout/head.jsp"/>` 로 바꾼다 (contextPath, 공통 CSS·JS 포함)
3. CSS · JS 경로를 `<c:url value='/resources/css/common.css'/>` 처럼 바꾼다
4. 화면 사이 링크(`login.html`, `record.html?userId=21` 등)를 `<c:url value='/login'/>`, `<c:url value='/workout/record'/>` 같은 실제 주소로 바꾼다
5. HTML 에 직접 적힌 예시 데이터는 지우고 `<template>` 만 남긴다 — 실제 데이터는 기능 구현 때 JS 가 Ajax 로 받아 template 을 복제해 채운다
6. `run-ui.js` 의 상태 바꿔 보기 같은 임시 동작은 기능 구현 때 실제 동작으로 대체한다
