import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskcsc/Home/pages/TextScreen/GetStartedPage2.dart';

import '../../Widgets/SplashContainer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // بعد 3 ثواني انتقل لصفحة اللوجن مع أنيميشن
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GetStarted(), // غيّرها إذا اسم الصفحة غير
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuad;

            final offsetTween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            final opacityTween = Tween<double>(begin: 0.0, end: 1.0);

            return SlideTransition(
              position: animation.drive(offsetTween),
              child: FadeTransition(
                opacity: animation.drive(opacityTween),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6), // لون الخلفية الفاتح
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            // انت مبسوط على هالقيم، خليتها زي ما هي
            child: const SplashContainer(hei: 800, wid: 400),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo 2.png', // تأكد من اسم الملف والمسار
                  width: 250,
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
