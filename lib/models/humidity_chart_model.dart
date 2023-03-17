import 'dart:io';

class HumidityChartModel {
  double humidity;
  DateTime recordedAt;

  HumidityChartModel({required this.humidity, required this.recordedAt});

  factory HumidityChartModel.fromJson(Map<String, dynamic> json) {
    return HumidityChartModel(
      humidity: json['Humidity'] is String
          ? double.parse(json['Humidity'])
          : json['Humidity'],
      recordedAt: json['RecordedAt'] is String
          ? HttpDate.parse(json['RecordedAt'].toString())
          : json['RecordedAt'],
    );
  }
}
