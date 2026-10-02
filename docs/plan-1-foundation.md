# 계획 1: 기반 단계 (정리 · 배포 · GPS 테스트 · 카카오맵 · UI 프롬프트)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
> 단, 이 프로젝트에서는 아래 "작업 규칙"이 우선한다.

**Goal:** 기능 구현을 시작하기 전에 필요한 기반(정리된 뼈대, 자동 배포, GPS 실측 결과, 카카오맵 키, UI 요청 프롬프트)을 갖춘다.

**Architecture:** 기존 Spring 6 + MyBatis + JSP 뼈대에서 Claude 가 만든 화면 · 디자인을 걷어 내고, push 하면 서버에 자동 배포되는 환경을 만든다. 그 위에 버리는 GPS 테스트 페이지를 올려 휴대폰에서 실측하고, 결과로 런닝 기능의 기준값과 네이티브 앱 필요 여부를 정한다.

**Tech Stack:** Java 17, Spring Framework 6.2, MyBatis 3.5, JSP + 순수 JS, Tomcat 10.1, PostgreSQL 16, Docker Compose, nginx, GitHub Actions, 카카오맵 JavaScript API

**Spec:** [docs/design.md](design.md)

## 작업 규칙

- 담당이 **Claude** 인 작업: Claude 가 파일을 만들고 바꾼 뒤 변경 내용을 보고한다. **커밋 · push 는 사용자가 요청할 때만.**
- 담당이 **사용자** 인 작업: 사용자가 직접 실행하고, Claude 는 단계 안내와 결과 확인을 한다. 서버 · GitHub · 카카오 계정 작업은 모두 여기에 속한다.
- 기능 ①~⑦ 은 이 계획에 없다. GPS 테스트(작업 5) 뒤에 기능마다 별도 계획을 쓴다.

## Global Constraints

- 주소 `https://devgear.kr/p4/`, Tomcat `127.0.0.1:8082`, 서버 폴더 `/srv/devgear/workout`, DB `workout` / 계정 `workout_app`
- 비밀값은 `/etc/workout/app.env` (root:docker, 640). 저장소에 비밀값을 넣지 않는다
- 화면은 JSP + 순수 JavaScript. 새 의존성은 사용자 승인 후에만
- 데이터를 바꾸는 요청은 POST + JSON 만 (`ApiRequestInterceptor`), `/workout/**` 는 로그인 필요
- 날짜 · 시간 기준은 Asia/Seoul
- GPS 점 거르기 기준값(조정 대상): 정확도 > 30m 버림, 직전 점과 < 5m 버림, 속도 > 8m/s 버림
- 하버사인 지구 반지름 6,371,008.8m (JS · Java 동일 값)
- 지도는 카카오맵 JavaScript API

## Review Focus

테스트가 직접 다루지 않지만 사람이 실제로 마주칠 가능성이 높은 상황. 각 줄의 확인 단계는 담당 작업에 들어 있다.

1. **위치 권한을 거부하거나 위치를 못 받는 경우** — GPS 테스트 페이지가 멈춘 듯 보이지 않고 이유를 화면에 표시해야 한다 (작업 4, Step 4)
2. **실내처럼 정확도 나쁜 점만 계속 오는 경우** — 거리가 늘지 않고, 버린 이유별 개수가 보여야 한다 (작업 4, Step 4)
3. **테스트 중 새로고침 · 브라우저 종료** — 그때까지의 측정 기록이 남아 있어야 한다 (작업 4, Step 4)
4. **화면 꺼짐 방지(Wake Lock)를 지원하지 않거나 거부되는 브라우저** — 상태만 표시하고 측정은 계속돼야 한다 (작업 4, Step 4)
5. **정리 후 배포했는데 헬스체크 대상 파일이 없어 컨테이너가 unhealthy** — 정리 작업에서 헬스체크 경로를 바꾸고 WAR 안에 그 파일이 있는지 확인한다 (작업 1, Step 6)

---

### 작업 1: 화면 · 디자인 정리 — 담당 Claude

