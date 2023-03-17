import 'package:flutter/material.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:provider/provider.dart';

class NumberOfDevicesInRoom extends StatelessWidget {
  final int index;
  const NumberOfDevicesInRoom({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    var roomsList = context.watch<RoomProvider>().rooms;
    int numberOfDevices = roomsList[index].devices.length;
    return Container(
      child: Text(
        numberOfDevices == 1
            ? "${numberOfDevices} Device Connected"
            : "${numberOfDevices} Devices Connected",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
