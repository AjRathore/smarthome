enum DeviceType {
  Undefined,
  TemperatureSensor,
  Lamp,
  Thermostat,
  Sensor;

  String toJson() => name;
  static DeviceType fromJson(String json) => values.byName(json);
}
