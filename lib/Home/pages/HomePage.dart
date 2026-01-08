import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/Home/Widgets/CategoryChipsRow.dart';
import 'package:taskcsc/Home/Widgets/HeaderSection/HeaderSectionHome.dart';
import 'package:taskcsc/Home/Widgets/PopularSection/PopularCoursesSection.dart';
import 'package:taskcsc/Home/Widgets/SearchBarHome.dart';
import 'package:taskcsc/Home/Widgets/TrendingCoursesSection.dart';
import 'package:taskcsc/model/course_model.dart';
import 'package:taskcsc/provider/menu_provider.dart';
import 'package:taskcsc/services/course_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    try {
      final fetchedCourses = await CourseService.fetchCourses();
      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching courses: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menu, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFDF8F6),
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: RefreshIndicator(
                    onRefresh: loadCourses,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const HeaderSectionHome(),
                        const SizedBox(height: 30),
                        const SearchBarHome(),
                        const SizedBox(height: 20),
                        const CategoryChipsRow(),
                        const SizedBox(height: 25),

                        // ✅ هنا تعديل الـ TrendingCoursesSection
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : TrendingCoursesSection(
                                courses: courses
                                    .map(
                                      (c) => {
                                        "title": c.title,
                                        // ✅ عرض اسم المدرّس الصحيح
                                        "author": c.teacherName ?? "Unknown",
                                        "price": c.price?.toString() ?? "Free",
                                        "coverImage": c.coverImage,
                                        "description": c.description,
                                      },
                                    )
                                    .toList(),

                                // ✅ التنقل لصفحة التفاصيل DiscPay
                                onCourseTap: (course) {
                                  Navigator.pushNamed(
                                    context,
                                    '/DiscPay',
                                    arguments: course,
                                  );
                                },
                              ),

                        const PopularCoursesSection(),
                      ],
                    ),
                  ),
                ),

                // 🔹 الزر العائم
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(top: false, child: Center(heightFactor: 0.4)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
