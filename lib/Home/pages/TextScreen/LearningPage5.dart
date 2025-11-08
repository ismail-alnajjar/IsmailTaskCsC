import 'package:flutter/material.dart';
import 'package:taskcsc/Home/Widgets/CostumElevatedButton.dart';
import 'package:taskcsc/Home/Widgets/StaticScreenPage(2,3,4,5).dart';
import 'package:taskcsc/Home/Widgets/TANAKOL/entkal.dart';

class LearningPage5 extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onStart; // ✅ أضفناها

  const LearningPage5({
    super.key,
    this.currentIndex = 2,
    this.onStart, // ✅ استقبلناها هنا
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      body: StaticScreen(
        Title1: 'Ready to dive into',
        Title2: 'Learning?',
        Description: 'Access courses on the go,\nanytime, from anywhere.',
        imagePath: 'assets/getstart.png',
        onButtonPressed: () {
          Navigator.pushReplacementNamed(context, '/CoursesIntro');
        },
        colors: const [Color(0xFF087785), Color(0xFF0B3A54)],
        CLLORS: const Color(0xFFFFFFFF),
        bottomRow: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tanakol(currentIndex: currentIndex, total: 3),
            const SizedBox(height: 25),
            CustomElevatedBotton(
              buttonText: 'Start Learning',
              onButtonPressed:
                  onStart ??
                  () {
                    // ✅ استخدم onStart لو موجودة
                    Navigator.pushReplacementNamed(context, '/login');
                  },
              LISTCOLOR: const [Color(0xFF087785), Color(0xFF0B3A54)],
              CLLORS: const Color(0xFFFFFFFF),
              fontsize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
