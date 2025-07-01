import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/calculate_response.dart';
import 'package:optorg_mobile/data/repositories/calculate_repository.dart';
import 'package:optorg_mobile/widgets/loading_popup.dart';

class CalculateScreenVM extends ChangeNotifier {
  CalculateRepository proposalsRepository = CalculateRepository();

  // **************
  // **************
  Future<ApiResponse<CalculateResponse>> calculateSimulation(
      {required double financedAmount,
      required int duration,
      required double firstPayment,
      required double VRAmount,
      required int periodeGrace,
      required BuildContext ctx,
      Function(ApiResponse<CalculateResponse>)? onCompleteCalculate}) async {
    LoadingPopup().show(ctx);
    ApiResponse<CalculateResponse> response =
        await proposalsRepository.calculateSimulation(
            financedAmount: financedAmount,
            duration: duration,
            firstPayment: firstPayment,
            VRAmount: VRAmount,
            periodeGrace: periodeGrace);
    Navigator.of(ctx).pop();
    onCompleteCalculate?.call(response);
    return response;
  }
}
