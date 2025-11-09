import 'package:flutter/material.dart';
import 'package:taskcsc/Home/pages/CoursePlayingPage.dart';

class CourseDetailPage extends StatelessWidget {
  final String title;
  final String teacherName;
  final String description;
  final double price;
  final String coverImage;

  const CourseDetailPage({
    super.key,
    required this.title,
    required this.teacherName,
    required this.description,
    required this.price,
    required this.coverImage,
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
        title: const Text(
          "Course Details",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 صورة الكورس (محسّنة)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: (coverImage.isNotEmpty)
                  ? Image.network(
                      coverImage.startsWith('http')
                          ? coverImage
                          : "https://suhaib0000-001-site1.jtempurl.com/$coverImage",
                      width: double.infinity,
                      height: size.height * 0.25,
                      fit: BoxFit.cover,
                      // 🔸 في حال فشل تحميل الصورة
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/MyCorses.png", // صورة افتراضية
                          width: double.infinity,
                          height: size.height * 0.25,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      "assets/MyCorses.png",
                      width: double.infinity,
                      height: size.height * 0.25,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(height: 16),

            // 🔹 الاسم والسعر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007C83),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              "By: $teacherName",
              style: const TextStyle(
                color: Color(0xFF258A95),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),
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
                  : "No description available.",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14.5,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 الزر المعدل بتدرّج لوني
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoursePlayingPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF087785), // أزرق غامق
                        Color(0xFF0B3A54), // أزرق فاتح
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Start Learning",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
