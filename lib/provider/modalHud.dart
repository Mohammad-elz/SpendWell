import 'package:flutter/cupertino.dart';

class ModalHud extends ChangeNotifier {
  bool isLoading = false;

  ChangeisLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
