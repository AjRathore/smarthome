import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/helpers/service_locator.dart';

import '../interfaces/idevices.dart';
import '../services/room_provider_service.dart';

class SimulationModeDevices {
  List<IDevices> _devices = [];

  List<IDevices> get SimulatedDevices {
    return _devices;
  }

  Future InitSimulationDevices() async {
    var appPath = AppConfig.appPath;
    var input = await File("$appPath/Files/devices.json").readAsString();
    try {
      Iterable l = json.decode(input);
      List<IDevices> devices =
          List<IDevices>.from(l.map((model) => IDevices.fromMQTTJson(model)));
      serviceLocator<RoomProviderService>().CreateSimulationDevices(devices);
    } on Exception catch (e) {
      log("Exception: $e", time: DateTime.now());
    }
  }
}
