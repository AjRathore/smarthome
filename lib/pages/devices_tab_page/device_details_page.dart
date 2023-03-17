import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miriHome/models/room.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:provider/provider.dart';

class DeviceDetailsPage extends StatefulWidget {
  const DeviceDetailsPage({super.key, required this.device});

  final IDevices device;
  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  late FixedExtentScrollController scrollController;
  int selectedRoom = 0;
  late TextEditingController displayNameController;
  final List<Room> rooms = serviceLocator<RoomProviderService>().rooms;
  late String orgDisplayName;
  late String orgFriendlyName;
  late int orgSelectedRoom;

  @override
  void initState() {
    displayNameController = TextEditingController();
    displayNameController.text = widget.device.displayName;
    if (widget.device.roomIdentifier != "") {
      rooms.forEach((element) {
        if (element.roomIdentifier == widget.device.roomIdentifier) {
          selectedRoom = rooms.indexOf(element);
        }
      });
    }
    orgDisplayName = widget.device.displayName;
    orgFriendlyName = widget.device.zigbeeFriendlyName;
    orgSelectedRoom = selectedRoom;
    scrollController = FixedExtentScrollController(initialItem: selectedRoom);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RoomProvider>(context).Devices;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Device Details'),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: orgDisplayName != displayNameController.text ||
                  orgSelectedRoom != selectedRoom
              ? () {
                  widget.device.displayName = displayNameController.text;
                  widget.device.roomIdentifier =
                      rooms[selectedRoom].roomIdentifier;
                  serviceLocator<RoomProviderService>().ModifyDevice(
                      widget.device, rooms[orgSelectedRoom].roomIdentifier);

                  Navigator.pop(context);
                }
              : null,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Cancel"),
          onPressed: () {
            orgDisplayName != displayNameController.text ||
                    orgSelectedRoom != selectedRoom
                ? showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              child: const Text('Discard Changes'),
                            ),
                            CupertinoActionSheetAction(
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ))
                : Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: CupertinoListSection.insetGrouped(
              children: <CupertinoListTile>[
                CupertinoListTile(
                    title: const Text('Display Name'),
                    additionalInfo: Text(
                      displayNameController.text,
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _openDialogEditDeviceDisplayName(
                        context, widget.device)),
                CupertinoListTile(
                  title: const Text('Room'),
                  additionalInfo: Text(
                    rooms[selectedRoom].roomDisplayName,
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _showDialog(
                    SizedBox(
                      height: 250,
                      child: CupertinoPicker(
                        scrollController: scrollController,
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: 42.0,
                        looping: true,
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          HapticFeedback.selectionClick;
                          setState(() {
                            selectedRoom = selectedItem;
                          });
                        },
                        children:
                            List<Widget>.generate(rooms.length, (int index) {
                          return Center(
                            child: Text(
                              rooms[index].roomDisplayName,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                CupertinoListTile(
                  title: const Text('Friendly Name'),
                  subtitle: Text(
                    widget.device.zigbeeFriendlyName,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          CupertinoListSection.insetGrouped(
            children: [
              CupertinoListTile(
                title: const Text('IEEE Address'),
                additionalInfo: Text(
                  widget.device.ieeeAddress,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              CupertinoListTile(
                title: const Text('Vendor'),
                additionalInfo: Text(
                  widget.device.vendor,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              CupertinoListTile(
                title: const Text('Model'),
                additionalInfo: Text(
                  widget.device.model,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              CupertinoListTile(
                title: const Text('Description'),
                subtitle: Text(
                  widget.device.description,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          "Select a room for this device",
          style: TextStyle(fontSize: 16),
        ),
        actions: [child],
      ),
    );
  }

  void _openDialogEditDeviceDisplayName(
          BuildContext context, IDevices device) =>
      showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => CupertinoAlertDialog(
                  title: Text(
                    "Edit Display Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  content: Column(
                    children: [
                      Text("Enter a display name for this device"),
                      SizedBox(height: 20),
                      CupertinoTextField(
                        controller: displayNameController,
                        placeholder: "Display Name",
                        onChanged: (value) => {setState(() {})},
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                        child: Text("Ok"),
                        onPressed: () => {
                              Navigator.pop(context),
                            }),
                  ]));
}
