import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:miriHome/helpers/app_config.dart';
import 'package:path_provider/path_provider.dart';

class RoomDataStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    AppConfig.appPath = path;
    log("Appconfig path: " + AppConfig.appPath);
    return File('$path/roomdata.json');
  }

  void CreateFile() async {
    log("Calling local file creation");
    await _localFile;
  }

  Future<String> readRoomData() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeRoomData(String jsonRoom) async {
    final file = await _localFile;

    // Write the file
    return await file.writeAsString(jsonRoom);
  }
}
