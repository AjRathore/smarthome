import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miriHome/pages/navigation_page/navigation_page.dart';
import 'package:miriHome/pages/setup_screen/widgets/name_field.dart';
import 'package:miriHome/pages/setup_screen/widgets/get_started_button.dart';
import 'package:miriHome/pages/setup_screen/widgets/password_field.dart';
import 'package:miriHome/pages/setup_screen/widgets/server_address.dart';
import 'package:miriHome/pages/setup_screen/widgets/username_field.dart';
import 'package:miriHome/helpers/service_locator.dart';
import 'package:miriHome/services/local_storage_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController userNameController;
  late TextEditingController serverAddressController;
  late TextEditingController passwordController;
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  @override
  void initState() {
    firstNameController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    serverAddressController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: loadingBallAppear
            ? NavigationPage()
            : Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 70),
                        TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300),
                          tween: Tween(begin: 1, end: _elementsOpacity),
                          builder: (_, value, __) => Opacity(
                            opacity: value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage:
                                      Image.asset("assets/Icons/MiriHome.png")
                                          .image,
                                  backgroundColor: Colors.transparent,
                                ),
                                SizedBox(height: 25),
                                Text(
                                  "Welcome to MiriHome",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                                Text(
                                  "Setup to continue",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              NameField(
                                  fadeFirstName: _elementsOpacity == 0,
                                  firstNameController: firstNameController),
                              SizedBox(height: 20),
                              ServerAddress(
                                  fadeServerAddress: _elementsOpacity == 0,
                                  serverAddressController:
                                      serverAddressController),
                              SizedBox(height: 20),
                              UserNameField(
                                  fadeUserName: _elementsOpacity == 0,
                                  userNameController: userNameController),
                              SizedBox(height: 20),
                              PasswordField(
                                  fadePassword: _elementsOpacity == 0,
                                  passwordController: passwordController),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          width: double.infinity,
                          child: GetStartedButton(
                            elementsOpacity: _elementsOpacity,
                            onTap: () {
                              setState(() {
                                final form = formKey.currentState;
                                if (form!.validate()) {
                                  log("Info - ${LocalStorageService.MQTTUserName}");
                                  _elementsOpacity = 0;
                                  LocalStorageService.SetFirstName =
                                      firstNameController.text;
                                  LocalStorageService.SetUserImage =
                                      "assets/Images/flutter_dash1.png";
                                  LocalStorageService.SetServerAddress =
                                      serverAddressController.text;
                                  LocalStorageService.SetMQTTUserName =
                                      userNameController.text;
                                  LocalStorageService.SetPassword =
                                      passwordController.text;
                                }
                              });
                            },
                            onAnimatinoEnd: () async {
                              await Future.delayed(Duration(milliseconds: 500));
                              setState(() {
                                loadingBallAppear = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void ShowInfoDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text("Error"),
                content: Text(
                    "Please fill the information correctly in order to proceed"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }

  bool isValidName(String firstName) {
    return RegExp(r"^(?=.{3,40}$)[a-zA-Z]+(?:[-'\s][a-zA-Z]+)*$")
        .hasMatch(firstName);
  }

  bool isValidServerAddress(String serverAddress) {
    return RegExp(r"\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b")
        .hasMatch(serverAddress);
  }
}
