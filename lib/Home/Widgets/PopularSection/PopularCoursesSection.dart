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
  Set<String> savedIds = {}; // ⭐ لمعرفة المحفوظ مسبقاً
  bool isLoading = true;
  String? errorMessage;

  /// ⭐ ترتيب رابط الصورة (Emulator)
  String fixImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;

    return "https://taskcsc1-4.onrender.com/$path";
  }

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _loadSavedCourses();
  }

  /// 🟢 تحميل الكورسات (Popular) من Firebase
  Future<void> _loadCourses() async {
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      // 🔹 جلب البيانات من collection 'courses'
      // يمكنك إضافة .orderBy('studentsCount', descending: true) لو عندك حقل للشعبية
      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .limit(10) // مجرد مثال لجلب عدد محدود
          .get();

      final data = snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList();

      if (!mounted) return;
      setState(() {
        courses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  /// ⭐ جلب قائمة المحفوظات
  Future<void> _loadSavedCourses() async {
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

  /// ⭐ حفظ / إزالة من Saved + تغيير الأيقونة لحظياً
  Future<void> _toggleSaveCourse(Course course) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final id = course.id.toString();

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedCourses')
        .doc(id);

    if (savedIds.contains(id)) {
      // 🔴 إزالة
      await ref.delete();
      setState(() {
        savedIds.remove(id);
      });
    } else {
      // 🟢 حفظ
      await ref.set({
        ...course.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        savedIds.add(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null)
      return Center(child: Text("Error: $errorMessage"));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 العنوان + See All
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
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final c = courses[index];
              final isSaved = savedIds.contains(c.id.toString());

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/DiscPay', arguments: c);
                },
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 18),
                  child: Stack(
                    children: [
                      // الصورة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            (c.coverImage != null && c.coverImage!.isNotEmpty)
                            ? Image.network(
                                c.coverImage!.startsWith('http')
                                    ? c.coverImage!
                                    : "https://taskcsc1-4.onrender.com/${c.coverImage!}",
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                      'assets/getstart.png',
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
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

                      // زر الحفظ ⭐
                      Positioned(
                        bottom: 80,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => _toggleSaveCourse(c),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSaved
                                  ? Icons
                                        .bookmark // ⭐ محفوظ
                                  : Icons.bookmark_border, // ⭐ غير محفوظ
                              color: const Color(0xFF258A95),
                            ),
                          ),
                        ),
                      ),

                      // النصوص
                      Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "By: ${c.teacherName}",
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
