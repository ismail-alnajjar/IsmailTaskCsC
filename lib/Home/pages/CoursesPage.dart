import 'package:flutter/material.dart';
import 'package:taskcsc/model/course_model.dart';
import 'package:taskcsc/services/course_service.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> courses = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  /// 🟢 تحميل الكورسات (الكل أو البحث)
  Future<void> loadCourses([String? query]) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = (query == null || query.isEmpty)
          ? await CourseService.fetchCourses()
          : await CourseService.searchCourses(query);

      if (!mounted) return;
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
      debugPrint("❌ Error loading courses: $e");
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
          onSubmitted: (value) => loadCourses(value),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
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
                    : courses.isEmpty
                    ? const Center(
                        child: Text(
                          "No courses available yet.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
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
                                  // 🔹 الصورة
                                  SizedBox(
                                    height: 220,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(20),
                                                bottom: Radius.circular(20),
                                              ),
                                          child:
                                              c.coverImage != null &&
                                                  c.coverImage!.isNotEmpty
                                              ? Image.network(
                                                  c.coverImage!,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  "assets/MyCorses.png",
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        // 🔹 السعر
                                        Positioned(
                                          top: 12,
                                          left: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                        // 🔹 أيقونة الحفظ
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.bookmark_border,
                                              ),
                                              color: const Color(0xFF007C83),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 🔹 النصوص
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
                                          'By: ${c.teacherName ?? "Unknown"}',
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
