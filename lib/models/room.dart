import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/lamp.dart';
import 'package:miriHome/models/temp_sensor.dart';
import 'package:miriHome/models/thermostat.dart';
import 'package:miriHome/models/window_sensor.dart';
import 'package:miriHome/interfaces/idevices.dart';

class Room {
  late String roomDisplayName;
  late String roomIdentifier;
  late String image;
  List<IDevices> devices = [];

  Room(this.roomDisplayName, this.roomIdentifier, this.image, this.devices);

  Room.fromJson(Map<String, dynamic> json) {
    roomDisplayName = json['roomDisplayName'];
    roomIdentifier = json['roomIdentifier'];
    image = json['image'];
    if (json['devices'] != null) {
      devices = <IDevices>[];
      json['devices'].forEach((v) {
        var type = v['deviceType'];
        DeviceType t = DeviceType.values.byName(type);
        switch (t) {
          case DeviceType.TemperatureSensor:
            devices.add(new TempSensor.fromJson(v));
            break;
          case DeviceType.Lamp:
            devices.add(new Lamp.fromJson(v));
            break;
          case DeviceType.Thermostat:
            devices.add(new Thermostat.fromJson(v));
            break;
          case DeviceType.Sensor:
            devices.add(new WindowSensor.fromJson(v));
            break;
          default:
            throw new Exception("The device type is not implemented");
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomDisplayName'] = this.roomDisplayName;
    data['roomIdentifier'] = this.roomIdentifier;
    data['image'] = this.image;
    data['devices'] = this.devices.map((v) => v.toJson()).toList();
    return data;
  }
}
