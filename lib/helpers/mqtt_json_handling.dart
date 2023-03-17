import 'dart:convert';
import 'dart:developer';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/lamp.dart';
import 'package:miriHome/models/temp_sensor.dart';
import 'package:miriHome/models/thermostat.dart';
import 'package:miriHome/models/window_sensor.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:miriHome/helpers/service_locator.dart';

import '../Providers/devices_provider.dart';

enum MQTTAppConnectionState {
  connected,
  disconnected,
  connecting,
  connectedSubscribed,
  connectedUnSubscribed
}

class MQTT_JSON_Handling {
  // match: LivingRoom_TempSensor_Temp
  // match: Kitchen_Lamp_Stern
  final regularExpression =
      RegExp(r"^(?:[^_\n]*_){2}[^_\n]*$", caseSensitive: false);

  List<String> devicesList = [];
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';

  void ConvertReceivedTextToRoomInfo(String text, String topic) {
    _receivedText = text;
    if (topic == "zigbee2mqtt/bridge/devices" && devicesList.length == 0) {
      try {
        Iterable l = json.decode(text);
        List<IDevices> devices =
            List<IDevices>.from(l.map((model) => IDevices.fromMQTTJson(model)));
        serviceLocator<RoomProviderService>().CreateDevices(devices);
      } on Exception catch (e) {
        log("Exception: $e", time: DateTime.now());
      }
    } //else if (regularExpression.hasMatch(topic.toLowerCase())) {
    else {
      try {
        Map<String, dynamic> map = jsonDecode(text); // import 'dart:convert';

        //String deviceName = map['device']['friendlyName'];
        String zigbeeFriendlyName = topic.replaceAll("zigbee2mqtt/", "");
        IDevices device = serviceLocator<RoomProviderService>()
            .GetDeviceFromZigbeeFriendlyName(zigbeeFriendlyName);

        switch (device.deviceType) {
          case DeviceType.TemperatureSensor:
            TempSensor zigbeeTempSensor = TempSensor.fromMQTTJson(map);
            TempSensor tempSensor = device as TempSensor;
            tempSensor.UpdateDevice(zigbeeTempSensor);
            serviceLocator<DevicesProvider>()
                .UpdateListCurrentDevices(tempSensor);
            break;
          case DeviceType.Lamp:
            Lamp zigbeeLamp = Lamp.fromMQTTJson(map);
            Lamp lamp = device as Lamp;
            lamp.UpdateDevice(zigbeeLamp);
            serviceLocator<DevicesProvider>().UpdateListCurrentDevices(lamp);
            break;
          case DeviceType.Thermostat:
            Thermostat zigbeeThermostat = Thermostat.fromJMQTTJson(map);
            Thermostat thermostat = device as Thermostat;
            thermostat.UpdateDevice(zigbeeThermostat);
            serviceLocator<DevicesProvider>()
                .UpdateListCurrentDevices(thermostat);
            break;
          case DeviceType.Sensor:
            WindowSensor zigbeeWindowSensor = WindowSensor.fromMQTTJson(map);
            WindowSensor windowSensor = device as WindowSensor;
            windowSensor.UpdateDevice(zigbeeWindowSensor);
            serviceLocator<DevicesProvider>()
                .UpdateListCurrentDevices(windowSensor);
            break;
          default:
            log("The device is not supported");
            break;
        }
      } on Exception catch (ex) {
        log("Error in MQTTAppState.dart for mapList - $ex",
            time: DateTime.now());
      }
      log(topic + " :: " + text, time: DateTime.now());
    }
    _historyText = _historyText + '\n' + _receivedText;
  }

  void clearText() {
    _historyText = "";
    _receivedText = "";
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
}
