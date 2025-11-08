import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatefulWidget {
  const SignUpButton({super.key});

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  bool isLoading = false;

  // 🟢 متغيرات مؤقتة (استبدلها لاحقًا بـ TextEditingControllers)
  final String name = "محمد النجار"; // 👈 الاسم المؤقت للتجربة
  final String email = "example@gmail.com";
  final String password = "12345678";

  Future<void> _signUp() async {
    setState(() => isLoading = true);

    try {
      // 🟢 إنشاء المستخدم في Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final user = userCredential.user;

      if (user != null) {
        // ✅ تحديث اسم المستخدم داخل Firebase Auth
        await user.updateDisplayName(name);

        // ✅ إنشاء وثيقة المستخدم داخل Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': user.email,
          'profileImageUrl': '',
          'createdAt': DateTime.now(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Account created successfully")),
      );

      // 🔹 الانتقال بعد النجاح
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String errorMessage = "❌ Error: ${e.message}";
      if (e.code == 'email-already-in-use') {
        errorMessage = "⚠️ Email already registered";
      } else if (e.code == 'weak-password') {
        errorMessage = "⚠️ Weak password, please choose a stronger one";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF087B88), Color(0xFF0B3A54)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _signUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
