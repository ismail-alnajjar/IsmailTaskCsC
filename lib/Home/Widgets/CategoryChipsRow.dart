import 'package:flutter/material.dart';

class CategoryChipsRow extends StatefulWidget {
  const CategoryChipsRow({super.key});

  @override
  State<CategoryChipsRow> createState() => _CategoryChipsRowState();
}

class _CategoryChipsRowState extends State<CategoryChipsRow> {
  int selectedIndex = 0;

  final List<String> categories = ['UI & UX', 'Animation', 'Graphic Design'];

  @override
  Widget build(BuildContext context) {
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
