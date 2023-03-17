import 'package:miriHome/models/device_state.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/thermostat_child_lock.dart';
import 'package:miriHome/models/thermostat_running_state.dart';
import 'package:miriHome/interfaces/idevices.dart';

class Thermostat implements IDevices {
  late num deviceTemperature;
  late num desiredTemperature;
  bool isBatteryLow = false;
  ThermostatChildLock childLock = ThermostatChildLock.unlock;
  ThermostatRunningState runningState = ThermostatRunningState.idle;
  @override
  late DeviceType deviceType = DeviceType.Thermostat;

  @override
  late String displayName;

  @override
  late String zigbeeFriendlyName;

  @override
  DeviceState state = DeviceState.undefined;

  @override
  late String description;

  @override
  late String ieeeAddress;

  @override
  bool isDeviceSupported = false;

  @override
  late String model;

  @override
  late String vendor;

  @override
  String image = "";

  @override
  late String roomIdentifier;

  Thermostat(IDevices device) {
    this.displayName = device.displayName;
    this.zigbeeFriendlyName = device.zigbeeFriendlyName;
    this.state = state;
    this.deviceType = deviceType;
    this.description = device.description;
    this.model = device.model;
    this.image = "https://www.zigbee2mqtt.io/images/devices/${model}.jpg";
    this.vendor = device.vendor;
    this.roomIdentifier = device.roomIdentifier;
    this.ieeeAddress = device.ieeeAddress;
    this.deviceTemperature = 16.0;
    this.desiredTemperature = 16.0;
    this.isDeviceSupported = isDeviceSupported;
    this.isBatteryLow = isBatteryLow;
    this.childLock = childLock;
    this.runningState = runningState;
  }

  @override
  Thermostat.fromJson(Map<String, dynamic> json)
      : deviceTemperature = json["local_temperature"] ?? 15,
        desiredTemperature = json["current_heating_setpoint"] ?? 15,
        state = json['system_mode'].toString() == "off"
            ? DeviceState.off
            : json['system_mode'].toString() == "heat"
                ? DeviceState.heat
                : DeviceState.auto,
        isBatteryLow = json["battery_low"] ?? false,
        displayName = json['displayName'] ?? "Thermostat",
        zigbeeFriendlyName = json['zigbeeFriendlyName'] ?? "ZigbeeThermostat",
        deviceType = DeviceType.values.byName(json['deviceType']),
        ieeeAddress = json['ieeeAddress'] ?? "ieeeAddress",
        vendor = json['vendor'] ?? "vendor",
        model = json['model'] ?? "model",
        description = json['description'] ?? "description",
        isDeviceSupported = json['isDeviceSupported'] ?? false,
        image = json['image'] ?? "",
        roomIdentifier = json['roomIdentifier'] ?? "";

  Thermostat.fromJMQTTJson(Map<String, dynamic> json)
      : deviceTemperature = json["local_temperature"] ?? 2,
        desiredTemperature = json["current_heating_setpoint"] ?? 2,
        state = json['system_mode'].toString() == "off"
            ? DeviceState.off
            : json['system_mode'].toString() == "heat"
                ? DeviceState.heat
                : DeviceState.auto,
        childLock = json["child_lock"].toString().toUpperCase() == "LOCK"
            ? ThermostatChildLock.lock
            : ThermostatChildLock.unlock,
        runningState = json["running_state"].toString() == "idle"
            ? ThermostatRunningState.idle
            : ThermostatRunningState.heat,
        isBatteryLow = json["battery_low"] ?? false;

  UpdateThermostatInfo(
      num deviceTemperature, num desiredTemperature, DeviceState state) {
    this.deviceTemperature = deviceTemperature;
    this.desiredTemperature = desiredTemperature;
    this.state = state;
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'zigbeeFriendlyName': zigbeeFriendlyName,
        'deviceType': deviceType,
        'ieeeAddress': ieeeAddress,
        'vendor': vendor,
        'model': model,
        'description': description,
        'isDeviceSupported': isDeviceSupported,
        'image': image,
        'roomIdentifier': roomIdentifier
      };

  @override
  void UpdateDevice(IDevices devices) {
    var thermostat = devices as Thermostat;
    this.deviceTemperature = thermostat.deviceTemperature;
    this.desiredTemperature = thermostat.desiredTemperature;
    this.state = thermostat.state;
    this.childLock = thermostat.childLock;
    this.runningState = thermostat.runningState;
  }
}
