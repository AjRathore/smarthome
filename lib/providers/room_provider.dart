import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miriHome/models/lamp.dart';
import 'package:miriHome/models/thermostat.dart';
import 'package:miriHome/Providers/devices_provider.dart';
import 'package:miriHome/helpers/devices_helper.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:miriHome/services/room_data_storage.dart';
import '../models/window_sensor.dart';
import '../models/temp_sensor.dart';
import '../models/room.dart';
import '../services/local_storage_service.dart';

class RoomProvider with ChangeNotifier {
  late int activeDevices = 0;
  late Room livingRoom;
  late Room bedRoom;
  late Room bathRoom;
  late Room kitchen;
  late Room workRoom;

  List<Room> _rooms = [];
  List<IDevices> _devices = [];
  List<IDevices> _devicesRunTimeList = [];
  List<TempSensor> _tempSensorsList = DevicesHelper.getTemperatureSensorList;
  List<WindowSensor> _windowSensorsList = DevicesHelper.getWindowSensorList;

  List<Room> get rooms {
    //return _rooms;
    return _rooms;
  }

  List<IDevices> get Devices {
    return _devices;
  }

  List<IDevices> get DevicesRunTimeList {
    return _devicesRunTimeList;
  }

  int get ActiveDevices {
    return activeDevices;
  }

  List<TempSensor> get getTempSensorsList {
    return DevicesHelper.getTemperatureSensorList;
  }

  List<WindowSensor> get getWindowSensorsList {
    return DevicesHelper.getWindowSensorList;
  }

  int get roomCount {
    return _rooms.length;
  }

  Future CreateRooms() async {
    // _rooms.clear();
    // ConvertAndSaveRoomsToJson();
    _rooms.clear();
    activeDevices = 0;
    try {
      await ReadRoomsJson().then((value) => value.forEach((element) {
            _rooms.add(element);
          }));
    } on Exception catch (e) {
      log(e.toString());
    }

    if (!_rooms.any((element) => element.roomDisplayName == "None")) {
      this.CreateAndSaveDummyRoom();
    }
  }

  void CreateAndSaveDummyRoom() {
    Room dummyRoom = new Room("None", "", "", []);
    _rooms.insert(0, dummyRoom);
    ConvertAndSaveRoomsToJson();
    LocalStorageService.SetIsDummyRoomSaved = true;
  }

  void CreateDevices(List<IDevices> devices) {
    _devices.clear();
    _devicesRunTimeList.clear();
    devices.forEach(
      (device) {
        if (device.isDeviceSupported) {
          String roomIdentifier = GetRoomIdentifierForDevice(device);
          String displayName = GetDisplayNameForDevice(device);
          device.roomIdentifier = roomIdentifier;
          device.displayName = displayName;
          if (device.description.toLowerCase().contains('temperature')) {
            TempSensor temperatureSensor = new TempSensor(device);
            _devices.add(temperatureSensor);
          } else if (device.description.toLowerCase().contains('switch') ||
              device.description.toLowerCase().contains('plug') ||
              device.description.toLowerCase().contains('light') ||
              device.description.toLowerCase().contains('lamp')) {
            Lamp lamp = new Lamp(device);
            _devices.add(lamp);
          } else if (device.description.toLowerCase().contains('sensor')) {
            WindowSensor windowSensor = new WindowSensor(device);
            _devices.add(windowSensor);
          } else if (device.description.toLowerCase().contains('thermostat') ||
              device.description.toLowerCase().contains('radiator')) {
            Thermostat thermostat = new Thermostat(device);
            _devices.add(thermostat);
          }
        }
      },
    );
    _devicesRunTimeList = [..._devices];

    RemoveDevicesFromRoomIfNotConnected();
    notifyListeners();
  }

  /// Remove devices from saved rooms if they are not connected
  void RemoveDevicesFromRoomIfNotConnected() {
    for (var room in _rooms) {
      for (var device in room.devices) {
        if (!_devices
            .any((element) => element.ieeeAddress == device.ieeeAddress)) {
          room.devices.remove(device);
          this.ConvertAndSaveRoomsToJson();
          break;
        }
      }
    }
  }

