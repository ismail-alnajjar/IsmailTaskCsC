import 'dart:io'; // ✅ مهم لحل مشكلة SSL

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 🟢 الصفحات
import 'package:taskcsc/Home/Widgets/PopularSection/popularCoursesPage.dart';
import 'package:taskcsc/Home/pages/CourseDetail.dart';
import 'package:taskcsc/Home/pages/CoursePlayingPage.dart';
import 'package:taskcsc/Home/pages/CoursesPage.dart';
import 'package:taskcsc/Home/pages/DiscPay.dart';
import 'package:taskcsc/Home/pages/EnterMyCourse.dart';
import 'package:taskcsc/Home/pages/HomePage.dart';
import 'package:taskcsc/Home/pages/MYCOURSme.dart';
import 'package:taskcsc/Home/pages/NotificationsPage.dart';
import 'package:taskcsc/Home/pages/ProfilePage.dart';
import 'package:taskcsc/Home/pages/Setting/EditProfile.dart';
import 'package:taskcsc/Home/pages/Setting/SettingPage.dart';
import 'package:taskcsc/Home/pages/Setting/changePass.dart';
import 'package:taskcsc/Home/pages/TextScreen/CoursesIntroScreenPage3.dart';
import 'package:taskcsc/Home/pages/TextScreen/LearningPage5.dart';
import 'package:taskcsc/Home/pages/TextScreen/SchedulePage4.dart';
import 'package:taskcsc/Home/pages/TextScreen/splashScreenPage1.dart';
import 'package:taskcsc/Home/sections/FloatingMenu/FloatingMenuButton.dart';
import 'package:taskcsc/Home/sections/FloatingMenu/main_shell.dart';
import 'package:taskcsc/app_initializer.dart';
// 🟢 Auth
import 'package:taskcsc/log & sign/Login/LoginPage6.dart';
import 'package:taskcsc/log & sign/SignUp/SignUpPage7.dart';
// 🟢 Providers
import 'package:taskcsc/model/course_model.dart';
import 'package:taskcsc/provider/login_provider.dart';
import 'package:taskcsc/provider/menu_provider.dart';
import 'package:taskcsc/provider/notification_provider.dart';
import 'package:taskcsc/services/course_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ يسمح بالاتصال مع HTTPS حتى لو الشهادة غير موثوقة
  HttpOverrides.global = MyHttpOverrides();

  // ✅ تهيئة Firebase و FCM
  await AppInitializer.init();
  await CourseSyncService.syncApiToFirebase(); // ⬅️ المهم

  runApp(const SystemPage());
}

// ✅ كلاس لتجاهل التحقق من SSL (ضروري لـ jtempurl)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SystemPage extends StatelessWidget {
  const SystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: 'ClashDisplay',
          scaffoldBackgroundColor: const Color(0xFFFDF8F6),
        ),
        home: const SplashScreen(),

        // 🧭 المسارات
        routes: {
          '/login': (context) => const LoginPage(),
          '/SignUp': (context) => const SignUpPage(),
          '/Home': (context) => const HomePage(),
          '/PopularSeeAll': (context) => const PopularSeeAllPage(),
          '/MainShell': (context) => const MainShell(),
          '/profile': (context) => const ProfilePage(),
          '/Settings': (context) => const SettingsPage(),
          '/CoursesPage': (context) => const CoursesPage(),
          '/CoursePlayingPage': (context) => const CoursePlayingPage(),
          '/MyCoursesMe': (context) => const MyCoursesMe(),
          '/CoursesIntro': (context) => const CoursesIntroScreen(),
          '/Schedule': (context) => const Schedule(),
          '/LearningP': (context) => const LearningPage5(),
          '/NotificationsPage': (context) => const NotificationsPage(),
          '/FloatingMenuButton': (context) => const FloatingMenuButton(),
          '/editProfile': (_) => const EditProfilePage(),
          '/changePassword': (_) => const ChangePasswordPage(),
          // 🟢 EnterMyCourses
          '/EnterMyCourses': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is Map<String, dynamic>) {
              return EnterMyCourses(
                title: args['title'] ?? 'Untitled Course',
                teacherName: args['teacherName'] ?? 'Unknown',
                description: args['description'] ?? 'No description available',
                coverImage: args['coverImage'] ?? '',
                lessons: args['lessons'] ?? 48,
                chapters: args['chapters'] ?? 25,
              );
            }
            return const Scaffold(
              body: Center(
                child: Text(
                  "⚠️ Invalid or missing course data for EnterMyCourses!",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          },

          // 🟢 CourseDetail
          '/CourseDetail': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is Course) {
              return CourseDetailPage(
                title: args.title,
                teacherName: args.teacherName ?? 'Unknown',
                description: args.description ?? 'No description available',
                price: args.price ?? 0,
                coverImage: args.coverImage ?? '',
              );
            } else if (args is Map<String, dynamic>) {
              return CourseDetailPage(
                title: args['title'] ?? 'Untitled',
                teacherName: args['teacherName'] ?? 'Unknown',
                description: args['description'] ?? 'No description available',
                price: (args['price'] ?? 0).toDouble(),
                coverImage: args['coverImage'] ?? '',
              );
            }
            return const Scaffold(
              body: Center(
                child: Text(
                  "⚠️ Invalid or missing course data for CourseDetail!",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },

          // 🟢 DiscPay
          '/DiscPay': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is Course) {
              return DiscPay(course: args);
            } else if (args is Map<String, dynamic>) {
              return DiscPay(course: Course.fromJson(args));
            }
            return const Scaffold(
              backgroundColor: Color(0xFFF9F6F7),
              body: Center(
                child: Text(
                  "⚠️ Invalid or missing course data for DiscPay!",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        },
      ),
    );
  }
}
