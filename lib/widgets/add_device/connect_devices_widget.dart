import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/widgets/add_device/zigbee3_device_connected.dart';

class ConnectDevices extends StatefulWidget {
  const ConnectDevices({super.key});

  @override
  State<ConnectDevices> createState() => _ConnectDevices();
}

class _ConnectDevices extends State<ConnectDevices> {
  bool deviceFound = false;

  @override
  void initState() {
    super.initState();
    _simulateDeviceFound();
  }

  @override
  Widget build(BuildContext context) {
    if (deviceFound) {
      return Zigbee3ConnectDevice(scannedQRCode: "Tuya TS0601");
    } else {
      return buildSearchingDevices(context);
    }
    ;
  }

  Widget buildSearchingDevices(BuildContext context) {
    return Container(
      height: 600,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                iconSize: 24,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: CupertinoColors.systemGrey3,
                ),
              ),
            ],
          ),
          Text(
            "Searching for a Device",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Start pairing a device with the Zigbee Hub",
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
              child: CupertinoActivityIndicator(
            radius: 20,
          ))
        ],
      ),
    );
  }

  _simulateDeviceFound() async {
    await Future.delayed(Duration(seconds: 5));

    setState(() {
      deviceFound = true;
    });
  }

  openDialogZigbee3ConnectDevice(BuildContext context) =>
      showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isDismissible: false,
        context: context,
        builder: (context) =>
            Zigbee3ConnectDevice(scannedQRCode: "Tuya TS 0601"),
      ); // r
}
