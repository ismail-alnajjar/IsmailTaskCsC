import 'package:flutter/material.dart';
import 'package:taskcsc/Home/Widgets/CostumElevatedButton.dart';
import 'package:taskcsc/Home/Widgets/StaticScreenPage(2,3,4,5).dart';
import 'package:taskcsc/Home/Widgets/TANAKOL/entkal.dart';

class Schedule extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final int currentIndex;

  const Schedule({
    super.key,
    this.onNext, // 🔹 صار اختياري
    this.onSkip, // 🔹 صار اختياري
    this.currentIndex = 1, // 🔹 قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    return StaticScreen(
      Title1: 'Learn on your own',
      Title2: 'Schedule',
      Description: 'Access courses on the go,\n anytime, from anywhere.',
      imagePath: 'assets/Schedule.png',
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
      CLLORS: Color(0xFF000000),
      onButtonPressed:
          onNext ??
          () {
            Navigator.pushReplacementNamed(context, '/LearningP');
          },
      bottomRow: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomElevatedBotton(
            buttonText: 'Skip',
            onButtonPressed:
                onSkip ??
                () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
            LISTCOLOR: [Color(0xFFFDF8F6), Color(0xFFFDF8F6)],
            CLLORS: Color(0xFF000000),
            fontsize: 15,
          ),
          Tanakol(currentIndex: currentIndex),
          CustomElevatedBotton(
            buttonText: 'Next',
            onButtonPressed:
                onNext ??
                () {
                  Navigator.pushReplacementNamed(context, '/LearningP');
                },
            LISTCOLOR: [Color(0xFFFDF8F6), Color(0xFFFDF8F6)],
            CLLORS: Color(0xFF000000),
            fontsize: 15,
          ),
        ],
      ),
    );
  }
}
