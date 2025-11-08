import 'package:flutter/material.dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/EmailField.dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/HeaderSection(log).dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/LoginButton.dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/OrDivider.dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/PasswordField.dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/RememberAndForgotRow.dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/SignUpRow.dart';
import 'package:taskcsc/log%20&%20sign/Login/widgetOf(log)/SocialButton(log).dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 🔹 controllers لحفظ القيم
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.07,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const HeaderSection(),
              const SizedBox(height: 30),

              /// حقل الإيميل
              EmaillField(controller: emailController),
              const SizedBox(height: 16),

              /// حقل كلمة المرور
              PasswordField(controller: passwordController),
              const SizedBox(height: 24),

              /// زر تسجيل الدخول
              LoginButton(
                emailController: emailController,
                passwordController: passwordController,
              ),
              const SizedBox(height: 12),

              const RememberAndForgotRow(),
              const SizedBox(height: 20),
              const OrDivider(),
              const SizedBox(height: 20),

              const SocialButton(
                text: 'Sign in with Google',
                icon: Icons.g_mobiledata,
              ),
              const SizedBox(height: 12),
              const SocialButton(text: 'Sign in with Apple', icon: Icons.apple),
              const SizedBox(height: 24),
              const SignUpRow(),
            ],
          ),
        ),
      ),
    );
  }
}
