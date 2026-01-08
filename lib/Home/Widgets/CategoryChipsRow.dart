import 'package:flutter/material.dart';
import 'package:taskcsc/services/course_service.dart';

class CategoryChipsRow extends StatefulWidget {
  const CategoryChipsRow({super.key});

  @override
  State<CategoryChipsRow> createState() => _CategoryChipsRowState();
}

class _CategoryChipsRowState extends State<CategoryChipsRow> {
  int selectedIndex = 0;
  List<String> categories = ['All']; // Default category
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await CourseService.fetchCategories();
      if (mounted) {
        setState(() {
          categories = ['All', ...fetchedCategories];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Error fetching categories: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 40,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (value) {
                setState(() => selectedIndex = index);
              },
              selectedColor: const Color(0xFF007C83),
              backgroundColor: const Color(0xFFEFEFEF),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}
