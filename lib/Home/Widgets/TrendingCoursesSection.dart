import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrendingCoursesSection extends StatefulWidget {
  final List<Map<String, dynamic>> courses;
  final void Function(Map<String, dynamic> course)? onCourseTap;

  const TrendingCoursesSection({
    super.key,
    required this.courses,
    this.onCourseTap,
  });

  @override
  State<TrendingCoursesSection> createState() => _TrendingCoursesSectionState();
}

class _TrendingCoursesSectionState extends State<TrendingCoursesSection> {
  Set<String> savedIds = {}; // ⭐ لمعرفة الكورسات المحفوظة

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  /// ⭐ تحميل الكورسات المحفوظة من Firestore
  Future<void> _loadSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedCourses')
        .get();

    setState(() {
      savedIds = snap.docs.map((e) => e.id).toSet();
    });
  }

  /// ⭐ حفظ / إزالة الكورس
  Future<void> _toggleSave(Map<String, dynamic> course) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final id = course['id'].toString();

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedCourses')
        .doc(id);

    if (savedIds.contains(id)) {
      await ref.delete();
      setState(() => savedIds.remove(id));
    } else {
      await ref.set({...course, 'savedAt': FieldValue.serverTimestamp()});
      setState(() => savedIds.add(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = widget.courses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 العنوان الرئيسي
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trending Courses 🔥',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/CoursesPage'),
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF007C83),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // 🔹 عرض الكورسات
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final c = courses[index];

              final id = c['id'].toString();
              final title = c['title'] ?? 'No Title';
              final author = c['author'] ?? c['teacherName'] ?? 'Unknown';
              final price = c['price']?.toString() ?? '0';
              final img = c['coverImage'] ?? c['image'];

              final imageUrl = img != null && img.toString().isNotEmpty
                  ? (img.toString().startsWith("http")
                        ? img
                        : "http://10.0.2.2:7295/$img")
                  : "https://via.placeholder.com/400x250.png?text=No+Image";

              final isSaved = savedIds.contains(id);

              return GestureDetector(
                onTap: () => widget.onCourseTap?.call(c),
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 18),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 🔹 الصورة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(
                            "https://via.placeholder.com/400x250.png?text=No+Image",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // 🔹 السعر
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            "\$$price",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // 🔹 أيقونة الحفظ (مثل Popular)
                      Positioned(
                        bottom: 80,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => _toggleSave(c),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              isSaved
                                  ? Icons
                                        .bookmark // ⭐ غامقة إذا محفوظ
                                  : Icons
                                        .bookmark_border, // ⭐ مفتوحة إذا غير محفوظ
                              color: const Color(0xFF258A95),
                            ),
                          ),
                        ),
                      ),

                      // 🔹 النصوص
                      Positioned(
                        bottom: 0,
                        left: 8,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "By: $author",
                              style: const TextStyle(
                                color: Color(0xFF258A95),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
