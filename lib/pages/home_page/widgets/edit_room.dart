import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miriHome/models/room.dart';
import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class EditRoom extends StatefulWidget {
  EditRoom({super.key, required this.room});

  final Room room;

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  final TextEditingController roomNameController = TextEditingController();
  File? image;
  String? imageFileName;
  @override
  void initState() {
    super.initState();
    roomNameController.text = widget.room.roomDisplayName;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.width;
    return CupertinoAlertDialog(
        title: Text(
          "Edit Room",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          children: [
            Text("Enter a name and pick an image for this room"),
            SizedBox(height: 20),
            Container(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    pickImage();
                  },
                  child: Card(
                    child: Container(
                      width: _width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: image != null
                                  ? Image.file(image!)
                                  : image == null &&
                                          widget.room.image != "" &&
                                          widget.room.image !=
                                              "assets/Images/LivingRoom.png"
                                      ? Image(
                                          image: FileImage(File(
                                              AppConfig.appPath +
                                                  "/" +
                                                  widget.room.image)))
                                      : Image.asset(
                                          "assets/Images/LivingRoom.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            CupertinoTextField(
              controller: roomNameController,
              placeholder: "Title",
              onChanged: (value) => {setState(() {})},
            ),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text("Save"),
            onPressed: roomNameController.text != ""
                ? () {
                    serviceLocator<RoomProviderService>().ModifyRoomDetails(
                        widget.room.roomDisplayName,
                        roomNameController.text,
                        image == null ? widget.room.image : imageFileName!);
                    Navigator.pop(context);
                  }
                : null,
          ),
        ]);
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      final appDir = (await syspaths.getApplicationDocumentsDirectory()).path;
      // final fileName = "${roomNameController.text}.jpg";
      // final savedImage = await imageTemp.copy('${appDir.path}/$fileName');
      // log('${appDir.path}/$fileName');
      // imageFileName = '${appDir.path}/$fileName';
      final basDir = path.basename(appDir);
      final fileName = path.basename(image.path);
      final File localImage = await imageTemp.copy('$appDir/$fileName');
      imageFileName = '/$fileName';
      setState(() => this.image = localImage);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
