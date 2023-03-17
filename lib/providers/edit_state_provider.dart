import 'package:flutter/cupertino.dart';

class EditStateProvider with ChangeNotifier {
  bool isHomePageUIBeingEdited = false;
  bool isRoomPageUIBeingEdited = false;

  void SetHomePageUIBeingEdited(bool editMode) {
    isHomePageUIBeingEdited = editMode;
    notifyListeners();
  }

  void SetRoomPageUIBeingEdited(bool editMode) {
    isRoomPageUIBeingEdited = editMode;
    notifyListeners();
  }
}
