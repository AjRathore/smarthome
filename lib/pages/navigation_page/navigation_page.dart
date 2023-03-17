import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miriHome/pages/connection_lost_page/connection_lost_page.dart';
import 'package:miriHome/pages/devices_tab_page/devices_list.dart';
import 'package:miriHome/pages/home_page/home_page.dart';
import 'package:miriHome/pages/settings_page/settings.dart';
import 'package:miriHome/Providers/mqtt_state_provider.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/Providers/user_provider.dart';
import 'package:miriHome/helpers/mqtt_json_handling.dart';
import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/managers/MQTTManager.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  //RoomProviderService roomProviderService = RoomProviderService();
  int _currentIndex = 0;
  late MQTTAppConnectionState appConnectionState;
  //late MQTTManager _manager;
  //late RoomProvider roomProvider;

  final List<Widget> _pages = [
    HomePage(),
    Devices(),
    //WindowSensors(),
    Settings()
  ];

  void _onNavigationBarTapped(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    RoomProvider roomProvider = RoomProvider();
    serviceLocator<UserProvider>().CreateUser(
        LocalStorageService.FirstName, LocalStorageService.UserImage);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //_manager = Provider.of<MQTTManager>(context, listen: false);
      //roomProvider = Provider.of<RoomProvider>(context, listen: false);
      connectToMQTT(serviceLocator<MQTTManager>());
      serviceLocator<RoomProviderService>().CreateRooms();
    });
  }

  void connectToMQTT(MQTTManager manager) async {
    if (!LocalStorageService.IsSumulationMode) {
      await Future.any([manager.initializeMQTTClient()]);
    }
  }

  void createRooms(RoomProvider roomProvider) {
    //roomProvider.CreateRooms();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      serviceLocator<MQTTManager>().disconnect();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_manager = Provider.of<MQTTManager>(context);
    return Scaffold(
        // bottom navigation bar
        bottomNavigationBar: buildBottomNavigationBar(),
        body: _pages[_currentIndex] //getAppropriateStartupWidget(context)
        );
  }

  Widget getAppropriateStartupWidget(BuildContext context) {
    if (AppConfig.isDebug) {
      return _pages[_currentIndex];
    } else {
      log(
          serviceLocator<MqttConnectionStateProvider>()
              .getMqttConnectionState
              .toString(),
          time: DateTime.now());
      switch (
          context.watch<MqttConnectionStateProvider>().getMqttConnectionState) {
        //case MQTTAppConnectionState.connected:
        case MQTTAppConnectionState.connectedSubscribed:
          return _pages[_currentIndex];
        case MQTTAppConnectionState.disconnected:
          return ConnectionLostPage();
        default:
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
              SizedBox(
                height: 20,
              ),
              Text(
                "Connecting to MiriHome Server...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          );
      }
    }
  }

  // Bottom Navigation Bar
  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      fixedColor: CupertinoColors.activeBlue,
      type: BottomNavigationBarType.fixed,
      onTap: _onNavigationBarTapped,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
            icon: new Icon(CupertinoIcons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: new Icon(CupertinoIcons.lightbulb),
          label: "Devices",
        ),
        // BottomNavigationBarItem(
        //     icon: new Icon(Icons.sensor_window), label: "Windows"),
        BottomNavigationBarItem(
            icon: new Icon(CupertinoIcons.settings), label: "Settings"),
      ],
    );
  }

  Future Refresh() async {
    HapticFeedback.lightImpact();
    connectToMQTT(serviceLocator<MQTTManager>());
  }
}
