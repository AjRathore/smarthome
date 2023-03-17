import '../models/room.dart';
import '../models/temp_sensor.dart';
import '../models/window_sensor.dart';

class DevicesHelper {
  List<String> roomsListTemporary = [];
  static List<Room> _rooms = [];
  static List<TempSensor> _tempSensorsList = [];
  static List<WindowSensor> _windowSensorsList = [];

  static int totalDevices = 0;

  static List<Room> get getRoomsList => _rooms;

  static List<TempSensor> get getTemperatureSensorList => _tempSensorsList;
  static List<WindowSensor> get getWindowSensorList => _windowSensorsList;

  //Devices(this.devicesList);

  void getRoomsFromDevicesList(List<String> devices) {
    roomsListTemporary =
        devices.map((item) => item.split("_")[0]).toSet().toList();
  }

  int getNumberOfDevices(String roomName, List<String> devicesList) {
    int numberOfDevices = 0;
    numberOfDevices =
        devicesList.where((item) => item.contains(roomName)).toList().length;
    return numberOfDevices;
  }

  // List<Lamp> getLampsForRoom(String roomName, List<String> devicesList) {
  //   // List<Lamp> lampList = [];
  //   // var temporaryList = devicesList.where((e) => e.contains(roomName)).toList();
  //   // for (int i = 0; i < temporaryList.length; i++) {
  //   //   if (temporaryList[i].contains("Lamp") ||
  //   //       temporaryList[i].contains("LED")) {
  //   //     Lamp lamp = new Lamp(temporaryList[i], "OFF");
  //   //     lampList.add(lamp);
  //   //   }
  //   // }
  //   // return lampList;
  // }

  void createRooms(List<String> devicesList) {
    // roomsListTemporary =
    //     devicesList.map((item) => item.split("_")[0]).toSet().toList();

    // for (int listItem = 0; listItem < roomsListTemporary.length; listItem++) {
    //   int activeDevices =
    //       getNumberOfDevices(roomsListTemporary[listItem], devicesList);

    //   List<Lamp> lampList = [];

    //   String sRoomName = roomsListTemporary[listItem];

    //   lampList = getLampsForRoom(sRoomName, devicesList);

    //   Room room = new Room(
    //       sRoomName,
    //       Image.asset('assets/Images/$sRoomName.png'),
    //       activeDevices,
    //       new TempSensor(sRoomName + "_TempSensor", "10.0", "50", "80"),
    //       new WindowSensor(sRoomName + "_WindowSensor", true, "80"),
    //       lampList);

    //   _rooms.add(room);

    //   createTempSensorsList(room.tempSensor);
    //   createWindowSensorsList(room.windowSensor);
    //}
    //rooms.updateList(_rooms);
  }

  void createTempSensorsList(TempSensor tempSensor) {
    _tempSensorsList.add(tempSensor);
  }

  void createWindowSensorsList(WindowSensor windowSensor) {
    _windowSensorsList.add(windowSensor);
  }
}
