import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';
import 'package:optorg_mobile/utils/app_navigation.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/utils/shared_prefs.dart';
import 'package:optorg_mobile/utils/utils.dart';
import 'package:optorg_mobile/widgets/app_dialog.dart';
import 'package:optorg_mobile/widgets/custom_popup_bottom_sheet.dart';

class AppScaffold extends StatefulWidget {
  final Widget screenContent;
  final bool displayBackButton;
  final Function? onBackPressed;
  final bool displayLogoutButton;
  final bool displayUserIcon;
  final bool hideMyAccountMenu;

  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final Widget? screenBackground;

  final bool withAppBar;

  final int? contentMaxWidth;
  final Widget? floatingActionButton;
  const AppScaffold(
      {required this.screenContent,
      this.displayBackButton = true,
      this.onBackPressed,
      this.floatingActionButton,
      this.displayUserIcon = false,
      this.hideMyAccountMenu = false,
      this.displayLogoutButton = false,
      this.backgroundColor,
      this.bottomNavigationBar,
      this.resizeToAvoidBottomInset,
      this.withAppBar = true,
      this.screenBackground,
      this.contentMaxWidth = 1000});
  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

// +++++++++++++++++++++++
// +++++++++++++++++++++++
class _AppScaffoldState extends State<AppScaffold> {
  bool isMenuDisplayed = false;
  // ******
  // ******
  @override
  Widget build(BuildContext context) {
    double appBarHeight = APP_BAR_DEFAULT_SIZE.heightResponsive();
    double topViewPadding = MediaQuery.of(context).viewPadding.top;
    double totalAppBarHeight =
        topViewPadding + (widget.withAppBar ? appBarHeight : 0);
    double screenContentHeight =
        MediaQuery.of(context).size.height - totalAppBarHeight;
    return Scaffold(
        floatingActionButton: widget.floatingActionButton,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        bottomNavigationBar: widget.bottomNavigationBar,
        appBar: null,
        body: Container(
          color: widget.backgroundColor ?? Colors.grey.shade100,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: widget.withAppBar,
                child: renderEFloAppBar(
                    displayLogouButton: widget.displayLogoutButton,
                    displayBackButton: widget.displayBackButton,
                    onBackPressed: widget.onBackPressed,
                    displayUserIcon: widget.displayUserIcon,
                    height: appBarHeight,
                    onMenuClick: _onMenuClick,
                    topViewPadding: topViewPadding),
              ),
            ),
            Positioned(
                top: totalAppBarHeight * 0.9 - PADDING_5.heightResponsive(),
                left: 0,
                right: 0,
                height: screenContentHeight,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding:
                        EdgeInsets.only(top: PADDING_20.heightResponsive()),
                    constraints: widget.contentMaxWidth != null
                        ? BoxConstraints(
                            maxWidth: widget.contentMaxWidth!.toDouble())
                        : null,
                    decoration: BoxDecoration(
                        color: widget.withAppBar
                            ? Colors.grey.shade100
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(APP_BAR_BORDER_RADIUS),
                            topRight: Radius.circular(APP_BAR_BORDER_RADIUS))),
                    child: widget.screenContent,
                  ),
                )),
            Positioned(
              top: totalAppBarHeight * 0.9 - PADDING_5.heightResponsive(),
              right: PADDING_5.widthResponsive(),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  width: PADDING_60.widthResponsive(),
                  height: isMenuDisplayed ? PADDING_180.heightResponsive() : 0,
                  child: Column(
                    children: [
                      widget.hideMyAccountMenu == false
                          ? InkWell(
                              onTap: _onMyAccountClick,
                              child: CircleAvatar(
                                backgroundColor: PRIMARY_BLUE_COLOR,
                                radius: PADDING_20,
                                child: SvgPicture.asset(MENU_SETTINGS_ICON,
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn)),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: PADDING_5.heightResponsive(),
                      ),
                      InkWell(
                        onTap: _onLogoutClick,
                        child: CircleAvatar(
                          backgroundColor: PRIMARY_BLUE_COLOR,
                          radius: 17,
                          child: SvgPicture.asset(MENU_LOGOUT_ICON,
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ));
  }

  // ******
  // ******
  _onMenuClick() {
    setState(() {
      isMenuDisplayed = !isMenuDisplayed;
    });
  }

  // ******
  // ******
  _onLogoutClick() {
    _onMenuClick();
    CustomPopupBottomSheet.showBottomSheet(
        context,
        CustomPopupBottomSheet(
          popupContent: AppDialog.twoButtonsDialog(
            background: Colors.white,
            title: appName.toUpperCase(),
            description: DISCONNECT_APP_MESSAGE,
            buttonText: BUTTON_LOGOUT_TEXT,
            onClickHandler: () {
              AppDataStore().clearAppData().then((value) async {
                await SharedPrefs.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    ROUTE_TO_LOGIN_SCREEN, (route) => false,
                    arguments: ROUTE_TO_LOGIN_SCREEN);
              });
            },
            onCancelClickHandler: () {
              Navigator.pop(context);
            },
          ),
        ),
        isScrollControlled: true,
        isDismissible: true);
    return;
  }
  // *************
  // *************

  // ******
  // ******
  _onMyAccountClick() {
    _onMenuClick();
    AppNavigation.goToMyAccountScreen();
  }
}
