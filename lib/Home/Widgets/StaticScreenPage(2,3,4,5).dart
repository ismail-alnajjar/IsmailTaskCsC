import 'package:flutter/material.dart';

class StaticScreen extends StatelessWidget {
  const StaticScreen({
    super.key,
    required this.Title1,
    required this.Title2,
    required this.Description,
    required this.imagePath,
    required this.onButtonPressed,
    required this.colors,
    required this.CLLORS,
    required this.bottomRow,
  });

  final String Title1;
  final String Title2;
  final String Description;
  final String imagePath;
  final VoidCallback onButtonPressed;
  final Widget bottomRow;

  final List<Color> colors;
  final Color CLLORS;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // دالة لتكبير/تصغير المقاسات حسب حجم الشاشة
    double scale(double value) => value * (width / 390);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
              top: height * 0.05,
              bottom: height * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 الصورة
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imagePath,
                      width: width,
                      height: height * 0.45,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// 🔹 النص الأول
                Text(
                  Title1,
                  style: TextStyle(
                    fontSize: scale(26),
                    color: const Color(0xDD000000),
                    fontWeight: FontWeight.w300,
                  ),
                ),

                /// 🔹 النص الثاني
                Text(
                  Title2,
                  style: TextStyle(
                    fontSize: scale(63),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF007C83),
                    height: 0.9,
                  ),
                ),

                SizedBox(height: height * 0.015),

                /// 🔹 الوصف
                Text(
                  Description,
                  style: TextStyle(
                    fontSize: scale(21),
                    color: const Color(0x8A000000),
                    height: 1.2,
                  ),
                ),

                SizedBox(height: height * 0.06),

                /// 🔹 الزر أو الصف السفلي
                bottomRow,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
