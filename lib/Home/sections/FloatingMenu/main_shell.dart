import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/Home/pages/HomePage.dart';
import 'package:taskcsc/Home/pages/MYCOURSme.dart';
import 'package:taskcsc/Home/pages/ProfilePage.dart';
import 'package:taskcsc/Home/pages/SavedCoursesPage.dart';
import 'package:taskcsc/Home/pages/Setting/SettingPage.dart';
import 'package:taskcsc/Home/sections/FloatingMenu/FloatingMenuButton.dart';
import 'package:taskcsc/provider/menu_provider.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<MenuProvider>(context);

    final List<Widget> pages = const [
      HomePage(),
      MyCoursesMe(),
      SavedCoursesPage(),
      ProfilePage(),
      SettingsPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),

      body: Stack(
        children: [
          /// 🔥 يمنع الصفحات من استقبال اللمس عندما القائمة مفتوحة
          AbsorbPointer(
            absorbing: menu.isOpen, // 👈 أهم سطر في الحل كله
            child: IndexedStack(index: menu.selectedIndex, children: pages),
          ),

          /// 🔹 Floating Menu يطفو فوق كل شيء
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Center(heightFactor: 0.7, child: FloatingMenuButton()),
            ),
          ),
        ],
      ),
    );
  }
}
