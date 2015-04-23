DoughnutChart = function(chartContainer, raw_data,init_val) {
    this.chartContainer = chartContainer;
    this.raw_data = raw_data;
    var w = $(this.chartContainer).outerWidth();
    var h = $(this.chartContainer).outerHeight();

    this.activeLabel = null;  
    this.activePercent = null;
    this.labelContainer = null;
    this.width = this.height = Math.min(w,h);

    this.canvas = $('<canvas>').attr('width', this.width)
                               .attr('height', this.height);

    $(this.chartContainer).css('position', 'relative');
    $(this.chartContainer).append(this.canvas);
    this.ctx = this.canvas[0].getContext("2d");



    this.options = {
        //Boolean - Whether we should show a stroke on each segment
        segmentShowStroke : true,

        //String - The colour of each segment stroke
        segmentStrokeColor : "#fff",

        //Number - The width of each segment stroke
        segmentStrokeWidth : 2,

        //Number - The percentage of the chart that we cut out of the middle
        percentageInnerCutout : 70, // This is 0 for Pie charts

        //Number - Amount of animation steps
        animationSteps : 100,

        //String - Animation easing effect
        animationEasing : "easeOutBounce",

        //Boolean - Whether we animate the rotation of the Doughnut
        animateRotate : false,

        //Boolean - Whether we animate scaling the Doughnut from the centre
        animateScale : false,

        showTooltips: true,

        //String - A legend template
        legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li><span style=\"background-color:<%=segments[i].fillColor%>\"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>"
     };


    this.data = this.constructData();
    this.chart = new Chart(this.ctx).Doughnut(this.data, this.options);

    this.initCenterText(init_val);


    var that = this;
    $(this.canvas).mousemove(function(evt){
        var activePoints = that.chart.getSegmentsAtEvent(evt);
        if(activePoints.length > 0) {
            var point = activePoints[0];
            that.updateLabel(point.label, point.value);
        }
    });
}

DoughnutChart.prototype.config = {
        color:"#F7464A",
        highlight: "#FF5A5E",
        labelFontFamily: "Arial",
        labelFontSize: "12",
        labelFontStyle: "normal",
        labelFontColor: "#666",
        centerLabelColor : 'grey',
        centerLabelFontFamily : 'Open Sans',
};

DoughnutChart.prototype.initCenterText = function(initVal) {
    this.labelContainer = $('<div>').css({
        'position' : 'absolute',
        'top' : '37%',
        'left' : 0,
        'text-align' : 'center',
        'width' : this.width +'px', 
        'color' : this.config.centerLabelColor,
        'font-family' : this.config.centerLabelFontFamily,
        'z-index' : 0,
    });

    this.activePercent = $('<div>').css('font-size', '30px');
    this.activeLabel = $('<div>');

    this.activePercent.text(initVal[1].toString() +'%');
    this.activeLabel.text(initVal[0]);

    this.labelContainer.append(this.activePercent)
                       .append(this.activeLabel);

    this.chartContainer.append(this.labelContainer);
};

DoughnutChart.prototype.updateLabel = function(label, value) {
    $(this.activePercent).text(value+'%');
    $(this.activeLabel).text(label);
};

DoughnutChart.prototype.constructData = function() {
    var data = []
    for(var i=0;  i<this.raw_data.length; i++) {
        var info = this.raw_data[i]; 
        var d = {};
        d['label'] = info[0]; 
        d['value'] = info[1]; 
        d['color'] = this.getColor(info[2]); 
        d['highlight'] = this.getHighlightColor(info[2]);
        d['labelFontFamily'] = this.config.labelFontFamily;
        d['labelFontSize'] = this.config.labelFontSize;
        d['labelFontStyle'] = this.config.labelFontStyle;
        d['labelFontColor'] = this.config.labelFontColor;
        data.push(d);
    }
    return data;
};

DoughnutChart.prototype.getColor = function(hex) {
    var rgb = this.hexToRGB(hex);
    return "rgba(" + rgb.r + ", "+ rgb.g +", "+ rgb.b +", 0.6)";
};

DoughnutChart.prototype.getHighlightColor = function(hex) {
    var rgb = this.hexToRGB(hex);
    return "rgb(" + rgb.r + ", "+ rgb.g +", "+ rgb.b +")";
};

DoughnutChart.prototype.hexToRGB = function(hex) {
     var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
     hex = hex.replace(shorthandRegex, function(m, r, g, b) {
         return r + r + g + g + b + b;
     });
     
     var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
     return result ? {
             r: parseInt(result[1], 16),
             g: parseInt(result[2], 16),
             b: parseInt(result[3], 16)
             } : null;
};



