import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/room.dart';
import 'package:miriHome/models/thermostat_child_lock.dart';
import 'package:miriHome/models/thermostat_running_state.dart';
import 'package:miriHome/pages/connection_lost_page/connection_lost_page.dart';
import 'package:miriHome/Providers/mqtt_state_provider.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/helpers/device_name_helper.dart';
import 'package:miriHome/helpers/mqtt_json_handling.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/services/MQTT_Service.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:miriHome/models/device_state.dart';
import 'package:miriHome/models/thermostat.dart';
import 'package:miriHome/Providers/devices_provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HeatingControl extends StatefulWidget {
  final Room room;
  const HeatingControl({Key? key, required this.room}) : super(key: key);

  @override
  State<HeatingControl> createState() => _HeatingControlState();
}

class _HeatingControlState extends State<HeatingControl> {
  double _width = 0.0;
  var _isHeatingOn = true;
  double _initialValue = 7.0;
  double _deviceTemperature = 20.0;
  bool dailySchedule = false;
  bool childLock = false;
  String valueToSend = "";
  int currentSystemMode = 0;

  List<Color> colors = <Color>[
    Colors.redAccent.shade700,
    Colors.redAccent.shade400,
    Colors.redAccent.shade400,
    Colors.redAccent.shade400,
    Colors.redAccent.shade400,
    Colors.redAccent.shade200,
    Colors.redAccent.shade100,
    Colors.blueAccent.shade400,
    Colors.blueAccent.shade400,
    Colors.blueAccent.shade400,
    Colors.blueAccent.shade400,
    Colors.blueAccent.shade400,
    Colors.blueAccent.shade400,
  ];

  List<Color> disabledColors = <Color>[
    Colors.grey,
    Colors.grey,
  ];

