import 'package:optorg_mobile/constants/strings.dart';

class ApiResponse<T> {
  ApiStatus status;
  T? data;
  String? message;

  ApiResponse.loading(this.message) : status = ApiStatus.LOADING;

  ApiResponse.completed(this.data) : status = ApiStatus.COMPLETED;

  ApiResponse.error(this.message) : status = ApiStatus.ERROR;

  ApiResponse.canceled(this.message) : status = ApiStatus.CANCELED;

  bool isSuccess() {
    return status == ApiStatus.COMPLETED;
  }

  bool isSuccessAndNotNulLData() {
    return isSuccess() && data != null;
  }

  String getErrorMessage() {
    return message ?? ERROR_OCCURED;
  }

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum ApiStatus { LOADING, COMPLETED, ERROR, CANCELED }
