import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_options.dart';

class AppInitializer {
  /// ✅ تهيئة Firebase + Firestore + FCM
  static Future<void> init() async {
    // 🔹 تهيئة Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance;

    // 🔹 إعداد FCM
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 🔹 طلب صلاحيات الإشعارات (Android 13 / iOS)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 🔹 الاشتراك في topic عام
    await messaging.subscribeToTopic("all-users");

    // 🔹 استقبال الإشعارات بالخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    print("✅ Firebase & FCM initialized successfully!");
  }

  // 📬 معالجة الإشعارات في الخلفية
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print("📩 Background message: ${message.notification?.title}");
  }
}
