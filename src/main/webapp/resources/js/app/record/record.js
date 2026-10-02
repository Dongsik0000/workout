// 기록(달력) 화면. 지금은 달력 그리기 · 날짜 선택 · 창 열고 닫기만 있다.
// 달력 · 하루 목록 데이터와 저장 · 삭제는 기능 ② · ③ 에서 이 모듈에 추가한다.
App.record = (function(){
    var m$ = {
            calendar: document.getElementById('calendar'),
            dayCellTemplate: document.getElementById('dayCellTemplate'),
            monthLabel: document.getElementById('monthLabel'),
            dayTitle: document.getElementById('dayTitle'),
            btnAddExercise: document.getElementById('btnAddExercise'),
            friendBanner: document.getElementById('friendBanner'),
            runDetail: document.getElementById('runDetail'),
            exerciseEditor: document.getElementById('exerciseEditor'),
            exerciseForm: document.getElementById('exerciseForm')
        },
        WEEKDAYS = '월화수목금토일',   // 달력은 월요일 시작 (순위의 주 기준과 같음)
        DAY_NAMES = '일월화수목금토',  // Date.getDay() 순서
        settings = {
            today: null,
            month: null,      // 보고 있는 달의 1일
            selected: null,   // 선택한 날짜
            friendId: new URLSearchParams(location.search).get('userId'),
            exerciseDirty: false,
            syncUnit: null
        },

        init = function(){
            settings.today = App.todayKst();
            settings.month = new Date(settings.today.getFullYear(), settings.today.getMonth(), 1);
            settings.selected = settings.today;

            if(settings.friendId){
                m$.friendBanner.hidden = false;
                m$.btnAddExercise.hidden = true;
            }

            bindEvent();
            renderCalendar();
            selectDay(settings.selected);
        },

        bindEvent = function(){
            document.getElementById('btnPrevMonth').addEventListener('click', function(){ moveMonth(-1); });
            document.getElementById('btnNextMonth').addEventListener('click', function(){ moveMonth(1); });
            m$.calendar.addEventListener('click', function(e){
                var cell = e.target.closest('.day-cell');
                if(cell) selectDay(App.parseDate(cell.dataset.date));
            });

            bindExerciseEditor();
            App.bindDialog(m$.runDetail, function(){ return false; }, function(){});
            document.getElementById('btnDeleteRun').addEventListener('click', function(){
                _error('삭제 기능 준비 중', '러닝 기록 데이터가 아직 연결되지 않았어요.');
            });
        },

        moveMonth = function(n){
            settings.month = new Date(settings.month.getFullYear(), settings.month.getMonth() + n, 1);
            renderCalendar();
        },

        // 6주(42칸) 달력. 앞뒤 달의 날짜는 .is-outside
        renderCalendar = function(){
            var month = settings.month,
                start = App.addDays(month, -((month.getDay() + 6) % 7)),
                todayIso = App.isoDate(settings.today),
                selectedIso = App.isoDate(settings.selected);

            m$.monthLabel.textContent = month.getFullYear() + '년 ' + (month.getMonth() + 1) + '월';
            m$.calendar.replaceChildren();
            WEEKDAYS.split('').forEach(function(day){
                m$.calendar.appendChild(App.h('span', {className: 'weekday', text: day}));
            });

            for(var i = 0; i < 42; i++){
                var date = App.addDays(start, i),
                    iso = App.isoDate(date),
                    cell = m$.dayCellTemplate.content.firstElementChild.cloneNode(true);

                cell.dataset.date = iso;
                cell.querySelector('.day-num').textContent = date.getDate();
                cell.classList.toggle('is-outside', date.getMonth() !== month.getMonth());
                cell.classList.toggle('is-today', iso === todayIso);
                cell.setAttribute('aria-label', iso + ', 기록 없음');
                cell.setAttribute('aria-pressed', iso === selectedIso ? 'true' : 'false');
                m$.calendar.appendChild(cell);
            }
        },

        selectDay = function(date){
            var iso = App.isoDate(date);
            settings.selected = date;
            m$.calendar.querySelectorAll('.day-cell').forEach(function(cell){
                cell.setAttribute('aria-pressed', cell.dataset.date === iso ? 'true' : 'false');
            });
            m$.dayTitle.textContent = (date.getMonth() + 1) + '월 ' + date.getDate() + '일 (' + DAY_NAMES[date.getDay()] + ')';
        },

        // 기타 운동 추가 창: 선택한 날짜로 열고, 입력이 있으면 닫을 때 버릴지 묻는다
        bindExerciseEditor = function(){
            var form = m$.exerciseForm;
            settings.syncUnit = App.bindToggleFields(form, 'unit', 'data-unit-fields');

            m$.btnAddExercise.addEventListener('click', function(){
                resetExerciseForm();
                m$.exerciseEditor.showModal();
            });
            form.addEventListener('input', function(){ settings.exerciseDirty = true; });
            App.bindDialog(m$.exerciseEditor, function(){ return settings.exerciseDirty; }, resetExerciseForm);

            form.addEventListener('submit', function(e){
                e.preventDefault();
                _error('저장 기능 준비 중', '운동 기록은 아직 저장되지 않았어요.');
            });
        },

        resetExerciseForm = function(){
            m$.exerciseForm.reset();
            m$.exerciseForm.elements.date.value = App.isoDate(settings.selected);
            settings.syncUnit();
            settings.exerciseDirty = false;
        };

    return { init: init };
}());

document.addEventListener('DOMContentLoaded', function(){
    App.record.init();
});
