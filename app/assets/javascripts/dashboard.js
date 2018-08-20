if (document.addEventListener) {
    window.addEventListener('resize', resizeCharts);
} else if (document.attachEvent) {
    window.attachEvent('onresize', resizeCharts);
} else {
    window.resize = resizeCharts;
}

function resizeCharts () {
    if (typeof usersByMonthInDateRangeChart !== 'undefined') {
        usersByMonthInDateRangeChart.draw();
    }
    if (typeof usersByGroupInDateRangeChart !== 'undefined') {
        usersByGroupInDateRangeChart.draw();
    }
    if (typeof usersByGroupAndMonthInDateRangeChart !== 'undefined') {
        usersByGroupAndMonthInDateRangeChart.draw();
    }
    if (typeof userEligibilityByRangeChart !== 'undefined') {
        userEligibilityByRangeChart.draw();
    }
    if (typeof userEligibilityByRangeAndGroupChart !== 'undefined') {
        userEligibilityByRangeAndGroupChart.draw();
    }

    //FOOD_ETALK
    if (typeof usersStartedCompletedCurriculaChartFOOD_ETALK !== 'undefined') {
        usersStartedCompletedCurriculaChartFOOD_ETALK.draw();
    }
    if (typeof usersStartedCompletedCurriculaByGroupChartFOOD_ETALK !== 'undefined') {
        usersStartedCompletedCurriculaByGroupChartFOOD_ETALK.draw();
    }

    //BETTER_U
    if (typeof usersStartedCompletedCurriculaChartBETTER_U !== 'undefined') {
        usersStartedCompletedCurriculaChartBETTER_U.draw();
    }
    if (typeof usersStartedCompletedCurriculaByGroupChartBETTER_U !== 'undefined') {
        usersStartedCompletedCurriculaByGroupChartBETTER_U.draw();
    }
}

//track current tab in admin>stats dashboard
//also fix to redraw chart after selecting a Bootstrap tab
$(function(){
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var id = e.target.id
        //set currently clicked tab
        $('#stats-current-tab').val(id)
        var should_redraw_charts = false;
        switch(id) {
            case 'nav-admin-tab':
            case 'stats-tab-link':
            case 'user-stats-tab':
            case 'food-etalk-stats-tab':
            case 'better-u-stats-tab':
                should_redraw_charts = true;
                break;
        }
        if (should_redraw_charts) {
            resizeCharts();
            Chartkick.eachChart( function(chart) {
                chart.redraw();
            });
        }
    })
});