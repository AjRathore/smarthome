import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/models/temp_sensor.dart';
import 'package:miriHome/pages/connection_lost_page/connection_lost_page.dart';
import 'package:miriHome/Providers/mqtt_state_provider.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/pages/devices_tab_page/widgets/add_device_widget.dart';
import 'package:miriHome/pages/devices_tab_page/widgets/device_item.dart';
import 'package:miriHome/helpers/mqtt_json_handling.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/services/MQTT_Service.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Devices extends StatefulWidget {
  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  List<TempSensor> tempSensorsList = [];

  @override
  Widget build(BuildContext context) {
    return GetAppropriateConnectionStateWidget(context);
  }

  CupertinoPageScaffold BuildMainArea(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    var devicesList = context.watch<RoomProvider>().Devices;
    return CupertinoPageScaffold(
      //height: 300,
      child: RefreshIndicator(
        edgeOffset: 140,
        color: CupertinoColors.activeBlue,
        onRefresh: () => serviceLocator<MQTTService>().Refresh(),
        child: CustomScrollView(
          semanticChildCount: devicesList.length,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
                padding: EdgeInsetsDirectional.only(end: 15),
                largeTitle: Text('Devices'),
                trailing: Material(
                  child: IconButton(
                      color: CupertinoColors.activeBlue,
                      iconSize: 24,
                      onPressed: () {
                        openDialogAddDevices(context);
                      },
                      icon: Icon(CupertinoIcons.add)),
                )),
            SliverSafeArea(
              // ADD from here...
              top: false,
              minimum: const EdgeInsets.only(top: 0),
              sliver: SliverToBoxAdapter(
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: devicesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: DeviceItem(
                              device: devicesList[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // child: CupertinoListSection(
                //   topMargin: 0,
                //   children: [
                //     for (var device in devicesList) DeviceItem(device: device)
                //   ],
                // ),
              ),
            ),
            // SliverList(
            //     delegate: SliverChildBuilderDelegate((context, index) {
            //   return new Container(child: DeviceItem(device: devicesList[index]));
            // }, childCount: devicesList.length)),
          ],
        ),
      ),
    );
  }

  void openDialogAddDevices(BuildContext context) => showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isDismissible: false,
        context: context,
        builder: (context) => AddDevice(),
      );

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
