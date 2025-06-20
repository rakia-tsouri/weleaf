import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optorg_mobile/constants/images.dart';

class OfferDetailGradientBackground extends StatelessWidget {
  const OfferDetailGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      APP_GRADIENT_BACKGROUND,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
  }
}
