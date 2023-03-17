// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../Providers/room_provider.dart';
// import '../Models/window_sensor.dart';
// import '../Widgets/window_card.dart';

// class WindowSensors extends StatefulWidget {
//   @override
//   _WindowSensorsState createState() => _WindowSensorsState();
// }

// class _WindowSensorsState extends State<WindowSensors> {
//   List<WindowSensor> windowSensorsList = List<WindowSensor>();
//   @override
//   Widget build(BuildContext context) {
//     var roomProvider = Provider.of<RoomProvider>(context);
//     windowSensorsList = roomProvider.getWindowSensorsList;

//     return Container(
//       //height: 300,
//       child: Scrollbar(
//         child: ListView.builder(
//             itemCount: windowSensorsList.length,
//             //controller: scrollController,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (context, index) {
//               return new Container(
//                 child: WindowCard(roomProvider.getRoomFromWindowSensor(
//                     windowSensorsList[index].windowSensorName)),
//               );
//             }),
//       ),
//     );
//   }
// }
