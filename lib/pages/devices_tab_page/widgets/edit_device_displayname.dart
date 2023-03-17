import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miriHome/interfaces/idevices.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class EditDeviceDisplayName extends StatefulWidget {
  EditDeviceDisplayName(
      {super.key, required this.device, required this.displayNameController});

  final IDevices device;
  final TextEditingController displayNameController;

  @override
  State<EditDeviceDisplayName> createState() => _EditDeviceDisplayName();
}

class _EditDeviceDisplayName extends State<EditDeviceDisplayName> {
  late TextEditingController displayNameController;
  File? image;
  String? imageFileName;
  @override
  void initState() {
    super.initState();
    displayNameController = widget.displayNameController;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.width;
    return CupertinoAlertDialog(
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
            onPressed: displayNameController.text != ""
                ? () {
                    Navigator.pop(context);
                    log("device display name edited");
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
