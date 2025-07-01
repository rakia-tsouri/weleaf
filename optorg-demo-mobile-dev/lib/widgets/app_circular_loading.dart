import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';

class AppCircularLoading extends StatelessWidget {
  const AppCircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          backgroundColor: CIRCULAR_PROGRESS_VALUE_COLOR,
          color: Colors.grey.shade100,
        ));
  }
}
