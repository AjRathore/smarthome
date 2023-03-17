/* import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/temperature_chart_model.dart';
import '../Models/humidity_chart_model.dart';

class HTTPRequestManager {
  static Future<List<TemperatureChartModel>> fetchTemperatureData(
      String sensorName) async {
    final String postsURL =
        "http://192.168.8.122:5000/getTemperatureData/$sensorName";
    final response = await http.get(Uri.parse(postsURL));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> body = jsonDecode(response.body);

      List<TemperatureChartModel> temperatureData = body
          .map(
            (dynamic item) => TemperatureChartModel.fromJson(item),
          )
          .toList();
      return temperatureData;
    } else {
      print("THROWING EXCEPTION");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  static Future<List<HumidityChartModel>> fetchHumidityData(
      String sensorName) async {
    final String postsURL =
        "http://192.168.8.122:5000/getHumidityData/$sensorName";
    final response = await http.get(Uri.parse(postsURL));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> body = jsonDecode(response.body);

      List<HumidityChartModel> humidityData = body
          .map(
            (dynamic item) => HumidityChartModel.fromJson(item),
          )
          .toList();
      return humidityData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
 */