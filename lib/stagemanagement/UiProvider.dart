import 'package:flutter/cupertino.dart';

class UiProvider with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _editable = false;
  bool get editable => _editable;

  bool _triger = true;
  bool get triger => _triger;

  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;
  set isLoggingOut(bool value) {
    _isLoggingOut = value;
    notifyListeners();
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void setIndex(int index) async {
    if (selectedIndex == index) {
      if (index == 0 || index == 1) {
        scrollToTop();
        notifyListeners();
      }
    } else {
      selectedIndex = index;
      notifyListeners();
    }
    notifyListeners();
  }

  void trigers(bool x) {
    if (x == true) {
      _triger = false;
    } else {
      _triger = true;
    }
    notifyListeners();
  }

  void iseditable(bool x) {
    if (x == true) {
      _editable = false;
    } else {
      _editable = true;
    }
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
