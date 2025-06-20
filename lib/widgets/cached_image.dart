import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class PagerCachedImage extends StatelessWidget {
  final String? url;
  final double imageSize;
  final BoxFit boxFit;
  final Widget Function()? onErrorBuilder;
  PagerCachedImage(
      {required this.url,
      this.imageSize = PAGER_IMAGE_SIZE,
      this.onErrorBuilder,
      this.boxFit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: url ?? "",
        fit: boxFit,
        width: this.imageSize.widthResponsive(),
        placeholder: (context, url) => Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.grey.shade100,
                color: PRIMARY_YELLOW_COLOR,
              ),
            ),
        errorWidget: (context, url, error) {
          return onErrorBuilder?.call() ??
              new Icon(Icons.error, color: Colors.red, size: ICON_SIZE);
        });
  }
}
