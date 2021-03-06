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

function select_tab() {
    //make sure tab doesn't lose state
    var selectedTab = $('#stats-current-tab').val()
    switch(selectedTab) {
        case 'user-stats-tab':
        case 'food-etalk-stats-tab':
        case 'better-u-stats-tab':
            break;
        default:
            $('#user-stats-tab').tab('show')
    }
}


function show_spinner() {
    $("#nav-tabContent").hide();
    $("#loader").show();
}

function hide_spinner() {
    $("#loader").hide();
}

//track current tab in admin>stats dashboard
//also fix to redraw chart after selecting a Bootstrap tab
$(function(){
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var id = e.target.id
        //set currently clicked tab
        $('#stats-current-tab').val(id)

        switch(id) {
            case 'nav-admin-tab':
            case 'stats-tab-link':
            case 'user-stats-tab':
            case 'food-etalk-stats-tab':
            case 'better-u-stats-tab':
                resizeCharts();
                Chartkick.eachChart( function(chart) {
                    chart.redraw();
                });
        }
        if(id == 'nav-my-activity-tab'){
            init_isotope_started_courses();
        }
    })
});