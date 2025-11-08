import 'package:flutter/material.dart';

class EmaillField extends StatelessWidget {
  final TextEditingController controller;

  const EmaillField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF007C83)),
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF007C83), width: 1.8),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
