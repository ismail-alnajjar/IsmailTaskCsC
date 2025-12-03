class Course {
  final int? id;
  final String title;
  final String? description;
  final String? teacherName;
  final double? price;
  late String? coverImage;

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

    return Course(
      id: json['id'] ?? json['Id'],
      title: json['title'] ?? json['Title'] ?? '',
      description: json['description'] ?? json['Description'],
      teacherName: teacherRaw?.toString() ?? 'Unknown',
      price: _parsePrice(json['price'] ?? json['Price']),
      coverImage:
          json['coverImageUrl'] ??
          json['coverImage'] ??
          json['coverUrl'] ??
          json['CoverImage'] ??
          json['CoverUrl'] ??
          json['imageUrl'] ??
          json['ImageUrl'] ??
          '',
    );
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
