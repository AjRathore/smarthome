import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/pages/devices_tab_page/device_details_page.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeviceItem extends StatelessWidget {
  const DeviceItem({required this.device});

  final IDevices device;

  @override
  Widget build(BuildContext context) {
    var roomName = serviceLocator<RoomProviderService>()
        .GetRoomDisplayNameFromRoomIdentifier(device.roomIdentifier);
    return Slidable(
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: CupertinoColors.systemRed,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0.5,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: const EdgeInsets.only(
            left: 0,
            top: 8,
            bottom: 8,
            right: 8,
          ),
          child: CupertinoListTile.notched(
            onTap: () {
              showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor:
                    CupertinoTheme.of(context).scaffoldBackgroundColor,
                builder: (context) => DeviceDetailsPage(device: device),
              );
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                device.image,
                fit: BoxFit.cover,
                width: 68,
                height: 68,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image(
                      image: GetDeviceImageWhenNoIternet(device.deviceType));
                },
              ),
            ),
            leadingSize: 68,
            title: Text(device.zigbeeFriendlyName),
            subtitle: Text(device.roomIdentifier != ""
                ? "Room: " + roomName
                : "Room: " + "None"),
            trailing: const CupertinoListTileChevron(),
          ),
        ),
      ),
    );
  }

  void doNothing(BuildContext context) {}

  ImageProvider GetDeviceImageWhenNoIternet(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.TemperatureSensor:
        return Image.asset("assets/Images/TempSensor.jpeg").image;
      case DeviceType.Lamp:
        return Image.asset("assets/Images/Switch.jpeg").image;
      case DeviceType.Thermostat:
        return Image.asset("assets/Images/Thermostat.jpeg").image;
      default:
        return Image.asset("assets/Images/sampledevice.png").image;
    }
  }
}
