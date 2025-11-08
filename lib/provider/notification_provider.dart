import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  bool _hasNewNotification = false;
  bool get hasNewNotification => _hasNewNotification;

  final List<Map<String, String>> _notifications = [];
  List<Map<String, String>> get notifications =>
      List.unmodifiable(_notifications);

  bool _disposed = false;

  NotificationProvider() {
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() {
    // ✅ استقبال إشعارات أثناء فتح التطبيق
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "New Notification";
      final body = message.notification?.body ?? "No content";

      _addNotification(title, body);
    });

    // ✅ لما المستخدم يفتح الإشعار من الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Opened Notification";
      final body = message.notification?.body ?? "No content";

      _addNotification(title, body);
    });
  }

  // ✅ إضافة إشعار آمن
  void _addNotification(String title, String body) {
    _notifications.insert(0, {"title": title, "body": body});
    _hasNewNotification = true;
    _safeNotify();
  }

  // ✅ مسح كل الإشعارات
  void clearNotifications() {
    _notifications.clear();
    _safeNotify();
  }

  // ✅ حذف إشعار واحد فقط
  void removeNotificationAt(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      _safeNotify();
    }
  }

  // ✅ عند الدخول لصفحة الإشعارات
  void markNotificationsAsRead() {
    _hasNewNotification = false;
    _safeNotify();
  }

  // ✅ دالة أمان بدل notifyListeners() العادي
  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
