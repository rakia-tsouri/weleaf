class CalculateResponse {
  bool? success;
  String? message;
  String? inCalculationMethod;
  double? nominalrate;
  double? effectiverate;
  double? financedamount;
  double? residualvalue;
  int? duration;
  double? installmentamount;
  double? deferredInterest;
  double? depositInterest;
  double? profitabilityRate;
  double? aprRate;
  double? partAmount;
  double? commissionAmount;
  double? effectivefundingRate;
  double? discountCoefficient;
  double? totalRental;
  double? totalInterest;
  double? totalAmortization;
  double? totaldiscountedInterest;
  double? totaldiscountedOutstanding;
  double? totaldiscountedAgiosdeb;
  double? totalAgiosdeb;
  double? totalVatDeffered;
  double? dgo;
  double? marginImpactCredit;
  double? marginImpactDebit;
  double? flatRate;
  double? rate000;

  double? inFinancedamount;
  String? inTerm;
  String? inInterestMethod;
  double? inRateValue;
  double? inRatePeriodicity;
  double? inPeriodicity;
  String? inRateType;
  String? inCountingbasis;
  int? inDuration;
  double? inResidualValue;
  double? inInstallmentAmount;
  double? inRoundingAmount;
  double? inRoundingRate;
  String? inTaxcode;
  double? inTaxrate;
  double? inFirstPayment;
  int? inGracePeriodDuration;
  String? inGracePeriodMethod;
  String? inBillingDate;
  String? inDeferredMethod;
  double? inDeferredRate;
  double? inDepositRate;
  String? inDepositMethod;
  double? inDepositAmount;
  String? inPartMethod;
  double? inPartAmount;
  double? inPartRate;
  double? inPartNbDays;
  String? inStartDate;
  String? inFirstInstallmentDate;

  double? inFeesAmount;
  double? inDealerPartAmount;
  double? inManufacturerPartAmount;
  double? inCommissionAmount;
  double? inFundingRate;

  double? inVatAmount;
  double? inVatDuration;

  List<PaymentSchedule>? paymentSchedule;

  CalculateResponse(
      {this.success,
      this.message,
      this.inCalculationMethod,
      this.nominalrate,
      this.effectiverate,
      this.financedamount,
      this.residualvalue,
      this.duration,
      this.installmentamount,
      this.deferredInterest,
      this.depositInterest,
      this.profitabilityRate,
      this.aprRate,
      this.partAmount,
      this.commissionAmount,
      this.effectivefundingRate,
      this.discountCoefficient,
      this.totalRental,
      this.totalInterest,
      this.totalAmortization,
      this.totaldiscountedInterest,
      this.totaldiscountedOutstanding,
      this.totaldiscountedAgiosdeb,
      this.totalAgiosdeb,
      this.totalVatDeffered,
      this.dgo,
      this.marginImpactCredit,
      this.marginImpactDebit,
      this.flatRate,
      this.rate000,
      this.inFinancedamount,
      this.inTerm,
      this.inInterestMethod,
      this.inRateValue,
      this.inRatePeriodicity,
      this.inPeriodicity,
      this.inRateType,
      this.inCountingbasis,
      this.inDuration,
      this.inResidualValue,
      this.inInstallmentAmount,
      this.inRoundingAmount,
      this.inRoundingRate,
      this.inTaxcode,
      this.inTaxrate,
      this.inFirstPayment,
      this.inGracePeriodDuration,
      this.inGracePeriodMethod,
      this.inBillingDate,
      this.inDeferredMethod,
      this.inDeferredRate,
      this.inDepositRate,
      this.inDepositMethod,
      this.inDepositAmount,
      this.inPartMethod,
      this.inPartAmount,
      this.inPartRate,
      this.inPartNbDays,
      this.inStartDate,
      this.inFirstInstallmentDate,
      this.inFeesAmount,
      this.inDealerPartAmount,
      this.inManufacturerPartAmount,
      this.inCommissionAmount,
      this.inFundingRate,
      this.inVatAmount,
      this.inVatDuration,
      this.paymentSchedule});

  CalculateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    inCalculationMethod = json['inCalculationMethod'];
    nominalrate = json['nominalrate']?.toDouble();
    effectiverate = json['effectiverate']?.toDouble();
    financedamount = json['financedamount']?.toDouble();
    residualvalue = json['residualvalue']?.toDouble();
    duration = json['duration'];
    installmentamount = json['installmentamount']?.toDouble();
    deferredInterest = json['deferredInterest']?.toDouble();
    depositInterest = json['depositInterest']?.toDouble();
    profitabilityRate = json['profitabilityRate']?.toDouble();
    aprRate = json['aprRate']?.toDouble();
    partAmount = json['partAmount']?.toDouble();
    commissionAmount = json['commissionAmount']?.toDouble();
    effectivefundingRate = json['effectivefundingRate']?.toDouble();
    discountCoefficient = json['discountCoefficient']?.toDouble();
    totalRental = json['totalRental']?.toDouble();
    totalInterest = json['totalInterest']?.toDouble();
    totalAmortization = json['totalAmortization']?.toDouble();
    totaldiscountedInterest = json['totaldiscountedInterest']?.toDouble();
    totaldiscountedOutstanding = json['totaldiscountedOutstanding']?.toDouble();
    totaldiscountedAgiosdeb = json['totaldiscountedAgiosdeb']?.toDouble();
    totalAgiosdeb = json['totalAgiosdeb']?.toDouble();
    totalVatDeffered = json['totalVatDeffered']?.toDouble();
    dgo = json['dgo']?.toDouble();
    marginImpactCredit = json['marginImpactCredit']?.toDouble();
    marginImpactDebit = json['marginImpactDebit']?.toDouble();
    flatRate = json['flatRate']?.toDouble();
    rate000 = json['rate000']?.toDouble();

    inFinancedamount = json['inFinancedamount']?.toDouble();
    ;
    inTerm = json['inTerm'];
    inInterestMethod = json['inInterestMethod'];
    inRateValue = json['inRateValue']?.toDouble();
    inRatePeriodicity = json['inRatePeriodicity']?.toDouble();
    inPeriodicity = json['inPeriodicity']?.toDouble();
    inRateType = json['inRateType'];
    inCountingbasis = json['inCountingbasis'];
    inDuration = json['inDuration'];
    inResidualValue = json['inResidualValue']?.toDouble();
    inInstallmentAmount = json['inInstallmentAmount']?.toDouble();
    inRoundingAmount = json['inRoundingAmount']?.toDouble();
    inRoundingRate = json['inRoundingRate']?.toDouble();
    inTaxcode = json['inTaxcode'];
    inTaxrate = json['inTaxrate']?.toDouble();
    inFirstPayment = json['inFirstPayment']?.toDouble();
    inGracePeriodDuration = json['inGracePeriodDuration'];
    inGracePeriodMethod = json['inGracePeriodMethod'];
    inBillingDate = json['inBillingDate'];
    inDeferredMethod = json['inDeferredMethod'];
    inDeferredRate = json['inDeferredRate']?.toDouble();
    inDepositRate = json['inDepositRate']?.toDouble();
    inDepositMethod = json['inDepositMethod'];
    inDepositAmount = json['inDepositAmount']?.toDouble();
    inPartMethod = json['inPartMethod'];
    inPartAmount = json['inPartAmount']?.toDouble();
    inPartRate = json['inPartRate']?.toDouble();
    inPartNbDays = json['inPartNbDays']?.toDouble();
    inStartDate = json['inStartDate'];
    inFirstInstallmentDate = json['inFirstInstallmentDate'];
    inFeesAmount = json['inFeesAmount']?.toDouble();
    inDealerPartAmount = json['inDealerPartAmount']?.toDouble();
    inManufacturerPartAmount = json['inManufacturerPartAmount']?.toDouble();
    inCommissionAmount = json['inCommissionAmount']?.toDouble();
    inFundingRate = json['inFundingRate']?.toDouble();
    inVatAmount = json['inVatAmount']?.toDouble();
    inVatDuration = json['inVatDuration']?.toDouble();
    if (json['paymentSchedule'] != null) {
      paymentSchedule = <PaymentSchedule>[];
      json['paymentSchedule'].forEach((v) {
        paymentSchedule!.add(new PaymentSchedule.fromJson(v));
      });
    }
  }
}

