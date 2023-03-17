import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/models/user.dart';
import 'package:miriHome/pages/edit_profile_page/edit_profile.dart';
import 'package:miriHome/Providers/user_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:miriHome/pages/setup_screen/setup_screen.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_config.dart';
import '../../services/local_storage_service.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController firstNameController = TextEditingController();
  bool _simulationMode = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<UserProvider>().user;
    String currentUserImagePath = LocalStorageService.UserImage;
    _simulationMode = LocalStorageService.IsSumulationMode;
    return CupertinoPageScaffold(
        child: CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text("Settings"),
        ),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 0),
          sliver: SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              children: <CupertinoListTile>[
                CupertinoListTile(
                  padding: EdgeInsets.only(left: 10, right: 15),
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: GetUserImage(currentUser.userImagePath),
                    backgroundColor: Colors.transparent,
                  ),
                  leadingSize: 68,
                  title: Text(
                    currentUser.userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      isDismissible: false,
                      enableDrag: false,
                      expand: true,
                      context: context,
                      backgroundColor:
                          CupertinoTheme.of(context).scaffoldBackgroundColor,
                      builder: (context) => EditProfilePage(
                        currentUser: currentUser,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 0),
          sliver: SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              children: <CupertinoListTile>[
                CupertinoListTile(
                  title: Text('App Name'),
                  additionalInfo: Text(AppConfig.appDisplayName),
                ),
                CupertinoListTile(
                  title: Text('Version'),
                  additionalInfo: Text(_packageInfo.version),
                ),
                CupertinoListTile(
                  title: Text('Build Number'),
                  additionalInfo: Text(_packageInfo.buildNumber),
                ),
              ],
            ),
          ),
        ),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 0),
          sliver: SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              children: <CupertinoListTile>[
                CupertinoListTile(
                  title: Text('Server Address'),
                  additionalInfo: Text(LocalStorageService.ServerAddress),
                ),
              ],
            ),
          ),
        ),
        SliverSafeArea(
            top: false,
            minimum: const EdgeInsets.only(top: 0),
            sliver: SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                children: <CupertinoListTile>[
                  CupertinoListTile(
                    padding: EdgeInsets.fromLTRB(20, 15, 10, 10),
                    title: Text('Simulation Mode'),
                    trailing: CupertinoSwitch(
                      value: _simulationMode,
                      onChanged: (newVal) {
                        setState(() {
                          _simulationMode = newVal;
                          LocalStorageService.SetIsSimulationMode =
                              _simulationMode;
                          //ShowInfoDialog(context);
                        });
                      },
                    ),
                    subtitle: Text(
                      "Please restart the app for proper functioning of simulation mode.",
                      maxLines: 2,
                    ),
                  ),
                  CupertinoListTile(
                    title: CupertinoButton(
                      padding: EdgeInsetsDirectional.zero,
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            new CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    SetupScreen()),
                            ((route) => false));
                      },
                      child: Text("Setup ${AppConfig.appDisplayName}",
                          style: TextStyle(fontSize: 18)),
                      //padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    ),
                  ),
                  CupertinoListTile(
                    title: CupertinoButton(
                      padding: EdgeInsetsDirectional.zero,
                      onPressed: () {
                        showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                    title: const Text("Info"),
                                    content: Text(
                                        "Restarting server is currently not supported"),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text("Ok"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]));
                      },
                      child: Text("Restart ${AppConfig.appDisplayName} Server",
                          style: TextStyle(fontSize: 18)),
                      //padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    ),
                  ),
                ],
              ),
            ))
      ],
    ));
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  ImageProvider GetUserImage(String imagePath) {
    if (imagePath == "" || imagePath == "assets/Images/flutter_dash1.png") {
      return Image.asset("assets/Images/flutter_dash1.png").image;
    } else {
      return Image(image: FileImage(File(AppConfig.appPath + "/" + imagePath)))
          .image;
    }
  }

  void ShowInfoDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text("Info"),
                content: Text("Please restart the app"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }
}
