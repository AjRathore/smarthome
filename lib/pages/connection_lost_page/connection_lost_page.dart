import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miriHome/pages/setup_screen/setup_screen.dart';

import '../../helpers/app_config.dart';
import '../../helpers/service_locator.dart';
import '../../managers/MQTTManager.dart';

class ConnectionLostPage extends StatefulWidget {
  const ConnectionLostPage({super.key});

  @override
  State<ConnectionLostPage> createState() => _ConnectionLostPageState();
}

class _ConnectionLostPageState extends State<ConnectionLostPage> {
  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //serviceLocator<MQTTManager>().disconnect();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<MqttConnectionStateProvider>().getMqttConnectionState;
    return RefreshIndicator(
      color: CupertinoColors.activeBlue,
      onRefresh: () => Refresh(context),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          height: (MediaQuery.of(context).size.height) * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.router,
                      color: Colors.red,
                      size: 64,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "You're not connected to ${AppConfig.appDisplayName} Server!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Please refresh or restart the app",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Or",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CupertinoButton(
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future Refresh(BuildContext context) async {
    HapticFeedback.lightImpact();
    connectToMQTT(serviceLocator<MQTTManager>());
    // Navigator.of(context).pushReplacement(new MaterialPageRoute(
    //     builder: (BuildContext context) =>Navigation));
  }

  void connectToMQTT(MQTTManager manager) async {
    await Future.any([manager.initializeMQTTClient()]);
  }
}
