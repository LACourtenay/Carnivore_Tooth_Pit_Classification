am4core.useTheme(am4themes_animated);
var chart = am4core.create("african_plot", am4charts.RadarChart);

chart.data = [
    {
        "Variable": "Accuracy",
        "SVM" : 0.9267,
        "NSVM" : 0.9347
    },{
        "Variable": "Sensitivity",
        "SVM" : 0.89,
        "NSVM" : 0.93
    }, {
        "Variable": "Specificity",
        "SVM" : 0.96,
        "NSVM" : 0.98
    }, {
        "Variable": "AUC",
        "SVM" : 0.94,
        "NSVM" : 0.97
    }, {
        "Variable": "Precision",
        "SVM" : 1.00,
        "NSVM" : 0.93
    }, {
        "Variable": "Recall",
        "SVM" : 0.89,
        "NSVM" : 0.93
    }, {
        "Variable": "F-Measure",
        "SVM" : 0.94,
        "NSVM" : 0.93
    }, {
        "Variable": "Kappa",
        "SVM" : 0.8585,
        "NSVM" : 0.91
    }
];

var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
categoryAxis.dataFields.category = "Variable";
categoryAxis.fontWeight = "bold";
categoryAxis.fontSize = 20;

var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
valueAxis.renderer.gridType = "polygons";
valueAxis.fontWeight = 50;
valueAxis.fontSize = 20;
valueAxis.renderer.strokeWidth = 1.5;
valueAxis.min = 0.7;
valueAxis.max = 1;

var series1 = chart.series.push(new am4charts.RadarSeries());
series1.dataFields.valueY = "SVM";
series1.dataFields.categoryX = "Variable";
series1.strokeWidth = 3;
series1.name = "SVM";
series1.stroke = am4core.color("black");
series1.fillOpacity = 0.2;
series1.fill = am4core.color("black");

var series2 = chart.series.push(new am4charts.RadarSeries());
series2.dataFields.valueY = "NSVM";
series2.dataFields.categoryX = "Variable";
series2.strokeWidth = 3;
series2.name = "NSVM";
series2.stroke = am4core.color("red");
series2.fillOpacity = 0.2;
series2.fill = am4core.color("red");

var range = valueAxis.axisRanges.create();
range.value = 0.8;
range.grid.stroke = am4core.color("blue");
range.grid.strokeWidth = 2;
range.grid.strokeOpacity = 0.5;

chart.legend = new am4charts.Legend();
chart.legend.fontSize = 20;
chart.legend.fontWeight = "bold";

var title = chart.titles.create();
title.text = "African Taxa";
title.fontSize = 40;
title.marginBottom = 30;
title.fontWeight = "bold";

chart.exporting.menu = new am4core.ExportMenu();

// chart.cursor = new am4charts.RadarCursor();