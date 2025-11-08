import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 0,

            color: Color.fromARGB(
              31,
              255,
              255,
              255,
            ), // Colors.black12 (لون خفيف للخط)
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or',
            style: TextStyle(
              color: Colors.black, // Colors.black
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 0,
            color: Color.fromARGB(31, 255, 254, 254), // Colors.black12
          ),
        ),
      ],
    );
  }
}
