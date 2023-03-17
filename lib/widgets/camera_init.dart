// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';

// // class CameraInit extends StatefulWidget {
// //   CameraInit({Key? key}) : super(key: key);

// //   @override
// //   _CameraInitState createState() => _CameraInitState();
// // }

// // class _CameraInitState extends State<CameraInit> with WidgetsBindingObserver {
// //   CameraController? controller;
// //   bool _isCameraInitialized = false;

// //   void onNewCameraSelected(CameraDescription cameraDescription) async {
// //     final previousCameraController = controller;
// //     // Instantiating the camera controller
// //     final CameraController cameraController = CameraController(
// //       cameraDescription,
// //       ResolutionPreset.high,
// //       imageFormatGroup: ImageFormatGroup.jpeg,
// //     );

// //     // Dispose the previous controller
// //     await previousCameraController?.dispose();

// //     // Replace with the new controller
// //     if (mounted) {
// //       setState(() {
// //         controller = cameraController;
// //       });
// //     }

// //     // Update UI if controller updated
// //     cameraController.addListener(() {
// //       if (mounted) setState(() {});
// //     });

// //     // Initialize controller
// //     try {
// //       await cameraController.initialize();
// //     } on CameraException catch (e) {
// //       print('Error initializing camera: $e');
// //     }

// //     // Update the Boolean
// //     if (mounted) {
// //       setState(() {
// //         _isCameraInitialized = controller!.value.isInitialized;
// //       });
// //     }
// //   }

// //   @override
// //   void initState() {
// //     onNewCameraSelected(cameras[0]);
// //     super.initState();
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     final CameraController? cameraController = controller;

// //     // App state changed before we got the chance to initialize.
// //     if (cameraController == null || !cameraController.value.isInitialized) {
// //       return;
// //     }

// //     if (state == AppLifecycleState.inactive) {
// //       // Free up memory when camera not active
// //       cameraController.dispose();
// //     } else if (state == AppLifecycleState.resumed) {
// //       // Reinitialize the camera with same properties
// //       onNewCameraSelected(cameraController.description);
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     controller?.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double _width = MediaQuery.of(context).size.width;
// //     double _height = MediaQuery.of(context).size.width;
// //     final size = MediaQuery.of(context).size;
// //     return Container(
// //       child: _isCameraInitialized
// //           ? Padding(
// //               padding: const EdgeInsets.all(15.0),
// //               child: ClipRRect(
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: Radius.circular(8.0),
// //                   topRight: Radius.circular(8.0),
// //                   bottomRight: Radius.circular(8.0),
// //                   bottomLeft: Radius.circular(8.0),
// //                 ),
// //                 child: AspectRatio(
// //                   aspectRatio: 3.5 / controller!.value.aspectRatio,
// //                   //aspectRatio: 16.0 / 10.0,
// //                   child: CameraPreview(controller!),
// //                 ),
// //               ),
// //             )
// //           // ? Card(
// //           //     child: Container(
// //           //       width: 350,
// //           //       height: 200,
// //           //       child: Padding(
// //           //         padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
// //           //         child: ClipRRect(
// //           //           borderRadius: BorderRadius.circular(10.0),
// //           //           child: Transform.scale(
// //           //             scale: controller!.value.aspectRatio *
// //           //                 0.25 /
// //           //                 size.aspectRatio,
// //           //             child: Center(
// //           //               child: AspectRatio(
// //           //                 aspectRatio: controller!.value.aspectRatio,
// //           //                 child: CameraPreview(controller!),
// //           //               ),
// //           //             ),
// //           //           ),
// //           //         ),
// //           //       ),
// //           //     ),
// //           //     shape: RoundedRectangleBorder(
// //           //         borderRadius: BorderRadius.circular(10.0)),
// //           //   )
// //           : CircularProgressIndicator(),
// //     );
// //   }
// // }
