import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskcsc/Home/Widgets/HeaderSection/NotificationButton.dart';
import 'package:taskcsc/Home/Widgets/HeaderSection/ProfileAvatar.dart';

class HeaderSectionHome extends StatefulWidget {
  const HeaderSectionHome({super.key});

  @override
  State<HeaderSectionHome> createState() => _HeaderSectionHomeState();
}

class _HeaderSectionHomeState extends State<HeaderSectionHome> {
  String userName = 'User'; // القيمة الافتراضية
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      if (doc.exists &&
          doc.data()?['name'] != null &&
          doc.data()?['name'] != '') {
        setState(() {
          userName = doc.data()?['name'];
          isLoading = false;
        });
      } else {
        setState(() {
          userName = user.email?.split('@').first ?? 'User';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading user name: $e');
      if (mounted) {
        setState(() {
          userName = 'User';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isLoading ? 'Loading...' : 'Hello, $userName 👋',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const NotificationButton(),
            const SizedBox(width: 12),
            const ProfileButton(),
          ],
        ),
        const SizedBox(height: 5),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text(
              "Let's Learn🎓",
              style: TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 42,
                fontWeight: FontWeight.w100,
                height: 1,
                color: Colors.black,
              ),
            ),
            Text(
              'Something New',
              style: TextStyle(
                fontFamily: 'ClashDisplay',
                wordSpacing: 3,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
