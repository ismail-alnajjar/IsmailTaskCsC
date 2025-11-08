import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskcsc/model/course_model.dart';

class PopularCoursesSection extends StatefulWidget {
  const PopularCoursesSection({super.key});

  @override
  State<PopularCoursesSection> createState() => _PopularCoursesSectionState();
}

class _PopularCoursesSectionState extends State<PopularCoursesSection> {
  List<Course> courses = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  /// 🟢 تحميل الكورسات من Firestore (آمن من setState بعد dispose)
  Future<void> _loadCourses() async {
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .orderBy('createdAt', descending: true)
          .get();

      final data = snapshot.docs.map((e) {
        final json = e.data();
        return Course.fromJson(json);
      }).toList();

      if (!mounted) return; // ✅ تأكد أن الصفحة ما زالت ظاهرة
      setState(() {
        courses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  /// 🔖 حفظ / إزالة الكورس من SavedCourses
  Future<void> _toggleSaveCourse(Course course) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Please log in first.")));
      return;
    }

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedCourses')
        .doc(course.id?.toString() ?? course.title);

    final doc = await ref.get();

    if (doc.exists) {
      await ref.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Removed from saved courses.")),
      );
    } else {
      await ref.set({
        ...course.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Course saved successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text("Error: $errorMessage"));
    }

    if (courses.isEmpty) {
      return const Center(child: Text("No popular courses found."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 العنوان
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Courses ⭐',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/PopularSeeAll');
              },
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
            reverse: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final c = courses[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/DiscPay', arguments: c);
                },
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 18),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // الصورة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            (c.coverImage != null && c.coverImage!.isNotEmpty)
                            ? Image.network(
                                c.coverImage!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/getstart.png',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),

                      // السعر
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
                            c.price != null
                                ? "\$${c.price!.toStringAsFixed(0)}"
                                : "Free",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // أيقونة الحفظ
                      Positioned(
                        bottom: 80,
                        right: 10,
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
                          child: IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            color: const Color(0xFF258A95),
                            onPressed: () => _toggleSaveCourse(c),
                          ),
                        ),
                      ),

                      // النصوص
                      Positioned(
                        bottom: 0,
                        left: 8,
                        right: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "By: ${c.teacherName ?? "Unknown"}",
                                style: const TextStyle(
                                  color: Color(0xFF258A95),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
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
