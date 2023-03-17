import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/models/user.dart';
import 'package:miriHome/Providers/user_provider.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:miriHome/pages/edit_profile_page/widgets/profile_widget.dart';

class EditProfilePage extends StatefulWidget {
  final User currentUser;
  EditProfilePage({required this.currentUser});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  File? image;
  String imageFileName = "";
  late String currentUserImagePath;
  late User tempUser;

  @override
  void initState() {
    super.initState();
    tempUser = User.Clone(widget.currentUser);
    firstNameController.text = widget.currentUser.userName;
    currentUserImagePath = widget.currentUser.userImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Edit Profile'),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: widget.currentUser.userName != firstNameController.text ||
                  tempUser.userImagePath != widget.currentUser.userImagePath
              // // onPressed: (tempUser.userName != firstNameController.text ||
              // //             imageFileName != "") &&
              // //         firstNameController.text != ""
              ? () {
                  serviceLocator<UserProvider>().ModifyUserDetails(
                      firstNameController.text,
                      widget.currentUser.userImagePath);
                  Navigator.of(context).pop();
                }
              : null,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Cancel"),
          onPressed: () {
            widget.currentUser.userName != firstNameController.text ||
                    widget.currentUser.userImagePath != tempUser.userImagePath
                ? showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                widget.currentUser.userName = tempUser.userName;
                                widget.currentUser.userImagePath =
                                    tempUser.userImagePath;
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
                : Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(
          left: 0,
          top: 50,
          bottom: 8,
          right: 8,
        ),
        child: Column(
          children: [
            ProfileWidget(
              image: GetUserImage(widget.currentUser.userImagePath),
              // imagePath: image != null
              //     ? imageFileName
              //     : image == null && currentUserImagePath == ""
              //         ? "assets/Images/flutter_dash1.png"
              //         : currentUserImagePath,
              onClicked: () {
                _showCupertioActionSheet(context);
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: CupertinoTextField(
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
                controller: firstNameController,
                placeholder: "Name",
                onChanged: (value) => {setState(() {})},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget?> _showCupertioActionSheet(BuildContext context) {
    return showCupertinoModalPopup<Widget>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              pickImage();
            },
            child: const Text(
              'Choose a Photo',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.currentUser.userImagePath =
                    "assets/Images/flutter_dash1.png";
              });
            },
            child: const Text('Choose default Avatar',
                style: TextStyle(color: CupertinoColors.activeBlue)),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
      setState(() => {
            this.image = localImage,
            widget.currentUser.userImagePath = imageFileName
          });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  ImageProvider GetUserImage(String imagepath) {
    if (imagepath == "assets/Images/flutter_dash1.png") {
      return Image.asset("assets/Images/flutter_dash1.png").image;
    } else {
      return Image(image: FileImage(File(AppConfig.appPath + "/" + imagepath)))
          .image;
    }
  }
}
