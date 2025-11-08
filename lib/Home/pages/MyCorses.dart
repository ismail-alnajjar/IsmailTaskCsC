import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/provider/menu_provider.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<MenuProvider>(context, listen: false);

    final List<Map<String, String>> courses = [
      {
        "title": "Introduction To Programming",
        "author": "John Smith",
        "progress": "75",
        "duration": "2hr 45min",
        "lessons": "48 Lessons",
        "image": "assets/MyCorses.png",
      },
      {
        "title": "UI Design With Figma",
        "author": "John Smith",
        "progress": "75",
        "duration": "2hr 45min",
        "lessons": "48 Lessons",
        "image": "assets/image.png",
      },
      {
        "title": "Build Own Portfolio",
        "author": "John Smith",
        "progress": "75",
        "duration": "2hr 45min",
        "lessons": "48 Lessons",
        "image": "assets/image (1).png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F7),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            padding: EdgeInsets.zero,
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
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF007C83),
                size: 26,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),

      // 🔹 المحتوى
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            final int progress = int.parse(course['progress']!);

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ حولنا الصورة إلى GestureDetector
                    GestureDetector(
                      onTap: () {
                        // ✅ الانتقال إلى صفحة تفاصيل الكورس
                        Navigator.pushNamed(
                          context,
                          '/CourseDetail',
                          arguments: {
                            "title": course['title'],
                            "author": course['author'],
                            "image": course['image'],
                            "lessons": course['lessons'],
                            "duration": course['duration'],
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          course['image']!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // 🔹 التفاصيل
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your progress",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "$progress% to complete",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF007C83),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "03 min →",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 6,
                              backgroundColor: const Color(
                                0xFFE0E0E0,
                              ).withOpacity(0.6),
                              color: const Color(0xFF007C83),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            course['title']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "By: ${course['author']}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF258A95),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.play_circle_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                course['lessons']!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                course['duration']!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
    );
  }
}
