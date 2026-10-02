# 운동 기록 설계

작성일: 2026-10-01

## 1. 목적과 범위

지인 몇 명이 함께 쓰는 런닝 중심 운동 기록 웹 앱. 휴대폰 브라우저에서 GPS로 런닝 경로와 거리를 기록하고, 맨몸·줄넘기·헬스 같은 운동은 직접 입력한다. 친구를 맺은 사람끼리 기록을 비교하고 경쟁한다.

- 사용자: 초대 코드로 가입한 지인 몇 명
- 메인 화면: 런닝 (카카오맵 + 시작 버튼)
- 첫 버전 기능: 런닝 기록, 기록 달력·상세, 기타 운동, 일별 계획, 친구, 순위
- 나중에: 게시판, 네이티브 앱(GPS 테스트 결과에 따라), 빌드를 GitHub Actions 로 이전

### 역할

| 영역 | 담당 |
|---|---|
| 기능 코드(프론트 JS · 백엔드) | 사용자. Claude 는 단계 안내와 코드 리뷰 |
| UI(JSP · CSS · 화면 동작 JS) | 2026-10-02 요청에 따라 러닝 중심 화면 작업본을 직접 작성 |
| 배포 설정, GPS 테스트 페이지 | Claude 가 작성 (커밋 · push 는 사용자 요청 시) |

## 2. 기술 구성

기존 뼈대를 유지한다.

| 영역 | 기술 |
|---|---|
| 서버 | Java 17, Spring Framework 6.2 (XML 설정), MyBatis 3.5, HikariCP |
| 화면 | JSP + 순수 JavaScript. 받은 HTML 을 JSP 로 옮기고 데이터는 Ajax 로 채운다 |
| 지도 | 카카오맵 JavaScript API (개발자 계정의 첫 활성화 앱, 일 30만 건 무료) |
| DB | PostgreSQL 16 (서버의 기존 인스턴스, DB `workout`) |
| 배포 | Docker Compose (Tomcat 10.1, 127.0.0.1:8082), nginx `/p4/`, GitHub Actions → SSH → `deploy/deploy.sh` |

유지하는 기존 코드: 백엔드 뼈대(Spring · MyBatis 설정, 공통 응답 · 예외 · 인터셉터, DB 스크립트, 테스트), 로그인 · 회원가입(BCrypt, 시도 제한, 초대 코드), 배포 설정. 기존 공통 CSS·레이아웃을 재사용하면서 러닝 중심 색상·메뉴·로그인 화면을 적용한다.
러닝·기록·계획·친구·순위는 UI 마크업과 화면 동작을 먼저 마련한다. GPS·지도 SDK·데이터 API 는 이후 기능 구현 단계에서 연결한다.

## 3. 화면

| 화면 | 주소 | 내용 |
|---|---|---|
| 로그인 / 회원가입 | `/login`, `/signup` | 가입은 초대 코드 필요 |
| 런닝 (메인) | `/workout/run` | 지도 + 현재 위치. 시작 → 진행(거리 · 시간 · 현재 페이스 · 경로) → 일시정지/다시 시작 → 종료 → 결과 확인(경로 · 거리 · 시간 · 평균 페이스 · 1km 구간, 경로 공개 여부) → 저장 / 버리기 |
| 기록 | `/workout/record` | 직접 만든 월 달력. 날짜 칸에 런닝 km · 기타 운동 유무 · 계획 달성 표시. 날짜 클릭 → 그날 목록 → 런닝 상세(지도 · 거리 · 시간 · 페이스 · 구간) / 기타 운동 상세. 기타 운동 추가. `?userId=` 이면 그 친구 한 명의 달력(친구 목록에서 한 명을 눌러 열기. 내 달력에 친구 기록을 합치지 않음) |
| 계획 | `/workout/plan` | 날짜별 목표 추가 · 수정 · 삭제, 달성 여부 표시 |
| 친구 | `/workout/friend` | 아이디 검색 → 요청, 받은 요청 수락 · 거절, 보낸 요청 취소, 친구 목록 · 삭제, 친구 달력으로 이동 |
| 순위 | `/workout/rank` | 이번 주(월~일) / 이번 달. 런닝 거리 순위, 운동한 날 수 순위 (나 + 친구) |

탭 구성(런닝 · 기록 · 계획 · 친구 · 순위)은 제안이며 실제 배치는 받아 올 UI 를 따른다.

## 4. 데이터

모든 사용자 데이터는 `user_id` 로 격리하고, 조회 SQL 은 항상 사용자 조건을 건다. 계산으로 얻을 수 있는 값(평균 페이스, 계획 달성, 순위)은 저장하지 않고 조회할 때 계산한다 — 기록을 고치거나 지워도 어긋나지 않게.