class PaymentSchedule {
  int? ctsorder;
  String? ctstype;
  String? ctsterm;
  int? ctsperiodicity;
  String? ctsperiodicityunit;
  String? ctsduedate;
  String? ctsstartdate;
  String? ctsenddate;
  String? ctsinterestmethod;
  double? ctseffectiverate;
  double? ctsnominalrate;
  double? ctsstartamount;
  double? ctsamortizedamount;
  double? ctsvatdeffered;
  double? ctsinterestamount;
  double? ctsrentalamount;
  double? ctsoutstandingamount;
  double? ctsdepositbasis;
  double? ctsdepositrate;
  double? ctsdepositinterest;
  double? ctsbasisamount;
  double? ctsbasisrate;
  String? ctstaxcode;
  double? ctstaxrate;
  double? ctstaxamount;
  double? ctstotalamount;
  double? ctsdiscountcoef;
  double? ctsdiscountoutstanding;
  double? ctsagiosdeb;
  double? ctsdiscountinterest;
  double? ctsdiscountagiosdeb;

  PaymentSchedule({
    this.ctsorder,
    this.ctstype,
    this.ctsterm,
    this.ctsperiodicity,
    this.ctsperiodicityunit,
    this.ctsduedate,
    this.ctsstartdate,
    this.ctsenddate,
    this.ctsinterestmethod,
    this.ctseffectiverate,
    this.ctsnominalrate,
    this.ctsstartamount,
    this.ctsamortizedamount,
    this.ctsvatdeffered,
    this.ctsinterestamount,
    this.ctsrentalamount,
    this.ctsoutstandingamount,
    this.ctsdepositbasis,
    this.ctsdepositrate,
    this.ctsdepositinterest,
    this.ctsbasisamount,
    this.ctsbasisrate,
    this.ctstaxcode,
    this.ctstaxrate,
    this.ctstaxamount,
    this.ctstotalamount,
    this.ctsdiscountcoef,
    this.ctsdiscountoutstanding,
    this.ctsagiosdeb,
    this.ctsdiscountinterest,
    this.ctsdiscountagiosdeb,
  });

