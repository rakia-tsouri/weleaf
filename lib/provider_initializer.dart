import 'package:optorg_mobile/views/calculate_screen/calculate_screen_vm.dart';
import 'package:optorg_mobile/views/login_screen/login_screen_vm.dart';
import 'package:optorg_mobile/views/my_account_screen/my_account_screen_vm.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposals_list_screen_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> initializeProviders() {
  return [
    ChangeNotifierProvider(create: (context) => LoginScreenVM(context)),
    ChangeNotifierProvider(create: (context) => ProposalsListScreenVM()),
    ChangeNotifierProvider(create: (context) => MyAccountScreenVM()),
    ChangeNotifierProvider(create: (context) => CalculateScreenVM()),
  ];
}