  void CreateSimulationDevices(List<IDevices> devices) {
    _devices.clear();
    _devicesRunTimeList.clear();
    devices.forEach(
      (device) {
        if (device.isDeviceSupported) {
          String roomIdentifier = GetRoomIdentifierForDevice(device);
          String displayName = GetDisplayNameForDevice(device);
          device.roomIdentifier = roomIdentifier;
          device.displayName = displayName;
          if (device.description.toLowerCase().contains('temperature')) {
            TempSensor temperatureSensor = new TempSensor(device);
            _devices.add(temperatureSensor);
          } else if (device.description.toLowerCase().contains('switch') ||
              device.description.toLowerCase().contains('plug') ||
              device.description.toLowerCase().contains('light') ||
              device.description.toLowerCase().contains('lamp')) {
            Lamp lamp = new Lamp(device);
            _devices.add(lamp);
          } else if (device.description.toLowerCase().contains('sensor')) {
            WindowSensor windowSensor = new WindowSensor(device);
            _devices.add(windowSensor);
          } else if (device.description.toLowerCase().contains('thermostat') ||
              device.description.toLowerCase().contains('radiator')) {
            Thermostat thermostat = new Thermostat(device);
            _devices.add(thermostat);
          }
        }
      },
    );
    _devicesRunTimeList = [..._devices];
    notifyListeners();
  }

  String GetRoomIdentifierForDevice(IDevices device) {
    String roomIdentifier = "";
    if (_rooms.isNotEmpty) {
      rooms.forEach((element) {
        element.devices.forEach((roomdevice) {
          if (roomdevice.ieeeAddress == device.ieeeAddress) {
            roomIdentifier = element.roomIdentifier;
          }
        });
      });
    }
    return roomIdentifier;
  }

  String GetDisplayNameForDevice(IDevices device) {
    String displayName = "";
    if (_rooms.isNotEmpty) {
      rooms.forEach((element) {
        element.devices.forEach((roomdevice) {
          if (roomdevice.ieeeAddress == device.ieeeAddress) {
            displayName = roomdevice.displayName;
          }
        });
      });
    }
    return displayName;
  }

  UpdateTemperatureSensor(TempSensor tempSensor) {
    IDevices? foundTempSensor = null;
    _devicesRunTimeList.forEach((element) {
      if (element.ieeeAddress == tempSensor.ieeeAddress) {
        foundTempSensor = element;
      }
    });

    if (foundTempSensor != null) {
      foundTempSensor = foundTempSensor as TempSensor;
      foundTempSensor?.UpdateDevice(tempSensor);
      // foundTempSensor?.UpdateTempSensor(tempSensor.temperatureValue,
      //     tempSensor.humidityValue, tempSensor.battery);
      serviceLocator<DevicesProvider>().UpdateListCurrentDevices(tempSensor);
      notifyListeners();
    }
  }

  UpdateLamp(Lamp lamp) {
    IDevices? foundLamp = null;
    _devicesRunTimeList.forEach((element) {
      if (element.ieeeAddress == lamp.ieeeAddress) {
        foundLamp = element;
      }
    });

    if (foundLamp != null) {
      foundLamp?.UpdateDevice(lamp);
      serviceLocator<DevicesProvider>().UpdateListCurrentDevices(lamp);
      notifyListeners();
    }
  }

  void UpdateThermostat(Thermostat thermostat) {
    IDevices? foundThermostat = null;
    _devicesRunTimeList.forEach((element) {
      if (element.ieeeAddress == thermostat.ieeeAddress) {
        foundThermostat = element;
      }
    });
    if (foundThermostat != null) {
      foundThermostat?.UpdateDevice(thermostat);
      serviceLocator<DevicesProvider>().UpdateListCurrentDevices(thermostat);
      notifyListeners();
    }
  }

  UpdateWindowSensor(WindowSensor windowSensor) {
    IDevices? foundSensor = null;
    _devicesRunTimeList.forEach((element) {
      if (element.ieeeAddress == windowSensor.ieeeAddress) {
        foundSensor = element;
      }
    });
    if (foundSensor != null) {
      foundSensor?.UpdateDevice(windowSensor);
      serviceLocator<DevicesProvider>().UpdateListCurrentDevices(windowSensor);
      notifyListeners();
    }
  }

  void AddRoomDevice(String roomIdentifier, IDevices device) {
    switch (roomIdentifier) {
      case "LivingRoom":
        livingRoom.devices.add((device));
        log('Added device: ${device.displayName} in the Living Room',
            time: DateTime.now());
        break;
      case "Bedroom":
        bedRoom.devices.add((device));
        log('Added device: ${device.displayName} in the Bedoom',
            time: DateTime.now());
        break;
      case "Bathroom":
        bathRoom.devices.add((device));
        log('Added device: ${device.displayName} in the Bathoom',
            time: DateTime.now());
        break;
      case "Kitchen":
        kitchen.devices.add((device));
        log('Added device: ${device.displayName} in the Kitchen',
            time: DateTime.now());
        break;
      case "WorkRoom":
        workRoom.devices.add((device));
        log('Added device: ${device.displayName} in the Workroom',
            time: DateTime.now());
        break;
      default:
        log("No room found for devices");
    }
    UpdateActiveDevices();
  }

  void UpdateActiveDevices() {
    activeDevices += 1;
    notifyListeners();
  }