> **상태 (2026-10-02): 대체됨.** UI 를 먼저 받아 와 적용했으므로 아래 단계 대신 다음이 이루어졌다 — 받은 UI 7개 화면 적용(`t:layout` · `menu.jsp` · `icons.jsp` 유지), 화면 JS 를 design 프로젝트 형식(`App.xxx` + `init` → `bindEvent`)으로 정리, 화면 주소를 기능별 컨트롤러(`RunApiController` 등 5개)로 분리, `DashboardApiController` 삭제. 헬스체크는 `manifest.json` 이 남아 있으므로 그대로 둔다. 아래 단계는 기록용으로만 남긴다.

**목적:** UI 는 따로 받아 오므로 Claude 가 만든 화면 · 디자인을 걷어 낸다. 로그인 → 메인으로 이어지는 흐름은 스타일 없는 최소 화면으로 계속 동작하게 둔다.

**Files:**
- Delete: `src/main/webapp/resources/css/common.css`, `login.css`, `reset.css`
- Delete: `src/main/webapp/resources/images/icon.svg`, `src/main/webapp/manifest.json`
- Delete: `src/main/webapp/WEB-INF/layout/icons.jsp`, `barbell.jsp`, `menu.jsp`, `src/main/webapp/WEB-INF/tags/layout.tag`
- Delete: `src/main/java/workout/dashboard/controller/DashboardApiController.java`, `src/main/webapp/WEB-INF/jsp/workout/dashboard/dashboardMain.jsp`
- Create: `src/main/java/workout/run/controller/RunApiController.java`, `src/main/webapp/WEB-INF/jsp/workout/run/runMain.jsp`
- Modify: `src/main/webapp/WEB-INF/layout/head.jsp` (글꼴 · CSS 링크 제거, 알림창 표시용 최소 스타일만)
- Modify: `src/main/webapp/WEB-INF/jsp/workout/login/loginMain.jsp`, `signupMain.jsp`, `error.jsp` (스타일 없는 최소 마크업)
- Modify: `src/main/webapp/index.jsp`, `src/main/java/workout/auth/controller/AuthApiController.java:60`, `src/main/webapp/resources/js/app/login/login.js:29` (`/workout/dashboard` → `/workout/run`)
- Modify: `src/main/webapp/WEB-INF/config/dispatcher-servlet.xml` (`/manifest.json` 리소스 매핑 제거)
- Modify: `Dockerfile` (헬스체크 대상 변경)

**Interfaces:**
- Produces: `GET /workout/run` → `run/runMain` (기능 ① 에서 사용자가 이 컨트롤러와 JSP 를 키운다)
- Produces: `head.jsp` 는 모든 JSP 가 `<jsp:include page="/WEB-INF/layout/head.jsp"/>` 로 쓴다 (meta, `contextPath`, `common.js`, `modal.js`)

- [ ] **Step 1: 파일 삭제**

```bash
cd /c/dev/workout
git rm -q --cached -r src/main/webapp/resources/css src/main/webapp/resources/images src/main/webapp/manifest.json \
  src/main/webapp/WEB-INF/layout/icons.jsp src/main/webapp/WEB-INF/layout/barbell.jsp src/main/webapp/WEB-INF/layout/menu.jsp \
  src/main/webapp/WEB-INF/tags src/main/java/workout/dashboard src/main/webapp/WEB-INF/jsp/workout/dashboard
rm -r src/main/webapp/resources/css src/main/webapp/resources/images src/main/webapp/manifest.json \
  src/main/webapp/WEB-INF/layout/icons.jsp src/main/webapp/WEB-INF/layout/barbell.jsp src/main/webapp/WEB-INF/layout/menu.jsp \
  src/main/webapp/WEB-INF/tags src/main/java/workout/dashboard src/main/webapp/WEB-INF/jsp/workout/dashboard
```

(아직 커밋이 없으므로 `git rm --cached` 는 스테이징에서만 빼는 것이다.)

- [ ] **Step 2: 메인 자리 만들기 (`/workout/run`)**

`src/main/java/workout/run/controller/RunApiController.java`

```java
package workout.run.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// 런닝(메인) 화면. 기능 ① 에서 저장 · 상세 API 를 이 컨트롤러에 추가한다.
@Controller
public class RunApiController {

    @GetMapping("/workout/run")
    public String runPage() {
        return "run/runMain";
    }
}
```

`src/main/webapp/WEB-INF/jsp/workout/run/runMain.jsp`

```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title>런닝 | 운동 기록</title>
</head>
<body>
<%-- 받아 온 UI 를 적용하기 전 임시 화면 --%>
<h1>런닝</h1>
<p><c:out value="${sessionScope.username}"/>님, 준비 중입니다.</p>
<button type="button" data-logout>로그아웃</button>
</body>
</html>
```

