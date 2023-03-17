import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miriHome/models/user.dart';
import 'package:miriHome/pages/home_page/widgets/total_number_devices.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/Providers/user_provider.dart';
import 'package:miriHome/helpers/app_config.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:provider/provider.dart';

class WelcomeCenter extends StatelessWidget {
  const WelcomeCenter({super.key});

  @override
  Widget build(BuildContext context) {
    LocalStorageService.SetIsSetupScreenShown = true;
    log("Building Welcome Center", time: DateTime.now());
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy');
    final String customDate = formatter.format(now);
    final String currentUserImagePath = LocalStorageService.UserImage;
    User currentUser = context.watch<UserProvider>().user;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage: GetUserImage(currentUser.userImagePath),
                backgroundColor: Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 10.0),
                child: Text(
                  "Welcome Home, ${currentUser.userName}!",
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                child: Text(customDate),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                //padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Icon(
                  LocalStorageService.IsSumulationMode
                      ? CupertinoIcons.wifi_slash
                      : Icons.router,
                  size: 48.0,
                  color: LocalStorageService.IsSumulationMode
                      ? CupertinoColors.systemRed
                      : Colors.green,
                ),
              ),
              LocalStorageService.IsSumulationMode
                  ? Text(
                      "Simulation Mode.",
                      style: TextStyle(color: Colors.black),
                    )
                  : Text(
                      "You're connected to ${AppConfig.appDisplayName} Server.",
                      style: TextStyle(color: Colors.black),
                    ),
              BuildNumberOfDevices(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildNumberOfDevices(BuildContext context) {
    int numberOfActiveDevices = context.read<RoomProvider>().activeDevices;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      //padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.home,
            color: Colors.black,
          ),
          TotalNumberOfDevices(),
        ],
      ),
    );
  }

  ImageProvider GetUserImage(String imagePath) {
    if (imagePath == "" || imagePath == "assets/Images/flutter_dash1.png") {
      return Image.asset("assets/Images/flutter_dash1.png").image;
    } else {
      return Image(image: FileImage(File(AppConfig.appPath + "/" + imagePath)))
          .image;
    }
  }
}
