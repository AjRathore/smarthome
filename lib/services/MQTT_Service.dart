import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:miriHome/models/device_state.dart';
import 'package:miriHome/models/thermostat_child_lock.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/managers/MQTTManager.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:miriHome/services/room_provider_service.dart';

class MQTTService {
  void SendMQTTMessage_LampState(String zigbeeFriendlyName, DeviceState state) {
    if (!LocalStorageService.IsSumulationMode) {
      switch (state) {
        case DeviceState.on:
          serviceLocator<MQTTManager>()
              .publish("zigbee2mqtt/${zigbeeFriendlyName}/set/state", "ON");
          break;
        case DeviceState.off:
          serviceLocator<MQTTManager>()
              .publish("zigbee2mqtt/${zigbeeFriendlyName}/set/state", "OFF");
          break;
        default:
      }
    }
  }

  void SendMQTTMessage_ThermostatState(
      String zigbeeFriendlyName, DeviceState state) {
    if (!LocalStorageService.IsSumulationMode) {
      switch (state) {
        case DeviceState.heat:
          serviceLocator<MQTTManager>().publish(
              "zigbee2mqtt/${zigbeeFriendlyName}/set/system_mode", "heat");
          break;
        case DeviceState.auto:
          serviceLocator<MQTTManager>().publish(
              "zigbee2mqtt/${zigbeeFriendlyName}/set/system_mode", "auto");
          break;
        case DeviceState.off:
          serviceLocator<MQTTManager>().publish(
              "zigbee2mqtt/${zigbeeFriendlyName}/set/system_mode", "off");
          break;
        default:
      }
    }
  }

  void SendMQTTMessage_SetTemperature(String zigbeeFriendlyName, String value) {
    if (!LocalStorageService.IsSumulationMode) {
      log("sending value for Thermostat: ${value}");
      serviceLocator<MQTTManager>().publish(
          "zigbee2mqtt/${zigbeeFriendlyName}/set/current_heating_setpoint",
          value);
    }
  }

  void SendMQTTMessage_SetThermostatChildLock(
      String zigbeeFriendlyName, ThermostatChildLock childLock) {
    if (!LocalStorageService.IsSumulationMode) {
      switch (childLock) {
        case ThermostatChildLock.lock:
          serviceLocator<MQTTManager>().publish(
              "zigbee2mqtt/${zigbeeFriendlyName}/set/child_lock", "LOCK");
          break;
        case ThermostatChildLock.unlock:
          serviceLocator<MQTTManager>().publish(
              "zigbee2mqtt/${zigbeeFriendlyName}/set/child_lock", "UNLOCK");
          break;
        default:
      }
    }
  }

  Future Refresh() async {
    HapticFeedback.lightImpact();
    connectToMQTT(serviceLocator<MQTTManager>());
    // Navigator.of(context).pushReplacement(new MaterialPageRoute(
    //     builder: (BuildContext context) =>Navigation));
  }

  void connectToMQTT(MQTTManager manager) async {
    if (!LocalStorageService.IsSumulationMode) {
      await Future.any([manager.initializeMQTTClient()]);
    } else {
      serviceLocator<RoomProviderService>().InitSimulationDevices();
    }
  }

  void disconnectMQTTClient() {
    this._disconnectMQTTClient(serviceLocator<MQTTManager>());
  }

  void _disconnectMQTTClient(MQTTManager manager) {
    if (!LocalStorageService.IsSumulationMode) {
      manager.disconnect();
    }
  }
}