- [ ] **Step 3: 공통 head 와 로그인 · 가입 · 오류 화면을 최소 마크업으로**

`src/main/webapp/WEB-INF/layout/head.jsp`

```jsp
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%-- 모든 화면 공통 <head> 내용. 화면별 CSS · JS 는 각 화면에서 이 뒤에 추가한다 --%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<%-- 알림창(modal.js)이 열고 닫히도록 하는 최소 스타일. 받아 온 UI 의 CSS 로 교체한다 --%>
<style>
    .manage-modal { display: none; position: fixed; inset: 0; z-index: 100; }
    .manage-modal.is-open { display: grid; place-items: center; }
    .manage-modal-backdrop { position: absolute; inset: 0; background: rgba(0, 0, 0, .4); }
    .manage-modal-dialog { position: relative; background: #fff; padding: 16px; max-width: 90vw; }
</style>
<script>var contextPath = "${pageContext.request.contextPath}";</script>
<script defer src="<c:url value='/resources/js/common/common.js'/>"></script>
<script defer src="<c:url value='/resources/js/common/modal.js'/>"></script>
```

`loginMain.jsp` — `login.js` 가 쓰는 `#loginForm` 과 `name` 값(`username`, `password`)을 유지:

```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title>로그인 | 운동 기록</title>
    <script defer src="<c:url value='/resources/js/app/login/login.js'/>"></script>
</head>
<body>
<h1>로그인</h1>
<form id="loginForm" novalidate>
    <label>아이디 <input name="username" type="text" autocomplete="username" required></label>
    <label>비밀번호 <input name="password" type="password" autocomplete="current-password" required></label>
    <button type="submit">로그인</button>
</form>
<p><a href="<c:url value='/signup'/>">회원가입</a></p>
</body>
</html>
```

`signupMain.jsp` — `signup.js` 가 쓰는 `#signupForm` 과 `name` 값(`username`, `password`, `passwordConfirm`, `signupCode`)을 유지:

```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title>회원가입 | 운동 기록</title>
    <script defer src="<c:url value='/resources/js/app/login/signup.js'/>"></script>
</head>
<body>
<h1>회원가입</h1>
<form id="signupForm" novalidate>
    <label>아이디 <input name="username" type="text" maxlength="50" autocomplete="username" required></label>
    <label>비밀번호 (8자 이상) <input name="password" type="password" minlength="8" autocomplete="new-password" required></label>
    <label>비밀번호 확인 <input name="passwordConfirm" type="password" autocomplete="new-password" required></label>
    <label>가입 코드 <input name="signupCode" type="text" autocomplete="off" required></label>
    <button type="submit">가입하기</button>
</form>
<p><a href="<c:url value='/login'/>">로그인</a></p>
</body>
</html>
```

`error.jsp`:

```jsp
<%-- isErrorPage 를 쓰지 않는다: 켜면 Spring 이 남긴 예외 속성 때문에 JSP 가 상태를 500 으로 덮어써 404/400 이 500 이 된다 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/layout/head.jsp"/>
    <title>오류 | 운동 기록</title>
</head>
<body>
<h1><c:out value="${pageContext.errorData.statusCode}" default="오류"/></h1>
<p>페이지를 열 수 없어요. 처음 화면에서 다시 시작해 주세요.</p>
<a href="<c:url value='/'/>">처음 화면으로</a>
</body>
</html>
```

- [ ] **Step 4: 첫 화면 주소를 `/workout/run` 으로**

- `index.jsp`: `<jsp:forward page="/workout/dashboard"/>` → `<jsp:forward page="/workout/run"/>`
- `AuthApiController.java` `loginPage()`: `return "redirect:/workout/dashboard";` → `return "redirect:/workout/run";`
- `login.js`: `location.href = contextPath + '/workout/dashboard';` → `location.href = contextPath + '/workout/run';`
- `dispatcher-servlet.xml`: 아래 블록 삭제

```xml
    <mvc:resources mapping="/manifest.json" location="/">
        <mvc:cache-control no-cache="true"/>
    </mvc:resources>
```

