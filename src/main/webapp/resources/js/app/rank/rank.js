// 순위 화면. 지금은 기간(이번 주 / 이번 달) 전환과 기간 표시만 있다.
// 순위 데이터는 기능 ⑦ 에서 이 모듈에 추가한다.
App.rank = (function(){
    var m$ = {
            periodLabel: document.getElementById('periodLabel'),
            periodButtons: document.querySelectorAll('[data-period]')
        },

        init = function(){
            bindEvent();
            selectPeriod('WEEK');
        },

        bindEvent = function(){
            m$.periodButtons.forEach(function(button){
                button.addEventListener('click', function(){ selectPeriod(button.dataset.period); });
            });
        },

        selectPeriod = function(period){
            m$.periodButtons.forEach(function(button){
                button.setAttribute('aria-pressed', String(button.dataset.period === period));
            });
            m$.periodLabel.textContent = periodText(period, App.todayKst());
        },

        // 주는 월요일 ~ 일요일, 달은 1일 ~ 말일 (한국 날짜 기준)
        periodText = function(period, today){
            if(period === 'MONTH'){
                var last = new Date(today.getFullYear(), today.getMonth() + 1, 0);
                return (today.getMonth() + 1) + '월 1일 ~ ' + (last.getMonth() + 1) + '월 ' + last.getDate() + '일';
            }
            var monday = App.addDays(today, -((today.getDay() + 6) % 7)),
                sunday = App.addDays(monday, 6);
            return shortDate(monday) + ' ~ ' + shortDate(sunday);
        },

        shortDate = function(date){
            return (date.getMonth() + 1) + '/' + date.getDate();
        };

    return { init: init };
}());

document.addEventListener('DOMContentLoaded', function(){
    App.rank.init();
});
