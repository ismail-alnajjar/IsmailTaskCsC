import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  // 🟢 تحميل صورة المستخدم من Firestore
  Future<void> loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return; // ✅ تأكد أن الواجهة ما زالت موجودة

      if (doc.exists && doc.data()?['profileImageUrl'] != null) {
        setState(() {
          imageUrl = doc.data()?['profileImageUrl'];
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile');
      },
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, color: Colors.black87);
                  },
                )
              : const Icon(Icons.person, color: Colors.black87),
        ),
      ),
    );
  }
}
