import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskcsc/model/course_model.dart';

class PopularSeeAllPage extends StatefulWidget {
  const PopularSeeAllPage({super.key});

  @override
  State<PopularSeeAllPage> createState() => _PopularSeeAllPageState();
}

class _PopularSeeAllPageState extends State<PopularSeeAllPage> {
  List<Course> courses = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController _searchController = TextEditingController();

  /// ⭐ إصلاح رابط الصورة لجميع الواجهات (Emulator + Real Device)
  String fixImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";

    // إذا كان الرابط أصلاً كامل
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return path;
    }

    // رابط API المحلي داخل Emulator
    return "https://taskcsc1-4.onrender.com/$path";
  }

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  /// 🟢 تحميل الكورسات من Firebase
  Future<void> loadCourses([String? query]) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      Query<Map<String, dynamic>> queryRef =
          FirebaseFirestore.instance.collection('courses');

      // لو فيه بحث بسيط
      if (query != null && query.isNotEmpty) {
        // 🔥 بحث بدائي في الفايربيس (Case-sensitive)
        queryRef = queryRef.where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThan: query + 'z');
      }

      final snapshot = await queryRef.get();

      List<Course> data = snapshot.docs.map((doc) {
        return Course.fromJson(doc.data());
      }).toList();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF9F6F7),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search courses...",
            prefixIcon: const Icon(Icons.search, color: Color(0xFF007C83)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: loadCourses,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child:
                    // 🔄 تحميل
                    isLoading
                    ? const Center(child: CircularProgressIndicator())
                    // 🔥 خطأ
                    : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Failed to load courses",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => loadCourses(),
                              icon: const Icon(Icons.refresh),
                              label: const Text("Retry"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007C83),
                              ),
                            ),
                          ],
                        ),
                      )
                    // 🚫 لا يوجد كورسات
                    : courses.isEmpty
                    ? const Center(
                        child: Text(
                          "No courses available yet.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                    // ⭐ عرض كل الكورسات
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final c = courses[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/DiscPay',
                                arguments: c,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 22),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F6F7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ⭐ الصورة
                                  SizedBox(
                                    height: 220,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        fixImageUrl(c.coverImage),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,

                                        // 🔥 منع الكراش + صورة بديلة
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/MyCorses.png",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              );
                                            },
                                      ),
                                    ),
                                  ),

                                  // ⭐ النصوص
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
