import 'package:miriHome/helpers/mqtt_json_handling.dart';
import 'package:miriHome/helpers/service_locator.dart';

import '../Providers/mqtt_state_provider.dart';

class MqttStateProviderService {
  UpdateState(MQTTAppConnectionState state) {
    serviceLocator<MqttConnectionStateProvider>().UpdateState(state);
  }
}
