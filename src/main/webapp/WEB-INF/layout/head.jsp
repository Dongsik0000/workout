<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%-- 모든 화면 공통 <head> 내용. 화면별 CSS·JS 는 각 화면에서 이 뒤에 추가한다 --%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<meta name="theme-color" content="#102a43">
<link rel="icon" href="<c:url value='/resources/images/icon.svg'/>" type="image/svg+xml">
<link rel="manifest" href="<c:url value='/manifest.json'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/reset.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/common.css'/>">
<script>var contextPath = "${pageContext.request.contextPath}";</script>
<script defer src="<c:url value='/resources/js/common/common.js'/>"></script>
<script defer src="<c:url value='/resources/js/common/modal.js'/>"></script>
