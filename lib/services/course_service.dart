import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskcsc/model/course_model.dart';

/// 🔹 خدمة إدارة الكورسات (عرض، إضافة، تعديل، حذف، بحث)
class CourseService {
  // ✅ غيّر الـ IP حسب شبكتك المحلية
  static const String baseUrl = "http://10.180.177.246:7295/api/";

  /// 🟢 جلب جميع الكورسات
  static Future<List<Course>> fetchCourses() async {
    final url = "${baseUrl}CoursesApi";
    return _getCourses(url);
  }

  /// 🔍 البحث عن الكورسات بالاسم أو الوصف (يستخدم ?q=)
  static Future<List<Course>> searchCourses(String query) async {
    final url = "${baseUrl}CoursesApi?q=${Uri.encodeQueryComponent(query)}";
    return _getCourses(url);
  }

  /// ♻️ دالة خاصة لمعالجة الاستجابة
  static Future<List<Course>> _getCourses(String url) async {
    try {
      print("🌍 GET: $url");
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      print("✅ Status: ${response.statusCode}");
      print("📦 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🔹 لو النتيجة object يحتوي على "courses" بدل list مباشرة
        final List<dynamic> coursesData = data is List
            ? data
            : (data['courses'] ?? data['data'] ?? []);

        if (coursesData.isEmpty) {
          print("⚠️ No courses found in response");
        } else {
          print("📚 Found ${coursesData.length} courses");
          print("👀 Sample course: ${coursesData.first}");
        }

        return coursesData.map((e) => Course.fromJson(e)).toList();
      } else {
        throw Exception('❌ Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("⚠️ Failed to fetch courses: $e");
      throw Exception('⚠️ Failed to fetch courses: $e');
    }
  }

  /// 🟡 إضافة كورس جديد
  static Future<Course> addCourse(Course course) async {
    final url = "${baseUrl}CoursesApi";
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(course.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Course.fromJson(data);
      } else {
        throw Exception(
          '❌ Failed to add course: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ Error adding course: $e');
    }
  }

  /// 🟠 تعديل كورس موجود
  static Future<bool> updateCourse(Course course) async {
    final url = "${baseUrl}CoursesApi/${course.id}";
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(course.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
          '❌ Failed to update course: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ Error updating course: $e');
    }
  }

  /// 🔴 حذف كورس
  static Future<bool> deleteCourse(int id) async {
    final url = "${baseUrl}CoursesApi/$id";
    try {
      final response = await http
          .delete(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
          '❌ Failed to delete course: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ Error deleting course: $e');
    }
  }
}
