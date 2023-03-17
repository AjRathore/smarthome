import 'dart:developer';

import 'package:miriHome/helpers/mqtt_json_handling.dart';
import 'package:miriHome/services/local_storage_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../Providers/room_provider.dart';
import '../helpers/device_information.dart';
import '../services/mqtt_state_provider_service.dart';
import '../helpers/service_locator.dart';

class MQTTManager {
  DeviceInformation _deviceInformation = DeviceInformation();
  MQTT_JSON_Handling mqttJsonHandler = MQTT_JSON_Handling();
  ////RoomProvider roomProvider = RoomProvider();
  late MqttServerClient _client;
  String get host => _host;
  MQTT_JSON_Handling get currentState => mqttJsonHandler;
  late String _identifier;
  late String _host;
  String _topic = "";

  Future<MqttServerClient> initializeMQTTClient() async {
    String savedHost = LocalStorageService.ServerAddress;
    String savedUserName = LocalStorageService.MQTTUserName;
    String savedPassword = LocalStorageService.MQTTPassword;
    // Save the values
    ////this.roomProvider = roomProvider;
    _identifier = await _deviceInformation.getDeviceInfo();
    _host = savedHost; //"192.168.178.35";
    _client = MqttServerClient(_host, _identifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure = false;
    _client.logging(on: false);

    /// Add the successful connection callback
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    //_client.onUnsubscribed = onUnsubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        //.authenticateAs('RathoreMQTT', 'syxQo6-rajdib-hukfoc')
        .authenticateAs(savedUserName, savedPassword)
        .withClientIdentifier(_identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        //.authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    log("Mosquitto client connecting...", time: DateTime.now());
    _client.connectionMessage = connMess;
    assert(_client != null);
    try {
      log('Mosquitto start client connecting....', time: DateTime.now());
      serviceLocator<MqttStateProviderService>()
          .UpdateState(MQTTAppConnectionState.connecting);
      //mqttJsonHandler.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client.connect();
      // // Future.delayed(
      // //     Duration(seconds: 10), (() async => {await _client.connect()}));
    } on Exception catch (e) {
      log('client exception - $e', time: DateTime.now());
      disconnect();
    }
    return _client;
  }

  // Connect to the host
  void connect() async {
    assert(_client != null);
    try {
      log("Mosquitto client connecting...", time: DateTime.now());
      serviceLocator<MqttStateProviderService>()
          .UpdateState(MQTTAppConnectionState.connecting);
      //mqttJsonHandler.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client.connect();
    } on Exception catch (e) {
      log('client exception - $e', time: DateTime.now());
      disconnect();
    }
  }

  void disconnect() {
    log('Mosquitto client Disconnected', time: DateTime.now());
    _client.disconnect();
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    ////final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    log('Mosquitto client::Subscription confirmed for topic $topic',
        time: DateTime.now());
    serviceLocator<MqttStateProviderService>()
        .UpdateState(MQTTAppConnectionState.connectedSubscribed);
    //mqttJsonHandler.setAppConnectionState(MQTTAppConnectionState.connectedSubscribed);
    updateState();
  }

  void onUnsubscribed(String topic) {
    log('Mosquitto client::onUnsubscribed confirmed for topic $topic',
        time: DateTime.now());
    mqttJsonHandler.clearText();
    serviceLocator<MqttStateProviderService>()
        .UpdateState(MQTTAppConnectionState.connectedUnSubscribed);
    //mqttJsonHandler.setAppConnectionState(MQTTAppConnectionState.connectedUnSubscribed);
    updateState();
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    log('Mosquitto client::OnDisconnected client callback - Client disconnection',
        time: DateTime.now());
    if (_client.connectionStatus?.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      log('Mosquitto client::OnDisconnected callback is solicited, this is correct',
          time: DateTime.now());
    }
    mqttJsonHandler.clearText();
    //mqttJsonHandler.setAppConnectionState(MQTTAppConnectionState.disconnected);
    serviceLocator<MqttStateProviderService>()
        .UpdateState(MQTTAppConnectionState.disconnected);
    updateState();
  }

  /// The successful connect callback
  void onConnected() {
    serviceLocator<MqttStateProviderService>()
        .UpdateState(MQTTAppConnectionState.connected);
    //mqttJsonHandler.setAppConnectionState(MQTTAppConnectionState.connected);
    updateState();
    subScribeTo("zigbee2mqtt/bridge/devices");
    subScribeTo("zigbee2mqtt/+");

    log('Mosquitto client connected.... Client connection was sucessful',
        time: DateTime.now());
  }

  void subScribeTo(String topic) {
    // Save topic for future use
    _topic = topic;
    _client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      mqttJsonHandler.ConvertReceivedTextToRoomInfo(pt, c[0].topic);
      updateState();
      // print(
      //     'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      // print('');
    });
  }

  /// Unsubscribe from a topic
  void unSubscribe(String topic) {
    _client.unsubscribe(topic);
  }

  /// Unsubscribe from a topic
  void unSubscribeFromCurrentTopic() {
    _client.unsubscribe(_topic);
  }

  void updateState() {
    //controller.add(_currentState);
    //notifyListeners();
  }
}
