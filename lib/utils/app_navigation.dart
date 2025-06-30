import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/views/calculate_screen/calculate_screen.dart';
import 'package:optorg_mobile/views/my_account_screen/my_account_screen.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_details/proposal_details_screen.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposals_list_screen.dart';

class AppNavigation {
  static final GlobalKey<NavigatorState> navigatorStateKey = GlobalKey();

  // *************
// *************
  static goToProposalsListScreen(
      {bool clearAllStack = false, bool replace = false}) {
    _goTo(const ProposalsListScreen(), ROUTE_TO_PROPOSALS_LIST_SCREEN,
        replace: replace, clearAllStack: clearAllStack);
  }

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

  // *************
// *************
  static goToProposalDetailsScreen(
      {bool clearAllStack = false,
      bool replace = false,
      required int proposalId}) {
    _goTo(ProposalDetailsScreen(proposalId: proposalId),
        ROUTE_TO_PROPOSAL_DETAILS_SCREEN,
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
