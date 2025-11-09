import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskcsc/services/storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? imageUrl;
  String? userName;
  String? userEmail;
  bool isLoading = false;
  final StorageService storageService = StorageService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final doc = await docRef.get();

      if (doc.exists) {
        setState(() {
          imageUrl = doc.data()?['profileImageUrl'];
          userName = doc.data()?['name'] ?? user.displayName ?? 'User';
          userEmail = doc.data()?['email'] ?? user.email ?? '';
        });
      } else {
        await docRef.set({
          'email': user.email,
          'name': user.displayName ?? 'User',
          'profileImageUrl': '',
          'createdAt': DateTime.now(),
        });

        setState(() {
          userName = user.displayName ?? 'User';
          userEmail = user.email;
          imageUrl = null;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading user data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('⚠️ Error loading user data: $e')));
    }
  }

  Future<void> changeProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final imageFile = await storageService.pickImage();
    if (imageFile == null) return;

    setState(() => isLoading = true);

    try {
      final url = await storageService.uploadProfileImage(user.uid, imageFile);
      if (url != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'profileImageUrl': url});

        setState(() => imageUrl = url);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Profile image updated')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Upload failed, please try again')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('⚠️ Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // ✅ يرجع إلى صفحة MainShell
            Navigator.pushReplacementNamed(context, '/MainShell');
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            imageUrl != null && imageUrl!.isNotEmpty
                            ? NetworkImage(imageUrl!)
                            : null,
                        child: (imageUrl == null || imageUrl!.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 45,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: changeProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF007C83),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          userEmail ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF087E8B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 25),
            ProfileOption(
              title: "Your Current Courses",
              onTap: () {
                Navigator.pushReplacementNamed(context, '/MyCoursesMe');
              },
            ),
            ProfileOption(title: "Your History", onTap: () {}),
            ProfileOption(title: "Certifications Earned", onTap: () {}),
            ProfileOption(
              title: "Settings",
              onTap: () {
                Navigator.pushReplacementNamed(context, '/Settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  const ProfileOption({super.key, required this.title, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Container(
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                color: Color(0xFF007C83),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
