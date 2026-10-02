// 전역 네임스페이스: 화면별 js는 App.xxx = (function(){ ... return {init:...}; })(); 형태로 등록한다.
// 사용 예) app/login/login.js -> App.login = (function(){ ... }()); jsp에서 App.login.init() 호출
var App = window.App || {};

// App.ajax(url, data, opts): 서버(jsonView) 공통 호출. fetch 기반, JSON 요청/응답 고정.
// opts.method 기본 POST, opts.onError 없으면 _error 모달로 공통 처리.
// jQuery 는 쓰지 않는다(알려진 취약점, 제거함).
//
// 사용 예)
//   App.ajax(contextPath + '/design/login', { user_id: 'abc', user_pw: '1234' })
//       .then(function(res){ console.log(res.code); })
//       .catch(function(){ /* 실패 시 처리, 안 써도 App.ajax가 알아서 _error 모달 띄움 */ });
//
//   App.get(contextPath + '/design/notice/list', { page: 1 }).then(function(res){ ... });
App.ajax = function (url, data, opts) {
    opts = opts || {};
    var method = (opts.method || 'POST').toUpperCase();
    var fetchOpt = {
        method: method,
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest'   // 인터셉터가 Ajax로 인식하게
        },
        credentials: 'same-origin'
    };

    if (method === 'GET') {
        if (data) url += (url.indexOf('?') === -1 ? '?' : '&') + new URLSearchParams(data).toString();
    } else {
        fetchOpt.body = JSON.stringify(data || {});
    }

    return fetch(url, fetchOpt)
        .then(function (res) {
            if (!res.ok) {
                var err = new Error('HTTP ' + res.status);
                err.status = res.status;
                throw err;
            }
            return res.json();
        })
        .then(function(data){
            if(data && data.sessionExpired) return App.sessionExpired();
            return data;
        })
        .catch(function (err) {
            if (typeof opts.onError === 'function') {
                opts.onError(err);
            } else if (typeof window._error === 'function') {
                // 429: nginx 요청 속도 제한(로그인·가입 시도 등)
                if (err.status === 429) window._error('잠시 후 다시 시도해 주세요', '짧은 시간에 요청이 너무 많았어요. 1분쯤 뒤에 다시 시도해 주세요.');
                else window._error('오류', '요청 처리 중 문제가 발생했습니다.');
            }
            throw err;
        });
};

App.sessionExpired = function(){
    _error('로그인 세션시간이 초과되었습니다.', '다시 로그인 부탁드립니다.', function(){
        window.location.href = contextPath + '/login';
    });
    return new Promise(function(){});   // 체인 중단 - 뒤의 .then(render)를 막는다
};

// App.get(url, data, opts) / App.post(url, data, opts): App.ajax의 GET/POST 전용 별칭.
// 화면 코드에서는 method 옵션을 신경 쓰지 않도록 이 둘을 우선 사용.
App.get = function (url, data, opts) {
    return App.ajax(url, data, Object.assign({}, opts, {method: 'GET'}));
};
App.post = function (url, data, opts) {
    return App.ajax(url, data, Object.assign({}, opts, {method: 'POST'}));
};

// App.isEmpty(v): null/undefined/빈문자열/빈배열/빈객체 여부
//
// 사용 예)
//   if(App.isEmpty(param.user_id)){ _error('알림', '아이디를 입력해주세요.'); return; }
App.isEmpty = function (v) {
    if (v === null || v === undefined) return true;
    if (typeof v === 'string' || Array.isArray(v)) return v.length === 0;
    if (typeof v === 'object') return Object.keys(v).length === 0;
    return false;
};

// 서버 결과 코드. Java workout.cmmn.util.Constants 와 같은 값을 유지한다.
App.CODE = {
    SUCCESS: '00',
    FAIL: '99',
    LOGIN_FAIL: '01',
    LOGIN_BLOCKED: '03',
    SIGNUP_FAIL_CODE: '11',
    SIGNUP_FAIL_EXISTS: '12',
    SIGNUP_BLOCKED: '13',
    INVALID: '90',
    NOT_FOUND: '91',
    DUPLICATE: '92',
    IN_USE: '95'
};

