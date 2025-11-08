import 'package:flutter/material.dart';
import 'package:taskcsc/Home/pages/PayPage.dart';
import 'package:taskcsc/model/course_model.dart';

class DiscPay extends StatelessWidget {
  final Course course; // ✅ استقبال بيانات الكورس مباشرة

  const DiscPay({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Course Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼️ صورة الكورس
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: _buildCoverImage(),
                ),

                // 🧾 التفاصيل
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 السعر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F6F8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              (course.price ?? 0) > 0
                                  ? "\$${course.price!.toStringAsFixed(2)}"
                                  : "Free",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF007C83),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border_rounded),
                            color: const Color(0xFF007C83),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Added to favorites 💚"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 🔹 العنوان
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 🔹 اسم المدرّس
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color(0xFF258A95),
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "By: ${course.teacherName ?? 'Unknown'}",
                            style: const TextStyle(
                              color: Color(0xFF258A95),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 🔹 الوصف
                      Text(
                        course.description?.trim().isNotEmpty == true
                            ? course.description!
                            : 'No description available for this course.',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // 🔹 زر الشراء
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007C83),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PayPage(
                                  buttonTitle: "Proceed to Payment",
                                  course: course,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🧩 دالة بناء صورة الغلاف
  Widget _buildCoverImage() {
    if (course.coverImage != null && course.coverImage!.isNotEmpty) {
      final url = course.coverImage!.startsWith('http')
          ? course.coverImage!
          : "http://10.0.2.2:7295/${course.coverImage!}";
      return Image.network(
        url,
        width: double.infinity,
        height: 230,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    } else {
      return _fallbackImage();
    }
  }

  /// 🖼️ صورة بديلة
  Widget _fallbackImage() {
    return Image.asset(
      'assets/getstart.png',
      width: double.infinity,
      height: 230,
      fit: BoxFit.cover,
    );
  }
}
