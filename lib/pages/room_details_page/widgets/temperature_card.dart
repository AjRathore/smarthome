import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/temp_sensor.dart';
import 'package:miriHome/helpers/device_name_helper.dart';
import 'package:provider/provider.dart';
import '../../../models/room.dart';
import '../../../Providers/room_provider.dart';

class TemperatureInformation extends StatelessWidget {
  const TemperatureInformation(
    this.room, {
    Key? key,
  }) : super(key: key);

  final Room room;

  IconData _getBatteryIcon(num battery) {
    if (battery >= 75) {
      return CupertinoIcons.battery_100;
    } else if (battery > 50 && battery < 75) {
      return CupertinoIcons.battery_75_percent;
    } else {
      return CupertinoIcons.battery_25;
    }
  }

  void _showGraphs(BuildContext ctx, double height) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        context: ctx,
        builder: (_) {
          return Container(
              height: height,
              child: null); //GraphsWindow(room.tempSensor.tempSensorName));
        });
  }

  Icon _getSmileyIcon(double temperature, double humidity) {
    if (temperature < 20 || humidity > 65) {
      return Icon(
        MdiIcons.emoticonSadOutline,
        color: Colors.red,
        size: 35,
      );
    } else if (temperature > 20 || humidity < 65) {
      return Icon(
        MdiIcons.emoticonHappyOutline,
        color: Colors.green,
        size: 35,
      );
    } else {
      return Icon(
        MdiIcons.emoticonSadOutline,
        color: Colors.green,
        size: 35,
      );
      ;
    }
  }

  Widget BuildTemperatureInfoWidgets(
      TempSensor temperatureDevice, double _height, double _width,
      {bool isRoomWithTemperatureSensor = true}) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: <Widget>[
                Text(
                  "Temperature",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _width * 0.038,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  isRoomWithTemperatureSensor
                      ? temperatureDevice.temperatureValue.toString() + " °C"
                      : "n.a.",
                  style: TextStyle(
                      fontSize: _width * 0.038, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            buildDivider(),
            Column(
              children: <Widget>[
                Text(
                  "Humidity",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _width * 0.038,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                    isRoomWithTemperatureSensor
                        ? temperatureDevice.humidityValue.toString() + " %"
                        : "n.a.",
                    style: TextStyle(
                        fontSize: _width * 0.038,
                        fontWeight: FontWeight.normal)),
              ],
            ),
            buildDivider(),
            Column(
              children: <Widget>[
                Text(
                  "Battery",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _width * 0.038,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                    isRoomWithTemperatureSensor
                        ? temperatureDevice.battery.toString() + " %"
                        : "n.a.",
                    style: TextStyle(
                        fontSize: _width * 0.038,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ],
        ),
        SizedBox(height: 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var allDevicesInCurrentRoom = context
        .read<RoomProvider>()
        .DevicesRunTimeList
        .where((element) => element.roomIdentifier == room.roomIdentifier);

    TempSensor temperatureDevice = allDevicesInCurrentRoom.firstWhere(
            (element) => element.deviceType == DeviceType.TemperatureSensor)
        as TempSensor;

    String tempSensorName =
        DeviceNameHelper.SplitDeivceName(temperatureDevice.displayName);

    // var tempSensorNamesSplit = tempSensorName.split('_');
    // String sRoomName = tempSensorNamesSplit[0];
    // String sSensorName = tempSensorNamesSplit[1];
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    num iBattery = temperatureDevice.battery;
    // int iBattery =
    //     temperatureDevice.battery ?? temperatureDevice.battery.toDouble();
    // assert(iBattery is int);

    // double dTemperature = double.parse(room.tempSensor.temperatureValue);
    // double dHumidity = double.parse(room.tempSensor.humidityValue);

    double dTemperature = temperatureDevice.temperatureValue;
    double dHumidity = temperatureDevice.humidityValue;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BuildTemperatureInfoWidgets(temperatureDevice, _height, _width)
        ],
      ),
    );
  }

  Widget buildDivider() => Container(
        height: 28,
        child: VerticalDivider(
          color: CupertinoColors.systemGrey,
        ),
      );
}
