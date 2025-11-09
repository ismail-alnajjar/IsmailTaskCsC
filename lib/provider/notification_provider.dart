import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  bool _hasNewNotification = false;
  bool get hasNewNotification => _hasNewNotification;

  final List<Map<String, String>> _notifications = [];
  List<Map<String, String>> get notifications =>
      List.unmodifiable(_notifications);

  bool _disposed = false;

  NotificationProvider() {
    _initFirebaseMessaging();
    _loadNotificationsFromStorage(); // ✅ تحميل الإشعارات عند التشغيل
  }

  void _initFirebaseMessaging() {
    // ✅ استقبال الإشعارات أثناء تشغيل التطبيق
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "New Notification";
      final body = message.notification?.body ?? "No content";
      _addNotification(title, body);
    });

    // ✅ لما المستخدم يفتح إشعار من الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Opened Notification";
      final body = message.notification?.body ?? "No content";
      _addNotification(title, body);
    });
  }

  // ✅ تحميل الإشعارات من SharedPreferences
  Future<void> _loadNotificationsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getStringList('notifications') ?? [];
    _notifications.clear();
    _notifications.addAll(
      savedData.map((n) => Map<String, String>.from(jsonDecode(n))),
    );
    _safeNotify();
  }

  // ✅ حفظ الإشعارات عند التعديل
  Future<void> _saveNotificationsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _notifications.map((n) => jsonEncode(n)).toList();
    await prefs.setStringList('notifications', encoded);
  }

  // ✅ إضافة إشعار جديد
  void _addNotification(String title, String body) {
    _notifications.insert(0, {"title": title, "body": body});
    _hasNewNotification = true;
    _saveNotificationsToStorage();
    _safeNotify();
  }

  // ✅ حذف إشعار واحد
  void removeNotificationAt(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      _saveNotificationsToStorage();
      _safeNotify();
    }
  }

  // ✅ مسح كل الإشعارات
  void clearNotifications() {
    _notifications.clear();
    _saveNotificationsToStorage();
    _safeNotify();
  }

  // ✅ عند الدخول لصفحة الإشعارات
  void markNotificationsAsRead() {
    _hasNewNotification = false;
    _safeNotify();
  }

  // ✅ حماية أثناء الإشعارات
  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
