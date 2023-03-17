import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/lamp.dart';
import 'package:miriHome/models/room.dart';
import 'package:miriHome/models/window_sensor.dart';
import 'package:miriHome/pages/connection_lost_page/connection_lost_page.dart';
import 'package:miriHome/pages/room_details_page/widgets/device_sensor_card.dart';
import 'package:miriHome/pages/room_details_page/widgets/device_switch_card.dart';
import 'package:miriHome/Providers/devices_provider.dart';
import 'package:miriHome/Providers/edit_state_provider.dart';
import 'package:miriHome/Providers/mqtt_state_provider.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/pages/room_details_page/widgets/temperature_card.dart';
import 'package:miriHome/helpers/mqtt_json_handling.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:miriHome/services/MQTT_Service.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'heating_control_page.dart';

class DetailPage extends StatefulWidget {
  final Room room;

  DetailPage({required this.room});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isOtherDevicesConnected = false;
  bool isThermostatConnected = false;
  bool isTemperatureSensorConnected = false;
  bool isUiBeingEdited = false;
  late String editModeText;
  late IDevices temperatureDevice;

  List<IDevices> listDevicesWithoutTempAndThermostat = [];
  @override
  Widget build(BuildContext context) {
    context.read<DevicesProvider>().SetCurrentRoom(widget.room.roomIdentifier);
    context.watch<DevicesProvider>().ListCurrentRoomDevices;
    isUiBeingEdited =
        context.watch<EditStateProvider>().isRoomPageUIBeingEdited;
    editModeText = isUiBeingEdited ? "Done" : "Edit";
    var allDevicesInCurrentroom = context
        .watch<RoomProvider>()
        .DevicesRunTimeList
        .where(
            (element) => element.roomIdentifier == widget.room.roomIdentifier);

    log(DateTime.now().toString() + " Building Room Details page",
        time: DateTime.now());

    // list without temp sensor and thermostat sorted according to device type
    // where all lamp appears first.
    listDevicesWithoutTempAndThermostat = allDevicesInCurrentroom
        .where((element) =>
            element.deviceType != DeviceType.TemperatureSensor &&
            element.deviceType != DeviceType.Thermostat)
        .toList()
      ..sort(((a, b) => a.deviceType.index.compareTo(b.deviceType.index)));

    isThermostatConnected = allDevicesInCurrentroom
        .any((element) => element.deviceType == DeviceType.Thermostat);

    isTemperatureSensorConnected = allDevicesInCurrentroom
        .any((element) => element.deviceType == DeviceType.TemperatureSensor);

    if (isTemperatureSensorConnected) {
      temperatureDevice = allDevicesInCurrentroom.firstWhere(
          (element) => element.deviceType == DeviceType.TemperatureSensor);
    }
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     elevation: 1.0,
    //     title: Text(widget.room.roomDisplayName,
    //         style: TextStyle(color: Colors.black)),
    //     centerTitle: true,
    //     iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    //     systemOverlayStyle: SystemUiOverlayStyle.dark,
    //     actions: <Widget>[
    //       IconButton(
    //         onPressed: () {
    //           print("do nothin");
    //         },
    //         icon: Icon(CupertinoIcons.add, color: Colors.blue),
    //       )
    //     ],
    //   ),
    //   body: GetAppropriateConnectionStateWidget(context),
    // );
    return CupertinoPageScaffold(
        child: RefreshIndicator(
      edgeOffset: 140,
      color: CupertinoColors.activeBlue,
      onRefresh: () => serviceLocator<MQTTService>().Refresh(),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            padding: EdgeInsetsDirectional.only(start: 10, end: 10),
            previousPageTitle: "Home",
            largeTitle: Text(widget.room.roomDisplayName),
            leading: isUiBeingEdited ? Text("") : null,
            trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(editModeText),
                onPressed: () {
                  setState(() {
                    if (editModeText == "Edit") {
                      editModeText = "Done";
                      context
                          .read<EditStateProvider>()
                          .SetRoomPageUIBeingEdited(true);
                    } else {
                      editModeText = "Edit";
                      context
                          .read<EditStateProvider>()
                          .SetRoomPageUIBeingEdited(false);
                    }
                  });
                }),
            // trailing: Material(
            //   child: IconButton(
            //     color: CupertinoColors.activeBlue,
            //     icon: Icon(
            //       CupertinoIcons.add,
            //       size: 24,
            //     ),
            //     onPressed: () => "do nothing",
            //   ),
            // ),
          ),
          SliverSafeArea(
            // ADD from here...
            top: false,
            minimum: const EdgeInsets.only(top: 0),
            sliver: SliverToBoxAdapter(
              child: GetAppropriateConnectionStateWidget(context),
            ),
          ),
          // SliverFillRemaining(
          //   child: GetAppropriateConnectionStateWidget(context),
          // )
        ],
      ),
    ));
  }

  Widget GetAppropriateConnectionStateWidget(BuildContext context) {
    log(
        serviceLocator<MqttConnectionStateProvider>()
            .getMqttConnectionState
            .toString(),
        time: DateTime.now());
    if (LocalStorageService.IsSumulationMode) {
      return BuildColumn();
    } else {
      switch (
          context.watch<MqttConnectionStateProvider>().getMqttConnectionState) {
        case MQTTAppConnectionState.disconnected:
          return Material(child: ConnectionLostPage());
        case MQTTAppConnectionState.connectedSubscribed:
          return BuildColumn();
        default:
          return Material(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Connecting to MiriHome Server...",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          );
      }
    }
  }

  Widget BuildColumn() {
    return BuildDetailsPageColumn();
  }

  Widget BuildDetailsPageColumn() {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Text("Climate Control",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 15, 15, 15),
            //padding: EdgeInsets.all(15),
            child: badges.Badge(
              badgeContent: Icon(
                CupertinoIcons.minus,
                color: Colors.white,
                size: 16,
              ),
              position: badges.BadgePosition.topStart(),
              badgeAnimation: badges.BadgeAnimation.scale(),
              showBadge: isUiBeingEdited && isTemperatureSensorConnected,
              onTap: () => ShowDeleteDeviceDialog(context, temperatureDevice),
              child: Container(
                //margin: EdgeInsets.all(10),
                //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                padding: EdgeInsets.all(15),
                //height: _height * 0.25,
                //width: _width * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: (Colors.grey[300])!,
                      blurRadius: 15,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: isTemperatureSensorConnected
                    ? TemperatureInformation(widget.room)
                    : Center(
                        child: Text("No Temperature sensor connected"),
                      ),
              ),
            ),
          ),
          isThermostatConnected
              ? Center(
                  child: CupertinoButton(
                    onPressed: () {
                      //_showGraphs(context, _height);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                HeatingControl(room: widget.room),
                          ));
                    },
                    child:
                        Text("Control Heating", style: TextStyle(fontSize: 18)),
                    //padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              height: 5,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Text(
              "Other Devices",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          listDevicesWithoutTempAndThermostat.isEmpty
              ? Container(
                  margin: EdgeInsets.all(15),
                  //padding: EdgeInsets.all(15),
                  child: Container(
                    //margin: EdgeInsets.all(10),
                    //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    padding: EdgeInsets.all(15),
                    //height: _height * 0.25,
                    //width: _width * 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: (Colors.grey[300])!,
                          blurRadius: 15,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text("No devices connected"),
                    ),
                  ))
              : AnimationLimiter(
                  key: ValueKey(listDevicesWithoutTempAndThermostat.length),
                  child: GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: listDevicesWithoutTempAndThermostat
                          .length, //widget.room.devices?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 10, 15, 10),
                                  child: GetAppropriateWidgetForDevices(
                                      listDevicesWithoutTempAndThermostat[
                                          index])),
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }

  Widget GetAppropriateWidgetForDevices(IDevices device) {
    switch (device.deviceType) {
      case DeviceType.Lamp:
        return DeviceSwitchCard(deviceLampOrSwitch: device as Lamp);
      case DeviceType.Sensor:
        return DeviceSensorCard(deviceSensor: device as WindowSensor);
      default:
        return Container();
    }
  }

  Widget textCate({nameCate}) {
    return Text(
      nameCate,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void ShowDeleteDeviceDialog(BuildContext context, IDevices device) {
    showCupertinoModalPopup<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(
                  "Delete '${device.displayName}'",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(
                    "Are you sure you want to delete the device '${device.displayName}'?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text("Remove from Server"),
                    onPressed: null,
                  ),
                  CupertinoDialogAction(
                    child: Text("Remove from the room"),
                    onPressed: () async {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        serviceLocator<RoomProviderService>()
                            .RemoveDeviceFromRoom(device);
                      });
                    },
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }
}
