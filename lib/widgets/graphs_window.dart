/* import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Widgets/humidity_chart.dart';
import '../Widgets/temperature_chart.dart';
import '../Models/temperature_chart_model.dart';
import '../Models/humidity_chart_model.dart';
import '../helpers/http_request_manager.dart';

class GraphsWindow extends StatefulWidget {
  final String sensorName;

  GraphsWindow(this.sensorName);

  @override
  _GraphsWindowState createState() => _GraphsWindowState();
}

class _GraphsWindowState extends State<GraphsWindow> {
  Future<List<TemperatureChartModel>> futureTemperatureChart;
  Future<List<HumidityChartModel>> futureHumidityChart;
  List<TemperatureChartModel> listTemperatureCharts;
  List<HumidityChartModel> listHumidityCharts;

  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text(
      'Temperature',
      style: TextStyle(fontWeight: FontWeight.w600),
    ),
    1: Text(
      'Humidity',
      style: TextStyle(fontWeight: FontWeight.w600),
    ),
  };

  int sharedValue = 0;

  @override
  void initState() {
    super.initState();
    getFutureList();
  }

  void getFutureList() async {
    futureTemperatureChart =
        HTTPRequestManager.fetchTemperatureData(widget.sensorName);
    listTemperatureCharts = await futureTemperatureChart;

    futureHumidityChart =
        HTTPRequestManager.fetchHumidityData(widget.sensorName);
    listHumidityCharts = await futureHumidityChart;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          CupertinoSlidingSegmentedControl<int>(
            children: logoWidgets,
            //padding: const EdgeInsets.symmetric(horizontal: 15.0),
            onValueChanged: (int val) {
              setState(() {
                sharedValue = val;
              });
            },
            groupValue: sharedValue,
          ),
          Expanded(
              child: sharedValue == 0
                  ? FutureBuilder<List<TemperatureChartModel>>(
                      future: futureTemperatureChart,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return TemperatureChart(listTemperatureCharts);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return Center(child: CircularProgressIndicator());
                      },
                    )
                  : FutureBuilder<List<HumidityChartModel>>(
                      future: futureHumidityChart,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return HumidityChart(listHumidityCharts);
                          ;
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return Center(child: CircularProgressIndicator());
                      },
                    )),
        ],
      ),
    );
  }
}
 */