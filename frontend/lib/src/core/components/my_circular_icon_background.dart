import 'package:flutter/material.dart';

class MyCircularIconBackground extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const MyCircularIconBackground(
      {super.key, required this.icon, required this.color, this.size = 260.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: ClipOval(
        child: Icon(icon, size: 150, color: Colors.white,)
      ),
    );
  }
}
