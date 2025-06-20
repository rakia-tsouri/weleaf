import 'package:optorg_mobile/constants/api_constants.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/calculate_response.dart';
import 'package:optorg_mobile/data/repositories/app_repository.dart';

class CalculateRepository extends AppRepository {
  // **************
  // **************
  Future<ApiResponse<CalculateResponse>> calculateSimulation(
      {required double financedAmount,
      required int duration,
      required double firstPayment,
      required double VRAmount,
      required int periodeGrace}) async {
    try {
      var serverResponse = await dioWithToken.post(CALCULATE_POST_API,
          data: {
            "inBillingDate": "25",
            "inCalculationMethod": "INST",
            "inCalculationType": "LINEAR",
            "inCountingbasis": "360",
            "inDeferredMethod": "NONE",
            "inDeferredRate": 0,
            "inDepositAmount": 0,
            "inDepositMethod": "NONE",
            "inDepositRate": 0,
            "inDuration": duration,
            "inFinancedAmount": financedAmount,
            "inFirstInstallmentDate": "",
            "inFirstPayment": firstPayment,
            "inGracePeriodDuration": periodeGrace,
            "inGracePeriodMethod": "NONE",
            "inInstallmentAmount": 0,
            "inInterestMethod": "BOP",
            "inPartAmount": 0,
            "inPartMethod": "NONE",
            "inPartNbDays": 0,
            "inPartRate": 0,
            "inPeriodicity": "1",
            "inPeriodicityUnit": "M",
            "inRatePeriodicity": 1,
            "inRateType": "NOMINAL",
            "inRateValue": 10,
            "inResidualValue": VRAmount,
            "inRoundingAmount": 2,
            "inRoundingRate": 9,
            "inStartDate": "2025-03-07",
            "inTaxcode": "NORM",
            "inTaxrate": 0,
            "inTaxtype": "RENTAL",
            "inTerm": "ADVANCE",
            "inUpFrontAmount": 0,
            "inFeesAmount": 0,
            "inDealerPartAmount": 0,
            "inManufacturerPartAmount": 0,
            "inCommissionAmount": 0,
            "inProfitabilityRate": 0,
            "inFundingRate": 0,
            "inFundingPeriodicity": 1,
            "inVatAmount": 0,
            "inVatDuration": 0,
            "inVatDaysBasis": "365",
            "inVatMethod": "NONE"
          },
          queryParameters: null);
      var data = serverResponse.data;
      CalculateResponse? calculateResponse = CalculateResponse.fromJson(data);

      return ApiResponse.completed(calculateResponse);
    } catch (e) {
      return ApiResponse.error(ERROR_OCCURED);
    }
  }
}
