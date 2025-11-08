import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/provider/notification_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _snackBarVisible = false;

  @override
  void initState() {
    super.initState();

    // ✅ إزالة النقطة الحمراء عند فتح صفحة الإشعارات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationProvider>().markNotificationsAsRead();
      }
    });
  }

  /// 🔔 دالة آمنة لعرض SnackBar بدون تكرار أو تعارض مفاتيح
  void _showSafeSnackBar(BuildContext context, String message) {
    if (_snackBarVisible) return; // يمنع التكرار
    _snackBarVisible = true;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.teal,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        ).closed.then((_) {
          if (mounted) setState(() => _snackBarVisible = false);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black54),
              tooltip: "Clear all notifications",
              onPressed: () {
                context.read<NotificationProvider>().clearNotifications();
                _showSafeSnackBar(context, "🧹 All notifications cleared");
              },
            ),
        ],
      ),

      // ✅ عرض الإشعارات أو رسالة فارغة
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications yet 📭",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Colors.black12),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.teal,
                    ),
                    title: Text(
                      n["title"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      n["body"] ?? "",
                      style: const TextStyle(color: Colors.black87),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        provider.removeNotificationAt(index);
                        _showSafeSnackBar(context, "🗑️ Notification removed");
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