  void ModifyRoomDetails(
      String currentRoomName, String newRoomName, String image) {
    var foundRoom = rooms
        .firstWhere((element) => element.roomDisplayName == currentRoomName);
    foundRoom.roomDisplayName = newRoomName;
    foundRoom.image = image;
    notifyListeners();
  }

  void DeleteRoom(String roomIdentifier) {
    for (var device in _devices) {
      if (device.roomIdentifier == roomIdentifier) {
        device.roomIdentifier = "";
      }
    }
    rooms.removeWhere((element) => element.roomIdentifier == roomIdentifier);
    notifyListeners();
  }

  void AddRoom(Room room) {
    rooms.add(room);
    notifyListeners();
  }

  void ModifyDevice(IDevices device, String previousRoomIdentifier) {
    _rooms.forEach((room) {
      room.devices.forEach((roomdevice) {
        if (roomdevice.ieeeAddress == device.ieeeAddress) {
          roomdevice.displayName = device.displayName;
          roomdevice.zigbeeFriendlyName = device.zigbeeFriendlyName;
        }
      });
    });
    var founddevice = _devices
        .firstWhere((element) => element.ieeeAddress == device.ieeeAddress);
    founddevice.displayName = device.displayName;
    founddevice.zigbeeFriendlyName = device.zigbeeFriendlyName;

    // if the room identifier of this device has been changed
    // then we add it to that room
    if (founddevice.roomIdentifier != previousRoomIdentifier) {
      AddDeviceToRoom(device, device.roomIdentifier);
    }

    notifyListeners();
  }

  void RemoveDeviceFromRoom(IDevices device) {
    var room = _rooms
        .firstWhere((room) => room.roomIdentifier == device.roomIdentifier);

    // remove device from rooms list
    room.devices.remove(room.devices
        .firstWhere((element) => element.ieeeAddress == device.ieeeAddress));

    // change room identifier from runtime devices list so that it is not shown
    var foundDevice = _devicesRunTimeList
        .firstWhere((d) => d.ieeeAddress == device.ieeeAddress);
    foundDevice.roomIdentifier = "";

    notifyListeners();
  }

  void AddDeviceToRoom(IDevices device, String roomIdentifier) {
    // first delete the device from the previous room
    for (var room in _rooms) {
      for (var roomdevice in room.devices) {
        if (roomdevice.ieeeAddress == device.ieeeAddress) {
          room.devices.remove(roomdevice);
          break;
        }
      }
    }

    var room =
        _rooms.firstWhere((room) => room.roomIdentifier == roomIdentifier);
    room.devices.add(device);
    var foundDevice = _devices
        .firstWhere((element) => element.ieeeAddress == device.ieeeAddress);
    foundDevice.roomIdentifier = roomIdentifier;
    notifyListeners();
  }

  void ConvertAndSaveRoomsToJson() async {
    var json = jsonEncode(_rooms.map((e) => e.toJson()).toList());
    await serviceLocator<RoomDataStorageService>().writeRoomData(json);
  }

  Future<List<Room>> ReadRoomsJson() async {
    var response = "";
    List<Room> rooms = [];
    try {
      response = await serviceLocator<RoomDataStorageService>().readRoomData();
      rooms = ConvertResponseToRooms(response);
    } on Exception catch (e) {
      log(e.toString());
    }

    return rooms;
  }

  List<Room> ConvertResponseToRooms(String response) {
    Iterable l = json.decode(response);
    List<Room> rooms = List<Room>.from(l.map((model) => Room.fromJson(model)));
    return rooms;
  }

  void FindAndUpdateDeviceProperties(String zigbeeFriendlyName) {
    try {
      IDevices? deviceToUpdate = null;
      for (var room in _rooms) {
        for (var device in room.devices) {
          if (device.zigbeeFriendlyName == zigbeeFriendlyName) {
            deviceToUpdate = device;
            break;
          }
        }
      }

      if (deviceToUpdate != null) {}
    } catch (e) {
      log(e.toString());
    }
  }

  IDevices GetDeviceFromZigbeeFriendlyName(String zigbeeFriendlyName) {
    IDevices? foundDevice;
    try {
      foundDevice = _devicesRunTimeList.firstWhere(
          (element) => element.zigbeeFriendlyName == zigbeeFriendlyName);
    } catch (e) {
      log(e.toString());
      return foundDevice!;
    }
    return foundDevice;
  }

  void UpdateRunTimeDeviceList(IDevices device) {
    var foundDevice = _devicesRunTimeList
        .firstWhere((element) => element.ieeeAddress == device.ieeeAddress);
    foundDevice = device;
    serviceLocator<DevicesProvider>().UpdateListCurrentDevices(foundDevice);
    notifyListeners();
  }
}
