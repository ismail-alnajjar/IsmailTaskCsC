import 'package:flutter/material.dart';
import 'package:taskcsc/Home/Widgets/CostumElevatedButton.dart';
import 'package:taskcsc/Home/Widgets/StaticScreenPage(2,3,4,5).dart';
import 'package:taskcsc/Home/Widgets/TANAKOL/entkal.dart';

class CoursesIntroScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final int currentIndex;

  const CoursesIntroScreen({
    super.key,
    this.onNext,
    this.onSkip,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: IntrinsicHeight(
              child: StaticScreen(
                Title1: 'Explore a wide range of ',
                Title2: 'IT Courses',
                Description: 'From coding to \n cybersecurity, we have it all!',
                imagePath: 'assets/CorsesintroScreen.png',
                colors: const [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                CLLORS: const Color(0xFF000000),
                onButtonPressed:
                    onNext ??
                    () {
                      Navigator.pushReplacementNamed(context, '/Schedule');
                    },
                bottomRow: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedBotton(
                        buttonText: 'Skip',
                        onButtonPressed:
                            onSkip ??
                            () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                        LISTCOLOR: const [Color(0xFFFDF8F6), Color(0xFFFDF8F6)],
                        CLLORS: const Color(0xFF000000),
                        fontsize: 15,
                      ),
                      Tanakol(currentIndex: currentIndex),
                      CustomElevatedBotton(
                        buttonText: 'Next',
                        onButtonPressed:
                            onNext ??
                            () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/Schedule',
                              );
                            },
                        LISTCOLOR: const [Color(0xFFFDF8F6), Color(0xFFFDF8F6)],
                        CLLORS: const Color(0xFF000000),
                        fontsize: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
