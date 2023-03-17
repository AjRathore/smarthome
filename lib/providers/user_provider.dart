import 'package:flutter/material.dart';
import 'package:miriHome/models/user.dart';
import 'package:miriHome/services/local_storage_service.dart';

class UserProvider with ChangeNotifier {
  late User _user;

  User get user {
    return _user;
  }

  User CreateUser(String userName, String userImagePath) {
    _user = new User(userName, userImagePath);
    return _user;
  }

  void ModifyUserDetails(String userName, String userImagePath) {
    if (user.userName != userName) {
      _changeUserName(userName);
    }
    _changeUserImage(userImagePath);
    // if (user.userImagePath != userImagePath && userImagePath != "") {
    //   _changeUserImage(userImagePath);
    // }
    notifyListeners();
  }

  void _changeUserName(String userName) {
    user.userName = userName;
    LocalStorageService.SetFirstName = userName;
  }

  void _changeUserImage(String userImagePath) {
    user.userImagePath = userImagePath;
    LocalStorageService.SetUserImage = userImagePath;
  }
}
