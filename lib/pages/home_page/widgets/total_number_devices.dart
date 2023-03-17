import 'package:flutter/material.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:provider/provider.dart';

class TotalNumberOfDevices extends StatelessWidget {
  const TotalNumberOfDevices({super.key});

  @override
  Widget build(BuildContext context) {
    int numberOfActiveDevices = context.watch<RoomProvider>().Devices.length;
    return Container(
      child: Text(
        numberOfActiveDevices == 1
            ? "  ${numberOfActiveDevices} - Device Connected"
            : "  ${numberOfActiveDevices} - Devices Connected",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
