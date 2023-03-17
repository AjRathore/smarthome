import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/pages/home_page/widgets/add_new_room.dart';
import 'package:provider/provider.dart';
import 'package:miriHome/Providers/edit_state_provider.dart';
import 'package:miriHome/pages/devices_tab_page/widgets/add_device_widget.dart';

class AddMenuWidget extends StatelessWidget {
  const AddMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUIBeingEdited =
        context.watch<EditStateProvider>().isHomePageUIBeingEdited;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: DividerThemeData(
          color: Colors.black,
        ),
      ),
      child: PopupMenuButton(
        enabled: !isUIBeingEdited,
        color: CupertinoColors.tertiarySystemBackground,
        icon: Icon(CupertinoIcons.add,
            color: isUIBeingEdited ? Colors.grey : CupertinoColors.activeBlue),
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            child: CupertinoListTile(
                trailing: Icon(Icons.meeting_room),
                title: const Text('Add a room'),
                onTap: () {
                  Navigator.pop(context);
                  openDialogAddRoom(context);
                }),
          ),
          PopupMenuItem(
            child: CupertinoListTile(
                trailing: Icon(CupertinoIcons.lightbulb),
                title: Text('Add a device'),
                onTap: () {
                  Navigator.pop(context);
                  openDialogAddDevices(context);
                }),
          ),
        ],
      ),
    );
  }

  void openDialogAddRoom(BuildContext context) => showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddNewRoom(),
      );

  void openDialogAddDevices(BuildContext context) => showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isDismissible: false,
        context: context,
        builder: (context) => AddDevice(),
      );
}
