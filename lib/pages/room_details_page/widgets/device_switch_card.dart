import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:miriHome/models/device_state.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/models/lamp.dart';
import 'package:miriHome/Providers/edit_state_provider.dart';
import 'package:miriHome/helpers/device_name_helper.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:provider/provider.dart';

class DeviceSwitchCard extends StatefulWidget {
  final Lamp deviceLampOrSwitch;

  const DeviceSwitchCard({Key? key, required this.deviceLampOrSwitch})
      : super(key: key);

  @override
  State<DeviceSwitchCard> createState() => _DeviceSwitchCardState();
}

class _DeviceSwitchCardState extends State<DeviceSwitchCard> {
  bool _switchValue = false;
  bool isUiBeingEdited = false;
  @override
  Widget build(BuildContext context) {
    isUiBeingEdited =
        context.watch<EditStateProvider>().isRoomPageUIBeingEdited;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    DeviceState state = widget.deviceLampOrSwitch.state;
    switch (state) {
      case DeviceState.on:
        _switchValue = true;
        break;
      case DeviceState.off:
        _switchValue = false;
        break;
      default:
        _switchValue = false;
        break;
    }
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
        ShowDeleteDeviceDialog(context, widget.deviceLampOrSwitch);
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
                  widget.deviceLampOrSwitch.image,
                  fit: BoxFit.fitWidth,
                  width: 68,
                  height: 68,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image(
                        width: 68,
                        height: 68,
                        image: GetDeviceImageWhenNoIternet(
                            widget.deviceLampOrSwitch.deviceType));
                  },
                ),
              ),
              SizedBox(height: _height * 0.01),
              Text(widget.deviceLampOrSwitch.displayName,
                  style: TextStyle(fontSize: 15, color: Colors.black)),
              SizedBox(height: _height * 0.008),
              Transform.scale(
                scale: 0.85,
                child: CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      value == true
                          ? widget.deviceLampOrSwitch.state = DeviceState.on
                          : widget.deviceLampOrSwitch.state = DeviceState.off;

                      serviceLocator<RoomProviderService>()
                          .UpdateLamp_SaveChanges(widget.deviceLampOrSwitch);
                    });
                  },
                ),
              ),
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
        return Image.asset("assets/Images/Switch.jpeg").image;
    }
  }
}