// App.fail(res, fallback): 화면이 따로 처리하지 않은 결과 코드의 공통 안내.
//
// 사용 예)
//   if(res.code === App.CODE.SUCCESS){ ... } else App.fail(res, '저장 중 문제가 발생했습니다.');
App.fail = function (res, fallback) {
    _error('오류', (res && res.message) || fallback || '요청 처리 중 문제가 발생했습니다.');
};

// App.escape(v): 사용자 입력을 HTML 문자열에 넣기 전에 반드시 거친다. 가능하면 textContent 를 쓴다.
//
// 사용 예)
//   li.innerHTML = '<strong>' + App.escape(row.title) + '</strong>';
App.escape = function (v) {
    var map = {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'};
    return String(v === null || v === undefined ? '' : v).replace(/[&<>"']/g, function (c) {
        return map[c];
    });
};

// App.h(tag, props, children): DOM 요소를 안전하게 만든다. 문자열 자식은 텍스트 노드(HTML 해석 없음).
//   props.text: textContent, props.attrs: setAttribute, props.on: 이벤트, 그 밖: 프로퍼티(value, checked, type, className …)
//
// 사용 예)
//   App.h('button', {type: 'button', className: 'button small', text: '저장', on: {click: save}})
App.h = function (tag, props, children) {
    var el = document.createElement(tag);
    props = props || {};
    Object.keys(props).forEach(function (k) {
        var v = props[k];
        if (v === undefined || v === null) return;
        if (k === 'attrs') {
            Object.keys(v).forEach(function (a) { el.setAttribute(a, v[a]); });
        } else if (k === 'on') {
            Object.keys(v).forEach(function (ev) { el.addEventListener(ev, v[ev]); });
        } else if (k === 'text') {
            el.textContent = v;
        } else {
            el[k] = v;
        }
    });
    (children || []).forEach(function (c) {
        if (c === null || c === undefined || c === false) return;
        el.appendChild(typeof c === 'string' || typeof c === 'number' ? document.createTextNode(String(c)) : c);
    });
    return el;
};

// App.icon(name): 아이콘 스프라이트(layout/icons.jsp)의 #i-name
App.icon = function (name) {
    var ns = 'http://www.w3.org/2000/svg';
    var svg = document.createElementNS(ns, 'svg');
    svg.setAttribute('class', 'icon');
    svg.setAttribute('aria-hidden', 'true');
    var use = document.createElementNS(ns, 'use');
    use.setAttribute('href', '#i-' + name);
    svg.appendChild(use);
    return svg;
};

// App.saved(title): 저장·삭제 성공을 짧게 알린다
App.saved = function (title) {
    _alert(title || '저장했어요', {autoClose: 900});
};

// App.bindDialog(dialog, isDirty, discard): 편집 창의 닫기 요청(data-close 버튼·Escape·뒤로 가기)을 한곳에서 받는다.
// isDirty() 가 true 면 버릴지 먼저 묻고, 버리기로 하면 discard() 뒤에 닫는다.
// Escape 는 cancel 을 막는 것만으로는 Chrome 이 연속 입력에서 창을 그냥 닫으므로 keydown 에서 막는다
App.bindDialog = function (dialog, isDirty, discard) {
    var requestClose = function () {
        if (!isDirty()) {
            dialog.close();
            return;
        }
        _confirm('작성 중인 내용을 버릴까요?', '저장하지 않은 입력은 사라져요.', function () {
            discard();
            dialog.close();
        });
    };
    dialog.querySelectorAll('[data-close]').forEach(function (b) {
        b.addEventListener('click', requestClose);
    });
    dialog.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            e.preventDefault();
            requestClose();
        }
    });
    dialog.addEventListener('cancel', function (e) {
        e.preventDefault();
        requestClose();
    });
};

