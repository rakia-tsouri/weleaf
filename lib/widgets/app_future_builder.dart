import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/api_error.dart';
import 'package:optorg_mobile/widgets/app_circular_loading.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class AppFutureBuilder<T> extends StatelessWidget {
  final Future<ApiResponse<T>>? future;

  final Widget? errorWidget;

  final Widget? loadingWidget;

  final Widget Function(T) successBuilder;

  final String loadingText;

  final Color loadingTextColor;

  final bool withLoadingText;

  final double? loadingCircleSize;

  final Color errorTextColor;
  final double? height;
  const AppFutureBuilder(
      {Key? key,
      required this.future,
      this.errorWidget,
      this.loadingWidget,
      this.loadingText = LOADING,
      this.loadingTextColor = Colors.black,
      required this.successBuilder,
      this.loadingCircleSize,
      this.errorTextColor = Colors.black,
      this.height,
      this.withLoadingText = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (loadingWidget != null) {
            return loadingWidget!;
          }

          return SizedBox(
            width: double.infinity,
            height: height ?? double.infinity,
            child: SizedBox(
              width: loadingCircleSize,
              height: loadingCircleSize,
              child: withLoadingText
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: loadingWidget ?? AppCircularLoading(),
                        ),
                        SizedBox(
                          height: PADDING_5.heightResponsive(),
                        ),
                        TextView(
                          text: loadingText,
                          textColor: loadingTextColor,
                        )
                      ],
                    )
                  : Center(
                      child: loadingWidget ?? AppCircularLoading(),
                    ),
            ),
          );
        } else if (snapshot.hasData &&
            snapshot.data!.isSuccess() &&
            snapshot.data?.data != null) {
          return successBuilder.call(snapshot.data!.data!);
        } else {
          return errorWidget ??
              Center(
                  child: ApiError(
                      textColor: errorTextColor,
                      errorMessage:
                          snapshot.data?.getErrorMessage() ?? ERROR_OCCURED));
        }
      },
    );
  }
}
