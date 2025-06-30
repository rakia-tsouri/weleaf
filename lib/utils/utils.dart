import 'package:flutter/material.dart';
import 'package:optorg_mobile/widgets/app_header.dart';
import 'package:package_info_plus/package_info_plus.dart';

// ******************
// ******************
// ******************
unfocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

// ******************
// ******************
// ******************
AppHeader renderEFloAppBar(
    {bool displayBackButton = true,
    Function? onBackPressed,
    bool displayLogouButton = false,
    bool displayUserIcon = false,
    required double height,
    final Function? onMenuClick,
    required double topViewPadding}) {
  return AppHeader(
    displayBackButton: displayBackButton,
    onBackPressed: onBackPressed,
    displayUserIcon: displayUserIcon,
    height: height,
    topViewPadding: topViewPadding,
    onMenuClick: onMenuClick,
  );
}

// ******************
// ******************
// ******************
Future<String> getAppVersionBuild() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return "${packageInfo.version}-${packageInfo.buildNumber}";
}
