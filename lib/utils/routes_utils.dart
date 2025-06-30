import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/views/login_screen/login_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  if (settings.name == ROUTE_TO_LOGIN_SCREEN) {
    String route = settings.arguments.toString();
    return MaterialPageRoute(
      builder: (context) {
        return LoginScreen(
          route: route,
        );
      },
    );
  } else {
// no route found
    return MaterialPageRoute(
      builder: (context) {
        return Container();
      },
    );
  }
}
