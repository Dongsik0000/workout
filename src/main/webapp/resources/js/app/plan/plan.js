// 계획 화면. 지금은 날짜 이동 · 목표 추가 창 열고 닫기만 있다.
// 목표 목록 · 저장 · 삭제는 기능 ④ 에서 이 모듈에 추가한다.
App.plan = (function(){
    var m$ = {
            planDate: document.getElementById('planDate'),
            editor: document.getElementById('planEditor'),
            form: document.getElementById('planForm')
        },
        settings = {
            dirty: false,
            syncKind: null,
            syncUnit: null
        },

        init = function(){
            m$.planDate.value = App.isoDate(App.todayKst());
            bindEvent();
        },

        bindEvent = function(){
            document.getElementById('btnPrevDay').addEventListener('click', function(){ moveDay(-1); });
            document.getElementById('btnNextDay').addEventListener('click', function(){ moveDay(1); });

            settings.syncKind = App.bindToggleFields(m$.form, 'kind', 'data-kind-fields');
            settings.syncUnit = App.bindToggleFields(m$.form, 'unit', 'data-unit-fields');

            document.getElementById('btnAddPlan').addEventListener('click', function(){
                resetForm();
                m$.editor.showModal();
            });
            m$.form.addEventListener('input', function(){ settings.dirty = true; });
            App.bindDialog(m$.editor, function(){ return settings.dirty; }, resetForm);

            m$.form.addEventListener('submit', function(e){
                e.preventDefault();
                _error('저장 기능 준비 중', '계획은 아직 저장되지 않았어요.');
            });
        },

        moveDay = function(n){
            m$.planDate.value = App.isoDate(App.addDays(App.parseDate(m$.planDate.value), n));
        },

        resetForm = function(){
            m$.form.reset();
            settings.syncKind();
            settings.syncUnit();
            settings.dirty = false;
        };

    return { init: init };
}());

document.addEventListener('DOMContentLoaded', function(){
    App.plan.init();
});
