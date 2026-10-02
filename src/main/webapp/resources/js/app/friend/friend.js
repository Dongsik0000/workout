// 친구 화면. 검색 · 요청 · 수락 · 삭제는 기능 ⑤ 에서 이 모듈에 추가한다.
App.friend = (function(){
    var m$ = {
            searchForm: document.getElementById('friendSearchForm')
        },

        init = function(){
            bindEvent();
        },

        bindEvent = function(){
            m$.searchForm.addEventListener('submit', function(e){
                e.preventDefault();
                _error('검색 기능 준비 중', '친구 검색은 아직 연결되지 않았어요.');
            });
        };

    return { init: init };
}());

document.addEventListener('DOMContentLoaded', function(){
    App.friend.init();
});