  Color GetColorBasedOnTemperature(bool isHeatingOn, double temperatureVlaue) {
    if (!isHeatingOn) {
      return Colors.grey;
    } else {
      if (temperatureVlaue > 23.0) {
        return Colors.redAccent.shade400;
      } else if (temperatureVlaue > 21.0 && temperatureVlaue <= 23.0) {
        return Colors.redAccent.shade200;
      } else if (temperatureVlaue >= 20.0 && temperatureVlaue <= 21.0) {
        return Colors.redAccent.shade100;
      } else if (temperatureVlaue < 20.0) {
        return Colors.blueAccent.shade100;
      } else {
        return Colors.black;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<DevicesProvider>().SetCurrentRoom(widget.room.roomIdentifier);
    var devices = context.watch<DevicesProvider>().ListCurrentRoomDevices;
    var allDevicesInCurrentRoom = context
        .read<RoomProvider>()
        .DevicesRunTimeList
        .where(
            (element) => element.roomIdentifier == widget.room.roomIdentifier);

    var thermostat = allDevicesInCurrentRoom.firstWhere(
        (element) => element.deviceType == DeviceType.Thermostat) as Thermostat;

    _deviceTemperature = thermostat.deviceTemperature.toDouble();
    _initialValue = thermostat.desiredTemperature.toDouble();
    DeviceState state = thermostat.state;
    ThermostatChildLock lock = thermostat.childLock;

    switch (state) {
      case DeviceState.on:
      case DeviceState.auto:
      case DeviceState.heat:
        _isHeatingOn = true;
        break;
      case DeviceState.off:
        _isHeatingOn = false;
        break;
      default:
        _isHeatingOn = false;
    }

    switch (lock) {
      case ThermostatChildLock.lock:
        childLock = true;
        break;
      case ThermostatChildLock.unlock:
        childLock = false;
        break;
      default:
        childLock = false;
    }

    currentSystemMode = ConvertDeviceStateToInt(state);

    log(DateTime.now().toString() + " Building Heating control page",
        time: DateTime.now());
    _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
        child: RefreshIndicator(
      edgeOffset: 140,
      color: CupertinoColors.activeBlue,
      onRefresh: () => serviceLocator<MQTTService>().Refresh(),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            previousPageTitle: widget.room.roomDisplayName,
            largeTitle: Text("Heating Control"),
          ),
          SliverSafeArea(
            // ADD from here...
            top: false,
            minimum: const EdgeInsets.only(top: 0),
            sliver: SliverToBoxAdapter(
              child: GetAppropriateConnectionStateWidget(context, thermostat),
            ),
          ),
          // SliverFillRemaining(
          //   child: GetAppropriateConnectionStateWidget(context),
          // )
        ],
      ),
    ));
  }

  Widget BuildMainArea(Thermostat thermostat) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          children: [
            Text(
              DeviceNameHelper.SplitDeivceName(thermostat.displayName),
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 30,
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                size: MediaQuery.of(context).size.width * 0.75,
                customColors: CustomSliderColors(
                  trackColor: Colors.grey.shade300,
                  progressBarColors: _isHeatingOn ? colors : disabledColors,
                  dotColor: Colors.white,
                  shadowColor: Colors.grey.shade600,
                ),
                customWidths: CustomSliderWidths(
                  trackWidth: 5,
                  progressBarWidth: 12,
                  handlerSize: 10,
                ),
              ),
              min: 5,
              max: 30,
              initialValue:
                  thermostat.desiredTemperature.toDouble(), //_initialValue,
              onChange: (value) => {HapticFeedback.selectionClick()},
              onChangeEnd: (value) => {
                valueToSend = ((value * 2).round() / 2).toString(),
                _isHeatingOn
                    ? UpdateThermostatTemperature_SaveChanges(
                        thermostat, valueToSend)
                    : log(
                        "Heating value changed to: ${valueToSend} but heating is off"),
              },
              innerWidget: (double value) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: GetColorBasedOnTemperature(
                                  _isHeatingOn, value),
                              spreadRadius: 30,
                              blurRadius: 200,
                            ),
                          ]),
                          child: const Icon(
                            Icons.power_settings_new,
                            color: Colors.transparent,
                          ),
                        ),
                        InkWell(
                          onTap: () => {
                            setState(() {
                              HapticFeedback.mediumImpact();
                              _isHeatingOn = !_isHeatingOn;
                              _isHeatingOn
                                  ? thermostat.state = DeviceState.heat
                                  : thermostat.state = DeviceState.off;

                              serviceLocator<RoomProviderService>()
                                  .UpdateThermostatState_SaveChanges(
                                      thermostat);
                            })
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    spreadRadius: 0.5,
                                    blurRadius: 0.5,
                                    offset: const Offset(0, 1.75),
                                  ),
                                ]),
                            child: Icon(
                              Icons.power_settings_new,
                              color: _isHeatingOn ? Colors.red : Colors.black,
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 65),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 28,
                          color: CupertinoColors.activeBlue,
                          onPressed: _isHeatingOn
                              ? () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    thermostat.desiredTemperature -= 0.5;
                                    UpdateThermostatTemperature_SaveChanges(
                                        thermostat,
                                        thermostat.desiredTemperature
                                            .toString());
                                  });
                                }
                              : null,
                        ),
                        Text(
                          _isHeatingOn
                              ? '${(value * 2).round() / 2} °C'
                              : 'Off',
                          style: TextStyle(
                              color: Colors
                                  .black, //GetColorBasedOnTemperature(_isHeatingOn, _temperatureValue),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.090,
                              fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 28,
                          color: CupertinoColors.activeBlue,
                          onPressed: _isHeatingOn
                              ? () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    thermostat.desiredTemperature += 0.5;
                                    UpdateThermostatTemperature_SaveChanges(
                                        thermostat,
                                        thermostat.desiredTemperature
                                            .toString());
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    Text(
                      'Temperature',
                      style: TextStyle(
                          color:
                              _isHeatingOn ? Colors.black : Colors.transparent,
                          fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LocalStorageService.IsSumulationMode && _isHeatingOn
                    ? Icon(
                        CupertinoIcons.flame,
                        color: Colors.red,
                        size: 36,
                      )
                    : thermostat.runningState == ThermostatRunningState.heat
                        ? Icon(
                            CupertinoIcons.flame,
                            color: Colors.red,
                            size: 32,
                          )
                        : Icon(
                            Icons.motion_photos_pause,
                            size: 32,
                          ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Divider(color: Colors.black),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                children: <Widget>[
                  Text(
                    "System Mode",
                    style: TextStyle(
                        fontSize: _width * 0.045,
                        fontWeight: FontWeight.normal),
                  ),
                  Spacer(),
                  BuildSlidingControl(currentSystemMode, thermostat)
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                children: <Widget>[
                  Text(
                    "Temperature on Device",
                    style: TextStyle(
                        fontSize: _width * 0.045,
                        fontWeight: FontWeight.normal),
                  ),
                  Spacer(),
                  Text(
                    "${_deviceTemperature} °C",
                    style: TextStyle(
                        fontSize: _width * 0.045,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 35),
              child: Row(
                children: <Widget>[
                  Text(
                    "Battery",
                    style: TextStyle(
                        fontSize: _width * 0.045,
                        fontWeight: FontWeight.normal),
                  ),
                  Spacer(),
                  Icon(_getBatteryIcon(thermostat.isBatteryLow),
                      size: 28,
                      color:
                          thermostat.isBatteryLow ? Colors.red : Colors.black),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 30, right: 28),
              child: Row(
                children: <Widget>[
                  Text(
                    "Child Lock",
                    style: TextStyle(
                        fontSize: _width * 0.045,
                        fontWeight: FontWeight.normal),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    value: childLock,
                    onChanged: (newVal) {
                      setState(() {
                        childLock = newVal;
                        childLock
                            ? thermostat.childLock = ThermostatChildLock.lock
                            : thermostat.childLock = ThermostatChildLock.unlock;

                        serviceLocator<RoomProviderService>()
                            .UpdateThermostatChildLock_SaveChanges(thermostat);
                        print(newVal);
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  color: Colors.black,
                )),
            Padding(
                padding: const EdgeInsets.only(left: 30),
                child: CupertinoButton(
                  onPressed: () {
                    ShowInfoDialog(context);
                  },
                  child: Text("Configure daily schedule"),
                ))
          ],
        ),
      ),
    );
  }

  Widget GetAppropriateConnectionStateWidget(
      BuildContext context, Thermostat thermostat) {
    log(
        serviceLocator<MqttConnectionStateProvider>()
            .getMqttConnectionState
            .toString(),
        time: DateTime.now());
    if (LocalStorageService.IsSumulationMode) {
      return BuildMainArea(thermostat);
    } else {
      switch (
          context.watch<MqttConnectionStateProvider>().getMqttConnectionState) {
        case MQTTAppConnectionState.disconnected:
          return Material(child: ConnectionLostPage());
        case MQTTAppConnectionState.connectedSubscribed:
          return BuildMainArea(thermostat);
        default:
          return Material(
            child: Container(
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

  Widget BuildSlidingControl(int currentMode, Thermostat thermostat) {
    return AbsorbPointer(
      absorbing: !_isHeatingOn,
      child: CupertinoSlidingSegmentedControl<int>(
          padding: EdgeInsets.all(4.0),
          backgroundColor: CupertinoColors.systemGrey3,
          groupValue: currentMode,
          thumbColor: _isHeatingOn
              ? CupertinoColors.activeBlue
              : CupertinoColors.systemGrey,
          children: {0: BuildSegment("Heat"), 1: BuildSegment("Auto")},
          onValueChanged: ((value) {
            setState(() {
              _isHeatingOn
                  ? UpdateThermostatState_SaveChanges(thermostat, value!)
                  : log("Heating is switched off. Cannot change system mode");
            });
          })),
    );
  }

  Widget BuildSegment(String segment) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Text(
        segment,
        style: TextStyle(
          color: Colors.white,
          fontSize: _width * 0.04,
        ),
      ),
    );
  }

  void ShowInfoDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text("Info"),
                content: Text("Daily Schedule currently not supported"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }

  IconData _getBatteryIcon(bool isBatteryLow) {
    if (isBatteryLow) {
      return CupertinoIcons.battery_25;
    } else {
      return CupertinoIcons.battery_75_percent;
    }
  }

  int ConvertDeviceStateToInt(DeviceState state) {
    switch (state) {
      case DeviceState.heat:
        return 0;
      case DeviceState.auto:
        return 1;
      default:
        return 0;
    }
  }

  DeviceState ConvertIntToState(int? value) {
    switch (value) {
      case 0:
        return DeviceState.heat;
      case 1:
        return DeviceState.auto;
      default:
        return DeviceState.auto;
    }
  }

  void UpdateThermostatState_SaveChanges(Thermostat thermostat, int value) {
    thermostat.state = ConvertIntToState(value);
    serviceLocator<RoomProviderService>()
        .UpdateThermostatState_SaveChanges(thermostat);
  }

  void UpdateThermostatTemperature_SaveChanges(
      Thermostat thermostat, String temperatureValue) {
    thermostat.desiredTemperature = num.parse(temperatureValue);
    serviceLocator<RoomProviderService>()
        .UpdateThermostatTemperature_SaveChanges(thermostat, temperatureValue);
  }
}