  PaymentSchedule.fromJson(Map<String, dynamic> json) {
    ctsorder = json['ctsorder'];
    ctstype = json['ctstype'];
    ctsterm = json['ctsterm'];
    ctsperiodicity = json['ctsperiodicity'];
    ctsperiodicityunit = json['ctsperiodicityunit'];
    ctsduedate = json['ctsduedate'];
    ctsstartdate = json['ctsstartdate'];
    ctsenddate = json['ctsenddate'];
    ctsinterestmethod = json['ctsinterestmethod'];
    ctseffectiverate = json['ctseffectiverate']?.toDouble();
    ctsnominalrate = json['ctsnominalrate']?.toDouble();
    ctsstartamount = json['ctsstartamount']?.toDouble();
    ctsamortizedamount = json['ctsamortizedamount']?.toDouble();
    ctsvatdeffered = json['ctsvatdeffered']?.toDouble();
    ctsinterestamount = json['ctsinterestamount']?.toDouble();
    ctsrentalamount = json['ctsrentalamount']?.toDouble();
    ctsoutstandingamount = json['ctsoutstandingamount']?.toDouble();
    ctsdepositbasis = json['ctsdepositbasis']?.toDouble();
    ctsdepositrate = json['ctsdepositrate']?.toDouble();
    ctsdepositinterest = json['ctsdepositinterest']?.toDouble();
    ctsbasisamount = json['ctsbasisamount']?.toDouble();
    ctsbasisrate = json['ctsbasisrate']?.toDouble();
    ctstaxcode = json['ctstaxcode'];
    ctstaxrate = json['ctstaxrate']?.toDouble();
    ctstaxamount = json['ctstaxamount']?.toDouble();
    ctstotalamount = json['ctstotalamount']?.toDouble();
    ctsdiscountcoef = json['ctsdiscountcoef']?.toDouble();
    ctsdiscountoutstanding = json['ctsdiscountoutstanding']?.toDouble();
    ctsagiosdeb = json['ctsagiosdeb']?.toDouble();
    ctsdiscountinterest = json['ctsdiscountinterest']?.toDouble();
    ctsdiscountagiosdeb = json['ctsdiscountagiosdeb']?.toDouble();
  }
}
