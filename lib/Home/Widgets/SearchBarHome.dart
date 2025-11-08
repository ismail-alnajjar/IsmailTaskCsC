import 'package:flutter/material.dart';

class SearchBarHome extends StatefulWidget {
  const SearchBarHome({super.key});

  @override
  State<SearchBarHome> createState() => _SearchBarHomeState();
}

class _SearchBarHomeState extends State<SearchBarHome> {
  final TextEditingController _controller = TextEditingController();

  void _openSearchResults() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/PopularSeeAll',
        arguments: {'query': query}, // 👈 إرسال الكلمة للصفحة الثانية
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Colors.black54, size: 26),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _openSearchResults(),
              decoration: const InputDecoration(
                hintText: 'Search Course',
                hintStyle: TextStyle(color: Colors.black45, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF007C83),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _openSearchResults,
                icon: const Icon(Icons.filter_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
