import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/window_sensor.dart';
import 'package:miriHome/Providers/edit_state_provider.dart';
import 'package:miriHome/helpers/device_name_helper.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class DeviceSensorCard extends StatefulWidget {
  final WindowSensor deviceSensor;

  const DeviceSensorCard({Key? key, required this.deviceSensor})
      : super(key: key);

  @override
  State<DeviceSensorCard> createState() => _DeviceSensorCardState();
}

class _DeviceSensorCardState extends State<DeviceSensorCard> {
  bool isUiBeingEdited = false;
  @override
  Widget build(BuildContext context) {
    isUiBeingEdited =
        context.watch<EditStateProvider>().isRoomPageUIBeingEdited;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    bool contact = widget.deviceSensor.contact;

    return badges.Badge(
      badgeContent: Icon(
        CupertinoIcons.minus,
        color: Colors.white,
        size: 16,
      ),
      position: badges.BadgePosition.topStart(),
      badgeAnimation: badges.BadgeAnimation.scale(),
      showBadge: isUiBeingEdited,
      onTap: () {
        ShowDeleteDeviceDialog(context, widget.deviceSensor);
      },
      child: Material(
        child: Container(
          height: _height * 0.19,
          width: _width * 1,
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
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.01),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.deviceSensor.image,
                  fit: BoxFit.fitWidth,
                  width: 52,
                  height: 52,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image(
                        width: 52,
                        height: 52,
                        image: GetDeviceImageWhenNoIternet(
                            widget.deviceSensor.deviceType));
                  },
                ),
              ),
              SizedBox(height: _height * 0.01),
              Text(widget.deviceSensor.displayName,
                  style: TextStyle(
                    fontSize: 15,
                  )),
              //SizedBox(height: _height * 0.01),
              Icon(
                Icons.sensors,
                size: 42,
                color: contact ? Colors.grey : Colors.red,
              ),
              Text(
                "Battery: ${widget.deviceSensor.battery.toString()} %",
                style: TextStyle(
                  fontSize: 14, //_width * 0.038,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: _height * 0.001),
            ],
          ),
        ),
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
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 1000), () {
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

  ImageProvider GetDeviceImageWhenNoIternet(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.TemperatureSensor:
        return Image.asset("assets/Images/TempSensor.jpeg").image;
      case DeviceType.Lamp:
        return Image.asset("assets/Images/Switch.jpeg").image;
      case DeviceType.Thermostat:
        return Image.asset("assets/Images/Thermostat.jpeg").image;
      default:
        return Image.asset("assets/Images/TempSensor.jpeg").image;
    }
  }
}
