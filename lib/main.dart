import 'package:flutter/material.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/pages/navigation_page/navigation_page.dart';
import 'package:miriHome/pages/setup_screen/setup_screen.dart';
import 'package:miriHome/Providers/devices_provider.dart';
import 'package:miriHome/Providers/edit_state_provider.dart';
import 'package:miriHome/Providers/mqtt_state_provider.dart';
import 'package:miriHome/Providers/user_provider.dart';
import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:miriHome/services/room_data_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  // make sure flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // start shared preferences
  await LocalStorageService.init();
  // set up get it locator
  setupLocator();
  // create file at the start
  serviceLocator<RoomDataStorageService>().CreateFile();
  runApp(MultiProvider(providers: [
    // ChangeNotifierProvider<MQTTManager>(
    //   create: (_) => serviceLocator<MQTTManager>(),
    // ),
    ChangeNotifierProvider<RoomProvider>(
      create: (_) => serviceLocator<RoomProvider>(),
    ),
    ChangeNotifierProvider<MqttConnectionStateProvider>(
      create: (_) => serviceLocator<MqttConnectionStateProvider>(),
    ),
    ChangeNotifierProvider<DevicesProvider>(
      create: (_) => serviceLocator<DevicesProvider>(),
    ),
    ChangeNotifierProvider<EditStateProvider>(
      create: (_) => serviceLocator<EditStateProvider>(),
    ),
    ChangeNotifierProvider<UserProvider>(
      create: (_) => serviceLocator<UserProvider>(),
    ),
  ], child: MiriHome()));
}

class MiriHome extends StatelessWidget {
  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appDisplayName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of my application.
        //primarySwatch: Colors.white,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        fontFamily: "SF Pro Display",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //primarySwatch: Colors.blue,
        primaryColor: Colors.blue[700],
      ),
      home: LocalStorageService.IsSetupScreenShownOnce
          ? NavigationPage()
          : Theme(
              data: ThemeData(
                primarySwatch: Colors.blue,
                textSelectionTheme:
                    TextSelectionThemeData(cursorColor: Colors.black),
                textTheme: TextTheme(
                  titleMedium: TextStyle(color: Colors.black),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              child: SetupScreen()),
    );
  }
}
