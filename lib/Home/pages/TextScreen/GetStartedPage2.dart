import 'package:flutter/material.dart';
import 'package:taskcsc/Home/Widgets/CostumElevatedButton.dart';
import 'package:taskcsc/Home/Widgets/StaticScreenPage(2,3,4,5).dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6), // نفس خلفية Figma
      body: StaticScreen(
        Title1: 'Welcom to',
        Title2: 'SALFORD',
        Description: 'Unlock the best IT courses \n for your career growth',
        imagePath: 'assets/getstart.png',
        onButtonPressed: () {
          Navigator.pushReplacementNamed(context, '/CoursesIntro');
        },
        colors: [
          Color(0xFF087785), // أزرق غامق
          Color(0xFF0B3A54), // أزرق فاتح
        ],

        CLLORS: Color(0xFFFFFFFF), // أبيض
        bottomRow: CustomElevatedBotton(
          buttonText: 'Get Started',
          onButtonPressed: () {
            Navigator.pushReplacementNamed(context, '/CoursesIntro');
          },
          LISTCOLOR: [
            Color(0xFF087785), // أزرق غامق
            Color(0xFF0B3A54), // أزرق فاتح
          ],
          CLLORS: Color(0xFFFFFFFF), // أبيض
          fontsize: 16,
        ),
      ),
    );
  }
}
