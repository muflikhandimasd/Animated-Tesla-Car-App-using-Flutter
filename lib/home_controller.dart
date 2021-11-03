import 'package:flutter/widgets.dart';

class HomeController extends ChangeNotifier {
  // HomeController for logical part

  int selectedBotttomTab = 0;
  void onBottomNavigationTabChange(int index) {
    selectedBotttomTab = index;
    notifyListeners();
  }

  bool isRightDoorLock = true;
  bool isLeftDoorLock = true;
  bool isBonnetDoorLock = true;
  bool isTrunkDoorLock = true;

  void updateRightDoorLock() {
    isRightDoorLock = !isRightDoorLock;
    notifyListeners();
    // it work like setState
  }

  void updateLeftDoorLock() {
    isLeftDoorLock = !isLeftDoorLock;
    notifyListeners();
    // it work like setState
  }

  void updateBonnetDoorLock() {
    isBonnetDoorLock = !isBonnetDoorLock;
    notifyListeners();
    // it work like setState
  }

  void updateTrunkDoorLock() {
    isTrunkDoorLock = !isTrunkDoorLock;
    notifyListeners();
    // it work like setState
  }
}
