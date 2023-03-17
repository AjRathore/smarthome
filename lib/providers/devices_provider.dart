import 'package:flutter/cupertino.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:miriHome/helpers/service_locator.dart';

import '../interfaces/idevices.dart';

class DevicesProvider with ChangeNotifier {
  String _currentRoomIdentifier = "";

  List<IDevices> _listCurrentRoomDevices = [];

  List<IDevices> get ListCurrentRoomDevices => _listCurrentRoomDevices;

  void SetCurrentRoom(String currentRoomIdentifier) {
    _currentRoomIdentifier = currentRoomIdentifier;
  }

  UpdateListCurrentDevices(IDevices device) {
    if (serviceLocator<RoomProviderService>().rooms.isNotEmpty &&
        _currentRoomIdentifier != "") {
      if (serviceLocator<RoomProviderService>()
          .rooms
          .any((room) => room.roomIdentifier == _currentRoomIdentifier)) {
        if (IsDeviceUpdateComingFromCurrentRoom(device)) {
          _listCurrentRoomDevices.clear();
          // // var devices = serviceLocator<RoomProviderService>()
          // //     .rooms
          // //     .firstWhere(
          // //         (room) => room.roomIdentifier == _currentRoomIdentifier)
          // //     .devices;
          var devices = serviceLocator<RoomProviderService>()
              .devicesRunTimeList
              .where((d) => d.roomIdentifier == _currentRoomIdentifier);

          _listCurrentRoomDevices.addAll(devices);
          notifyListeners();
        }
      }
    }
  }

  bool IsDeviceUpdateComingFromCurrentRoom(IDevices device) {
    bool isUpdateFromCurrenRoom = false;
    if (device.roomIdentifier == _currentRoomIdentifier) {
      isUpdateFromCurrenRoom = true;
    }
    return isUpdateFromCurrenRoom;
  }

  // // bool IsDeviceUpdateComingFromCurrentRoom(IDevices device) {
  // //   bool isUpdateFromCurrenRoom = false;
  // //   if (device.zigbeeFriendlyName.contains(_currentRoomIdentifier)) {
  // //     isUpdateFromCurrenRoom = true;
  // //   }
  // //   return isUpdateFromCurrenRoom;
  // // }
}
