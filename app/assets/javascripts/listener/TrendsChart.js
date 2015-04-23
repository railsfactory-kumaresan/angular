TrendsChart = function(chartContainer, legendContainer,
                       keywords, postPerDay) {
    this.chartContainer = chartContainer;
    this.legendContainer = legendContainer;
    this.keywords = keywords;
    this.postPerDay = postPerDay;
    this.width = $(this.chartContainer).outerWidth();
    this.height = $(this.chartContainer).outerHeight();

    this.canvas = $('<canvas>').attr('width', this.width)
                               .attr('height', this.height);

    $(this.chartContainer).append(this.canvas);

    this.ctx = this.canvas[0].getContext("2d");

    this.options = {
       ///Boolean - Whether grid lines are shown across the chart
       scaleShowGridLines : true,

       //String - Colour of the grid lines
       scaleGridLineColor : "rgba(0,0,0,.05)",

       //Number - Width of the grid lines
       scaleGridLineWidth : 1,

       //Boolean - Whether the line is curved between points
       bezierCurve : false,

       //Number - Tension of the bezier curve between points
       bezierCurveTension : 0.4,

       //Boolean - Whether to show a dot for each point
       pointDot : false,

       //Number - Radius of each point dot in pixels
       pointDotRadius : 4,

       //Number - Pixel width of point dot stroke
       pointDotStrokeWidth : 1,

       //Number - amount extra to add to the radius to cater for hit detection outside the drawn point
       pointHitDetectionRadius : 20,

       //Boolean - Whether to show a stroke for datasets
       datasetStroke : true,

       //Number - Pixel width of dataset stroke
       datasetStrokeWidth : 2,

       //Boolean - Whether to fill the dataset with a colour
       datasetFill : true,

       //String - A legend template
       legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].lineColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
            };


    this.config = {
       idle : {
           fillColor: "rgba(71, 184, 162, 0.2)",
           strokeColor: "rgba(71, 184, 162, 0.2)",
           pointColor: "rgba(71, 184, 162, 0.2)",
           pointStrokeColor: "#fff",
           pointHighlightFill: "#fff",
           pointHighlightStroke: "rgba(71, 184, 162, 0.2)"
       },
       active : {
           fillColor: "rgba(71, 184, 162, 0.8)",
           strokeColor: "rgba(71, 184, 162, 0.8)",
           pointColor: "rgba(71, 184, 162, 0.8)",
           pointStrokeColor: "#fff",
           pointHighlightFill: "#fff",
           pointHighlightStroke: "rgba(71, 184, 162, 0.8)"
       },
    }

    this.data = this.constructData();
    this.initLegend();

    this.chart = new Chart(this.ctx).Line(this.data, this.options);
}

TrendsChart.prototype.initLegend = function() {

    var that = this;
    function getLegendItem(keyword) {
        var a = $('<a>').addClass('trends-graph-legend')
                        .attr('href', 'javascript:void(0);')
                        .text(keyword)
                        .click(function(){
                            chartUpdateKeyword(keyword);
                            that.highlight(keyword);
                            $(this).addClass('active');
                        });

        var div = $('<div>').append(a)
        return div;            
    }

    for(var i=0; i<this.keywords.length; i++) {
        var keyword = this.keywords[i];
        var div = getLegendItem(keyword);
        this.legendContainer.append(div);                        
    }
};

TrendsChart.prototype.constructData = function() {

    var data = {labels:[], datasets: []};
    var dataLength = -1;

    function getDateStr(d) {
        var monthNames = new Array("Jan", "Feb", "Mar", 
                "Apr", "May", "Jun", "Jul", "Aug", "Sep", 
                "Oct", "Nov", "Dec");

        var date = d.getDate();
        var month = d.getMonth();
        return date+ " " + monthNames[month]; 
    }

    for(var i=0; i<this.keywords.length; i++) {
        var keyword = this.keywords[i];
        var d = {}
        d['label'] = keyword;
        d['data'] = this.postPerDay[keyword];
        d['fillColor'] = this.config.idle.fillColor;
        d['strokeColor'] = this.config.idle.strokeColor
        d['pointColor'] = this.config.idle.pointColor;
        d['pointStrokeColor'] = this.config.idle.pointStrokeColor;
        d['pointHighlightFill'] = this.config.idle.pointHighlightFill;
        d['pointHighlightStroke'] = this.config.idle.pointHighlightStroke
        data.datasets.push(d);

        dataLength = this.postPerDay[keyword].length;
    }

    var d = new Date();
    for(var i=0; i<dataLength; i++) {
        data.labels.unshift(getDateStr(d));
        d.setDate(d.getDate() - 1);
    }
    return data;
}


TrendsChart.prototype.highlight = function(keyword) {

    $('.trends-graph-legend').each(function(){
        $(this).removeClass('active');
    });

    var dataLength = this.chart.datasets.length;
    var index = -1;
    for(var i=0; i<dataLength; i++) {
        if(this.chart.datasets[i].label == keyword) {
            index = i;
            break;
        }
    }

    if(index == -1) {
        console.log('oops');
        return;
    }

    var data = this.chart.datasets[dataLength-1];
    data.fillColor = this.config.idle.fillColor;
    data.strokeColor = this.config.idle.strokeColor
    data.pointColor = this.config.idle.pointColor;
    data.pointStrokeColor = this.config.idle.pointStrokeColor;
    data.pointHighlightFill = this.config.idle.pointHighlightFill;
    data.pointHighlightStroke = this.config.idle.pointHighlightStroke;

    var data = this.chart.datasets.splice(index, 1)[0];
    data.fillColor = this.config.active.fillColor;
    data.strokeColor = this.config.active.strokeColor
    data.pointColor = this.config.active.pointColor;
    data.pointStrokeColor = this.config.active.pointStrokeColor;
    data.pointHighlightFill = this.config.active.pointHighlightFill;
    data.pointHighlightStroke = this.config.active.pointHighlightStroke;

    this.chart.datasets.push(data);
    this.chart.update();
}


function chartUpdateKeyword(keyword)
{
 $.ajax({
  url: "/admin/listeners",
  data:  { keyword: keyword, type_request: "graph"},
  dataType: "script",
  success: function(data){}
});
 jQuery(".loading").css('display','block');
}