// App.result(res, handlers): 결과 코드 분기 공통. handlers.ok 는 성공, handlers['95'] 처럼 코드별 처리.
// 처리하지 않은 90·92 는 서버 message, 91 은 "찾을 수 없어요", 나머지는 App.fail.
//
// 사용 예)
//   App.post(url, param).then(function(res){ App.result(res, {ok: reload}); });
App.result = function (res, handlers) {
    handlers = handlers || {};
    var code = res && res.code;
    if (code === App.CODE.SUCCESS) {
        if (handlers.ok) App.guard(handlers.ok, res);
        return;
    }
    if (handlers[code]) {
        App.guard(handlers[code], res);
        return;
    }
    if (code === App.CODE.INVALID || code === App.CODE.DUPLICATE) {
        _error('확인해 주세요', res.message || '입력한 내용을 확인해 주세요.');
    } else if (code === App.CODE.NOT_FOUND) {
        _error('찾을 수 없어요', '이미 삭제되었거나 권한이 없는 항목이에요.');
    } else {
        App.fail(res);
    }
};

// App.guard(fn, res): 결과 처리(화면 그리기) 중 예외를 조용히 삼키지 않고 알린다.
// 화면 코드의 .catch(function(){}) 는 통신 오류(이미 안내됨)용이라, 여기서 먼저 잡아야 빈 화면으로 멈추지 않는다
App.guard = function (fn, res) {
    try {
        fn(res);
    } catch (e) {
        if (window.console) console.error(e);
        _error('화면을 그리지 못했어요', '새로고침해 주세요. 계속되면 서버와 화면 버전이 다른지(배포 직후 등) 확인해 주세요.');
    }
};

// 로그아웃: data-logout 속성을 가진 요소를 누르면 POST /auth/logout 후 로그인 화면으로.
App.logout = function () {
    App.post(contextPath + '/auth/logout')
        .then(function () { location.href = contextPath + '/login'; })
        .catch(function () {});
};
document.addEventListener('click', function (e) {
    var el = e.target.closest ? e.target.closest('[data-logout]') : null;
    if (!el) return;
    e.preventDefault();
    App.logout();
});

// App.formToObject(form): <form> -> {name: value} 평면 객체. 폼 제출 데이터를 서버로 보낼 때 사용.
//
// 사용 예)
//   var param = App.formToObject(document.getElementById('searchForm'));
//   App.post(url, param).then(...);
App.formToObject = function (form) {
    var obj = {};
    new FormData(form).forEach(function (value, key) {
        if (obj.hasOwnProperty(key)) {
            if (!Array.isArray(obj[key])) obj[key] = [obj[key]];
            obj[key].push(value);
        } else {
            obj[key] = value;
        }
    });
    return obj;
};

// App.debounce(fn, wait): 마지막 호출 후 wait(ms) 지나야 실행. 검색어 입력, resize 등에 사용.
//
// 사용 예)
//   searchInput.addEventListener('input', App.debounce(function(){
//       App.get(url, { keyword: searchInput.value }).then(renderList);
//   }, 300));
App.debounce = function (fn, wait) {
    var timer = null;
    return function () {
        var ctx = this, args = arguments;
        clearTimeout(timer);
        timer = setTimeout(function () {
            fn.apply(ctx, args);
        }, wait);
    };
};

// 날짜는 "그 날의 0시(브라우저 시간)" Date 로 다룬다. 서버와 주고받을 때는 App.isoDate 문자열("2026-10-02")을 쓴다.
//
// 사용 예)
//   var today = App.todayKst();                     // 기기 시간대와 상관없이 한국 날짜
//   App.isoDate(App.addDays(today, -1));            // 어제 "2026-10-01"
//   App.parseDate('2026-10-02').getDay();           // 요일 (0=일)

// App.todayKst(): 한국 시간 기준 오늘
App.todayKst = function () {
    var p = {};
    new Intl.DateTimeFormat('en-CA', {timeZone: 'Asia/Seoul', year: 'numeric', month: '2-digit', day: '2-digit'})
        .formatToParts(new Date())
        .forEach(function (part) { p[part.type] = part.value; });
    return new Date(Number(p.year), Number(p.month) - 1, Number(p.day));
};

// App.isoDate(date): Date -> "yyyy-MM-dd"
App.isoDate = function (date) {
    return date.getFullYear() + '-' + String(date.getMonth() + 1).padStart(2, '0') + '-' + String(date.getDate()).padStart(2, '0');
};

