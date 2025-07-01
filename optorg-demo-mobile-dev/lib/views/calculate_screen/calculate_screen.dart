import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/calculate_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/calculate_screen/calculate_screen_vm.dart';
import 'package:optorg_mobile/widgets/app_button.dart';
import 'package:optorg_mobile/widgets/app_scaffold.dart';
import 'package:optorg_mobile/widgets/app_slider.dart';
import 'package:optorg_mobile/widgets/text_input_field.dart';
import 'package:optorg_mobile/widgets/textview.dart';
import 'package:provider/provider.dart';

// ++++++++++++++++
// ++++++++++++++++
class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

// ++++++++++++++++
// ++++++++++++++++
class _CalculateScreenState extends State<CalculateScreen> {
  late CalculateScreenVM calculateScreenVM;
  TextEditingController resultLoyerTextController = TextEditingController();
  double montantFinance = 100000;
  double residualValuePourcentage = 10;
  int duration = 36;
  double firstInstallementPourcentage = 1;
  int gracePeriod = 0;
  FocusNode valueFocusNode = FocusNode();

  // *****
  // *****
  @override
  void initState() {
    // implement initState
    calculateScreenVM = Provider.of<CalculateScreenVM>(context, listen: false);
    super.initState();
  }

  // *****
  // *****
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayBackButton: true,
      displayLogoutButton: false,
      displayUserIcon: true,
      backgroundColor: Colors.grey.shade100,
      screenContent: Container(
        color: Colors.grey.shade100,
        child: _buildScreenContent(),
      ),
    );
  }

// ****************
// ****************
  _buildScreenContent() {
    return Padding(
      padding: EdgeInsets.only(
          left: PADDING_10.widthResponsive(),
          right: PADDING_10.widthResponsive(),
          top: PADDING_10.widthResponsive()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: PADDING_5.heightResponsive()),
              TextView(
                textAlign: TextAlign.start,
                textColor: PRIMARY_BLUE_COLOR,
                text: CALCULETTE_CALCULETTE,
                isBold: true,
              ),
              SizedBox(height: PADDING_10.heightResponsive()),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: PADDING_10.heightResponsive(),
                    horizontal: PADDING_5.widthResponsive()),
                child: AppSlider(
                  maxValue: 1200000,
                  minValue: 50,
                  onSlideChanged: (value) {},
                  onSlideChangedEnd: (value) {
                    montantFinance = value;
                    _resetLoyerResult();
                  },
                  title: CALCULETTE_MONTANT_FINANCE,
                  withResult: true,
                  rangeOfIntegers: true,
                  valuePrefix: "",
                  selectedValue: montantFinance,
                  numberOfDivision: null,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: PADDING_10.heightResponsive(),
                    horizontal: PADDING_5.widthResponsive()),
                child: AppSlider(
                  maxValue: 60,
                  minValue: 24,
                  onSlideChanged: (value) {},
                  onSlideChangedEnd: (value) {
                    duration = value.toInt();
                    _resetLoyerResult();
                    //fieldType.onChanged?.call(value);
                  },
                  title: CALCULETTE_DURATION,
                  withResult: true,
                  rangeOfIntegers: true,
                  valuePrefix: CALCULETTE_MONTH,
                  selectedValue: duration.toDouble(),
                  numberOfDivision: null,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: PADDING_10.heightResponsive(),
                    horizontal: PADDING_5.widthResponsive()),
                child: AppSlider(
                  maxValue: 30,
                  minValue: 0,
                  onSlideChanged: (value) {},
                  onSlideChangedEnd: (value) {
                    firstInstallementPourcentage = value;
                    _resetLoyerResult();
                  },
                  title: CALCULETTE_FIRST_INSTALLEMENT,
                  withResult: true,
                  rangeOfIntegers: true,
                  valuePrefix: "%",
                  selectedValue: firstInstallementPourcentage,
                  numberOfDivision: 30,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: PADDING_10.heightResponsive(),
                    horizontal: PADDING_5.widthResponsive()),
                child: AppSlider(
                  maxValue: 20,
                  minValue: 0,
                  onSlideChanged: (value) {},
                  onSlideChangedEnd: (value) {
                    residualValuePourcentage = value;
                    _resetLoyerResult();
                  },
                  title: CALCULETTE_VR,
                  withResult: true,
                  rangeOfIntegers: true,
                  valuePrefix: "%",
                  selectedValue: residualValuePourcentage,
                  numberOfDivision: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: PADDING_10.heightResponsive(),
                    horizontal: PADDING_5.widthResponsive()),
                child: AppSlider(
                  maxValue: 3,
                  minValue: 0,
                  onSlideChanged: (value) {},
                  onSlideChangedEnd: (value) {
                    gracePeriod = value.toInt();
                    _resetLoyerResult();
                  },
                  title: CALCULETTE_PERIOD_GRACE,
                  withResult: true,
                  rangeOfIntegers: true,
                  valuePrefix: CALCULETTE_MONTH,
                  selectedValue: gracePeriod.toDouble(),
                  numberOfDivision: 3,
                ),
              ),
            ],
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                buttonHeight: APP_BUTTON_HEIGHT,
                buttonText: CALCULETTE_CALCULATE,
                onClickCallback: () {
                  _performCalcul();
                },
              ),
              SizedBox(height: PADDING_10.heightResponsive()),
              TextInputField(
                label: CALCULETTE_CALCULATED_LOYER,
                textAlignement: TextAlign.center,
                textSize: 14,
                textController: this.resultLoyerTextController,
                enabled: false,
                contentPadding: EdgeInsets.symmetric(
                    vertical: PADDING_10.heightResponsive(),
                    horizontal: PADDING_10.widthResponsive()),
              ),
              SizedBox(height: PADDING_20.heightResponsive()),
            ],
          ),
        ],
      ),
    );
  }

  // ************
  // ************
  _resetLoyerResult() {
    setState(() {
      resultLoyerTextController.text = "";
    });
  }

  // ************
  // ************
  _performCalcul() {
    double firstPayment = montantFinance * firstInstallementPourcentage / 100;
    double vrAmount = montantFinance * residualValuePourcentage / 100;
    calculateScreenVM.calculateSimulation(
        financedAmount: montantFinance,
        duration: duration,
        firstPayment: firstPayment,
        VRAmount: vrAmount,
        periodeGrace: gracePeriod,
        ctx: context,
        onCompleteCalculate: _onCompleteCalculate);
  }

// ************
  // ************
  _onCompleteCalculate(ApiResponse<CalculateResponse> response) {
    String resultString = "";
    if (response.isSuccess() &&
        response.data != null &&
        response.data!.success == true &&
        response.data!.installmentamount != null) {
      resultString =
          "${response.data!.installmentamount!.amountFormat()} x ${response.data!.inDuration} mois";
    } else {
      resultString = ERROR_OCCURED;
    }
    resultLoyerTextController.text = resultString;
  }
}
