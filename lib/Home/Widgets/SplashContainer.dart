import 'package:flutter/material.dart';

class SplashContainer extends StatelessWidget {
  const SplashContainer({super.key, required this.hei, required this.wid});

  final double hei;
  final double wid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hei * 0.9, // الجزء السفلي من الشاشة
      width: wid, // عرض الشاشة كامل
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // الدائرة الكبيرة (أبعد وحدة)
          Positioned(
            bottom: -wid * 0.80, // ننزلها لتحت الشاشة
            child: Container(
              width: wid * 1.26, // أكبر من الشاشة
              height: wid * 1.48,
              decoration: const BoxDecoration(
                color: Color(0xFF4D9BA3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // الدائرة الوسطى
          Positioned(
            bottom: -wid * 0.60,
            child: Container(
              width: wid * 1.2,
              height: wid * 1.06,
              decoration: const BoxDecoration(
                color: Color(0xFF15808B),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // الدائرة الصغيرة (الأقرب)
          Positioned(
            bottom: -wid * 0.45,
            child: Container(
              width: wid * 0.9,
              height: wid * 0.8,
              decoration: const BoxDecoration(
                color: Color(0xFF087986),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
