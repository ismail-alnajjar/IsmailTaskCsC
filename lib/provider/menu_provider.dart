import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  bool isOpen = false;
  int selectedIndex = 0; // 👈 نبدأ بالهوم (بدل -1)

  void toggleMenu() {
    isOpen = !isOpen;
    notifyListeners();
  }

  void selectIndex(int index) {
    selectedIndex = index;
    isOpen = false; // 🔥 يسكر المنيو بعد الضغط
    notifyListeners();
  }
}
