import 'package:flutter/material.dart';

class MyCircularImageBackground extends StatelessWidget {
  final AssetImage imagePath;
  final Color color;
  final double size;
  const MyCircularImageBackground(
      {super.key, required this.imagePath, required this.color, this.size = 260.0});

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
        child: Image(
          image: imagePath,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
