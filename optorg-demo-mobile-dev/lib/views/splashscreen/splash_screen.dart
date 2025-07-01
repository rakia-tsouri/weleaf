import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/utils/app_navigation.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/login_screen/login_screen_vm.dart';
import 'package:optorg_mobile/views/splashscreen/splash_screen_vm.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late LoginScreenVM loginVM;
  late Widget displayedScreen;
// ********
// ********
  @override
  void initState() {
    super.initState();
    loginVM = Provider.of<LoginScreenVM>(context, listen: false);
    Timer(const Duration(milliseconds: 3200), () {
      SplashScreenVM().getUserToken().then((token) async {
        _navigateToNextScreen(token);
      });
    });
  }

// ********
// ********
  _navigateToNextScreen(String? token) async {
    if (token != null) {
      //loginVM.connectedUser = await SplashScreenVM().getUserData();
      // navigate direct to car home screen
      AppNavigation.goToProposalsListScreen(clearAllStack: true);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          ROUTE_TO_LOGIN_SCREEN, (route) => false,
          arguments: ROUTE_TO_LOGIN_SCREEN);
    }
  }

// ********
// ********
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (_, child) {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(SPLASH_SCREEN_BACKGROUND),
                  fit: BoxFit.fill)),
          child: Center(
            child: Image.asset(
              OPTORG_ANIMATION_SPLASH_SCREEN,
              width: SPLASH_SCREEN_LOGO_SIZE.widthResponsive(),
            ),
          ),
        ),
      );
    });
  }
}
