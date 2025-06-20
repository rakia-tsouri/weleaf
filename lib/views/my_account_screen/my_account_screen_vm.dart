import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class MyAccountScreenVM extends ChangeNotifier {
  User? connectedUser;

  // *************
  // *************
  Future<ApiResponse<User>> getConnectedUserData() async {
    connectedUser = await AppDataStore().getUserInfo();
    if (connectedUser != null) {
      return ApiResponse.completed(connectedUser);
    }

    return ApiResponse.error(ERROR_OCCURED);
  }
}
