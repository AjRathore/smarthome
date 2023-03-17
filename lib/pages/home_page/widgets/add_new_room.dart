import 'dart:io';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miriHome/models/room.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/services/room_provider_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class AddNewRoom extends StatefulWidget {
  const AddNewRoom({super.key});

  @override
  State<AddNewRoom> createState() => _AddNewRoomState();
}

class _AddNewRoomState extends State<AddNewRoom> {
  final TextEditingController roomNameController = TextEditingController();
  File? image;
  String? imageFileName;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.width;
    return CupertinoAlertDialog(
        title: Text(
          "New Room",
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
                                    : Center(
                                        child: Icon(
                                          CupertinoIcons.photo,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                      )),
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
                    var newRoom = CreateANewRoom(
                        roomNameController.text,
                        image == null
                            ? "assets/Images/LivingRoom.png"
                            : imageFileName!);

                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      serviceLocator<RoomProviderService>().AddRoom(newRoom);
                    });
                  }
                : null,
          ),
        ]);
  }

  Room CreateANewRoom(String roomName, String image) {
    Room room = new Room(
        roomName, DateTime.now().microsecondsSinceEpoch.toString(), image, []);
    return room;
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
      final baseDir = path.basename(appDir);
      final fileName = path.basename(image.path);
      final File localImage = await imageTemp.copy('$appDir/$fileName');
      imageFileName = '/$fileName';
      setState(() => this.image = localImage);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
