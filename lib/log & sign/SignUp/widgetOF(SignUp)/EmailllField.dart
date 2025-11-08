import 'package:flutter/material.dart';

class EmailllField extends StatelessWidget {
  const EmailllField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
        hintText: 'Enter your email',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26),
        ),
      ),
    );
  }
}
