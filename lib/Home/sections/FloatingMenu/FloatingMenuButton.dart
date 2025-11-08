import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskcsc/provider/menu_provider.dart';

class FloatingMenuButton extends StatefulWidget {
  const FloatingMenuButton({super.key});

  @override
  State<FloatingMenuButton> createState() => _FloatingMenuButtonState();
}

class _FloatingMenuButtonState extends State<FloatingMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<IconData> icons = [
    Icons.home_rounded, // Home
    Icons.grid_view_rounded, // Courses
    Icons.bookmark_border_rounded, // Bookmarks
    Icons.person_outline_rounded, // Profile
    Icons.settings_outlined, // Settings
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menu, _) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return SizedBox(
              width: 340,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// 🟢 الخلفية الرمادية الشفافة
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: menu.isOpen ? 250 : 90,
                    height: menu.isOpen ? 230 : 90,
                    decoration: BoxDecoration(
                      color: menu.isOpen
                          ? const Color(0xffC4C4C4).withAlpha(95)
                          : const Color(0xFF007C83),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(menu.isOpen ? 180 : 45),
                        bottom: Radius.circular(menu.isOpen ? 155 : 45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 الأزرار الصغيرة
                  ...List.generate(icons.length, (index) {
                    final startAngle = -pi / 2000;
                    final endAngle = pi / 1;
                    final step = (endAngle - startAngle) / (icons.length - 1);
                    final angle = startAngle + (index * step);
                    final radius = 78 * _controller.value;

                    return Transform.translate(
                      offset: Offset(radius * cos(angle), -radius * sin(angle)),
                      child: Opacity(
                        opacity: menu.isOpen ? _controller.value : 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: menu.selectedIndex == index
                                ? const Color(0xFF007C83)
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              icons[index],
                              size: 27,
                              color: menu.selectedIndex == index
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                menu.selectIndex(index);

                                // 🔥 كل أيقونة تستدعي الكلاس الخاص فيها
                                switch (index) {
                                  case 0:
                                    HomeAction(context).execute();
                                    break;
                                  case 1:
                                    CoursesAction(context).execute();
                                    break;
                                  case 2:
                                    BookmarkAction(context).execute();
                                    break;
                                  case 3:
                                    ProfileAction(context).execute();
                                    break;
                                  case 4:
                                    SettingsAction(context).execute();
                                    break;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }),

                  /// 🔹 الزر الرئيسي (+ / ×)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: menu.isOpen
                          ? Colors.white
                          : const Color(0xFF007C83),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 40,
                      icon: AnimatedRotation(
                        duration: const Duration(milliseconds: 400),
                        turns: menu.isOpen ? 0.25 : 0,
                        curve: Curves.easeInOut,
                        child: Icon(
                          menu.isOpen ? Icons.close : Icons.add,
                          color: menu.isOpen
                              ? const Color(0xFF007C83)
                              : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          menu.toggleMenu();
                          if (menu.isOpen) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

////////////////////////////////////////
/// 🏠 Home Action
class HomeAction {
  final BuildContext context;
  HomeAction(this.context);

  void execute() {
    final menu = Provider.of<MenuProvider>(context, listen: false);
    menu.selectIndex(0);
  }
}

class CoursesAction {
  final BuildContext context;
  CoursesAction(this.context);

  void execute() {
    final menu = Provider.of<MenuProvider>(context, listen: false);
    menu.selectIndex(1);
  }
}

class BookmarkAction {
  final BuildContext context;
  BookmarkAction(this.context);

  void execute() {
    final menu = Provider.of<MenuProvider>(context, listen: false);
    menu.selectIndex(2);
  }
}

class ProfileAction {
  final BuildContext context;
  ProfileAction(this.context);

  void execute() {
    final menu = Provider.of<MenuProvider>(context, listen: false);
    menu.selectIndex(3);
  }
}

class SettingsAction {
  final BuildContext context;
  SettingsAction(this.context);

  void execute() {
    final menu = Provider.of<MenuProvider>(context, listen: false);
    menu.selectIndex(4);
  }
}
