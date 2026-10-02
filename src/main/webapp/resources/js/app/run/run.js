// 러닝(메인) 화면. 지금은 상태(시작 전 → 러닝 중 → 일시정지 → 결과 확인) 전환만 있다.
// GPS 추적 · 저장은 기능 ① 에서 이 모듈에 추가한다.
App.run = (function(){
    var m$ = {
            panel: document.getElementById('runPanel'),
            stateLabel: document.querySelector('#runPanel .run-state-label')
        },
        STATE_NAME = {idle: '시작 전', running: '러닝 중', paused: '일시정지', finished: '결과 확인'},

        init = function(){
            bindEvent();
        },

        bindEvent = function(){
            document.getElementById('btnStart').addEventListener('click', function(){ setState('running'); });
            document.getElementById('btnPause').addEventListener('click', function(){ setState('paused'); });
            document.getElementById('btnResume').addEventListener('click', function(){ setState('running'); });
            document.getElementById('btnStop').addEventListener('click', function(){
                _confirm('러닝을 끝낼까요?', '결과 확인 화면으로 이동합니다. 이 미리보기에서는 기록이 저장되지 않아요.', function(){
                    setState('finished');
                });
            });
            document.getElementById('btnDiscard').addEventListener('click', function(){
                _confirm('이 화면을 닫을까요?', '미리보기 상태가 초기화됩니다.', function(){
                    setState('idle');
                });
            });
            document.getElementById('btnSave').addEventListener('click', function(){
                _error('저장 기능 준비 중', '이 화면은 디자인 미리보기입니다. 러닝 기록은 저장되지 않았어요.');
            });
        },

        // 화면 모습은 run.css 가 #runPanel[data-state] 값으로 바꾼다
        setState = function(state){
            m$.panel.dataset.state = state;
            document.body.dataset.runState = state;
            m$.stateLabel.textContent = STATE_NAME[state];
        };

    return { init: init };
}());

document.addEventListener('DOMContentLoaded', function(){
    App.run.init();
});
