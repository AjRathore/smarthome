import 'dart:io';

class TemperatureChartModel {
  double temperature;
  DateTime recordedAt;

  TemperatureChartModel({required this.temperature, required this.recordedAt});

  factory TemperatureChartModel.fromJson(Map<String, dynamic> json) {
    return TemperatureChartModel(
      temperature: json['Temperature'] is String
          ? double.parse(json['Temperature'])
          : json['Temperature'],
      recordedAt: json['RecordedAt'] is String
          ? HttpDate.parse(json['RecordedAt'].toString())
          : json['RecordedAt'],
    );
  }
}
