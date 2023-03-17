/* import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:intl/intl.dart';

import '../Models/humidity_chart_model.dart';

class HumidityChart extends StatelessWidget {
  final List<HumidityChartModel> humidityData;
  // // Defining the data
  // final temperatureData = [
  //   new HumidityChartModel(
  //     humidity: 52.25,
  //     recordedAt: DateTime(2021, 01, 12, 14, 30),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 52.34,
  //     recordedAt: DateTime(2021, 01, 12, 14, 45),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 52.44,
  //     recordedAt: DateTime(2021, 01, 12, 15, 00),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 53.00,
  //     recordedAt: DateTime(2021, 01, 12, 15, 15),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 52.84,
  //     recordedAt: DateTime(2021, 01, 12, 16, 00),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 44.14,
  //     recordedAt: DateTime(2021, 01, 12, 16, 15),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 43.00,
  //     recordedAt: DateTime(2021, 01, 12, 16, 20),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 40.10,
  //     recordedAt: DateTime(2021, 01, 12, 16, 30),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 44.10,
  //     recordedAt: DateTime(2021, 01, 12, 16, 45),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 45.05,
  //     recordedAt: DateTime(2021, 01, 12, 17, 00),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 46.80,
  //     recordedAt: DateTime(2021, 01, 12, 17, 15),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 48.28,
  //     recordedAt: DateTime(2021, 01, 12, 17, 30),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 49.34,
  //     recordedAt: DateTime(2021, 01, 12, 18, 15),
  //   ),
  //   new HumidityChartModel(
  //     humidity: 51.5,
  //     recordedAt: DateTime(2021, 01, 12, 18, 30),
  //   ),
  // ];

  HumidityChart(this.humidityData);
  _getSeriesData() {
    List<charts.Series<HumidityChartModel, DateTime>> series = [
      charts.Series(
        id: "Humidity",
        data: humidityData,
        domainFn: (HumidityChartModel series, _) => series.recordedAt,
        measureFn: (HumidityChartModel series, _) => series.humidity,
        colorFn: (HumidityChartModel series, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue[700]),
      ),
    ];
    return series;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        //height: 550,
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                // Text(
                //   "Sales of a company over the years",
                // ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: new charts.TimeSeriesChart(
                    _getSeriesData(),
                    animate: true,
                    defaultRenderer: new charts.LineRendererConfig(),
                    behaviors: [
                      LinePointHighlighter(
                          symbolRenderer:
                              CustomCircleSymbolRenderer() // add this line in behaviours
                          ),
                      new charts.ChartTitle("Time",
                          titleStyleSpec: charts.TextStyleSpec(fontSize: 16),
                          behaviorPosition: charts.BehaviorPosition.bottom,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                      new charts.ChartTitle("Humidity in %",
                          titleStyleSpec: charts.TextStyleSpec(fontSize: 16),
                          behaviorPosition: charts.BehaviorPosition.start,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                    ],
                    selectionModels: [
                      SelectionModelConfig(
                        changedListener: (SelectionModel model) {
                          if (model.hasDatumSelection) {
                            // print(model.selectedSeries[0]
                            //     .measureFn(model.selectedDatum[0].index));
                            CustomCircleSymbolRenderer.humidityValue = model
                                .selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index)
                                .toString();

                            CustomCircleSymbolRenderer.timeValue = model
                                .selectedSeries[0]
                                .domainFn(model.selectedDatum[0].index);
                          }
                        },
                      )
                    ],

                    // Optionally pass in a [DateTimeFactory] used by the chart. The factory
                    // should create the same type of [DateTime] as the data provided. If none
                    // specified, the default creates local date time.
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    domainAxis: new charts.DateTimeAxisSpec(
                      tickFormatterSpec:
                          new charts.AutoDateTimeTickFormatterSpec(
                        hour: new charts.TimeFormatterSpec(
                            format: "HH", transitionFormat: "HH"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  static String humidityValue;
  static DateTime timeValue;
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      Color fillColor,
      FillPatternType fillPattern,
      Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 12;
    canvas.drawText(
        TextElement.TextElement(
            humidityValue + " %" "\n" + DateFormat.Hm().format(timeValue),
            style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round());
  }
}
 */