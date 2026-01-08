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

  /// ⭐ دالة لإصلاح رابط الصورة (لو كان من API لوكال)
  String fixImageUrl(String url) {
    if (url.isEmpty) return "";
    if (url.startsWith("http")) return url;

    // لو الرابط جاي كـ "uploads/.."
    return "http://10.0.2.2:7295/$url";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),

      // ----------------- APPBAR -----------------
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

      // ----------------- BODY -----------------
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 صورة الكورس (محسّنة)
            Builder(
              builder: (context) {
                String finalImage = coverImage;
                if (finalImage.isNotEmpty) {
                  if (finalImage.contains("suhaib0000-001-site1.jtempurl.com")) {
                    finalImage = finalImage.replaceAll(
                        "suhaib0000-001-site1.jtempurl.com",
                        "suhaib0000-001-site5.jtempurl.com");
                  }
                  if (!finalImage.startsWith('http')) {
                    if (finalImage.startsWith('/')) {
                      finalImage =
                          "http://suhaib0000-001-site5.jtempurl.com$finalImage";
                    } else {
                      finalImage =
                          "http://suhaib0000-001-site5.jtempurl.com/$finalImage";
                    }
                  }
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: (finalImage.isNotEmpty)
                      ? Image.network(
                          finalImage,
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
                );
              },
            ),

            const SizedBox(height: 20),

            // ---------- TITLE + PRICE ----------
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
                      height: 1.3,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF087785),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),

            // ---------- DESCRIPTION ----------
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description.isNotEmpty
                  ? description
                  : "No description available.",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 35),

            // ---------- BUTTON ----------
            GestureDetector(
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
                    colors: [Color(0xFF087785), Color(0xFF0B3A54)],
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
