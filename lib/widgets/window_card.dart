// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../Models/room.dart';

// class WindowCard extends StatefulWidget {
//   final Room room;
//   WindowCard(this.room);

//   @override
//   _WindowCardState createState() => _WindowCardState();
// }

// class _WindowCardState extends State<WindowCard> {
//   IconData _getBatteryIcon(int battery) {
//     if (battery >= 75) {
//       return CupertinoIcons.battery_100;
//     } else if (battery > 50 && battery < 75) {
//       return CupertinoIcons.battery_75_percent;
//     } else {
//       return CupertinoIcons.battery_25;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     bool contact = widget.room.windowSensor.contact;
//     String sSensorName = widget.room.windowSensor.windowSensorName;
//     var sensorNamesSplit = sSensorName.split('_');
//     String sRoomName = sensorNamesSplit[0];
//     String sWindowSensorName = sensorNamesSplit[1];

//     int iBattery = int.tryParse(widget.room.windowSensor.battery) ??
//         double.parse(widget.room.windowSensor.battery).toInt();
//     assert(iBattery is int);

//     print(iBattery);
//     String status = 'Closed';

//     switch (contact) {
//       case true:
//         status = "Closed";
//         break;
//       case false:
//         status = "Open";
//         break;
//       default:
//     }
//     return Container(
//       margin: EdgeInsets.all(15),
//       child: Container(
//         padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
//         height: _height * 0.19,
//         width: _width * 0.7,
//         decoration: BoxDecoration(
//           color:
//               contact == false ? Theme.of(context).primaryColor : Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey[300],
//               blurRadius: 15,
//               offset: Offset(0, 0),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text("$sRoomName\n$sWindowSensorName",
//                             style: TextStyle(
//                               height: _height * 0.0015,
//                               fontSize: _width * 0.045,
//                               color:
//                                   contact == true ? Colors.black : Colors.white,
//                             )),
//                       ),
//                       Container(
//                         child: contact == true
//                             ? Image.asset(
//                                 "assets/Images/ClosedWindow.png",
//                                 height: _height * 0.075,
//                               )
//                             : Image.asset(
//                                 "assets/Images/OpenWindow.png",
//                                 height: _height * 0.075,
//                               ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 15,
//                     width: _width * 1,
//                   ),
//                   Expanded(
//                     child: ListTile(
//                       contentPadding: EdgeInsets.only(left: 0, right: 10),
//                       trailing: Text(
//                         status,
//                         style: TextStyle(
//                           fontSize: _width * 0.040,
//                           color: contact == true ? Colors.black : Colors.white,
//                         ),
//                       ),
//                       leading: Column(
//                         children: <Widget>[
//                           Expanded(
//                             child: Icon(
//                               _getBatteryIcon(iBattery),
//                               color:
//                                   contact == true ? Colors.black : Colors.white,
//                               size: _height * 0.04,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Expanded(
//                             child: Text(widget.room.windowSensor.battery + " %",
//                                 style: TextStyle(
//                                     fontSize: _width * 0.038,
//                                     fontWeight: FontWeight.normal,
//                                     color: contact == true
//                                         ? Colors.black
//                                         : Colors.white)),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Text(status,
//                   //     style: TextStyle(
//                   //       fontSize: 16,
//                   //       color: contact == true ? Colors.black : Colors.white,
//                   //     )),
//                   // SizedBox(
//                   //   height: 24,
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
