<%@ page pageEncoding="UTF-8"%>
<%-- 로그인·가입 화면의 큰 바벨. 원판이 바깥에서 하나씩 끼워지는 애니메이션(login.css)이 원판마다 걸리도록
     스프라이트(<use>)가 아니라 SVG 를 직접 넣는다. --%>
<svg class="rack-bar" viewBox="0 0 64 32" aria-hidden="true">
    <rect x="0" y="14.5" width="64" height="3" rx="1.5" fill="currentColor"/>
    <rect x="17" y="12" width="2" height="8" rx=".5" fill="currentColor"/>
    <rect x="45" y="12" width="2" height="8" rx=".5" fill="currentColor"/>
    <rect class="plate left" style="--i:0" x="13" y="2" width="4" height="28" rx="1" fill="#d42a3c"/>
    <rect class="plate left" style="--i:1" x="9.5" y="4" width="3.5" height="24" rx="1" fill="#1f5bd6"/>
    <rect class="plate left" style="--i:2" x="6.5" y="6" width="3" height="20" rx="1" fill="#f0be2c"/>
    <rect class="plate left" style="--i:3" x="4" y="8" width="2.5" height="16" rx="1" fill="#17945a"/>
    <rect class="plate right" style="--i:0" x="47" y="2" width="4" height="28" rx="1" fill="#d42a3c"/>
    <rect class="plate right" style="--i:1" x="51" y="4" width="3.5" height="24" rx="1" fill="#1f5bd6"/>
    <rect class="plate right" style="--i:2" x="54.5" y="6" width="3" height="20" rx="1" fill="#f0be2c"/>
    <rect class="plate right" style="--i:3" x="57.5" y="8" width="2.5" height="16" rx="1" fill="#17945a"/>
</svg>
