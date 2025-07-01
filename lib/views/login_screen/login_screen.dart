import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/fonts.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/utils/app_navigation.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/utils/input_validator.dart';
import 'package:optorg_mobile/views/login_screen/login_screen_vm.dart';
import 'package:optorg_mobile/widgets/app_button.dart';
import 'package:optorg_mobile/widgets/app_checkbox.dart';
import 'package:optorg_mobile/widgets/app_dialog.dart';
import 'package:optorg_mobile/widgets/app_scaffold.dart';
import 'package:optorg_mobile/widgets/app_version_build.dart';
import 'package:optorg_mobile/widgets/custom_popup_bottom_sheet.dart';
import 'package:optorg_mobile/widgets/loading_popup.dart';
import 'package:optorg_mobile/widgets/text_input_field.dart';
import 'package:optorg_mobile/widgets/textview.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final String route;

  LoginScreen({required this.route});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginScreenVM loginVM;

  late FocusNode focusOnEmail;
  late FocusNode focusOnPassword;
  late FocusNode focusOnURL;
  InputValidator? loginInputValidator;
  InputValidator? passwordInputValidator;

  // **************
  // **************
  @override
  void initState() {
    super.initState();

    loginVM = Provider.of<LoginScreenVM>(context, listen: false);
    loginVM.context = context;

    focusOnEmail = FocusNode();
    focusOnPassword = FocusNode();
    focusOnURL = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loginVM.prepareLoginFields();
    });
  }

  // **************
  // **************
  @override
  void dispose() async {
    super.dispose();
  }

  // **************
  // **************
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        withAppBar: false,
        backgroundColor: Colors.transparent,
        screenContent: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Consumer<LoginScreenVM>(
            builder: (context, provider, child) {
              return Padding(
                padding: EdgeInsets.only(
                    left: PADDING_30.widthResponsive(),
                    right: PADDING_30.widthResponsive()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: PADDING_50.heightResponsive(),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              LOGO_UTINA_COLORS,
                              height: WELEAF_HEIGHTAUTH.heightResponsive(),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: PADDING_10.heightResponsive(),
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextInputField(
                                  autoCorrect: false,
                                  passwordInput: false,
                                  width: IDENTITY_TEXT_INPUT_WIDTH,
                                  textController: loginVM.usernameController,
                                  label: IDENTIFIANT,
                                  focusNode: focusOnEmail,
                                  inputValidator: loginInputValidator,
                                  textInputAction: TextInputAction.next,
                                  onSubmitInput: (value) {
                                    focusOnPassword.requestFocus();
                                  },
                                ),
                                const SizedBox(
                                  height: PADDING_5,
                                ),
                                Visibility(
                                  visible:
                                      (loginInputValidator?.isError == true),
                                  child: TextView(
                                      text: USERNAME_EMPTY_ERROR,
                                      textFont: POPPINS_REGULAR,
                                      textSize: LOGIN_ERROR_MESSAGE_SIZE,
                                      textColor: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: PADDING_15.heightResponsive(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextInputField(
                                  autoCorrect: false,
                                  passwordInput: true,
                                  suffixIcon:
                                      const Icon(CupertinoIcons.eye_slash),
                                  width: IDENTITY_TEXT_INPUT_WIDTH,
                                  label: PASSWORD,
                                  inputValidator: passwordInputValidator,
                                  textController: loginVM.passwordController,
                                  focusNode: focusOnPassword,
                                  onSubmitInput: (value) {
                                    focusOnURL.requestFocus();
                                  },
                                ),
                                const SizedBox(
                                  height: PADDING_5,
                                ),
                                Visibility(
                                  visible:
                                      (passwordInputValidator?.isError == true),
                                  child: TextView(
                                      text: PASSWORD_EMPTY_ERROR,
                                      textSize: LOGIN_ERROR_MESSAGE_SIZE,
                                      textFont: POPPINS_REGULAR,
                                      textColor: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: PADDING_15.heightResponsive(),
                            ),
                            SizedBox(
                              height: PADDING_15.heightResponsive(),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AppCheckBox(
                                    isChecked: loginVM.rememberUser,
                                    onChanged: (isSelected) {
                                      loginVM.rememberUser = isSelected != null
                                          ? isSelected
                                          : false;
                                    },
                                  ),
                                  SizedBox(
                                    width: PADDING_5.widthResponsive(),
                                  ),
                                  TextView(
                                    text: REMEMBER_ME,
                                    textSize: 12,
                                  )
                                ]),
                            SizedBox(
                              height: PADDING_25.heightResponsive(),
                            ),
                            AppButton(
                              buttonHeight: APP_BUTTON_HEIGHT,
                              buttonWidth: APP_BUTTON_WIDTH_LARGE,
                              buttonText: CONNECT,
                              onClickCallback: () {
                                performAuthentication();
                              },
                            ),
                            SizedBox(
                              height: PADDING_10.heightResponsive(),
                            ),
                            SizedBox(
                              height: PADDING_25.heightResponsive(),
                            ),
                          ],
                        )),
                    AppVersionBuild(),
                    SizedBox(
                      height: PADDING_20.heightResponsive(),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }

// ******
// ******
  void performAuthentication() {
    if (_isValidForm()) {
      const LoadingPopup().show(context);
      loginVM.login(
          saveSession: loginVM.rememberUser,
          onResultCallback: _loginResultHandler);
    }
  }

// ******
// ******
  _loginResultHandler(User? user) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (user == null) {
      _displayErrorMessage();
    } else {
      Navigator.pop(context);
      AppNavigation.goToBienvenue(clearAllStack: true);
    }
  }

  // *************
  // *************
  _displayErrorMessage({String message = LOGIN_ERROR_MESSAGE}) {
    Navigator.pop(context);
    CustomPopupBottomSheet.showBottomSheet(
        context,
        CustomPopupBottomSheet(
          popupHeight: PADDING_120.heightResponsive(),
          popupContent: AppDialog.informationPopup(
            description: message,
            onClickHandler: () {
              Navigator.pop(context);
            },
          ),
        ),
        isScrollControlled: true);
    return;
  }

  // ***************
  // ***************
  bool _isValidForm() {
    bool isAllRequiredFieldsOk = true;
    setState(() {
      loginInputValidator =
          InputValidator.isInputEmpty(loginVM.usernameController.text);
      passwordInputValidator =
          InputValidator.isInputEmpty(loginVM.passwordController.text);

      isAllRequiredFieldsOk = InputValidator.isAllInputsValid([
        loginInputValidator,
        passwordInputValidator,
      ]);
    });
    return isAllRequiredFieldsOk;
  }
}
