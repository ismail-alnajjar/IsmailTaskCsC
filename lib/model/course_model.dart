class Course {
  final int? id;
  final String title;
  final String? description;
  final String? teacherName;
  final double? price;
  final String? coverImage;

  Course({
    this.id,
    required this.title,
    this.description,
    this.teacherName,
    this.price,
    this.coverImage,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    dynamic teacherRaw;

    // 🔹 نحاول نلتقط اسم المدرّس من كل مفتاح محتمل
    teacherRaw =
        json['teacherName'] ??
        json['TeacherName'] ??
        json['author'] ??
        json['Author'] ??
        json['teacher'] ??
        json['Teacher'];

    // 🔹 إذا كانت teacher عبارة عن object يحتوي name
    if (teacherRaw == null && json['teacher'] is Map) {
      final t = json['teacher'] as Map;
      teacherRaw = t['name'] ?? t['fullName'] ?? t['teacherName'];
    }

    final course = Course(
      id: json['id'] ?? json['Id'],
      title: json['title'] ?? json['Title'] ?? '',
      description: json['description'] ?? json['Description'],
      teacherName: teacherRaw?.toString() ?? 'Unknown',
      price: _parsePrice(json['price'] ?? json['Price']),
      coverImage: json['coverImageUrl'] ??
          json['coverImage'] ??
          json['coverUrl'] ??
          json['CoverImage'] ??
          json['CoverUrl'] ??
          json['imageUrl'] ??
          json['ImageUrl'] ??
          '',
    );

    // 🔹 تصحيح الرابط القديم إذا وجد
    // 🔹 تصحيح الرابط القديم إذا وجد
    if (course.coverImage != null) {
      String finalImage = course.coverImage!;
      
      // 1. استبدال الدومين القديم بالجديد
      if (finalImage.contains("suhaib0000-001-site1.jtempurl.com")) {
        finalImage = finalImage.replaceAll(
          "suhaib0000-001-site1.jtempurl.com",
          "suhaib0000-001-site5.jtempurl.com",
        );
      }

      // 2. إذا كان الرابط لا يبدأ بـ http (أي مسار نسبي أو اسم ملف فقط)
      if (!finalImage.startsWith('http')) {
        // إذا كان يبدأ بـ /uploads/courses/ أو uploads/courses/
        if (finalImage.startsWith('/')) {
            finalImage = "http://suhaib0000-001-site5.jtempurl.com$finalImage";
        } else {
            // إذا كان اسم ملف فقط أو مسار نسبي بدون / في البداية
            finalImage = "http://suhaib0000-001-site5.jtempurl.com/$finalImage";
        }
      }

      return Course(
        id: course.id,
        title: course.title,
        description: course.description,
        teacherName: course.teacherName,
        price: course.price,
        coverImage: finalImage,
      );
    }

    return course;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "teacherName": teacherName,
      "price": price,
      "coverImage": coverImage,
    };
  }

  static double? _parsePrice(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
