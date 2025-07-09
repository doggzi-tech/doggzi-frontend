import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A custom loader widget using staggeredDotsWave animation
class CustomLoader extends StatelessWidget {
  /// The size of the loader dots
  final double size;

  /// The color of the loader dots
  final Color color;

  /// Creates a [CustomLoader] with optional [size] and [color]
  const CustomLoader({
    Key? key,
    this.size = 50.0,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: color,
        size: size,
      ),
    );
  }
}
