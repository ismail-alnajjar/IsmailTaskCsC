import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/provider/notification_provider.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final hasNewNotification = context
        .watch<NotificationProvider>()
        .hasNewNotification;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {
              context.read<NotificationProvider>().markNotificationsAsRead();
              Navigator.pushNamed(context, '/NotificationsPage');
            },
          ),
        ),
        if (hasNewNotification)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
