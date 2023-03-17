import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/pages/home_page/widgets/rooms_widget.dart';
import 'package:miriHome/pages/home_page/widgets/welcome_center.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:miriHome/Providers/mqtt_state_provider.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/helpers/service_locator.dart';
import '../../models/room.dart';
import '../../Providers/edit_state_provider.dart';
import 'widgets/add_menu_widget.dart';
import '../../helpers/app_config.dart';
import '../../helpers/mqtt_json_handling.dart';
import '../../services/MQTT_Service.dart';
import '../../services/room_provider_service.dart';
import '../connection_lost_page/connection_lost_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// stateful widget for Home Page
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  late Room debugRoom;
  late String editModeText;
  bool isHomePageUIBeingEdited = false;
  @override
  Widget build(BuildContext context) {
    return GetAppropriateConnectionStateWidget(context);
  }

  CupertinoPageScaffold BuildMainArea(BuildContext context) {
    int numberofRooms = context.watch<RoomProvider>().rooms.length;
    isHomePageUIBeingEdited =
        context.read<EditStateProvider>().isHomePageUIBeingEdited;
    editModeText = isHomePageUIBeingEdited ? "Done" : "Edit";
    log(DateTime.now().toString() + " Building Home page",
        time: DateTime.now());
    return CupertinoPageScaffold(
      child: RefreshIndicator(
        edgeOffset: 140,
        color: CupertinoColors.activeBlue,
        onRefresh: () => serviceLocator<MQTTService>().Refresh(),
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              padding: EdgeInsetsDirectional.only(start: 10, end: 10),
              largeTitle: Text(AppConfig.appDisplayName),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  editModeText,
                  style: TextStyle(
                      color: context
                                  .read<EditStateProvider>()
                                  .isHomePageUIBeingEdited ||
                              numberofRooms != 0 && numberofRooms > 1
                          ? CupertinoColors.activeBlue
                          : CupertinoColors.systemGrey),
                ),
                onPressed:
                    context.read<EditStateProvider>().isHomePageUIBeingEdited ||
                            numberofRooms != 0 && numberofRooms > 1
                        ? () {
                            setState(() {
                              if (editModeText == "Edit") {
                                editModeText = "Done";
                                context
                                    .read<EditStateProvider>()
                                    .SetHomePageUIBeingEdited(true);
                              } else {
                                editModeText = "Edit";
                                context
                                    .read<EditStateProvider>()
                                    .SetHomePageUIBeingEdited(false);
                                serviceLocator<RoomProviderService>()
                                    .ConvertAndSaveRoomsToJson();
                              }
                            });
                          }
                        : null,
              ),
              trailing: Material(child: AddMenuWidget()),
            ),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 0),
              sliver: SliverToBoxAdapter(
                child: buildWelcomeCenter(),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Welcome Center widget
  Center buildWelcomeCenter() {
    var roomsCount = context.watch<RoomProvider>().rooms.length;
    return new Center(
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 400),
              childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
              children: <Widget>[
                Row(),
                WelcomeCenter(),
                roomsCount == 0 || roomsCount == 1
                    ? Center(
                        child: Text(
                        "No rooms found. Please create rooms",
                        style: TextStyle(fontSize: 16),
                      ))
                    : RoomWidget(),
              ]),
        ),
      ),
    );
  }

  Widget GetAppropriateConnectionStateWidget(BuildContext context) {
    log(
        serviceLocator<MqttConnectionStateProvider>()
            .getMqttConnectionState
            .toString(),
        time: DateTime.now());
    if (LocalStorageService.IsSumulationMode) {
      return BuildMainArea(context);
    } else {
      switch (
          context.watch<MqttConnectionStateProvider>().getMqttConnectionState) {
        case MQTTAppConnectionState.disconnected:
          return Material(child: ConnectionLostPage());
        case MQTTAppConnectionState.connectedSubscribed:
          return BuildMainArea(context);
        default:
          return Material(
            child: Center(
              child: Column(
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
              ),
            ),
          );
      }
    }
  }
}
