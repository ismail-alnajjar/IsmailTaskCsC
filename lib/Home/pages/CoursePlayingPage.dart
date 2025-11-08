import 'package:flutter/material.dart';

class CoursePlayingPage extends StatelessWidget {
  const CoursePlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF8F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Course Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Course 1",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            const Text(
              "UI & UX Design Basic",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "UI Refers To The Screens, Buttons, Toggles, Icons, And Other Visual...",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 أزرار الكورسات وعدد الطلاب
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007C83).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "16 Courses",
                    style: TextStyle(
                      color: Color(0xFF007C83),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC857),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "235+ Lessons",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🔹 الدروس (قائمة)
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: const [
                  LessonCard(
                    title: "Advance Prototyping",
                    lessons: "48 Lessons",
                    chapters: "25 Chapters",
                    duration: "2hr 45min",
                  ),
                  LessonCard(
                    title: "UI Design With Figma",
                    lessons: "48 Lessons",
                    chapters: "25 Chapters",
                    duration: "2hr 45min",
                  ),
                  LessonCard(
                    title: "How To Become UX Designer",
                    lessons: "48 Lessons",
                    chapters: "25 Chapters",
                    duration: "2hr 45min",
                  ),
                  LessonCard(
                    title: "Art Director & Design Leadership",
                    lessons: "48 Lessons",
                    chapters: "25 Chapters",
                    duration: "2hr 45min",
                  ),
                  LessonCard(
                    title: "Build Own Portfolio",
                    lessons: "48 Lessons",
                    chapters: "25 Chapters",
                    duration: "2hr 45min",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ مكون خاص لكل كارد درس
class LessonCard extends StatelessWidget {
  final String title;
  final String lessons;
  final String chapters;
  final String duration;

  const LessonCard({
    super.key,
    required this.title,
    required this.lessons,
    required this.chapters,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.book_outlined, color: Color(0xFF007C83)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "$lessons • $chapters • $duration",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFF007C83),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
