<%@ page pageEncoding="UTF-8"%>
<%-- 아이콘 스프라이트. 사용: <svg class="icon" aria-hidden="true"><use href="#i-plus"></use></svg>
     선 아이콘은 CSS(.icon)가 stroke 를 currentColor 로 칠한다. #i-barbell 은 원판 색을 직접 가진 브랜드 마크(.mark) --%>
<svg xmlns="http://www.w3.org/2000/svg" style="display:none" aria-hidden="true">
    <%-- 옆에서 본 바벨: 안쪽부터 25kg(빨강) · 20kg(파랑) · 15kg(노랑) · 10kg(초록) 원판 --%>
    <symbol id="i-barbell" viewBox="0 0 64 32">
        <rect x="0" y="14.5" width="64" height="3" rx="1.5" fill="currentColor"/>
        <rect x="13" y="2" width="4" height="28" rx="1" fill="#d42a3c"/>
        <rect x="9.5" y="4" width="3.5" height="24" rx="1" fill="#1f5bd6"/>
        <rect x="6.5" y="6" width="3" height="20" rx="1" fill="#f0be2c"/>
        <rect x="4" y="8" width="2.5" height="16" rx="1" fill="#17945a"/>
        <rect x="17" y="12" width="2" height="8" rx=".5" fill="currentColor"/>
        <rect x="45" y="12" width="2" height="8" rx=".5" fill="currentColor"/>
        <rect x="47" y="2" width="4" height="28" rx="1" fill="#d42a3c"/>
        <rect x="51" y="4" width="3.5" height="24" rx="1" fill="#1f5bd6"/>
        <rect x="54.5" y="6" width="3" height="20" rx="1" fill="#f0be2c"/>
        <rect x="57.5" y="8" width="2.5" height="16" rx="1" fill="#17945a"/>
    </symbol>
    <symbol id="i-today" viewBox="0 0 24 24">
        <rect x="3" y="5" width="18" height="16" rx="3"/>
        <path d="M7 3v4M17 3v4M3 11h18"/>
        <path d="m9 16 2 2 4-4"/>
    </symbol>
    <symbol id="i-plus" viewBox="0 0 24 24">
        <path d="M12 5v14M5 12h14"/>
    </symbol>
    <symbol id="i-check" viewBox="0 0 24 24">
        <path d="m5 12 5 5 9-10"/>
    </symbol>
    <symbol id="i-left" viewBox="0 0 24 24">
        <path d="m14 6-6 6 6 6"/>
    </symbol>
    <symbol id="i-right" viewBox="0 0 24 24">
        <path d="m10 6 6 6-6 6"/>
    </symbol>
    <symbol id="i-close" viewBox="0 0 24 24">
        <path d="m6 6 12 12M6 18 18 6"/>
    </symbol>
    <symbol id="i-user" viewBox="0 0 24 24">
        <circle cx="12" cy="8" r="3"/>
        <path d="M5 21v-2a7 7 0 0 1 14 0v2"/>
    </symbol>
    <symbol id="i-logout" viewBox="0 0 24 24">
        <path d="M10 4H4v16h6M10 12h11m-4-4 4 4-4 4"/>
    </symbol>
    <symbol id="i-route-mark" viewBox="0 0 40 40">
        <rect width="40" height="40" rx="12" fill="#3768ed"/>
        <path d="M12 28V16a8 8 0 0 1 16 0v8a4 4 0 0 1-8 0V14" fill="none" stroke="white" stroke-width="3" stroke-linecap="round"/>
        <circle cx="12" cy="29" r="2" fill="#a9e4d0"/>
    </symbol>
    <symbol id="i-run" viewBox="0 0 24 24">
        <circle cx="15" cy="4" r="2"/><path d="m11 8 4 2 2 4m-7-6-3 4 4 2-3 6m3-6 4-2 4 7M4 20l4-4"/>
    </symbol>
    <symbol id="i-target" viewBox="0 0 24 24">
        <circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1"/>
    </symbol>
    <symbol id="i-people" viewBox="0 0 24 24">
        <circle cx="8" cy="8" r="3"/><path d="M2 20v-2a6 6 0 0 1 12 0v2M16 5a3 3 0 0 1 0 6m2 3a5 5 0 0 1 4 5v1"/>
    </symbol>
    <symbol id="i-rank" viewBox="0 0 24 24">
        <path d="M3 20h18M5 20v-6h4v6m2 0V5h4v15m2 0v-9h4v9"/>
    </symbol>
</svg>
