import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:taskcsc/model/course_model.dart';

class CourseSyncService {
  static const String apiBaseUrl = "http://10.0.2.2:7295/api/CoursesApi";

  /// 🟢 1️⃣ جلب الكورسات من API
  static Future<List<Course>> fetchCoursesFromApi() async {
    final uri = Uri.parse(apiBaseUrl);
    final res = await http.get(uri).timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      throw Exception("Failed to load courses: ${res.statusCode}");
    }

    final List<dynamic> data = jsonDecode(res.body);
    return data.map((e) => Course.fromJson(e)).toList();
  }

  /// 🟡 2️⃣ حفظ الكورسات في Firestore داخل collection "courses"
  static Future<void> saveCoursesToFirebase(List<Course> courses) async {
    final col = FirebaseFirestore.instance.collection('courses');

    for (final course in courses) {
      await col
          .doc(
            course.id?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
          )
          .set({
            'id': course.id,
            'title': course.title,
            'description': course.description,
            'teacherName': course.teacherName,
            'price': course.price,
            'coverImage': course.coverImage,
            'syncedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }
  }

  /// 🔵 3️⃣ استرجاع الكورسات من Firebase
  static Future<List<Course>> fetchCoursesFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('courses')
        .orderBy('syncedAt', descending: true)
        .get();

    return snapshot.docs.map((d) => Course.fromJson(d.data())).toList();
  }

  /// 🔴 4️⃣ مزامنة كاملة (API → Firebase)
  static Future<void> syncApiToFirebase() async {
    final courses = await fetchCoursesFromApi();
    await saveCoursesToFirebase(courses);
    print(
      "✅ ${courses.length} courses synced successfully from API to Firebase!",
    );
  }
}
