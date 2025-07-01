import 'package:flutter/cupertino.dart';
import 'package:optorg_mobile/data/models/authentication_user.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/data/repositories/auth_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class LoginScreenVM extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool resetLoginValidate = true;
  bool resetPasswordValidate = true;
  bool resetSmsCodeValidate = true;

  bool rememberUser = false;

  AuthRepository authRepository = AuthRepository();

  User? connectedUser;
  BuildContext context;
  String? anonymousToken;

  bool disableAuthButton = true;
  bool disableRegisterButton = true;

  LoginScreenVM(this.context);

// **************
  // **************
  prepareLoginFields() async {
    usernameController.clear();
    passwordController.clear();

    var appStorage = AppDataStore();
    bool isUserRemember = await appStorage.getUserRemeberMe();
    if (isUserRemember) {
      rememberUser = isUserRemember;
      usernameController.text = await appStorage.getUsername() ?? "";
    }
  }

// *************
// *************
  login({
    Function(User?)? onResultCallback,
    bool saveSession = true,
  }) {
    var authUser = AuthUser(
        password: passwordController.text,
        username: usernameController.text,
        rememberMe: saveSession);
    authRepository.authenticateUser(authUser, saveSession).then((user) {
      connectedUser = user;
      onResultCallback?.call(user);
    });
  }

  // ****************
  // ****************
  Future<bool> isOnline() async {
    return await authRepository.isOnline();
  }
}
