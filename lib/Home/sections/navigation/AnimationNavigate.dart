import 'package:flutter/material.dart';
import 'package:taskcsc/Home/Widgets/TANAKOL/entkal.dart';
import 'package:taskcsc/Home/pages/TextScreen/CoursesIntroScreenPage3.dart';
import 'package:taskcsc/Home/pages/TextScreen/LearningPage5.dart';
import 'package:taskcsc/Home/pages/TextScreen/SchedulePage4.dart';

class AnimationNavigate extends StatefulWidget {
  const AnimationNavigate({super.key});

  @override
  State<AnimationNavigate> createState() => _AnimationNavigateState();
}

class _AnimationNavigateState extends State<AnimationNavigate> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void nextPage() {
    if (currentIndex < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void skipToLast() {
    _controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                children: [
                  CoursesIntroScreen(
                    onNext: nextPage,
                    onSkip: skipToLast,
                    currentIndex: currentIndex,
                  ),
                  Schedule(
                    onNext: nextPage,
                    onSkip: skipToLast,
                    currentIndex: currentIndex,
                  ),
                  LearningPage5(
                    onStart: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    currentIndex: currentIndex,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Tanakol(currentIndex: currentIndex), // النقاط السفلية تتحرك
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
