import 'package:flutter/material.dart';

class Tanakol extends StatelessWidget {
  final int currentIndex;
  final int total;

  const Tanakol({super.key, required this.currentIndex, this.total = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 12 : 7,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive
                ? const Color(0xFF007C83) // النقطة النشطة
                : Colors.grey.shade400, // النقاط الخاملة
          ),
        );
      }),
    );
  }
}
