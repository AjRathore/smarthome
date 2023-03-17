// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../Managers/MQTTManager.dart';
// import '../Models/lamp.dart';

// class LampCard extends StatefulWidget {
//   const LampCard(
//     this.manager,
//     this.lamp, {
//     Key key,
//   }) : super(key: key);

//   final Lamp lamp;
//   final MQTTManager manager;

//   @override
//   _LampCardState createState() => _LampCardState();
// }

// class _LampCardState extends State<LampCard> {
//   bool _switchValue = false;

//   @override
//   Widget build(BuildContext context) {
//     String lampName = widget.lamp.lampName;
//     var lampNamesSplit = lampName.split('_');
//     String sRoomName = lampNamesSplit[0];
//     String sLampName = lampNamesSplit[1];
//     String state = widget.lamp.state;

//     switch (state) {
//       case "ON":
//         _switchValue = true;
//         break;
//       case "OFF":
//         _switchValue = false;
//         break;
//       default:
//         _switchValue = false;
//         break;
//     }
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     return Container(
//       margin: EdgeInsets.all(15),
//       child: Container(
//         padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
//         height: _height * 0.19,
//         width: _width * 0.7,
//         decoration: BoxDecoration(
//           color: state == "ON" ? Theme.of(context).primaryColor : Colors.white,
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
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           "$sRoomName\n$sLampName",
//                           style: TextStyle(
//                             color: state == "ON" ? Colors.white : Colors.black,
//                             //fontWeight: FontWeight.w700,
//                             height: _height * 0.0015,
//                             fontSize: _width * 0.045,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         child: state == "ON"
//                             ? Image.asset(
//                                 "assets/Images/Lights_White.png",
//                                 height: _height * 0.075,
//                               )
//                             : Image.asset(
//                                 "assets/Images/Lights_Black.png",
//                                 height: _height * 0.075,
//                               ),
//                       ),
//                     ],
//                   ),
//                   // Expanded(
//                   //   child: SizedBox(
//                   //     height: 24,
//                   //   ),
//                   // ),
//                   // Expanded(
//                   //   child: Text(
//                   //     state,
//                   //     style: TextStyle(
//                   //         color: state == "ON" ? Colors.white : Colors.black),
//                   //   ),
//                   // ),
//                   // // Expanded(
//                   // //   child: SizedBox(
//                   // //     height: 10,
//                   // //   ),
//                   // // ),
//                   Expanded(
//                     child: ListTile(
//                       contentPadding: EdgeInsets.only(left: 0),
//                       title: Text(
//                         state,
//                         style: TextStyle(
//                             color: state == "ON" ? Colors.white : Colors.black),
//                       ),
//                       trailing: Transform.scale(
//                         scale: 0.8,
//                         child: CupertinoSwitch(
//                           value: _switchValue,
//                           onChanged: (value) {
//                             setState(() {
//                               value == true
//                                   ? widget.manager.publish(
//                                       "zigbee2mqtt/$lampName/set/state", "ON")
//                                   : widget.manager.publish(
//                                       "zigbee2mqtt/$lampName/set/state", "OFF");
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Positioned(
//             //     top: 5,
//             //     right: 10,
//             //     child: state == "ON"
//             //         ? Image.asset(
//             //             "assets/Images/Lights_White.png",
//             //             height: 80,
//             //           )
//             //         : Image.asset(
//             //             "assets/Images/Lights_Black.png",
//             //             height: 80,
//             //           )),
//           ],
//         ),
//       ),
//     );
//   }
// }
