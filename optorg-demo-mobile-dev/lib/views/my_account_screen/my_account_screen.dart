import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/my_account_screen/my_account_screen_vm.dart';
import 'package:optorg_mobile/widgets/app_future_builder.dart';
import 'package:optorg_mobile/widgets/app_scaffold.dart';
import 'package:optorg_mobile/widgets/app_version_build.dart';
import 'package:optorg_mobile/widgets/text_input_field.dart';
import 'package:optorg_mobile/widgets/textview.dart';
import 'package:provider/provider.dart';

// +++++++++++++++++
// +++++++++++++++++
class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

// +++++++++++++++++
// +++++++++++++++++
class _MyAccountScreenState extends State<MyAccountScreen> {
  late MyAccountScreenVM myAccountScreenVM;
  late Future<ApiResponse<User?>> futureConnectedUser;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  // ******************
// ******************
  @override
  void initState() {
    // implement initState
    myAccountScreenVM = Provider.of<MyAccountScreenVM>(context, listen: false);
    futureConnectedUser = myAccountScreenVM.getConnectedUserData();
    super.initState();
  }

  // ******************
// ******************
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        displayBackButton: true,
        displayLogoutButton: false,
        displayUserIcon: true,
        hideMyAccountMenu: true,
        backgroundColor: Colors.white,
        screenContent: Container(
          child: _buildMyAccountFutureBuilder(),
        ));
  }

// **********
  // **********
  _buildMyAccountFutureBuilder() {
    return AppFutureBuilder(
        future: futureConnectedUser,
        successBuilder: ((User? user) {
          return _buildMyAccountScreenContent();
        }));
  }

// ******************
// ******************
  _buildMyAccountScreenContent() {
    firstNameController.text =
        myAccountScreenVM.connectedUser?.data?.name ?? "-";
    lastNameController.text =
        myAccountScreenVM.connectedUser?.data?.surname ?? "-";
    emailController.text = myAccountScreenVM.connectedUser?.data?.email ?? "-";
    phoneNumberController.text =
        myAccountScreenVM.connectedUser?.data?.phone ?? "-";

    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(PADDING_10.widthResponsive()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: PADDING_5.heightResponsive()),
          TextView(
            textColor: PRIMARY_BLUE_COLOR,
            text: MY_ACCOUNT_PROFIL.toUpperCase(),
            isBold: true,
          ),
          SizedBox(height: PADDING_15.heightResponsive()),
          Center(
            child: CircleAvatar(
              backgroundColor: PRIMARY_BLUE_COLOR,
              radius: PADDING_62.widthResponsive(),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: PADDING_60.widthResponsive(),
                child: TextView(
                  text:
                      "${myAccountScreenVM.connectedUser?.data?.name?.substring(0, 1).toUpperCase()} ${myAccountScreenVM.connectedUser?.data?.surname?.substring(0, 1).toUpperCase()}",
                  isBold: true,
                  textSize: 40,
                ),
              ),
            ),
          ),
          SizedBox(height: PADDING_15.heightResponsive()),
          Expanded(
              child: Column(
            children: [
              TextInputField(
                autoCorrect: false,
                enabled: false,
                passwordInput: false,
                width: IDENTITY_TEXT_INPUT_WIDTH,
                textController: firstNameController,
                label: MY_ACCOUNT_NOM,
              ),
              SizedBox(height: PADDING_15.heightResponsive()),
              TextInputField(
                autoCorrect: false,
                passwordInput: false,
                enabled: false,
                width: IDENTITY_TEXT_INPUT_WIDTH,
                textController: lastNameController,
                label: MY_ACCOUNT_PRENOM,
              ),
              SizedBox(height: PADDING_15.heightResponsive()),
              TextInputField(
                autoCorrect: false,
                enabled: false,
                passwordInput: false,
                width: IDENTITY_TEXT_INPUT_WIDTH,
                textController: emailController,
                label: MY_ACCOUNT_EMAIL,
              ),
              SizedBox(height: PADDING_15.heightResponsive()),
              TextInputField(
                autoCorrect: false,
                enabled: false,
                passwordInput: false,
                width: IDENTITY_TEXT_INPUT_WIDTH,
                textController: phoneNumberController,
                label: MY_ACCOUNT_TEL,
              ),
            ],
          )),
          Center(child: AppVersionBuild()),
        ]));
  }
}
