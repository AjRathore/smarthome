import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _preferences;

  static const String KeyIsSetupScreenShown = "IsSetupScreenShown";
  static const String KeyFirstName = "FirstName";
  static const String KeyServerAddress = "ServerAddress";
  static const String KeyMQTTUserName = "MQTTUserName";
  static const String KeyMQTTPassword = "MQTTPassword";
  static const String KeyIsDummyRoomSaved = "IsDummyRoomSaved";
  static const String KeyIsSimulationMode = "IsSimulationMode";
  static const String KeyUserImage = "UserImage";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static String get FirstName {
    var firstName = _getFromDisk(KeyFirstName);
    if (firstName == null) {
      return "User";
    }

    return firstName;
  }

  static String get ServerAddress {
    var serverAddress = _getFromDisk(KeyServerAddress);
    if (serverAddress == null) {
      return "";
    }

    return serverAddress;
  }

  static String get MQTTUserName {
    var mqttUserName = _getFromDisk(KeyMQTTUserName);
    if (mqttUserName == null) {
      return "";
    }

    return mqttUserName;
  }

  static String get MQTTPassword {
    var mqttPassword = _getFromDisk(KeyMQTTPassword);
    if (mqttPassword == null) {
      return "";
    }

    return mqttPassword;
  }

  static bool get IsSetupScreenShownOnce {
    var isSetupScreenShownOnce = _getFromDisk(KeyIsSetupScreenShown);
    if (isSetupScreenShownOnce == null) {
      return false;
    }

    return isSetupScreenShownOnce;
  }

  static bool get IsDummyRoomSaved {
    var isDummyRoomSaved = _getFromDisk(KeyIsDummyRoomSaved);
    if (isDummyRoomSaved == null) {
      return false;
    }

    return isDummyRoomSaved;
  }

  static bool get IsSumulationMode {
    var isSimulationMode = _getFromDisk(KeyIsSimulationMode);
    if (isSimulationMode == null) {
      return false;
    }

    return isSimulationMode;
  }

  static String get UserImage {
    var userImage = _getFromDisk(KeyUserImage);
    if (userImage == null) {
      return "";
    }

    return userImage;
  }

  static set SetFirstName(String value) => saveToDisk(KeyFirstName, value);
  static set SetServerAddress(String value) =>
      saveToDisk(KeyServerAddress, value);
  static set SetMQTTUserName(String value) =>
      saveToDisk(KeyMQTTUserName, value);
  static set SetPassword(String value) => saveToDisk(KeyMQTTPassword, value);
  static set SetIsSetupScreenShown(bool value) =>
      saveToDisk(KeyIsSetupScreenShown, value);
  static set SetIsDummyRoomSaved(bool value) =>
      saveToDisk(KeyIsDummyRoomSaved, value);
  static set SetIsSimulationMode(bool value) =>
      saveToDisk(KeyIsSimulationMode, value);
  static set SetUserImage(String value) => saveToDisk(KeyUserImage, value);

  static dynamic _getFromDisk(String key) {
    var value = _preferences!.get(key);
    log('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  static void saveToDisk<T>(String key, T content) {
    log('(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    if (content is String) {
      _preferences!.setString(key, content);
    }
    if (content is bool) {
      _preferences!.setBool(key, content);
    }
  }
}
