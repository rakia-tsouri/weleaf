import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class ApiError extends StatelessWidget {
  final String errorMessage;
  final Color textColor;

  ApiError(
      {this.errorMessage = API_ERROR_MESSAGE, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: API_ERROR_CONTAINER_WIDTH.widthResponsive(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              color: Colors.red, size: API_ERROR_ICON_SIZE.widthResponsive()),
          TextView(text: this.errorMessage, textColor: this.textColor)
        ],
      ),
    );
  }
}