// App.parseDate(s): "yyyy-MM-dd" -> Date (그 날 0시)
App.parseDate = function (s) {
    var a = String(s).split('-');
    return new Date(Number(a[0]), Number(a[1]) - 1, Number(a[2]));
};

// App.addDays(date, n): n일 뒤(음수면 앞) 날짜. 원본은 바꾸지 않는다
App.addDays = function (date, n) {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate() + n);
};

// App.bindToggleFields(scope, radioName, attr): 라디오 값에 맞는 입력 묶음만 보이게 한다.
// scope 안에서 name=radioName 라디오가 바뀌면 [attr="값"] 요소만 보이고 나머지 [attr] 요소는 hidden.
//
// 돌려주는 sync() 는 form.reset() 처럼 change 없이 값이 바뀐 뒤 화면을 다시 맞출 때 부른다.
//
// 사용 예) <div data-unit-fields="COUNT">…</div> <div data-unit-fields="SECOND" hidden>…</div>
//   var syncUnit = App.bindToggleFields(form, 'unit', 'data-unit-fields');
//   form.reset(); syncUnit();
App.bindToggleFields = function (scope, radioName, attr) {
    var sync = function () {
        var checked = scope.querySelector('input[name="' + radioName + '"]:checked');
        var value = checked ? checked.value : null;
        scope.querySelectorAll('[' + attr + ']').forEach(function (el) {
            el.hidden = el.getAttribute(attr) !== value;
        });
    };
    scope.querySelectorAll('input[name="' + radioName + '"]').forEach(function (radio) {
        radio.addEventListener('change', sync);
    });
    sync();
    return sync;
};

// show(container): 로딩화면을 뿌려줄 요소를 파라미터로 넘긴다.
// hide(container): container값이 없을 경우 모든 로딩화면 제거
//
// 사용 예)
//   _loading.show();               // 기본: .manage-section 영역에 표시
//   _loading.show('boardWrap');    // 특정 id 영역에만 표시
//   _loading.hide();               // 열려있는 로딩화면 전부 제거
var _loading = (function () {
    let OVERLAY_KEY = '_loadingOverlay';
    let _active = [];

    function resolve(container) {
        if (typeof container === 'string') return document.getElementById(container);
        return container || null;
    }

    function show(container) {
        let el = (container === undefined || container === null) ? document.querySelector('.manage-section') : resolve(container);
        if (!el) return;

        if (getComputedStyle(el).position === 'static') {
            el.style.position = 'relative';
        }

        let existing = el.querySelector('.line-manage-loading');
        if (existing) {
            el[OVERLAY_KEY] = existing;
            _active.push(el);
            return;
        }

        if (el[OVERLAY_KEY]) return;

        let overlay = document.createElement('div');
        overlay.className = 'line-manage-loading';
        overlay.setAttribute('role', 'status');
        overlay.setAttribute('aria-live', 'polite');
        overlay.innerHTML = '<div class="line-manage-loading-inner"><div class="spinner-wrap"><div class="krds-spinner" aria-hidden="true"></div></div><h1 class="loading-title">불러오는 중..</h1></div>';
        el.appendChild(overlay);
        el[OVERLAY_KEY] = overlay;
        _active.push(el);
    }

    function hide(container) {
        if (container === undefined) {
            _active.forEach(function (el) {
                if (el[OVERLAY_KEY]) {
                    el[OVERLAY_KEY].remove();
                    el[OVERLAY_KEY] = null;
                }
            });
            _active = [];

            let main = document.querySelector('.manage-section');
            if (main) {
                let preRendered = main.querySelector('.line-manage-loading');
                if (preRendered) preRendered.remove();
            }
            return;
        }

        let el = resolve(container);
        if (!el || !el[OVERLAY_KEY]) return;

        el[OVERLAY_KEY].remove();
        el[OVERLAY_KEY] = null;
        _active = _active.filter(function (a) {
            return a !== el;
        });
    }

    return {
        show: show,
        hide: hide
    };
}());