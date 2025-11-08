import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = false;

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  // 🔹 تسجيل الدخول بالبريد وكلمة السر
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login Successful ✅')));

      Navigator.pushReplacementNamed(context, '/CoursesIntro');
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed ❌';

      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 إنشاء حساب جديد
  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Created Successfully 🎉')),
      );

      Navigator.pushReplacementNamed(context, '/CoursesIntro');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Sign Up failed ❌')));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
