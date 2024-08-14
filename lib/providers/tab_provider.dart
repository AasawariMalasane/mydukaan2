import 'package:flutter/foundation.dart';

class TabProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    print("TabProvider - setCurrentIndex called with index: $index");
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
      print("TabProvider - notifyListeners called");
    }
  }
}