import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/models/room.dart';
import 'package:miriHome/pages/home_page/widgets/edit_room.dart';
import 'package:miriHome/pages/home_page/widgets/room_number_devices.dart';
import 'package:miriHome/pages/room_details_page/room_detail_page.dart';
import 'package:miriHome/Providers/edit_state_provider.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class RoomWidget extends StatefulWidget {
  const RoomWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RoomWidget> createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  double _height = 0.0;
  double _width = 0.0;
  double _imageHeight = 0.0;
  bool isUiBeingEdited = false;
  List<Room> roomsList = [];

  @override
  Widget build(BuildContext context) {
    context.watch<RoomProvider>().rooms;
    isUiBeingEdited =
        context.watch<EditStateProvider>().isHomePageUIBeingEdited;
    log("Building rooms widget", time: DateTime.now());
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _imageHeight = _height * 0.2;
    roomsList = context.read<RoomProvider>().rooms;

    if (isUiBeingEdited) {
      _updateImageHeight();
    }

    return Container(
      height: _height * 0.35,
      child: AnimationLimiter(
        key: ValueKey(roomsList.length),
        child: ListView.builder(
          //physics: ScrollableState,
          itemCount: roomsList.length,
          //controller: scrollController,
          scrollDirection: Axis.horizontal,

          itemBuilder: (context, index) {
            if (roomsList[index].roomDisplayName != "None") {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: isUiBeingEdited
                          ? null
                          : () {
                              Navigator.push(context,
                                  CupertinoPageRoute<Widget>(
                                      builder: (BuildContext context) {
                                return DetailPage(room: roomsList[index]);
                              }));
                            },
                      child: Ink(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                          child: SingleChildScrollView(
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: isUiBeingEdited,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onPressed: isUiBeingEdited
                                                ? () => openDialogEditRoom(
                                                    context, roomsList[index])
                                                : null,
                                            icon: Icon(CupertinoIcons
                                                .pencil_ellipsis_rectangle),
                                            color: CupertinoColors.activeBlue,
                                          ),
                                          IconButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onPressed: isUiBeingEdited
                                                ? () {
                                                    ShowDeleteRoomDialog(
                                                        context,
                                                        roomsList[index]);
                                                  }
                                                : null,
                                            icon: Icon(
                                              CupertinoIcons.delete,
                                              size: 20,
                                            ),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: _width * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 3),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: AnimatedSize(
                                                curve: Curves.easeIn,
                                                duration: const Duration(
                                                    milliseconds: 600),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: _imageHeight,
                                                  child: roomsList[index]
                                                              .image ==
                                                          "assets/Images/LivingRoom.png"
                                                      ? Image.asset(
                                                          roomsList[index]
                                                              .image)
                                                      : Image(
                                                          image: FileImage(File(
                                                              AppConfig
                                                                      .appPath +
                                                                  "/" +
                                                                  roomsList[
                                                                          index]
                                                                      .image))),
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 8.0, 8.0, 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                                child: NumberOfDevicesInRoom(
                                                    index: index),
                                                // Text(
                                                //   roomsList[index].devices.length == 1
                                                //       ? "${roomsList[index].devices.length} Device Connected"
                                                //       : "${roomsList[index].devices.length} Devices Connected",
                                                //   style: TextStyle(color: Colors.grey),
                                                // ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: Text(
                                                  "${roomsList[index].roomDisplayName}",
                                                  style:
                                                      TextStyle(fontSize: 20.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void ShowDeleteRoomDialog(BuildContext context, Room room) {
    showCupertinoModalPopup<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(
                  "Delete '${room.roomDisplayName}'",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(
                    "Are you sure you want to delete the room '${room.roomDisplayName}'?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text("Delete"),
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        serviceLocator<RoomProviderService>()
                            .DeleteRoom(room.roomIdentifier);
                      });
                    },
                  ),
                ]));
  }

  void openDialogEditRoom(BuildContext context, Room room) =>
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => EditRoom(room: room),
      );

  void _updateImageHeight() {
    setState(() {
      _imageHeight = isUiBeingEdited ? _height * 0.15 : _height * 0.2;
    });
  }
}
