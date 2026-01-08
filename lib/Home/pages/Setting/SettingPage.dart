import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskcsc/Home/pages/Setting/SubScriptionPlan%20+/SubscriptionPlans.dart';
import 'package:taskcsc/provider/menu_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<MenuProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () {
            // ✅ يرجع للـ MainScreen والهوم
            Navigator.pushReplacementNamed(context, '/Home');

            menu.selectIndex(0);
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),

      // 🔹 محتوى الصفحة
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),

            // 🧑‍💼 الحساب الشخصي
            const _SettingsSectionTitle(title: "Account"),
            _SettingsTile(
              icon: Icons.person_outline_rounded,
              title: "Edit Profile",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: "Change Password",
              onTap: () {},
            ),
            const SizedBox(height: 25),

            // 💳 الإشتراك والدفع
            const _SettingsSectionTitle(title: "Subscription"),
            _SettingsTile(
              icon: Icons.subscriptions_outlined,
              title: "Subscription Plans",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionPlans(),
                  ),
                );
              },
            ),
            _SettingsTile(
              icon: Icons.payment_outlined,
              title: "Payment Method",
              onTap: () {
                Navigator.pushNamed(context, '/PayPage');
              },
            ),

            const SizedBox(height: 25),

            // 🧾 الدعم و تسجيل الخروج
            const _SettingsSectionTitle(title: "Support"),
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              title: "Help Center",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.logout_rounded,
              title: "Logout",
              color: Colors.red,
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  try {
                    // 🔹 تسجيل خروج فعلي من Firebase (إن وجد)
                    // import 'package:firebase_auth/firebase_auth.dart';
                    await FirebaseAuth.instance.signOut();

                    // 🔹 تنظيف أي بيانات محلية محفوظة (SharedPreferences)
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    // 🔹 انتقال آمن لشاشة تسجيل الدخول مع حذف السجل
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error logging out: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////
/// 🟩 عنوان القسم
class _SettingsSectionTitle extends StatelessWidget {
  final String title;
  const _SettingsSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}

////////////////////////////////////////
/// 🟦 عنصر الإعداد الفردي
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFF007C83).withOpacity(0.15),
          child: Icon(icon, color: const Color(0xFF007C83)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }
}
