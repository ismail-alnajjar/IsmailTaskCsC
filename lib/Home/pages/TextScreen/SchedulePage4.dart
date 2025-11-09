import 'package:flutter/material.dart';
import 'package:taskcsc/Home/Widgets/StaticScreenPage(2,3,4,5).dart';
import 'package:taskcsc/Home/Widgets/TANAKOL/entkal.dart';

class Schedule extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final int currentIndex;

  const Schedule({super.key, this.onNext, this.onSkip, this.currentIndex = 1});

  @override
  Widget build(BuildContext context) {
    return StaticScreen(
      Title1: 'Learn on your own',
      Title2: 'Schedule',
      Description: 'Access courses on the go,\nanytime, from anywhere.',
      imagePath: 'assets/Schedule.png',
      colors: const [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
      CLLORS: const Color(0xFF000000),
      onButtonPressed:
          onNext ??
          () {
            Navigator.pushReplacementNamed(context, '/LearningP');
          },
      bottomRow: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 زر Skip
            TextButton(
              onPressed:
                  onSkip ??
                  () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // 🔹 النقاط (Tanakol)
            Tanakol(currentIndex: currentIndex, total: 3),

            // 🔹 زر Next
            TextButton(
              onPressed:
                  onNext ??
                  () {
                    Navigator.pushReplacementNamed(context, '/LearningP');
                  },
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
