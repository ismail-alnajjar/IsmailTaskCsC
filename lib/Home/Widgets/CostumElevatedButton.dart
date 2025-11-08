import 'package:flutter/material.dart';

class CustomElevatedBotton extends StatelessWidget {
  const CustomElevatedBotton({
    super.key,
    required this.buttonText,
    required this.onButtonPressed,
    required this.LISTCOLOR,
    required this.CLLORS,
    required this.fontsize,
  });
  final String buttonText; // نص الزر
  final VoidCallback onButtonPressed; // دالة عند الضغط على الزر
  final List<Color> LISTCOLOR;
  final Color CLLORS;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: LISTCOLOR,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          onButtonPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0x00000000), // مهم حتى يظهر التدرّج
          shadowColor: const Color(0x00000000), // إلغاء الظل الافتراضي
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.w400,
            color: CLLORS,
          ),
        ),
      ),
    );
  }
}
