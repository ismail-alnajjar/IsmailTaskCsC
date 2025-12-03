import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool _loading = false;

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;

    if (newPassword.text != confirmPassword.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    if (newPassword.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters."),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // 🔸 إعادة تسجيل الدخول للتحقق من كلمة المرور القديمة
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword.text,
      );

      await user.reauthenticateWithCredential(cred);

      // 🔸 تحديث الباسورد
      await user.updatePassword(newPassword.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password Updated Successfully 🔐")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field("Old Password", oldPassword, obscure: true),
            const SizedBox(height: 20),
            _field("New Password", newPassword, obscure: true),
            const SizedBox(height: 20),
            _field("Confirm Password", confirmPassword, obscure: true),
            const SizedBox(height: 35),

            _loading
                ? const CircularProgressIndicator(color: Colors.teal)
                : ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007C83),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Update Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool obscure = false,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
