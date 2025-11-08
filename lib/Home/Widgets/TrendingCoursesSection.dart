import 'package:flutter/material.dart';

class TrendingCoursesSection extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final void Function(Map<String, dynamic> course)? onCourseTap;

  const TrendingCoursesSection({
    super.key,
    required this.courses,
    this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 العنوان الرئيسي
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trending Courses 🔥',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/CoursesPage'),
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

        // 🔹 تصميم الكروسات (نفس تصميم الـ Popular)
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];

              final title = course['title'] ?? 'No Title';
              final author = course['author'] ?? 'Unknown';
              final price = course['price']?.toString() ?? '0';
              final imageUrl =
                  course['coverImage'] ??
                  course['coverImageUrl'] ??
                  course['image'] ??
                  "https://via.placeholder.com/400x250.png?text=No+Image";

              return GestureDetector(
                onTap: () => onCourseTap?.call(course),
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 18),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 🔹 الصورة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          imageUrl.startsWith('http')
                              ? imageUrl
                              : "http://10.0.2.2:7295/$imageUrl",
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network(
                                "https://via.placeholder.com/400x250.png?text=No+Image",
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),

                      // 🔹 السعر فوق الصورة
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
                            "\$$price",
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
                            onPressed: () {
                              // TODO: حفظ في المفضلة
                            },
                          ),
                        ),
                      ),

                      // 🔹 النصوص تحت الصورة
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
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'By: $author',
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
