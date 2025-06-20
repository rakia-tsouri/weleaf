import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  AppBackground({@required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: backgroundColor ?? Colors.white,
      child: child,
    );
  }
}
