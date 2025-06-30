import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class AppHeader extends StatelessWidget {
  final bool displayBackButton;
  final Function? onBackPressed;
  final bool displayUserIcon;
  final double height;
  final double topViewPadding;
  final Function? onMenuClick;
  AppHeader(
      {this.displayBackButton = true,
      this.onBackPressed,
      this.displayUserIcon = false,
      required this.height,
      required this.topViewPadding,
      this.onMenuClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(HEADER_APP_NAV_BAR),
        fit: BoxFit.cover,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: topViewPadding,
          ),
          SizedBox(
            height: height + PADDING_20,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    SizedBox(
                      height: PADDING_7.heightResponsive(),
                    ),
                    SvgPicture.asset(
                      LOGO_UTINA_WHITE,
                      height: APP_HEADER_LOGO_SIZE.heightResponsive(),
                    ),
                  ]),
                ),
                if (displayBackButton)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          onBackPressed == null
                              ? Navigator.pop(context)
                              : onBackPressed?.call();
                        },
                        icon: const Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: NAVIGATION_BAR_BUTTON_SIZE,
                        )),
                  ),
                if (displayUserIcon)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: PADDING_10.heightResponsive()),
                      child: GestureDetector(
                        onTap: () {
                          onMenuClick?.call();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: PADDING_25,
                          child: SvgPicture.asset(ICON_PROFILE,
                              colorFilter: ColorFilter.mode(
                                  PRIMARY_BLUE_COLOR, BlendMode.srcIn)),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