- `Dockerfile` 헬스체크: `manifest.json` 이 없어지므로 세션을 만들지 않는 정적 파일로 바꾼다

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=90s --retries=3 \
    CMD curl -fsS http://localhost:8082/p4/resources/js/common/common.js > /dev/null || exit 1
```

- [ ] **Step 5: 남은 참조가 없는지 확인**

Run: `grep -rn "dashboard\|manifest\|icons.jsp\|menu.jsp\|layout.tag\|common.css\|login.css\|reset.css\|t:layout" src Dockerfile`
Expected: 출력 없음

- [ ] **Step 6: 빌드 · 테스트 · 헬스체크 대상 확인**

Run: `mvn -B -q verify && unzip -l target/workout.war | grep "resources/js/common/common.js"`
Expected: 테스트 통과(출력 없음) 후 `resources/js/common/common.js` 한 줄

- [ ] **Step 7: 사용자에게 보고**

삭제 · 수정한 파일 목록과 Step 5 · 6 결과를 보고한다. 커밋 여부는 사용자가 정한다.

---

### 작업 2: 배포 설정 보강 — 담당 Claude

**목적:** 런닝 저장 요청(100KB 이상)이 nginx 에서 막히지 않게 하고, 카카오맵 키를 설정으로 받을 자리를 만든다.

**Files:**
- Modify: `deploy/nginx-workout.conf`
- Modify: `src/main/resources/egovProps/globals.properties`, `deploy/app.env.example`

**Interfaces:**
- Produces: 설정 키 `Globals.Workout.KakaoJsKey` (환경변수 `WORKOUT_KAKAO_JS_KEY`, 기본값 빈 문자열). 기능 ① 의 컨트롤러가 `@Value("${Globals.Workout.KakaoJsKey}")` 로 읽어 JSP 에 넘긴다

- [ ] **Step 1: nginx 에 런닝 저장 전용 위치 추가** — `location /p4/ { … }` 블록 안, 로그인 제한 위치 아래에 추가

```nginx
    # 런닝 저장: 경로(GPS 점) 때문에 본문이 100KB 를 넘을 수 있다 (1시간 실측 약 110KB)
    location = /p4/workout/run/save {
        client_max_body_size 1m;
        proxy_pass         http://127.0.0.1:8082;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
```

- [ ] **Step 2: 카카오맵 키 설정 자리**

`globals.properties` 끝에 추가:

```properties

# 카카오맵 JavaScript 키 (Kakao Developers 에서 도메인을 등록한 앱의 키. 브라우저에 노출되므로 도메인 제한으로 보호된다)
Globals.Workout.KakaoJsKey=${WORKOUT_KAKAO_JS_KEY:}
```

`deploy/app.env.example` 끝에 추가:

```
WORKOUT_KAKAO_JS_KEY=
```

- [ ] **Step 3: 문법 확인**

Run: `mvn -B -q verify`
Expected: 통과. nginx 문법은 작업 3 Step 10 에서 서버의 `sudo nginx -t` 로 확인한다

- [ ] **Step 4: 사용자에게 보고** — 변경 내용 보고, 커밋 여부는 사용자가 정한다.

---

### 작업 3: 배포 환경 만들기 — 담당 사용자 (Claude 안내)

**목적:** `git push` 하면 테스트 → 서버 배포가 자동으로 되게 한다.

**선행:** 작업 1 · 2 완료, 사용자가 첫 커밋을 만든다.

- [ ] **Step 1: 첫 커밋 (로컬)**

```bash
git -C /c/dev/workout add -A
```
```bash
git -C /c/dev/workout commit -m "운동 기록 초기 구조"
```

- [ ] **Step 2: GitHub 저장소 만들기** — github.com 에서 `workout`, Public, README · .gitignore · 라이선스 모두 체크 해제

- [ ] **Step 3: push**

```bash
git -C /c/dev/workout remote add origin https://github.com/Dongsik0000/workout.git
```
```bash
git -C /c/dev/workout push -u origin main
```

Expected: Actions 에서 test 성공, deploy 실패(Secrets 없음 — 정상, Step 12 뒤 다시 실행)

- [ ] **Step 4: [서버] DB 계정 · DB** (`ssh oracle` 접속 후)

```bash
sudo -u postgres createuser --login --pwprompt workout_app
```
```bash
sudo -u postgres createdb --owner=workout_app --encoding=UTF8 workout
```

- [ ] **Step 5: [서버] 저장소 받기 · 테이블 만들기**

```bash
git clone https://github.com/Dongsik0000/workout.git /srv/devgear/workout
```
```bash
psql -h 127.0.0.1 -U workout_app -d workout -f /srv/devgear/workout/db/001_schema.sql
```

Expected: `CREATE TABLE`

- [ ] **Step 6: [서버] 비밀값 파일**

```bash
sudo mkdir -p /etc/workout
```
```bash
sudo install -m 640 -o root -g docker /srv/devgear/workout/deploy/app.env.example /etc/workout/app.env
```
```bash
sudo nano /etc/workout/app.env
```

`WORKOUT_DB_PASSWORD` 에 Step 4 비밀번호, `WORKOUT_SIGNUP_CODE` 에 가입 코드(`openssl rand -hex 12` 로 생성). `WORKOUT_KAKAO_JS_KEY` 는 작업 6 에서 채운다.

- [ ] **Step 7: [로컬] 배포 전용 키**

```bash
ssh-keygen -t ed25519 -N "" -C github-actions-workout -f ~/.ssh/workout-deploy
```

- [ ] **Step 8: [로컬→서버] 공개키 등록 — 배포 스크립트만 실행하도록 제한**

```bash
{ printf 'restrict,command="bash /srv/devgear/workout/deploy/deploy.sh" '; cat ~/.ssh/workout-deploy.pub; } | ssh oracle 'cat >> ~/.ssh/authorized_keys'
```

- [ ] **Step 9: 새 키로 첫 배포**

```bash
ssh -i ~/.ssh/workout-deploy -o IdentitiesOnly=yes ubuntu@150.230.218.194
```

| 결과 | 의미 |
|---|---|
| `배포 완료: …` | 성공 |
| `컨테이너가 정상 상태가 되지 않았습니다` + 로그 | 로그의 `password authentication` → Step 6 비밀번호 확인. 그 밖은 로그를 Claude 에게 |
| `env file … not found` / `permission denied` | Step 6 위치 · 권한(640 root:docker) 확인 |
| 일반 셸 프롬프트 | `IdentitiesOnly=yes` 누락 또는 Step 8 미적용 |

- [ ] **Step 10: [서버] nginx 연결**

```bash
sudo cp /srv/devgear/workout/deploy/nginx-workout.conf /etc/nginx/snippets/workout.conf
```
```bash
sudo cp /srv/devgear/workout/deploy/nginx-workout-limit.conf /etc/nginx/conf.d/workout-limit.conf
```
```bash
sudo nano /etc/nginx/sites-available/devgear.kr
```

`include /etc/nginx/snippets/ledger.conf;` 아래 줄에 `include /etc/nginx/snippets/workout.conf;` 추가

```bash
sudo nginx -t
```
```bash
sudo systemctl reload nginx
```

(`nginx -t` 가 실패하면 reload 하지 않는다 — 기존 사이트는 영향 없음)

- [ ] **Step 11: [확인] https://devgear.kr/p4/** — 스타일 없는 로그인 화면 → 가입 코드로 가입 → 로그인 → "런닝 / 준비 중입니다" 화면

| 결과 | 의미 |
|---|---|
| 로그인 화면 | 성공 |
| 502 | 컨테이너 꺼짐 — 서버에서 `docker ps` |
| devgear.kr 메인 · 404 | Step 10 include 누락 |

- [ ] **Step 12: [GitHub] Secrets** — Settings → Secrets and variables → Actions

| 이름 | 값 |
|---|---|
| `DEPLOY_HOST` | `150.230.218.194` |
| `DEPLOY_USER` | `ubuntu` |
| `DEPLOY_SSH_KEY` | `cat ~/.ssh/workout-deploy` 출력 전체 (BEGIN · END 줄 포함) |
| `DEPLOY_KNOWN_HOSTS` | `ssh-keygen -F 150.230.218.194 \| grep -v '^#'` 출력 3줄 |

- [ ] **Step 13: [확인] Actions → deploy → Run workflow**

| 결과 | 의미 |
|---|---|
| test · deploy 모두 성공 | 완료. 이후 push 하면 자동 배포 |
| `Permission denied (publickey)` | `DEPLOY_SSH_KEY` 값 잘림 |
| `Host key verification failed` | `DEPLOY_KNOWN_HOSTS` 값 확인 |

---

### 작업 4: GPS 테스트 페이지 — 담당 Claude (버리는 코드)

**목적:** 휴대폰에서 GPS 가 어떻게 들어오는지, 화면을 끄거나 앱을 바꾸면 끊기는지, 거리 오차가 얼마인지 실측할 도구를 만든다. 측정이 끝나면 지운다(기능 코드로 쓰지 않음).

**Files:**
- Create: `src/main/webapp/resources/gps-test.html` (로그인 없이 `https://devgear.kr/p4/resources/gps-test.html`)

**화면 구성 (스타일 최소, 글자 크게):**
- 버튼: 시작 · 일시정지/다시 시작 · 종료 · 기록 초기화 · 로그 내려받기(JSON)
- 기준값 입력칸: 최대 정확도(m, 기본 30) · 최소 이동(m, 기본 5) · 최대 속도(m/s, 기본 8) — 바꾸면 즉시 적용, 저장 시 로그에 기록
- 상태: 위치 권한 상태 · 오류 메시지, Wake Lock 상태(지원 안 함 / 켜짐 / 풀림), 화면 표시 상태(visible/hidden) 변경 시각
- 수치: 경과 시간(일시정지 제외), **보정 거리**(통과한 점), **원본 거리**(모든 점), 받은 점 수, 통과 수, 버린 수(정확도 · 최소 이동 · 속도별), 마지막 점의 정확도 · 받은 시각
- 끊김 목록: 점 사이 간격이 10초를 넘은 구간마다 시작 시각 · 길이(초) · 그동안의 visibility 변화

**핵심 로직 (그대로 사용):**

```js
const R = 6371008.8; // 지구 평균 반지름(m) — Java 와 같은 값

// 두 점 사이 거리(m). a, b: {lat, lng}
function haversine(a, b) {
    const rad = d => d * Math.PI / 180;
    const dLat = rad(b.lat - a.lat);
    const dLng = rad(b.lng - a.lng);
    const h = Math.sin(dLat / 2) ** 2
            + Math.cos(rad(a.lat)) * Math.cos(rad(b.lat)) * Math.sin(dLng / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(h));
}

// 점 거르기. 버리면 이유('accuracy' | 'minStep' | 'speed'), 통과하면 null.
// p, last: {lat, lng, acc, t(ms)}. last 는 마지막으로 "통과한" 점
function judge(p, last, cfg) {
    if (p.acc > cfg.maxAccuracy) return 'accuracy';
    if (!last) return null;
    const d = haversine(last, p);
    if (d < cfg.minStep) return 'minStep';
    const sec = (p.t - last.t) / 1000;
    if (sec > 0 && d / sec > cfg.maxSpeed) return 'speed';
    return null;
}
```

- 위치: `navigator.geolocation.watchPosition(onPos, onErr, {enableHighAccuracy: true, maximumAge: 0, timeout: 15000})`
- 일시정지: `clearWatch` 후 다시 시작 시 새 구간(`segments.push([])`). 보정 거리는 구간 안에서만 더한다
- Wake Lock: 시작 시 `navigator.wakeLock.request('screen')`, `visibilitychange` 에서 visible 이 되면 재요청. 없거나 실패하면 상태만 표시
- 저장: 상태 전체(설정 · 구간 · 원본 점 · 버린 점 · 끊김 · visibility 로그)를 점마다 `localStorage['gpsTest']` 에 저장. 페이지를 열면 복원
- 로그 내려받기: 사용자가 버튼을 누를 때만 `Blob` + `<a download>` 로 `gps-test-YYYYMMDD-HHmm.json`

- [ ] **Step 1: 페이지 작성** — 위 구성과 로직으로 `gps-test.html` 하나에 HTML · JS 를 함께 작성

- [ ] **Step 2: 거리 계산 확인 (PC 브라우저 콘솔)** — 페이지를 열고 콘솔에서:

```js
haversine({lat: 37.5665, lng: 126.9780}, {lat: 37.5665, lng: 126.9790})
```

Expected: 약 88.2 (위도 37.5665 에서 경도 0.001° ≈ 88.2m)

```js
judge({lat: 37.5665, lng: 126.9780, acc: 50, t: 1000}, null, {maxAccuracy: 30, minStep: 5, maxSpeed: 8})
```

Expected: `'accuracy'`

```js
judge({lat: 37.5665, lng: 126.9790, acc: 5, t: 2000},
      {lat: 37.5665, lng: 126.9780, acc: 5, t: 1000}, {maxAccuracy: 30, minStep: 5, maxSpeed: 8})
```

Expected: `'speed'` (1초에 88m)

- [ ] **Step 3: 로컬 빌드**

Run: `mvn -B -q verify && unzip -l target/workout.war | grep gps-test.html`
Expected: `resources/gps-test.html` 한 줄

- [ ] **Step 4: Review Focus 확인 (PC 브라우저, 개발자 도구 위치 흉내 기능 사용)**

| 확인 | 기대 |
|---|---|
| 위치 권한 거부 후 시작 | 권한 거부 이유가 화면에 표시, 버튼이 멈추지 않음 |
| 정확도 100m 로 위치 흉내 | 보정 거리 0 유지, "정확도" 버린 수 증가 |
| 측정 중 새로고침 | 점 수 · 거리 · 끊김 목록 복원 |
| Wake Lock 없는 환경(데스크톱 Firefox 등) | "지원 안 함" 표시, 측정 계속 |

- [ ] **Step 5: 사용자에게 보고** — 커밋 · push(자동 배포) 여부는 사용자가 정한다

---

### 작업 5: GPS 실측 — 담당 사용자 (Claude 결과 분석)

**선행:** 작업 3 · 4 완료, 테스트 페이지가 배포됨

휴대폰 브라우저로 `https://devgear.kr/p4/resources/gps-test.html` 을 열고 측정한다. 가능하면 아이폰(Safari)과 안드로이드(Chrome) 각각.

- [ ] **Step 1: 측정** — 측정마다 "기록 초기화 → 시작 → 종료 → 로그 내려받기"

| 측정 | 방법 | 보는 것 |
|---|---|---|
| A. 기준 | 400m 트랙 3바퀴(1,200m), 화면 켠 채 | 보정 거리 · 원본 거리와 1,200m 의 차이 |
| B. 화면 끄기 | A 와 같은 코스, 중간에 2분 화면 끄기 | 끊김 목록에 2분 공백이 생기는지, 거리 오차 |
| C. 앱 전환 | 중간에 1분 다른 앱(음악 등) | 끊김 여부 · 길이 |
| D. 왕복 | 같은 길 500m 왕복(1,000m) | 왕복 거리가 제대로 쌓이는지 |
| E. 정지 | 1분 제자리에 서 있기 | 보정 거리가 늘지 않는지 |

- [ ] **Step 2: 결과 공유** — 내려받은 JSON 파일과 기기 · 브라우저 이름을 Claude 에게 전달

- [ ] **Step 3: 결정 (함께)** — Claude 가 정리한 결과로 정한다
  - 기준값 30m / 5m / 8m/s 유지 또는 조정
  - B · C 에서 끊긴다면: "화면 켜고 뛰기 + 직선 보정"으로 갈지, 네이티브 래핑을 검토할지
  - 결정 내용을 `docs/design.md` 6장에 반영

- [ ] **Step 4: 테스트 페이지 삭제** — 결정 후 `gps-test.html` 을 지운다 (담당 Claude, 커밋은 사용자 요청 시)

---

### 작업 6: 카카오맵 준비 — 담당 사용자

**선행:** 작업 2 (설정 자리)

메뉴 이름은 콘솔 개편으로 다를 수 있다. 다르면 Claude 가 현재 공식 문서로 다시 안내한다.

- [ ] **Step 1:** [Kakao Developers](https://developers.kakao.com/) 로그인 → 애플리케이션 추가 (이름 예: 운동 기록)
- [ ] **Step 2:** 카카오맵 API 사용 설정. **이 개발자 계정에서 처음 활성화하는 앱이어야 무료 쿼터**가 적용된다 — 이미 다른 앱에서 카카오맵을 켰다면 Claude 와 다시 검토
- [ ] **Step 3:** 플랫폼 → Web 에 사이트 도메인 등록: `https://devgear.kr`, `http://localhost:8080`
- [ ] **Step 4:** 앱 키에서 **JavaScript 키** 복사
- [ ] **Step 5:** 서버 `/etc/workout/app.env` 의 `WORKOUT_KAKAO_JS_KEY=` 에 입력 (`sudo nano /etc/workout/app.env`). 로컬 실행용은 IntelliJ Tomcat 실행 설정의 환경변수에 같은 이름으로
- [ ] **Step 6: 확인** — 키가 지도를 띄우는지는 기능 ① 의 첫 단계에서 확인한다

---

### 작업 7: UI 요청 프롬프트 — 담당 Claude

**목적:** 다른 AI 에게 화면 7개를 요청할 프롬프트를 만든다. 받은 HTML 을 JSP 로 옮기기 쉽도록, JS 가 연결할 요소를 미리 정해 둔다.

**선행:** 작업 5 Step 3 (GPS 결정이 런닝 화면 요소에 영향)

**Files:**
- Create: `docs/ui-prompts.md`

**문서 구성:**
1. **공통 프롬프트** (모든 화면 요청 앞에 붙임)
   - 결과물: 화면마다 HTML 1개 + 공통 CSS 1개 + 화면별 JS 는 화면 전환 · 열고 닫기 같은 UI 동작만(데이터 통신 없음, 예시 데이터는 HTML 에 하드코딩)
   - 순수 HTML · CSS · JavaScript, 프레임워크 · 빌드 도구 · 외부 CDN 없음 (카카오맵 SDK 자리는 `<div id="map">` 로만)
   - 모바일 우선(375px 기준), PC 에서도 깨지지 않게
   - 상태별 모습 포함: 빈 상태, 불러오는 중, 오류
   - 접근성: 버튼 · 입력칸 레이블, 키보드 초점 표시, 글자 대비
   - JS 연결용 `id` · `data-*` 속성은 아래 목록 그대로 사용 (이름 변경 금지)
   - 알림창은 만들지 않음 (`_alert` · `_error` · `_confirm` 기존 함수가 담당) — 대신 그 알림창 디자인용 CSS 클래스 목록(`manage-modal` 등)을 함께 스타일링 요청
2. **화면별 프롬프트 7개** — 각 화면의 목적, 들어갈 요소, 필수 `id` · `data-*` 목록, 예시 데이터
   - 로그인(`#loginForm`, `name=username/password`), 회원가입(`#signupForm`, `name=username/password/passwordConfirm/signupCode`)
   - 런닝: `#map`, 시작 · 일시정지 · 종료 버튼, 거리 · 시간 · 현재 페이스 표시, 결과 확인 영역(1km 구간 목록, 경로 공개 선택, 저장 · 버리기), 이어서 하기 안내
   - 기록: 월 이동, 직접 만든 달력(날짜 칸에 km · 기타 운동 · 계획 달성 표시), 하루 목록, 런닝 상세(지도 · 수치 · 구간), 기타 운동 추가 창(종목 추천, 횟수/시간 선택, 메모), 친구 달력일 때 표시
   - 계획: 날짜 선택, 목표 목록(달성 표시), 추가 · 수정 창(런닝 km / 종목 + 횟수 · 시간)
   - 친구: 아이디 검색 · 요청, 받은 요청(수락 · 거절), 보낸 요청(취소), 친구 목록(달력 보기 · 삭제)
   - 순위: 이번 주 / 이번 달 전환, 거리 순위, 운동한 날 수 순위(나 강조)
3. **받은 UI 를 JSP 로 옮기는 방법** — HTML 을 `WEB-INF/jsp/workout/<기능>/<기능>Main.jsp` 로, CSS · JS 를 `resources/` 로, `<head>` 는 `head.jsp` include 로 교체

- [ ] **Step 1:** `docs/ui-prompts.md` 작성
- [ ] **Step 2: 자기 검토** — `docs/design.md` 3장 화면 표와 5장 API 응답 항목마다 그것을 보여 줄 요소가 프롬프트에 있는지 대조, 빠진 것 추가
- [ ] **Step 3: 사용자에게 보고** — 사용자가 검토 후 다른 AI 에 요청

---

## 다음 계획

작업 5 의 결정과 작업 7 의 UI 를 받은 뒤, 기능마다 계획을 따로 쓴다: ① 런닝 메인 → ② 기록 달력 · 런닝 상세 → ③ 기타 운동 → ④ 계획 → ⑤ 친구 → ⑥ 친구 달력 보기 → ⑦ 순위. 각 계획에는 파일 위치, 함수 이름 · 입출력, 테스트 케이스(입력 → 기대 결과), 단계별 확인 방법을 넣고, 구현 코드는 사용자가 작성한다.