```sql
-- 있음
app_user (id, username, password_hash, created_at)

run (
    id            BIGSERIAL PK,
    user_id       BIGINT NOT NULL → app_user,
    started_at    TIMESTAMPTZ NOT NULL,
    ended_at      TIMESTAMPTZ NOT NULL,
    duration_sec  INT NOT NULL,        -- 일시정지를 뺀 시간 (서버 계산)
    distance_m    INT NOT NULL,        -- 보정 후 거리 (서버 계산)
    route         JSONB NOT NULL,      -- 구간 배열 [[[lat, lng, t], …], …]  t = 시작 후 초
    splits        JSONB NOT NULL,      -- 1km 구간별 걸린 초 [312, 305, …] (서버 계산)
    route_public  BOOLEAN NOT NULL,    -- 친구에게 경로 공개
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
)

exercise (
    id, user_id, exercise_date DATE,
    name VARCHAR(50),                  -- 자유 입력, 앞뒤 공백 제거
    amount INT, unit ('COUNT' | 'SECOND'),
    memo, created_at
)

plan (
    id, user_id, plan_date DATE,
    kind ('RUN' | 'EXERCISE'),
    exercise_name,                     -- RUN 이면 NULL
    target_amount INT,
    unit ('METER' | 'COUNT' | 'SECOND')
)

friendship (
    id, requester_id, addressee_id,
    status ('PENDING' | 'ACCEPTED'),
    created_at, responded_at
    -- 같은 두 사람 사이 한 행만 (방향 무관 유일 제약)
    -- 거절 · 취소 · 친구 삭제 = 행 삭제
)
```

계산 규칙:

- 평균 페이스 = `duration_sec ÷ distance_m × 1000` (초/km)
- 계획 달성: RUN 은 그날 `run.distance_m` 합 ≥ 목표, EXERCISE 는 그날 같은 종목명 · 같은 단위 `exercise.amount` 합 ≥ 목표. 종목명은 입력 시 이전 종목명을 추천해 표기를 맞춘다
- 운동한 날 수: 기간 안에서 런닝 또는 기타 운동이 하나라도 있는 날
- 날짜 기준: 한국 시간(Asia/Seoul). 런닝의 날짜는 `started_at` 의 한국 날짜

저장량: 서버에서 실측한 1시간(3,600점) 경로는 전송 약 110KB, 저장(압축 후) 약 38KB. 실제 경로는 40~80KB 로 잡는다. 5명이 매일 1시간 뛰어도 월 약 12MB (디스크 여유 27GB).

## 5. API

ledger 와 같은 규칙: 화면은 GET → JSP, 데이터는 Ajax. 응답은 `{code, message, data}` (`Response`), 데이터를 바꾸는 요청은 POST + JSON 만 받는다(`ApiRequestInterceptor`). `/workout/**` 는 로그인 필요(`LoginPageInterceptor`).

| 기능 | 요청 | 내용 |
|---|---|---|
| 런닝 저장 | POST `/workout/run/save` | 시작 · 종료 시각, `route`(구간 배열), `routePublic` → 서버가 계산한 거리 · 시간 · 구간 |
| 런닝 상세 | GET `/workout/run/detail?id=` | 친구 기록이면 친구 관계 확인, 비공개면 경로 제외 |
| 런닝 수정 · 삭제 | POST `/workout/run/update`, `/workout/run/delete` | 경로 공개 여부 변경 / 삭제 (본인 것만) |
| 달력 한 달 | GET `/workout/record/month?month=YYYY-MM[&userId=]` | 날짜별 런닝 km · 기타 운동 수 · 계획 달성/전체 |
| 하루 목록 | GET `/workout/record/day?date=YYYY-MM-DD[&userId=]` | 그날 런닝 · 기타 운동 · 계획(달성 여부) |
| 기타 운동 | POST `/workout/exercise/save`, `/delete` · GET `/workout/exercise/names` | 추가 · 수정 · 삭제, 이전 종목명 목록 |
| 계획 | POST `/workout/plan/save`, `/delete` · GET `/workout/plan/list?from=&to=` | |
| 친구 | GET `/workout/friend/list`, `/search?username=` · POST `/request`, `/accept`, `/delete` | 목록 = 친구 · 받은 요청 · 보낸 요청 |
| 순위 | GET `/workout/rank?period=WEEK\|MONTH` | 거리 순위, 운동한 날 수 순위 |

권한: `userId` 가 붙은 조회는 서버가 수락된 친구인지 확인한다. 친구에게는 수치(날짜 · 거리 · 시간 · 페이스 · 기타 운동 · 계획 달성)를 보여 주고, 지도 경로는 `route_public` 인 기록만 보여 준다. 수정 · 삭제는 본인 데이터만.

nginx: 런닝 저장 요청은 100KB 를 넘을 수 있으므로 `/p4/workout/run/save` 만 `client_max_body_size 1m`, 나머지는 64k 유지.

## 6. GPS 처리

기준값은 GPS 테스트 결과로 조정하므로 JS 한 곳에 상수로 모은다.

### 브라우저

1. `navigator.geolocation.watchPosition` (`enableHighAccuracy: true`, `maximumAge: 0`)
2. 점 거르기 (통과한 점만 경로에 추가)
   - 정확도(오차 반경) > 30m → 버림
   - 직전 점과 거리 < 5m → 버림 (정지 중 흔들림)
   - 직전 점 대비 속도 > 8m/s → 버림 (순간 튐)
