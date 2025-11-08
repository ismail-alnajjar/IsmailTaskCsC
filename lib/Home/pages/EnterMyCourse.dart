import 'package:flutter/material.dart';
import 'package:taskcsc/Home/pages/CoursePlayingPage.dart';

class EnterMyCourses extends StatelessWidget {
  final String title;
  final String teacherName;
  final String description;
  final String coverImage;
  final int lessons;
  final int chapters;

  const EnterMyCourses({
    super.key,
    required this.title,
    required this.teacherName,
    required this.description,
    required this.coverImage,
    required this.lessons,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF8F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Course Playing",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 صورة الكورس
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: (coverImage.isNotEmpty)
                  ? Image.network(
                      coverImage.startsWith('http')
                          ? coverImage
                          : "http://10.0.2.2:7295/$coverImage",
                      width: double.infinity,
                      height: size.height * 0.25,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/MyCorses.png",
                      width: double.infinity,
                      height: size.height * 0.25,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 20),

            // 🔹 معلومات الدروس والفصول
            Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  color: const Color(0xFF087785),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "$lessons Lessons",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.article_outlined,
                  color: Color(0xFF087785),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "$chapters Chapters",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 عنوان الكورس
            Text(
              title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // 🔹 اسم المدرس
            Text(
              "By: $teacherName",
              style: const TextStyle(
                color: Color(0xFF087785),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),

            // 🔹 صور الطلاب وعددهم
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 120,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: List.generate(3, (index) {
                      return Positioned(
                        left: index * 25,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage(
                              'assets/p${index + 1}.png',
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF087785).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "163+",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 🔹 الوصف
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description.isNotEmpty
                  ? description
                  : "No description available for this course.",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14.5,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 35),

            // 🔹 الأسابيع (Weeks)
            const WeekSection(
              weekTitle: "Week 1-2",
              weekSubtitle: "Introduction to UI/UX Design",
            ),
            const SizedBox(height: 18),
            const WeekSection(
              weekTitle: "Week 3-4",
              weekSubtitle: "User Research & Analysis",
            ),
            const SizedBox(height: 18),
            const WeekSection(
              weekTitle: "Week 5-6",
              weekSubtitle: "Wireframing & Prototyping",
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // 🔹 زر التشغيل (Floating)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CoursePlayingPage()),
          );
        },
        backgroundColor: const Color(0xFF087785),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}

// 🔹 Widget للأسابيع
class WeekSection extends StatelessWidget {
  final String weekTitle;
  final String weekSubtitle;

  const WeekSection({
    super.key,
    required this.weekTitle,
    required this.weekSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF087785),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.book, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weekTitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                weekSubtitle,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
