import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/provider/menu_provider.dart';

class MyCoursesMe extends StatefulWidget {
  const MyCoursesMe({super.key});

  @override
  State<MyCoursesMe> createState() => _MyCoursesMeState();
}

class _MyCoursesMeState extends State<MyCoursesMe> {
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  List<Map<String, dynamic>> myCourses = [];

  /// ⭐ إصلاح رابط الصورة
  String fixImageUrl(String path) {
    if (path.isEmpty) return "";
    if (path.startsWith("http")) return path;

    const port = 7295;

    // ✔ لو Emulator
    if (path.contains("uploads")) {
      return "http://10.0.2.2:$port/$path";
    }

    // ✔ لو تلفون فعلي (عدّل IP مرة واحدة)
    const String localIp = "192.168.1.10";

    return "http://$localIp:$port/$path";
  }

  @override
  void initState() {
    super.initState();
    fetchMyCourses();
  }

  /// 🟢 جلب بيانات الكورسات
  Future<void> fetchMyCourses() async {
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('myCourses')
          .orderBy('purchasedAt', descending: true)
          .get();

      setState(() {
        myCourses = snapshot.docs.map((doc) {
          final data = doc.data();

          return {
            'title': data['title'] ?? 'Untitled Course',
            'teacherName': data['teacherName'] ?? 'Unknown',
            'description': data['description'] ?? '',
            'price': data['price'] ?? 0,
            'coverImage': fixImageUrl(data['coverImage'] ?? ""),
            'lessons': data['lessons'] ?? 48,
            'chapters': data['chapters'] ?? 25,
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error loading courses: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<MenuProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F7),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 18,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/MainShell');
              menu.selectIndex(0);
            },
          ),
        ),
        title: const Text(
          "My Courses",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : myCourses.isEmpty
          ? const Center(
              child: Text(
                "You haven’t purchased any courses yet.",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              itemCount: myCourses.length,
              itemBuilder: (context, index) {
                final c = myCourses[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/EnterMyCourses',
                      arguments: c,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF007C83).withOpacity(0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Your progress",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 15,
                                  color: Colors.black45,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "39min",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "75% to complete",
                          style: TextStyle(
                            color: Color(0xFF087785),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.75,
                            minHeight: 8,
                            backgroundColor: const Color(
                              0xFFE0E0E0,
                            ).withOpacity(0.6),
                            color: const Color(0xFF087785),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Row Course Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "By: ${c['teacherName']}",
                                    style: const TextStyle(
                                      color: Color(0xFF087785),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.menu_book_outlined,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${c['lessons']} Lessons",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.access_time,
                                        size: 8,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "2hr 45min",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            // ⭐ الصورة داخل SizedBox لمنع Overflow
                            SizedBox(
                              width: 120,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child:
                                    (c['coverImage'] != null &&
                                        c['coverImage'].toString().isNotEmpty)
                                    ? Image.network(
                                        c['coverImage'],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/MyCorses.png",
                                                fit: BoxFit.cover,
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        "assets/MyCorses.png",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
