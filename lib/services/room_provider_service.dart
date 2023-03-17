import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/services/MQTT_Service.dart';
import 'package:miriHome/services/local_storage_service.dart';

import '../models/lamp.dart';
import '../models/room.dart';
import '../models/temp_sensor.dart';
import '../models/thermostat.dart';
import '../models/window_sensor.dart';
import '../interfaces/idevices.dart';

class RoomProviderService {
  int get activeDevices {
    return serviceLocator<RoomProvider>().ActiveDevices;
  }

  List<Room> get rooms {
    return serviceLocator<RoomProvider>().rooms;
  }

  List<IDevices> get devicesRunTimeList {
    return serviceLocator<RoomProvider>().DevicesRunTimeList;
  }

  void CreateRooms() async {
    await serviceLocator<RoomProvider>().CreateRooms();
    if (LocalStorageService.IsSumulationMode) {
      await this.InitSimulationDevices();
    }
  }

  void CreateDevices(List<IDevices> devices) {
    serviceLocator<RoomProvider>().CreateDevices(devices);
  }

  UpdateTemperatureSensor(TempSensor tempSensor) {
    serviceLocator<RoomProvider>().UpdateTemperatureSensor(tempSensor);
  }

  UpdateLamp(Lamp lamp) {
    serviceLocator<RoomProvider>().UpdateLamp(lamp);
  }

  void UpdateThermostat(Thermostat thermostat) {
    serviceLocator<RoomProvider>().UpdateThermostat(thermostat);
  }

  void UpdateThermostatState_SaveChanges(Thermostat thermostat) {
    serviceLocator<RoomProvider>().UpdateThermostat(thermostat);
    serviceLocator<MQTTService>().SendMQTTMessage_ThermostatState(
        thermostat.zigbeeFriendlyName, thermostat.state);
  }

  void UpdateThermostatTemperature_SaveChanges(
      Thermostat thermostat, String temperatureValue) {
    serviceLocator<RoomProvider>().UpdateThermostat(thermostat);
    serviceLocator<MQTTService>().SendMQTTMessage_SetTemperature(
        thermostat.zigbeeFriendlyName, temperatureValue);
  }

  void UpdateThermostatChildLock_SaveChanges(Thermostat thermostat) {
    serviceLocator<RoomProvider>().UpdateThermostat(thermostat);
    serviceLocator<MQTTService>().SendMQTTMessage_SetThermostatChildLock(
        thermostat.zigbeeFriendlyName, thermostat.childLock);
  }

  UpdateWindowSensor(WindowSensor windowSensor) {
    serviceLocator<RoomProvider>().UpdateWindowSensor(windowSensor);
  }

  void UpdateLamp_SaveChanges(Lamp lamp) {
    serviceLocator<RoomProvider>().UpdateLamp(lamp);
    serviceLocator<MQTTService>()
        .SendMQTTMessage_LampState(lamp.zigbeeFriendlyName, lamp.state);
  }

  void ModifyRoomDetails(
      String currentRoomName, String newRoomName, String image) {
    serviceLocator<RoomProvider>()
        .ModifyRoomDetails(currentRoomName, newRoomName, image);
    this.ConvertAndSaveRoomsToJson();
  }

  void ModifyDevice(IDevices device, String previousRoomIdentifier) {
    serviceLocator<RoomProvider>().ModifyDevice(device, previousRoomIdentifier);
    this.ConvertAndSaveRoomsToJson();
  }

  void AddDeviceToRoom(IDevices device, String roomIdentifier) {
    serviceLocator<RoomProvider>().AddDeviceToRoom(device, roomIdentifier);
    this.ConvertAndSaveRoomsToJson();
  }

  void RemoveDeviceFromRoom(IDevices device) {
    serviceLocator<RoomProvider>().RemoveDeviceFromRoom(device);
    this.ConvertAndSaveRoomsToJson();
  }

  void DeleteRoom(String roomIdentifier) {
    serviceLocator<RoomProvider>().DeleteRoom(roomIdentifier);
    this.ConvertAndSaveRoomsToJson();
  }

  void AddRoom(Room room) {
    serviceLocator<RoomProvider>().AddRoom(room);
    this.ConvertAndSaveRoomsToJson();
  }

  String GetRoomDisplayNameFromRoomIdentifier(String roomIdentifier) {
    String roomDisplayName = "None";
    if (rooms.isNotEmpty && roomIdentifier != "") {
      roomDisplayName = rooms
          .firstWhere((element) => element.roomIdentifier == roomIdentifier)
          .roomDisplayName;
    }
    return roomDisplayName;
  }

  void ConvertAndSaveRoomsToJson() {
    serviceLocator<RoomProvider>().ConvertAndSaveRoomsToJson();
  }

  void ReadRoomsJson() {
    serviceLocator<RoomProvider>().ReadRoomsJson();
  }

  IDevices GetDeviceFromZigbeeFriendlyName(String zigbeeFriendlyName) {
    return serviceLocator<RoomProvider>()
        .GetDeviceFromZigbeeFriendlyName(zigbeeFriendlyName);
  }

  void UpdateRunTimeDeviceList(IDevices device) {
    serviceLocator<RoomProvider>().UpdateRunTimeDeviceList(device);
  }

  Future InitSimulationDevices() async {
    var input = await rootBundle.loadString('assets/Files/devices.json');
    ////var input = await File("$appPath//devices.json").readAsString();
    try {
      Iterable l = json.decode(input);
      List<IDevices> devices =
          List<IDevices>.from(l.map((model) => IDevices.fromMQTTJson(model)));
      this.CreateSimulationDevices(devices);
    } on Exception catch (e) {
      log("Exception: $e", time: DateTime.now());
    }
  }

  void CreateSimulationDevices(List<IDevices> devices) {
    serviceLocator<RoomProvider>().CreateSimulationDevices(devices);
  }
}
