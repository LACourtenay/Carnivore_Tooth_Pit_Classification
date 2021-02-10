am4core.useTheme(am4themes_animated);
var chart = am4core.create("overall_plot", am4charts.RadarChart);

chart.data = [
    {
        "Variable": "Accuracy",
        "European" : 0.8883,
        "African" : 0.9347,
        "Felidae" : 0.9698,
        "Canidae" : 0.9804,
        "Family" : 0.9656,
    },{
        "Variable": "AUC",
        "European" : 0.94,
        "African" : 0.97,
        "Felidae" : 0.98,
        "Canidae" : 0.99,
        "Family" : 0.98,
    }, {
        "Variable": "F-Measure",
        "European" : 0.90,
        "African" : 0.94,
        "Felidae" : 0.97,
        "Canidae" : 0.98,
        "Family" : 0.97,
    }, {
        "Variable": "Kappa",
        "European" : 0.85,
        "African" : 0.91,
        "Felidae" : 0.96,
        "Canidae" : 0.97,
        "Family" : 0.96,
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
valueAxis.min = 0.825;
valueAxis.max = 1;
valueAxis.strictMinMax = true; 

const colour_1 = "#e41a1c";
const colour_2 = "#377eb8";
const colour_3 = "#4daf4a";
const colour_4 = "#984ea3";
const colour_5 = "#ff7f00";
var opacity = 0.1;

var series4 = chart.series.push(new am4charts.RadarSeries());
series4.dataFields.valueY = "Canidae";
series4.dataFields.categoryX = "Variable";
series4.strokeWidth = 3;
series4.name = "Canidae";
series4.stroke = am4core.color(colour_4);
series4.fillOpacity = opacity;
series4.fill = am4core.color(colour_4);

var series3 = chart.series.push(new am4charts.RadarSeries());
series3.dataFields.valueY = "Felidae";
series3.dataFields.categoryX = "Variable";
series3.strokeWidth = 3;
series3.name = "Felidae";
series3.stroke = am4core.color(colour_3);
series3.fillOpacity = opacity;
series3.fill = am4core.color(colour_3);

var series5 = chart.series.push(new am4charts.RadarSeries());
series5.dataFields.valueY = "Family";
series5.dataFields.categoryX = "Variable";
series5.strokeWidth = 3;
series5.name = "Family";
series5.stroke = am4core.color(colour_5);
series5.fillOpacity = opacity;
series5.fill = am4core.color(colour_5);

var series2 = chart.series.push(new am4charts.RadarSeries());
series2.dataFields.valueY = "African";
series2.dataFields.categoryX = "Variable";
series2.strokeWidth = 3;
series2.name = "African";
series2.stroke = am4core.color(colour_2);
series2.fillOpacity = opacity;
series2.fill = am4core.color(colour_2);

var series1 = chart.series.push(new am4charts.RadarSeries());
series1.dataFields.valueY = "European";
series1.dataFields.categoryX = "Variable";
series1.strokeWidth = 3;
series1.name = "European";
series1.stroke = am4core.color(colour_1);
series1.fillOpacity = opacity;
series1.fill = am4core.color(colour_1);

//var range = valueAxis.axisRanges.create();
//range.value = 0.8;
//range.grid.stroke = am4core.color("blue");
//range.grid.strokeWidth = 2;
//range.grid.strokeOpacity = 0.5;

chart.legend = new am4charts.Legend();
chart.legend.fontSize = 20;
chart.legend.fontWeight = "bold";

var title = chart.titles.create();
title.text = "Overall Comparisons";
title.fontSize = 40;
title.marginBottom = 30;
title.fontWeight = "bold";

chart.exporting.menu = new am4core.ExportMenu();

// chart.cursor = new am4charts.RadarCursor();