import 'package:get_it/get_it.dart';
import 'package:miriHome/Providers/devices_provider.dart';
import 'package:miriHome/Providers/edit_state_provider.dart';
import 'package:miriHome/Providers/mqtt_state_provider.dart';
import 'package:miriHome/Providers/room_provider.dart';
import 'package:miriHome/Providers/user_provider.dart';
import 'package:miriHome/services/MQTT_Service.dart';
import 'package:miriHome/services/mqtt_state_provider_service.dart';
import 'package:miriHome/services/room_data_storage.dart';
import 'package:miriHome/services/room_provider_service.dart';

import '../managers/MQTTManager.dart';
import '../services/local_storage_service.dart';

GetIt serviceLocator = GetIt.instance;
setupLocator() {
  //var instance = await LocalStorageService.getInstance();
  //serviceLocator.registerSingleton<LocalStorageService>(instance!);
  //serviceLocator.registerLazySingleton(() => LocalStorageService());
  serviceLocator.registerLazySingleton(() => MQTTManager());
  serviceLocator.registerLazySingleton(() => RoomProvider());
  serviceLocator.registerLazySingleton(() => MqttConnectionStateProvider());
  serviceLocator.registerLazySingleton(() => RoomProviderService());
  serviceLocator.registerLazySingleton(() => MqttStateProviderService());
  serviceLocator.registerLazySingleton(() => MQTTService());
  serviceLocator.registerLazySingleton(() => DevicesProvider());
  serviceLocator.registerLazySingleton(() => EditStateProvider());
  serviceLocator.registerLazySingleton(() => RoomDataStorageService());
  serviceLocator.registerLazySingleton(() => UserProvider());
}
