import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/views/calculate_screen/calculate_screen.dart';
import 'package:optorg_mobile/views/my_account_screen/my_account_screen.dart';
import 'package:optorg_mobile/pages/home_page.dart';
class AppNavigation {
  static final GlobalKey<NavigatorState> navigatorStateKey = GlobalKey();

  // *************
// *************



  static goToMyAccountScreen(
      {bool clearAllStack = false, bool replace = false}) {
    _goTo(const MyAccountScreen(), ROUTE_TO_MY_ACCOUNT_SCREEN,
        replace: replace, clearAllStack: clearAllStack);
  }

  // *************
// *************
  static goToCalculateScreen(
      {bool clearAllStack = false, bool replace = false}) {
    _goTo(const CalculateScreen(), ROUTE_TO_CALCULATE_SCREEN,
        replace: replace, clearAllStack: clearAllStack);
  }

  static goToBienvenue(
      {bool clearAllStack = false, bool replace = false}) {
      _goTo(const HomePage(), ROUTE_TO_BIENVENUE,
        replace: replace, clearAllStack: clearAllStack);
  }


// *************
// *************
  static pop() {
    navigatorStateKey.currentState?.pop();
  }

// *************
// *************
  static _goTo(Widget widget, String routeName,
      {bool replace = false, String? popUntil, bool clearAllStack = false}) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
        builder: (context) => widget, settings: RouteSettings(name: routeName));
    if (replace) {
      Navigator.of(navigatorStateKey.currentContext!)
          .pushReplacement(pageRoute);
    } else if (clearAllStack) {
      Navigator.of(navigatorStateKey.currentContext!)
          .pushAndRemoveUntil(pageRoute, (route) => false);
    } else if (popUntil != null) {
      Navigator.of(navigatorStateKey.currentContext!)
          .pushAndRemoveUntil(pageRoute, (route) {
        return route.isFirst;
      });
    } else {
      Navigator.of(navigatorStateKey.currentContext!).push(pageRoute);
    }
  }
}