3. Screen Wake Lock: 시작 시 요청, 화면 복귀(`visibilitychange`) 시 재요청
4. 일시정지: 위치 수신 중단, 다시 시작하면 새 구간
5. 끊김(화면 꺼짐 등): 같은 구간 안이므로 다음 점과 직선으로 이어짐
6. 실시간 표시: 거리(하버사인 합), 뛴 시간, 현재 페이스(최근 점 기준), 1km 구간
7. 중간 저장: 점이 추가될 때마다 상태(구간 · 시작 시각 · 일시정지 여부)를 localStorage 에 기록. 페이지를 다시 열면 이어서 할지 묻는다. 저장하거나 버리면 지운다. 저장이 실패하면(`QuotaExceededError` 등, 사이트당 한도 약 5MiB · 기기 공간 부족) 화면에 "중간 저장 실패"를 알린다 — 측정 · 종료 후 서버 저장은 계속 가능

### 서버 (저장 시)

1. 검사 — 위반 시 `INVALID`: 좌표 범위, 구간 안 시각 오름차순, 전체 점 ≤ 20,000, 평균 속도 ≤ 8m/s, 거리 > 0
2. 재계산 — 구간 안 하버사인 거리 합(구간 사이는 더하지 않음), 구간별 (마지막 t − 첫 t) 합, 1km 경계를 두 점 사이에서 보간한 구간 시간
3. 하버사인 계산은 JS 와 Java 양쪽에 있으므로 같은 경로에 같은 값이 나오는지 테스트로 고정한다

### 알려진 제약

- 웹에서 위치는 화면에 열린 페이지에서만 받을 수 있다(워커에서는 Geolocation 사용 불가). 화면을 끄거나 다른 앱으로 가면 추적이 멈출 수 있고, 기기 · 브라우저마다 다르다 — GPS 테스트로 확인
- Wake Lock 은 탭 전환 · 절전 모드에서 풀린다
- 첫 버전은 "화면을 켜 두고 뛰기 + 끊긴 구간 직선 보정"을 전제로 한다. 백그라운드 추적이 꼭 필요하면 네이티브 래핑(예: Capacitor)을 별도로 결정한다. 이 경우에도 서버 부하는 같다(GPS · 지도는 휴대폰에서 처리)

## 7. 작업 순서

| 단계 | 내용 | 담당 |
|---|---|---|
| 0. 정리 | Claude 가 만든 화면 · 디자인 삭제, 로그인 · 가입 JSP 최소화 | Claude |
| 1. 배포 환경 | GitHub 저장소, 서버 DB · 폴더 · app.env(root:docker 640), 배포 전용 키(배포 스크립트만 실행하도록 제한), nginx, Actions Secrets | 사용자 (Claude 안내) |
| 2. GPS 테스트 | 버리는 테스트 페이지 `/p4/gps-test` 배포 → 휴대폰(아이폰 · 안드로이드)으로 측정: 점 간격 · 정확도 분포, 화면 끔 · 앱 전환 시 끊김, 길이를 아는 코스(트랙 · 왕복)의 거리 오차 → 기준값 조정, 네이티브 필요 여부 판단 | 페이지 Claude, 측정 사용자 |
| 3. 카카오맵 | Kakao Developers 앱 등록, 도메인(devgear.kr, localhost) 등록, JavaScript 키 발급 | 사용자 |
| 4. UI 화면 | 화면 7개 러닝 중심 디자인과 UI 마크업 (모바일 우선, JSP + CSS + 순수 JS, JS 연결용 id 규칙, 지도 영역, 직접 만드는 달력) | 2026-10-02 작업본 |
| 5. 기능 구현 | 기능마다 테이블 → SQL → DAO → Service → Controller → JSP → JS → 테스트, 끝나면 push 로 배포 · 휴대폰 확인 | 사용자 (Claude 안내 · 리뷰) |
| | ① 런닝 메인 ② 기록 달력 · 런닝 상세 ③ 기타 운동 ④ 계획 ⑤ 친구 ⑥ 친구 달력 보기 ⑦ 순위 | |

순서 근거: 달력 · 계획 · 순위가 모두 런닝 데이터를 쓰고 GPS 가 가장 불확실하므로 런닝을 먼저 검증한다. 친구 열람은 혼자 쓰는 기능이 완성된 뒤 권한을 얹는다.

## 8. 테스트

- Java 단위 테스트: 하버사인 거리, 구간 · 일시정지 시간 합, 1km 구간 보간, 저장 검사 규칙, 계획 달성 판정, 주 · 월 기간 경계(월요일 시작, 한국 시간)
- JS 와 Java 거리 일치: 같은 고정 경로로 양쪽 결과 비교
- 권한: 친구가 아닌 사용자의 `userId` 조회 거부, 비공개 경로 제외, 남의 기록 수정 · 삭제 거부
- 실기기: GPS 테스트(2단계), 기능마다 배포 후 휴대폰 확인
