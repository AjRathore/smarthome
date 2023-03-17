import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Zigbee3ConnectDevice extends StatefulWidget {
  const Zigbee3ConnectDevice({super.key, required this.scannedQRCode});

  final String scannedQRCode;

  @override
  State<Zigbee3ConnectDevice> createState() => _Zigbee3ConnectDevice();
}

class _Zigbee3ConnectDevice extends State<Zigbee3ConnectDevice> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.width;
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
            "Device Connected!",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Container(
            height: _width * 0.5,
            width: _height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Images/sampledevice.png'),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.scannedQRCode,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            // temporary solution
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: CupertinoButton.filled(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
