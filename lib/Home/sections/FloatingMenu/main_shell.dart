import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/Home/Widgets/PopularSection/popularCoursesPage.dart';
import 'package:taskcsc/Home/pages/HomePage.dart';
import 'package:taskcsc/Home/pages/MYCOURSme.dart';
import 'package:taskcsc/Home/pages/ProfilePage.dart';
import 'package:taskcsc/Home/pages/Setting/SettingPage.dart';
import 'package:taskcsc/Home/sections/FloatingMenu/FloatingMenuButton.dart';
import 'package:taskcsc/provider/menu_provider.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<MenuProvider>(context);

    /// ترتيب الصفحات حسب الأيقونات في FloatingMenuButton
    final List<Widget> pages = const [
      HomePage(), // 0️⃣ أيقونة Home
      MyCoursesMe(), // 1️⃣ أيقونة المربعات
      PopularSeeAllPage(), // 2️⃣ أيقونة الحفظ
      ProfilePage(), // 3️⃣ أيقونة الشخص
      SettingsPage(), // 4️⃣ أيقونة الإعدادات
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          /// 📄 الصفحات داخل IndexedStack (لا تُعاد بناؤها)
          IndexedStack(index: menu.selectedIndex, children: pages),

          /// 🔹 زر Floating Menu الثابت فوق كل الصفحات
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Center(heightFactor: 0.4, child: FloatingMenuButton()),
            ),
          ),
        ],
      ),
    );
  }
}
