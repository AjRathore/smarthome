import 'package:flutter/material.dart';
import 'package:miriHome/helpers/mqtt_json_handling.dart';

class MqttConnectionStateProvider with ChangeNotifier {
  MQTTAppConnectionState appConnectionState =
      MQTTAppConnectionState.disconnected;
  MQTTAppConnectionState get getMqttConnectionState {
    return appConnectionState;
  }

  UpdateState(MQTTAppConnectionState state) {
    appConnectionState = state;
    notifyListeners();
  }
}
