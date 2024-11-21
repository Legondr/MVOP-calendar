import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 3, 192, 244)),
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Image.asset(
        imagePath,
        height: 40,
        width: 40,
      ),
    );
  }
}
