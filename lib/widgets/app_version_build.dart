import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/versions.dart';
import 'package:optorg_mobile/utils/utils.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class AppVersionBuild extends StatefulWidget {
  @override
  _AppVersionState createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersionBuild> {
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (appVersion.isEmpty) {
        _getAppVersion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextView(
      text: "${ENV.toUpperCase()} $appVersion",
      textColor: PRIMARY_BLUE_COLOR,
      textSize: VERSION_BUILD_TEXT_SIZE,
    );
  }

  _getAppVersion() async {
    String appVersionBuild = await getAppVersionBuild();
    setState(() {
      appVersion = appVersionBuild;
    });
  }
}
