import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/Widgets/add_device/connect_devices_widget.dart';
import 'package:miriHome/Widgets/add_device/qrcode_view.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 300,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
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
            "Add a Device",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Scan code for Zigbee 3.0 devices",
            style: TextStyle(fontSize: 16),
          ),
          ////CameraInit(),
          QRCodeView(),
          SizedBox(height: 10),
          Text(
            "Or",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          CupertinoButton.filled(
              child: Text("Connect Devices Manually"),
              onPressed: () {
                openDialogConnectDevices(context);
              })
        ],
      ),
    );
  }

  void openDialogConnectDevices(BuildContext context) =>
      showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isDismissible: false,
        context: context,
        builder: (context) => ConnectDevices(),
      ).whenComplete(() => Navigator.pop(context));
}
