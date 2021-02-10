am4core.useTheme(am4themes_animated);

var chart = am4core.create("loss_plot", am4charts.XYChart);

chart.data = [
    {
        "Group": "European Taxa",
        "SVM Loss" : 0.16,
        "NSVM Loss" : 0.26
    },{
        "Group": "African Taxa",
        "SVM Loss" : 0.09,
        "NSVM Loss" : 0.10
    }, {
        "Group": "Canidae",
        "SVM Loss" : 0.05,
        "NSVM Loss" : 0.06
    }, {
        "Group": "Felidae",
        "SVM Loss" : 0.05,
        "NSVM Loss" : 0.01
    }, {
        "Group": "Family",
        "SVM Loss" : 0.04,
        "NSVM Loss" : 0.01
    }
];

var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
categoryAxis.dataFields.category = "Group";
categoryAxis.title.text = "Group";
categoryAxis.title.fontSize = 0;
categoryAxis.title.fontWeight = "bold";
categoryAxis.fontSize = 20;
categoryAxis.fontWeight = "bold";

var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
valueAxis.title.text = "Loss";
valueAxis.title.fontSize = 30;
valueAxis.title.fontWeight = "bold";
valueAxis.fontSize = 20;
valueAxis.fontWeight = 50;

var svm_series = chart.series.push(new am4charts.LineSeries());
svm_series.name = "SVM Loss";
svm_series.dataFields.valueY = "SVM Loss";
svm_series.dataFields.categoryX = "Group";
svm_series.stroke = am4core.color("black");
svm_series.strokeWidth = 3;

var nsvm_series = chart.series.push(new am4charts.LineSeries());
nsvm_series.name = "NSVM Loss";
nsvm_series.dataFields.valueY = "NSVM Loss";
nsvm_series.dataFields.categoryX = "Group";
nsvm_series.stroke = am4core.color("red");
nsvm_series.strokeWidth = 3;

chart.legend = new am4charts.Legend();
chart.legend.fontSize = 20;
chart.legend.fontWeight = "bold";

chart.exporting.menu = new am4core.ExportMenu();