import 'package:optorg_mobile/constants/constants.dart';
import 'package:optorg_mobile/constants/strings.dart';

class InputValidator {
  String validationError;
  bool isError;
  InputValidator({required this.validationError, required this.isError});

// ***********************
// ***********************
  static bool isAllInputsValid(List<InputValidator?> validators) {
    return validators.every((element) => element != null && !element.isError);
  }

// ***********************
// ***********************
  static InputValidator isValidEmail(String? email) {
    bool isValidEmail =
        email != null ? RegExp(EMAIL_REGEX).hasMatch(email) : false;
    return InputValidator(
        validationError: emailValidationError, isError: !isValidEmail);
  }

  // ***********************
// ***********************
  static InputValidator isInputEmpty(String? inputForm) {
    if (inputForm == null || inputForm.isEmpty) {
      return InputValidator(validationError: Empty_Input_Error, isError: true);
    } else {
      return InputValidator(validationError: Empty_Input_Error, isError: false);
    }
  }


  // ***********************
// ***********************
  static InputValidator isValidPassword(String? password) {
    if (password == null || password.isEmpty) {
      return InputValidator(
          validationError: PASSWORD_EMPTY_ERROR, isError: true);
    }
    bool isValidPassword = RegExp(PASSWORD_REGEX).hasMatch(password);
    return InputValidator(
        validationError: PASSWORD_NOT_CONFORM, isError: !isValidPassword);
  }

  // ***********************
// ***********************
  static InputValidator isValidURL(String? url) {
    if (url == null || url.isEmpty) {
      return InputValidator(validationError: URL_EMPTY_ERROR, isError: true);
    }
    bool isValidURL = RegExp(URL_REGEX).hasMatch(url);
    return InputValidator(
        validationError: URL_NOT_VALID_ERROR, isError: !isValidURL);
  }
}
