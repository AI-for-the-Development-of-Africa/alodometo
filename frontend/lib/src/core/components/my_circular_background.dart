import 'package:flutter/material.dart';

class MyCircularBackground extends StatelessWidget {
  final Color color;
  final double size;
  const MyCircularBackground(
      {super.key, required this.color, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: const ClipOval(),
    );
  }
}
