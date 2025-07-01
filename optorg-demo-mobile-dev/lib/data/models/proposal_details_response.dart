import 'package:optorg_mobile/data/models/asset_services_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class ProposalDetailsResponse {
  String? code;
  String? message;
  String? description;
  ProposalDetailsData? data;
// ******
// ******
  String getMarqueModele() {
    if (data != null && data!.assets != null && data!.assets!.length > 0) {
      Assets asset = data!.assets!.first;
      return asset.assetcategorylabel ?? "--";
    }

    return "--";
  }

// ******
// ******
  String getMontantFinance() {
    if (data != null) {
      return data!.ctfinancedamount.amountFormat();
    }

    return "--";
  }

  // ******
// ******
  String getMontantHT() {
    if (data != null && data!.assets != null && data!.assets!.length > 0) {
      Assets asset = data!.assets!.first;
      return asset.assetnetamount?.amountFormat() ?? "--";
    }

    return "--";
  }

// ******
// ******
  String getMonthlyRent() {
    if (data != null &&
        data!.conElements != null &&
        data!.conElements!.length > 0) {
      for (ConElement conElement in data!.conElements!) {
        if (conElement.ctetype == "FIN") {
          return conElement.cterentalamount?.amountFormat() ?? "--";
        }
      }
    }

    return "--";
  }

// ******
// ******
  String getDuration() {
    if (data != null &&
        data!.conElements != null &&
        data!.conElements!.length > 0) {
      for (ConElement conElement in data!.conElements!) {
        if (conElement.ctetype == "FIN") {
          return conElement.cteduration?.toString() ?? "--";
        }
      }
    }

    return "--";
  }

// ******
// ******
  String getMileageKm() {
    if (data != null &&
        data!.conElements != null &&
        data!.conElements!.length > 0) {
      for (ConElement conElement in data!.conElements!) {
        if (conElement.ctetype == "FIN") {
          return conElement.ctemileage?.toString() ?? "--";
        }
      }
    }

    return "--";
  }

  // ******
// ******
  String getFirstPayement() {
    if (data != null &&
        data!.conElements != null &&
        data!.conElements!.length > 0) {
      for (ConElement conElement in data!.conElements!) {
        if (conElement.ctetype == "FIN") {
          return conElement.ctefirstpayment?.amountFormat() ?? "--";
        }
      }
    }

    return "--";
  }

  // ******
// ******
  String getResidualValue() {
    if (data != null &&
        data!.conElements != null &&
        data!.conElements!.length > 0) {
      for (ConElement conElement in data!.conElements!) {
        if (conElement.ctetype == "FIN") {
          return conElement.ctervamount?.amountFormat() ?? "--";
        }
      }
    }

    return "--";
  }

  ProposalDetailsResponse(
      {this.code, this.message, this.description, this.data});

  ProposalDetailsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    description = json['description'];
    data = json['data'] != null
        ? new ProposalDetailsData.fromJson(json['data'])
        : null;
  }
}

class ProposalDetailsData {
  int? mgid;
  String? ctreference;
  String? ctdescription;
  String? ctphase;
  String? ctstatus;
  String? ctstatusdate;
  int? tpidclient;
  int? tpidcoborrower;
  String? prcode;
  String? currcode;
  int? offerid;

  String? ctrequestdate;
  String? ctacceptancedate;
  String? ctinitstartdate;
  String? ctinitenddate;
  String? ctorderdate;
  String? ctdeliverydate;
  String? ctactivationdate;
  String? ctenddate;
  double? ctfinancedamount;
  String? ctinvoiceaddressname;
  String? ctinvoiceaddressstr1;
  String? ctinvoiceaddressstr2;
  String? ctinvoiceaddresszipcode;
  String? ctinvoiceaddresscity;

  String? ctpaymentmode;
  String? ctiban;
  String? ctbic;
  String? ctbankname;

  String? ctstage;
  String? propreference;

  String? tpinvoiceaddressregion;
  String? ctpaymentdelay;
  bool? ctflagreminder;
  String? cttype;

  String? ctfclevel;

  String? ctvaliditydate;

  double? mfrequestedamount;
  double? mfagreedamount;
  double? mfbookedamount;
  double? mfusedamount;
  double? mfavailableamount;
  String? mfvaliditydate;
  int? tpadrid;
  int? tpbkidin;
  int? tpbkidout;
  String? ctcomment;
  int? catalogid;
  String? assetpictureurl;
  String? assetpictureBase64;
  ClientData? clientData;
  Offer? offer;
  List<ConElement>? conElements;
  int? ctdurationmonths;
  int? ctrid;
  String? ctinvoiceaddresscitylabel;
  String? ctphaselabel;
  String? ctstatuslabel;
  String? clientname;
  String? clientreference;
  String? cobname;
  String? cobreference;
  String? suppliername;
  String? supplierreference;
  String? brokername;
  String? brokerreference;
  String? guarantorname;
  String? guarantorreference;
  String? branchname;
  String? branchreference;
  String? offerlabel;
  String? prilabel;

  String? ctdecisioncodelabel;
  String? ctdecisionlevellabel;

  String? ctreversalreasonlabel;
  String? syndleadreference;
  String? syndleadname;
  bool? flagmasterfacility;
  bool? flagrealestate;
  bool? flagasset;
  bool? flaguseassetgrossamount;

  bool? flagfleet;
  bool? flagredemption;

  List<ThirdParties>? thirdParties;

  List<Assets>? assets;
  List<AssetSerivce>? assetServiceList;

  ProposalDetailsData(
      {this.mgid,
      this.ctreference,
      this.ctdescription,
      this.ctphase,
      this.ctstatus,
      this.ctstatusdate,
      this.tpidclient,
      this.tpidcoborrower,
      this.prcode,
      this.currcode,
      this.offerid,
      this.ctrequestdate,
      this.ctacceptancedate,
      this.ctinitstartdate,
      this.ctinitenddate,
      this.ctorderdate,
      this.ctdeliverydate,
      this.ctactivationdate,
      this.ctenddate,
      this.ctfinancedamount,
      this.ctinvoiceaddressname,
      this.ctinvoiceaddressstr1,
      this.ctinvoiceaddressstr2,
      this.ctinvoiceaddresszipcode,
      this.ctinvoiceaddresscity,
      this.ctpaymentmode,
      this.ctiban,
      this.ctbic,
      this.ctbankname,
      this.ctstage,
      this.propreference,
      this.tpinvoiceaddressregion,
      this.ctpaymentdelay,
      this.ctflagreminder,
      this.cttype,
      this.ctfclevel,
      this.ctvaliditydate,
      this.mfrequestedamount,
      this.mfagreedamount,
      this.mfbookedamount,
      this.mfusedamount,
      this.mfavailableamount,
      this.mfvaliditydate,
      this.tpadrid,
      this.tpbkidin,
      this.tpbkidout,
      this.ctcomment,
      this.catalogid,
      this.assetpictureurl,
      this.clientData,
      this.offer,
      this.ctdurationmonths,
      this.ctrid,
      this.ctinvoiceaddresscitylabel,
      this.ctphaselabel,
      this.ctstatuslabel,
      this.clientname,
      this.clientreference,
      this.cobname,
      this.cobreference,
      this.suppliername,
      this.supplierreference,
      this.brokername,
      this.brokerreference,
      this.guarantorname,
      this.guarantorreference,
      this.branchname,
      this.branchreference,
      this.offerlabel,
      this.prilabel,
      this.ctdecisioncodelabel,
      this.ctdecisionlevellabel,
      this.ctreversalreasonlabel,
      this.syndleadreference,
      this.syndleadname,
      this.flagmasterfacility,
      this.flagrealestate,
      this.flagasset,
      this.flaguseassetgrossamount,
      this.flagfleet,
      this.flagredemption,
      this.thirdParties,
      this.assets});

  ProposalDetailsData.fromJson(Map<String, dynamic> json) {
    mgid = json['mgid'];
    ctreference = json['ctreference'];
    ctdescription = json['ctdescription'];
    ctphase = json['ctphase'];
    ctstatus = json['ctstatus'];
    ctstatusdate = json['ctstatusdate'];
    tpidclient = json['tpidclient'];
    tpidcoborrower = json['tpidcoborrower'];
    prcode = json['prcode'];
    currcode = json['currcode'];
    offerid = json['offerid'];

    ctrequestdate = json['ctrequestdate'];
    ctacceptancedate = json['ctacceptancedate'];
    ctinitstartdate = json['ctinitstartdate'];
    ctinitenddate = json['ctinitenddate'];
    ctorderdate = json['ctorderdate'];
    ctdeliverydate = json['ctdeliverydate'];
    ctactivationdate = json['ctactivationdate'];
    ctenddate = json['ctenddate'];
    ctfinancedamount = json['ctfinancedamount'];
    ctinvoiceaddressname = json['ctinvoiceaddressname'];
    ctinvoiceaddressstr1 = json['ctinvoiceaddressstr1'];
    ctinvoiceaddressstr2 = json['ctinvoiceaddressstr2'];
    ctinvoiceaddresszipcode = json['ctinvoiceaddresszipcode'];
    ctinvoiceaddresscity = json['ctinvoiceaddresscity'];

    ctpaymentmode = json['ctpaymentmode'];
    ctiban = json['ctiban'];
    ctbic = json['ctbic'];
    ctbankname = json['ctbankname'];

    ctstage = json['ctstage'];
    propreference = json['propreference'];

    tpinvoiceaddressregion = json['tpinvoiceaddressregion'];
    ctpaymentdelay = json['ctpaymentdelay'];
    ctflagreminder = json['ctflagreminder'];
    cttype = json['cttype'];

    ctfclevel = json['ctfclevel'];

    ctvaliditydate = json['ctvaliditydate'];

    mfrequestedamount = json['mfrequestedamount']?.toDouble();
    mfagreedamount = json['mfagreedamount']?.toDouble();
    mfbookedamount = json['mfbookedamount']?.toDouble();
    mfusedamount = json['mfusedamount']?.toDouble();
    mfavailableamount = json['mfavailableamount']?.toDouble();
    mfvaliditydate = json['mfvaliditydate'];
    tpadrid = json['tpadrid'];
    tpbkidin = json['tpbkidin'];
    tpbkidout = json['tpbkidout'];
    ctcomment = json['ctcomment'];
    catalogid = json['catalogid'];
    assetpictureurl = json['assetpictureurl'];

    clientData = json['clientData'] != null
        ? new ClientData.fromJson(json['clientData'])
        : null;
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;

    ctdurationmonths = json['ctdurationmonths'];
    ctrid = json['ctrid'];
    ctinvoiceaddresscitylabel = json['ctinvoiceaddresscitylabel'];
    ctphaselabel = json['ctphaselabel'];
    ctstatuslabel = json['ctstatuslabel'];
    clientname = json['clientname'];
    clientreference = json['clientreference'];
    cobname = json['cobname'];
    cobreference = json['cobreference'];
    suppliername = json['suppliername'];
    supplierreference = json['supplierreference'];
    brokername = json['brokername'];
    brokerreference = json['brokerreference'];
    guarantorname = json['guarantorname'];
    guarantorreference = json['guarantorreference'];
    branchname = json['branchname'];
    branchreference = json['branchreference'];
    offerlabel = json['offerlabel'];
    prilabel = json['prilabel'];

    ctdecisioncodelabel = json['ctdecisioncodelabel'];
    ctdecisionlevellabel = json['ctdecisionlevellabel'];

    ctreversalreasonlabel = json['ctreversalreasonlabel'];
    syndleadreference = json['syndleadreference'];
    syndleadname = json['syndleadname'];
    flagmasterfacility = json['flagmasterfacility'];
    flagrealestate = json['flagrealestate'];
    flagasset = json['flagasset'];
    flaguseassetgrossamount = json['flaguseassetgrossamount'];

    flagfleet = json['flagfleet'];
    flagredemption = json['flagredemption'];

    if (json['thirdParties'] != null) {
      thirdParties = <ThirdParties>[];
      json['thirdParties'].forEach((v) {
        thirdParties!.add(new ThirdParties.fromJson(v));
      });
    }

    if (json['assets'] != null) {
      assets = <Assets>[];
      json['assets'].forEach((v) {
        assets!.add(new Assets.fromJson(v));
      });
    }
    if (json['conElements'] != null) {
      conElements = <ConElement>[];
      json['conElements'].forEach((v) {
        conElements!.add(new ConElement.fromJson(v));
      });
    }
  }
}

class ClientData {
  GeneralData? generalData;
  Address? address;
  Contact? contact;

  BankAccount? bankAccount;
  Status? status;

  ClientData({
    this.generalData,
    this.address,
    this.contact,
    this.bankAccount,
    this.status,
  });

  ClientData.fromJson(Map<String, dynamic> json) {
    generalData = json['generalData'] != null
        ? new GeneralData.fromJson(json['generalData'])
        : null;
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    contact =
        json['contact'] != null ? new Contact.fromJson(json['contact']) : null;

    bankAccount = json['bankAccount'] != null
        ? new BankAccount.fromJson(json['bankAccount'])
        : null;

    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
  }
}

class GeneralData {
  String? tpreference;
  String? tptype;

  String? tpstatus;

  String? tpstatusdate;
  String? tpclass;

  String? tpname;
  String? tpsurname;
  String? tpactivity;

  int? mgid;
  String? lancode;
  String? countcode;
  String? tpcompanycreationdate;
  String? tpfiscalid;
  String? tpfiscalcity;
  String? tptaxid;
  String? tpsalutationcode;
  String? tpgender;
  String? tpbirthdate;
  String? tpbirthcity;
  String? tpbirthcountry;
  String? tpprofession;
  String? tpidentitycardtype;
  String? tpidentitycardid;
  String? tpmaritalstatus;
  int? tpnbofchildren;
  String? tpworkingcttype;
  String? tpworkingctdate;
  String? tpkycdate;
  String? tpkycstatus;
  int? lastAction;
  bool? tpflagvatexemption;
  String? currcode;
  bool? tpflagresident;
  String? tpcategory;
  String? tpactivitysector;
  String? tpidentitycardexpirationdate;
  String? tpidentitycardcountry;
  String? tpcompanyid;
  String? tpfiscalcitylabel;
  String? tpidentitycardcountrylabel;

  GeneralData(
      {this.tpreference,
      this.tptype,
      this.tpstatus,
      this.tpstatusdate,
      this.tpclass,
      this.tpname,
      this.tpsurname,
      this.tpactivity,
      this.mgid,
      this.lancode,
      this.countcode,
      this.tpcompanycreationdate,
      this.tpfiscalid,
      this.tpfiscalcity,
      this.tptaxid,
      this.tpsalutationcode,
      this.tpgender,
      this.tpbirthdate,
      this.tpbirthcity,
      this.tpbirthcountry,
      this.tpprofession,
      this.tpidentitycardtype,
      this.tpidentitycardid,
      this.tpmaritalstatus,
      this.tpnbofchildren,
      this.tpworkingcttype,
      this.tpworkingctdate,
      this.tpkycdate,
      this.tpkycstatus,
      this.lastAction,
      this.tpflagvatexemption,
      this.currcode,
      this.tpflagresident,
      this.tpcategory,
      this.tpactivitysector,
      this.tpidentitycardexpirationdate,
      this.tpidentitycardcountry,
      this.tpcompanyid,
      this.tpfiscalcitylabel,
      this.tpidentitycardcountrylabel});

  GeneralData.fromJson(Map<String, dynamic> json) {
    tpreference = json['tpreference'];
    tptype = json['tptype'];

    tpstatus = json['tpstatus'];

    tpstatusdate = json['tpstatusdate'];
    tpclass = json['tpclass'];

    tpname = json['tpname'];
    tpsurname = json['tpsurname'];

    tpactivity = json['tpactivity'];

    mgid = json['mgid'];
    lancode = json['lancode'];
    countcode = json['countcode'];
    tpcompanycreationdate = json['tpcompanycreationdate'];
    tpfiscalid = json['tpfiscalid'];
    tpfiscalcity = json['tpfiscalcity'];
    tptaxid = json['tptaxid'];
    tpsalutationcode = json['tpsalutationcode'];
    tpgender = json['tpgender'];
    tpbirthdate = json['tpbirthdate'];
    tpbirthcity = json['tpbirthcity'];
    tpbirthcountry = json['tpbirthcountry'];
    tpprofession = json['tpprofession'];
    tpidentitycardtype = json['tpidentitycardtype'];
    tpidentitycardid = json['tpidentitycardid'];
    tpmaritalstatus = json['tpmaritalstatus'];
    tpnbofchildren = json['tpnbofchildren'];
    tpworkingcttype = json['tpworkingcttype'];
    tpworkingctdate = json['tpworkingctdate'];

    tpkycdate = json['tpkycdate'];
    tpkycstatus = json['tpkycstatus'];

    lastAction = json['last_action'];
    tpflagvatexemption = json['tpflagvatexemption'];

    currcode = json['currcode'];
    tpflagresident = json['tpflagresident'];
    tpcategory = json['tpcategory'];

    tpactivitysector = json['tpactivitysector'];
    tpidentitycardexpirationdate = json['tpidentitycardexpirationdate'];
    tpidentitycardcountry = json['tpidentitycardcountry'];

    tpcompanyid = json['tpcompanyid'];
    tpfiscalcitylabel = json['tpfiscalcitylabel'];
    tpidentitycardcountrylabel = json['tpidentitycardcountrylabel'];
  }
}

class Address {
  String? tpmainadrstreet1;

  String? tpmainadrcity;
  String? tpmainadrzipcode;
  String? tpmainadrregion;
  String? tpmainadrcountry;

  String? tpmainadrcitylabel;

  Address(
      {this.tpmainadrstreet1,
      this.tpmainadrcity,
      this.tpmainadrzipcode,
      this.tpmainadrregion,
      this.tpmainadrcountry,
      this.tpmainadrcitylabel});

  Address.fromJson(Map<String, dynamic> json) {
    tpmainadrstreet1 = json['tpmainadrstreet1'];

    tpmainadrcity = json['tpmainadrcity'];
    tpmainadrzipcode = json['tpmainadrzipcode'];
    tpmainadrregion = json['tpmainadrregion'];
    tpmainadrcountry = json['tpmainadrcountry'];

    tpmainadrcitylabel = json['tpmainadrcitylabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tpmainadrstreet1'] = this.tpmainadrstreet1;

    data['tpmainadrcity'] = this.tpmainadrcity;
    data['tpmainadrzipcode'] = this.tpmainadrzipcode;
    data['tpmainadrregion'] = this.tpmainadrregion;
    data['tpmainadrcountry'] = this.tpmainadrcountry;

    data['tpmainadrcitylabel'] = this.tpmainadrcitylabel;
    return data;
  }
}

class Contact {
  String? tptel1;
  String? tptelmobile1;
  String? tpemail1;
  String? tpcontactname1;
  String? tpcontactposition1;
  String? tptel2;
  String? tptelmobile2;
  String? tpemail2;
  String? tpcontactname2;

  Contact({
    this.tptel1,
    this.tptelmobile1,
    this.tpemail1,
    this.tpcontactname1,
    this.tpcontactposition1,
    this.tptel2,
    this.tptelmobile2,
    this.tpemail2,
    this.tpcontactname2,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    tptel1 = json['tptel1'];
    tptelmobile1 = json['tptelmobile1'];
    tpemail1 = json['tpemail1'];
    tpcontactname1 = json['tpcontactname1'];
    tpcontactposition1 = json['tpcontactposition1'];
    tptel2 = json['tptel2'];
    tptelmobile2 = json['tptelmobile2'];
    tpemail2 = json['tpemail2'];
    tpcontactname2 = json['tpcontactname2'];
  }
}

class BankAccount {
  String? tpiban;
  String? tpbic;
  String? tpbankname;

  String? tpcbnum;
  String? tpcbdate;

  BankAccount({
    this.tpiban,
    this.tpbic,
    this.tpbankname,
    this.tpcbnum,
    this.tpcbdate,
  });

  BankAccount.fromJson(Map<String, dynamic> json) {
    tpiban = json['tpiban'];
    tpbic = json['tpbic'];
    tpbankname = json['tpbankname'];

    tpcbnum = json['tpcbnum'];
    tpcbdate = json['tpcbdate'];
  }
}

class Status {
  String? tpsalestatus;
  String? tpsalestatusdate;
  String? tpriskstatus;
  String? tpriskstatusdate;

  Status(
      {this.tpsalestatus,
      this.tpsalestatusdate,
      this.tpriskstatus,
      this.tpriskstatusdate});

  Status.fromJson(Map<String, dynamic> json) {
    tpsalestatus = json['tpsalestatus'];
    tpsalestatusdate = json['tpsalestatusdate'];
    tpriskstatus = json['tpriskstatus'];
    tpriskstatusdate = json['tpriskstatusdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tpsalestatus'] = this.tpsalestatus;
    data['tpsalestatusdate'] = this.tpsalestatusdate;
    data['tpriskstatus'] = this.tpriskstatus;
    data['tpriskstatusdate'] = this.tpriskstatusdate;
    return data;
  }
}

class Offer {
  double? finamountmin;
  double? finamountmax;
  int? durationmin;
  int? durationmax;
  String? calculationmethod;
  String? calculationbasis;
  String? rateformula;
  String? ratetype;
  double? rateperiodicity;
  double? ratevaluedefault;
  double? ratespreadmin;
  double? ratespreadmax;
  double? ratespreaddefault;
  String? ratereqtype;
  String? ratereqreceivertype;
  String? ratereqreceiverroleprofile;
  int? ratereqreceiverid;
  int? durationdefault;
  String? durationreqtype;
  String? durationreqreceivertype;
  String? durationreqreceiverroleprofile;
  int? durationreqreceiverid;
  String? periodicity;
  String? unit;
  String? interestmethod;
  String? term;
  int? gpduration;
  String? gpmethod;
  double? firstrentalmin;
  double? firstrentalmax;
  double? firstrentaldefault;
  String? firstrentalreqtype;
  String? firstrentalreqreceivertype;
  String? firstrentalreqreceiverroleprofile;
  int? firstrentalreqreceiverid;
  double? rvmin;
  double? rvmax;
  double? rvdefault;
  String? rvreqtype;
  String? rvreqreceivertype;
  String? rvreqreceiverroleprofile;

  String? taxcode;
  String? deferredinterestmethod;
  double? deferredinterestnominalrate;
  double? depositamount;
  double? depositcoef;
  String? depositinterestmethod;
  double? depositnominalrate;
  double? rvdefaultamount;
  String? partmethod;
  double? partamount;
  double? partrate;

  String? prefinmethod;
  double? prefinnominalrate;
  String? prefinbasis;
  String? prefinperiodicity;
  String? prefinratetype;
  String? prefinrateformula;
  String? tprole;
  double? upfrontmin;
  double? upfrontmax;
  double? upfrontdefault;
  String? upfrontreqtype;
  String? upfrontreqreceivertype;
  String? upfrontreqreceiverroleprofile;
  int? upfrontreqreceiverid;

  String? offerlabel;

  String? startdate;

  String? offerstatus;
  int? partnbdays;

  int? offerid;
  String? taxtype;
  double? taxrate;

  double? rvcontextmax;
  double? rvcontextmin;
  int? rvauthid;
  int? rvtaskid;
  double? ratecontextmax;
  double? ratecontextmin;
  int? rateauthid;
  int? ratetaskid;
  double? frcontextmax;
  double? frcontextmin;
  int? frauthid;
  int? frtaskid;
  double? durationcontextmax;
  double? durationcontextmin;
  int? durationauthid;
  int? durationtaskid;

  String? depositratetype;
  String? deferredinterestratetype;

  Offer(
      {this.finamountmin,
      this.finamountmax,
      this.durationmin,
      this.durationmax,
      this.calculationmethod,
      this.calculationbasis,
      this.rateformula,
      this.ratetype,
      this.rateperiodicity,
      this.ratevaluedefault,
      this.ratespreadmin,
      this.ratespreadmax,
      this.ratespreaddefault,
      this.ratereqtype,
      this.ratereqreceivertype,
      this.ratereqreceiverroleprofile,
      this.ratereqreceiverid,
      this.durationdefault,
      this.durationreqtype,
      this.durationreqreceivertype,
      this.durationreqreceiverroleprofile,
      this.durationreqreceiverid,
      this.periodicity,
      this.unit,
      this.interestmethod,
      this.term,
      this.gpduration,
      this.gpmethod,
      this.firstrentalmin,
      this.firstrentalmax,
      this.firstrentaldefault,
      this.firstrentalreqtype,
      this.firstrentalreqreceivertype,
      this.firstrentalreqreceiverroleprofile,
      this.firstrentalreqreceiverid,
      this.rvmin,
      this.rvmax,
      this.rvdefault,
      this.rvreqtype,
      this.rvreqreceivertype,
      this.rvreqreceiverroleprofile,
      this.taxcode,
      this.deferredinterestmethod,
      this.deferredinterestnominalrate,
      this.depositamount,
      this.depositcoef,
      this.depositinterestmethod,
      this.depositnominalrate,
      this.rvdefaultamount,
      this.partmethod,
      this.partamount,
      this.partrate,
      this.prefinmethod,
      this.prefinnominalrate,
      this.prefinbasis,
      this.prefinperiodicity,
      this.prefinratetype,
      this.prefinrateformula,
      this.tprole,
      this.upfrontmin,
      this.upfrontmax,
      this.upfrontdefault,
      this.upfrontreqtype,
      this.upfrontreqreceivertype,
      this.upfrontreqreceiverroleprofile,
      this.upfrontreqreceiverid,
      this.offerlabel,
      this.startdate,
      this.offerstatus,
      this.partnbdays,
      this.offerid,
      this.taxtype,
      this.taxrate,
      this.rvcontextmax,
      this.rvcontextmin,
      this.rvauthid,
      this.rvtaskid,
      this.ratecontextmax,
      this.ratecontextmin,
      this.rateauthid,
      this.ratetaskid,
      this.frcontextmax,
      this.frcontextmin,
      this.frauthid,
      this.frtaskid,
      this.durationcontextmax,
      this.durationcontextmin,
      this.durationauthid,
      this.durationtaskid,
      this.depositratetype,
      this.deferredinterestratetype});

  Offer.fromJson(Map<String, dynamic> json) {
    finamountmin = json['finamountmin'];
    finamountmax = json['finamountmax'];
    durationmin = json['durationmin'];
    durationmax = json['durationmax'];
    calculationmethod = json['calculationmethod'];
    calculationbasis = json['calculationbasis'];
    rateformula = json['rateformula'];
    ratetype = json['ratetype'];
    rateperiodicity = json['rateperiodicity']?.toDouble();
    ratevaluedefault = json['ratevaluedefault'];
    ratespreadmin = json['ratespreadmin'];
    ratespreadmax = json['ratespreadmax'];
    ratespreaddefault = json['ratespreaddefault'];
    ratereqtype = json['ratereqtype'];
    ratereqreceivertype = json['ratereqreceivertype'];
    ratereqreceiverroleprofile = json['ratereqreceiverroleprofile'];
    ratereqreceiverid = json['ratereqreceiverid'];
    durationdefault = json['durationdefault'];
    durationreqtype = json['durationreqtype'];
    durationreqreceivertype = json['durationreqreceivertype'];
    durationreqreceiverroleprofile = json['durationreqreceiverroleprofile'];
    durationreqreceiverid = json['durationreqreceiverid'];
    periodicity = json['periodicity'];
    unit = json['unit'];
    interestmethod = json['interestmethod'];
    term = json['term'];
    gpduration = json['gpduration'];
    gpmethod = json['gpmethod'];
    firstrentalmin = json['firstrentalmin']?.toDouble();
    firstrentalmax = json['firstrentalmax']?.toDouble();
    firstrentaldefault = json['firstrentaldefault']?.toDouble();
    firstrentalreqtype = json['firstrentalreqtype'];
    firstrentalreqreceivertype = json['firstrentalreqreceivertype'];
    firstrentalreqreceiverroleprofile =
        json['firstrentalreqreceiverroleprofile'];
    firstrentalreqreceiverid = json['firstrentalreqreceiverid'];
    rvmin = json['rvmin'];
    rvmax = json['rvmax'];
    rvdefault = json['rvdefault'];
    rvreqtype = json['rvreqtype'];
    rvreqreceivertype = json['rvreqreceivertype'];
    rvreqreceiverroleprofile = json['rvreqreceiverroleprofile'];

    taxcode = json['taxcode'];
    deferredinterestmethod = json['deferredinterestmethod'];
    deferredinterestnominalrate = json['deferredinterestnominalrate'];
    depositamount = json['depositamount'];
    depositcoef = json['depositcoef'];
    depositinterestmethod = json['depositinterestmethod'];
    depositnominalrate = json['depositnominalrate']?.toDouble();
    rvdefaultamount = json['rvdefaultamount']?.toDouble();
    partmethod = json['partmethod'];
    partamount = json['partamount'];
    partrate = json['partrate']?.toDouble();

    prefinmethod = json['prefinmethod'];
    prefinnominalrate = json['prefinnominalrate']?.toDouble();
    prefinbasis = json['prefinbasis'];
    prefinperiodicity = json['prefinperiodicity'];
    prefinratetype = json['prefinratetype'];
    prefinrateformula = json['prefinrateformula'];
    tprole = json['tprole'];
    upfrontmin = json['upfrontmin']?.toDouble();
    upfrontmax = json['upfrontmax']?.toDouble();
    upfrontdefault = json['upfrontdefault']?.toDouble();
    upfrontreqtype = json['upfrontreqtype'];
    upfrontreqreceivertype = json['upfrontreqreceivertype'];
    upfrontreqreceiverroleprofile = json['upfrontreqreceiverroleprofile'];
    upfrontreqreceiverid = json['upfrontreqreceiverid'];

    offerlabel = json['offerlabel'];

    startdate = json['startdate'];

    offerstatus = json['offerstatus'];
    partnbdays = json['partnbdays'];

    offerid = json['offerid'];
    taxtype = json['taxtype'];
    taxrate = json['taxrate']?.toDouble();

    rvcontextmax = json['rvcontextmax']?.toDouble();
    rvcontextmin = json['rvcontextmin']?.toDouble();
    rvauthid = json['rvauthid'];
    rvtaskid = json['rvtaskid'];
    ratecontextmax = json['ratecontextmax']?.toDouble();
    ratecontextmin = json['ratecontextmin']?.toDouble();
    rateauthid = json['rateauthid'];
    ratetaskid = json['ratetaskid'];
    frcontextmax = json['frcontextmax'];
    frcontextmin = json['frcontextmin'];
    frauthid = json['frauthid'];
    frtaskid = json['frtaskid'];
    durationcontextmax = json['durationcontextmax']?.toDouble();
    durationcontextmin = json['durationcontextmin']?.toDouble();
    durationauthid = json['durationauthid'];
    durationtaskid = json['durationtaskid'];

    depositratetype = json['depositratetype'];
    deferredinterestratetype = json['deferredinterestratetype'];
  }
}

class ThirdParties {
  int? tpid;
  int? ctrid;
  String? tprolecode;
  String? startdate;

  String? status;
  String? statusdate;

  int? tpadrid;
  String? tppaymodein;
  String? tppaydelayin;
  String? tppaymodeout;
  String? tppaydelayout;

  bool? tpblocklateinterestinvoicing;

  bool? tpblockrejectionfeesinvoicing;

  bool? tpblockreminderfeesinvoicing;
  double? mfrequestedamount;
  double? mfagreedamount;
  double? mfusedamount;
  double? mfbookedamount;
  double? mfavailableamount;
  String? mfvaliditydate;
  int? tpbkidin;
  int? tpbkidout;
  int? tproleid;
  ClientData? thirdPartyData;
  String? tpname;
  String? tpreference;
  String? tprolecodelabel;
  Address? address;

  ThirdParties({
    this.tpid,
    this.ctrid,
    this.tprolecode,
    this.startdate,
    this.status,
    this.statusdate,
    this.tpadrid,
    this.tppaymodein,
    this.tppaydelayin,
    this.tppaymodeout,
    this.tppaydelayout,
    this.tpblocklateinterestinvoicing,
    this.tpblockrejectionfeesinvoicing,
    this.tpblockreminderfeesinvoicing,
    this.mfrequestedamount,
    this.mfagreedamount,
    this.mfusedamount,
    this.mfbookedamount,
    this.mfavailableamount,
    this.mfvaliditydate,
    this.tpbkidin,
    this.tpbkidout,
    this.tproleid,
    this.thirdPartyData,
    this.tpname,
    this.tpreference,
    this.tprolecodelabel,
    this.address,
  });

  ThirdParties.fromJson(Map<String, dynamic> json) {
    tpid = json['tpid'];
    ctrid = json['ctrid'];
    tprolecode = json['tprolecode'];
    startdate = json['startdate'];

    status = json['status'];
    statusdate = json['statusdate'];

    tpadrid = json['tpadrid'];
    tppaymodein = json['tppaymodein'];
    tppaydelayin = json['tppaydelayin'];
    tppaymodeout = json['tppaymodeout'];
    tppaydelayout = json['tppaydelayout'];

    tpblocklateinterestinvoicing = json['tpblocklateinterestinvoicing'];

    tpblockrejectionfeesinvoicing = json['tpblockrejectionfeesinvoicing'];

    tpblockreminderfeesinvoicing = json['tpblockreminderfeesinvoicing'];
    mfrequestedamount = json['mfrequestedamount']?.toDouble();
    mfagreedamount = json['mfagreedamount']?.toDouble();
    mfusedamount = json['mfusedamount']?.toDouble();
    mfbookedamount = json['mfbookedamount']?.toDouble();
    mfavailableamount = json['mfavailableamount']?.toDouble();
    mfvaliditydate = json['mfvaliditydate'];
    tpbkidin = json['tpbkidin'];
    tpbkidout = json['tpbkidout'];
    tproleid = json['tproleid'];
    thirdPartyData = json['thirdPartyData'] != null
        ? new ClientData.fromJson(json['thirdPartyData'])
        : null;
    tpname = json['tpname'];
    tpreference = json['tpreference'];
    tprolecodelabel = json['tprolecodelabel'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }
}

class Assets {
  int? cteid;
  String? assetreference;
  String? assetstatus;
  int? tpidsupplier;
  String? assettype;
  String? assetcategory;
  bool? assetmulticomponents;
  String? assetdescription;

  String? currcode;
  double? assetnetamount;
  String? taxcode;
  double? taxrate;
  double? assettaxamount;
  double? assetgrossamount;
  String? assetmodel;

  String? plateno;

  String? chassisno;
  String? engineno;
  String? registrationno;
  String? serialno;
  bool? flagused;
  String? fiscaldepreciationmethod;
  String? deliveryadrstreet1;
  String? deliveryadrstreet2;
  String? deliveryadrcity;
  String? deliveryadrzipcode;
  String? deliveryadrcountry;
  String? assetlabel;

  int? mgid;
  int? assetqtyavailable;
  double? assetunitnetamount;
  String? assetfamily;
  double? assetrvamount;
  bool? flagholdback;
  double? holdbackpercentage;
  double? holdbackamount;

  double? assetfinamount;

  int? assetid;

  int? catalogid;

  String? assetsegment;
  String? assetsegmentlabel;
  String? assetphase;

  String? deliveryadrregion;
  String? suppliername;
  String? supplierreference;
  String? statuslabel;
  String? assettypelabel;
  String? assetcategorylabel;

  String? manufacturername;
  String? manufacturerreference;

  int? assetqty;

  String? assetfamilylabel;

  String? assetstatusdate;
  String? brokername;
  String? brokerreference;

  String? balersizelabel;
  String? separatortypelabel;
  String? wheeldrivelabel;
  String? transmissionlabel;
  String? countrylabel;

  String? assetpictureurl;

  int? holdbackbeleasenbdays;

  Assets({
    this.cteid,
    this.assetreference,
    this.assetstatus,
    this.tpidsupplier,
    this.assettype,
    this.assetcategory,
    this.assetmulticomponents,
    this.assetdescription,
    this.assetnetamount,
    this.taxcode,
    this.taxrate,
    this.assettaxamount,
    this.assetgrossamount,
    this.assetmodel,
    this.plateno,
    this.chassisno,
    this.engineno,
    this.registrationno,
    this.serialno,
    this.flagused,
    this.fiscaldepreciationmethod,
    this.deliveryadrstreet1,
    this.deliveryadrstreet2,
    this.deliveryadrcity,
    this.deliveryadrzipcode,
    this.deliveryadrcountry,
    this.assetlabel,
    this.mgid,
    this.assetqtyavailable,
    this.assetunitnetamount,
    this.assetfamily,
    this.assetrvamount,
    this.flagholdback,
    this.holdbackpercentage,
    this.holdbackamount,
    this.assetfinamount,
    this.assetid,
    this.catalogid,
    this.assetsegment,
    this.assetsegmentlabel,
    this.assetphase,
    this.deliveryadrregion,
    this.suppliername,
    this.supplierreference,
    this.statuslabel,
    this.assettypelabel,
    this.assetcategorylabel,
    this.manufacturername,
    this.manufacturerreference,
    this.assetqty,
    this.assetfamilylabel,
    this.assetstatusdate,
    this.brokername,
    this.brokerreference,
    this.balersizelabel,
    this.separatortypelabel,
    this.wheeldrivelabel,
    this.transmissionlabel,
    this.countrylabel,
    this.assetpictureurl,
    this.holdbackbeleasenbdays,
  });

  Assets.fromJson(Map<String, dynamic> json) {
    cteid = json['cteid'];
    assetreference = json['assetreference'];
    assetstatus = json['assetstatus'];
    tpidsupplier = json['tpidsupplier'];
    assettype = json['assettype'];
    assetcategory = json['assetcategory'];
    assetmulticomponents = json['assetmulticomponents'];
    assetdescription = json['assetdescription'];

    currcode = json['currcode'];
    assetnetamount = json['assetnetamount']?.toDouble();
    taxcode = json['taxcode'];
    taxrate = json['taxrate']?.toDouble();
    assettaxamount = json['assettaxamount']?.toDouble();
    assetgrossamount = json['assetgrossamount']?.toDouble();
    assetmodel = json['assetmodel'];

    plateno = json['plateno'];

    chassisno = json['chassisno'];
    engineno = json['engineno'];
    registrationno = json['registrationno'];
    serialno = json['serialno'];
    flagused = json['flagused'];
    fiscaldepreciationmethod = json['fiscaldepreciationmethod'];
    deliveryadrstreet1 = json['deliveryadrstreet1'];
    deliveryadrstreet2 = json['deliveryadrstreet2'];
    deliveryadrcity = json['deliveryadrcity'];
    deliveryadrzipcode = json['deliveryadrzipcode'];
    deliveryadrcountry = json['deliveryadrcountry'];
    assetlabel = json['assetlabel'];

    mgid = json['mgid'];
    assetqtyavailable = json['assetqtyavailable'];
    assetunitnetamount = json['assetunitnetamount']?.toDouble();
    assetfamily = json['assetfamily'];
    assetrvamount = json['assetrvamount']?.toDouble();
    flagholdback = json['flagholdback'];
    holdbackpercentage = json['holdbackpercentage']?.toDouble();
    holdbackamount = json['holdbackamount']?.toDouble();

    assetfinamount = json['assetfinamount']?.toDouble();

    assetid = json['assetid'];

    catalogid = json['catalogid'];

    assetsegment = json['assetsegment'];
    assetsegmentlabel = json['assetsegmentlabel'];
    assetphase = json['assetphase'];

    deliveryadrregion = json['deliveryadrregion'];
    suppliername = json['suppliername'];
    supplierreference = json['supplierreference'];
    statuslabel = json['statuslabel'];
    assettypelabel = json['assettypelabel'];
    assetcategorylabel = json['assetcategorylabel'];

    manufacturername = json['manufacturername'];
    manufacturerreference = json['manufacturerreference'];

    assetqty = json['assetqty'];

    assetfamilylabel = json['assetfamilylabel'];

    assetstatusdate = json['assetstatusdate'];
    brokername = json['brokername'];
    brokerreference = json['brokerreference'];

    balersizelabel = json['balersizelabel'];
    separatortypelabel = json['separatortypelabel'];
    wheeldrivelabel = json['wheeldrivelabel'];
    transmissionlabel = json['transmissionlabel'];
    countrylabel = json['countrylabel'];

    assetpictureurl = json['assetpictureurl'];

    holdbackbeleasenbdays = json['holdbackbeleasenbdays'];
  }
}

class ConElement {
  int? cteorder;
  String? ctedirection;
  String? ctetype;
  String? ctecategory;
  String? ctestatus;

  int? tpid;
  int? priid;
  String? currcode;
  String? taxcode;
  String? ctestartdate;
  String? cteenddate;
  String? ctecalculationtype;
  String? ctecalculationbasis;
  double? cteinitialamount;
  double? cteupfrontamount;
  double? cteinvestamount;
  double? ctefinancedamount;
  double? ctestartamount;
  double? cteendamount;
  String? ctepaymentterm;
  String? cteinterestmethod;
  String? cteperiodicity;
  int? cteduration;

  String? ctedeferredinterestmethod;
  int? ctegraceperiodduration;
  String? ctegraceperiodmethod;
  double? ctervcoef;
  double? ctervamount;
  double? ctefirstpayment;
  double? ctefirstpaymentcoef;
  double? ctedepositamount;
  double? ctedepositcoef;
  String? ctedepositinterestmethod;
  double? ctedepositnominalrate;
  String? cteratetype;
  String? cterateformula;
  String? cterateterm;
  String? cteratebasis;
  String? cterateperiodicity;
  double? cteactuarialrate;
  double? ctenominalrate;
  double? cteratespread;
  String? lastAction;
  String? ctefree1;
  double? ctedeferredinterestnominalrate;
  double? cteinstallmentamount;
  String? ctedescription;
  String? cteunit;
  String? ctepartmethod;
  double? ctepartamount;
  double? ctepartrate;

  int? ctepartdays;
  int? assetid;
  double? ctedeferredinterest;
  double? ctedepositinterest;
  double? cterentalamount;
  String? prefinmethod;
  double? prefinnominalrate;
  String? prefinbasis;
  String? prefinperiodicity;
  String? prefinratetype;
  String? prefinrateformula;

  int? rvauthid;
  int? rvtaskid;
  int? rateauthid;
  int? ratetaskid;
  int? frauthid;
  int? frtaskid;
  int? durationauthid;
  int? durationtaskid;

  double? ctefeesamount;
  double? ctecommissionamount;
  double? cteprofitabilityrate;
  double? cteaprrate;
  double? cteflatrate;
  double? ctecoefrate;
  double? ctefundingrate;
  double? ctefundingperiodicity;
  double? ctefundinginstallment;
  double? ctefundingcost;
  double? ctemarginamount;
  double? ctemarginrate;
  double? ctevatdeferralamount;
  double? ctevatdeferralduration;
  String? ctevatdeferralmethod;
  int? ctevatdeferraldaysbasis;
  double? cteextracosttofinance;
  String? cteextracostcomment;
  double? servbasis;
  int? ctemileage;

  String? ctebilligdate;
  int? cteid;
  int? ctrid;
  double? taxrate;
  String? taxtype;
  String? rvcalculationmode;
  String? rvevaluationmode;

  double? prefinrateref;
  double? cterateref;
  double? servfixedamount;
  double? servpercentage;
  int? ofrid;
  String? ofrtype;
  String? ofrlabel;
  double? ceilingrate;
  double? floorrate;
  double? ceilingdefaultrate;
  double? floordefaultrate;
  int? calid;
  String? ctepartinvoicingmode;
  String? ctepartratetype;
  String? ctepartrateformula;
  String? ctedirectionlabel;
  String? ctetypelabel;
  String? ctecategorylabel;
  String? ctestatuslabel;
  int? cteidparentorder;
  String? tpname;
  String? prilabel;
  String? ctecalculationtypelabel;
  String? ctecalculationbasislabel;
  String? ctepaymenttermlabel;
  String? cteperiodicitylabel;
  String? ctedeferredinterestmethodlabel;
  String? ctegraceperiodmethodlabel;
  String? ctedepositinterestmethodlabel;
  String? cteunitlabel;
  String? ctepartmethodlabel;
  String? tpnamepart;
  String? assetdescription;
  String? assetreference;
  double? ctepartratespread;
  String? servuseunit;
  String? servusefrequency;
  double? servuseqty;
  double? servuseminamount;
  double? servusemaxamount;
  double? servusecoverage;
  double? servusedeductionamount;
  double? servusedeductionpercenrage;
  String? servdescription;

  ConElement(
      {this.cteorder,
      this.ctedirection,
      this.ctetype,
      this.ctecategory,
      this.ctestatus,
      this.tpid,
      this.priid,
      this.currcode,
      this.taxcode,
      this.ctestartdate,
      this.cteenddate,
      this.ctecalculationtype,
      this.ctecalculationbasis,
      this.cteinitialamount,
      this.cteupfrontamount,
      this.cteinvestamount,
      this.ctefinancedamount,
      this.ctestartamount,
      this.cteendamount,
      this.ctepaymentterm,
      this.cteinterestmethod,
      this.cteperiodicity,
      this.cteduration,
      this.ctedeferredinterestmethod,
      this.ctegraceperiodduration,
      this.ctegraceperiodmethod,
      this.ctervcoef,
      this.ctervamount,
      this.ctefirstpayment,
      this.ctefirstpaymentcoef,
      this.ctedepositamount,
      this.ctedepositcoef,
      this.ctedepositinterestmethod,
      this.ctedepositnominalrate,
      this.cteratetype,
      this.cterateformula,
      this.cterateterm,
      this.cteratebasis,
      this.cterateperiodicity,
      this.cteactuarialrate,
      this.ctenominalrate,
      this.cteratespread,
      this.lastAction,
      this.ctefree1,
      this.ctedeferredinterestnominalrate,
      this.cteinstallmentamount,
      this.ctedescription,
      this.cteunit,
      this.ctepartmethod,
      this.ctepartamount,
      this.ctepartrate,
      this.ctepartdays,
      this.assetid,
      this.ctedeferredinterest,
      this.ctedepositinterest,
      this.cterentalamount,
      this.prefinmethod,
      this.prefinnominalrate,
      this.prefinbasis,
      this.prefinperiodicity,
      this.prefinratetype,
      this.prefinrateformula,
      this.rvauthid,
      this.rvtaskid,
      this.rateauthid,
      this.ratetaskid,
      this.frauthid,
      this.frtaskid,
      this.durationauthid,
      this.durationtaskid,
      this.ctefeesamount,
      this.ctecommissionamount,
      this.cteprofitabilityrate,
      this.cteaprrate,
      this.cteflatrate,
      this.ctecoefrate,
      this.ctefundingrate,
      this.ctefundingperiodicity,
      this.ctefundinginstallment,
      this.ctefundingcost,
      this.ctemarginamount,
      this.ctemarginrate,
      this.ctevatdeferralamount,
      this.ctevatdeferralduration,
      this.ctevatdeferralmethod,
      this.ctevatdeferraldaysbasis,
      this.cteextracosttofinance,
      this.cteextracostcomment,
      this.servbasis,
      this.ctemileage,
      this.ctebilligdate,
      this.cteid,
      this.ctrid,
      this.taxrate,
      this.taxtype,
      this.rvcalculationmode,
      this.rvevaluationmode,
      this.prefinrateref,
      this.cterateref,
      this.servfixedamount,
      this.servpercentage,
      this.ofrid,
      this.ofrtype,
      this.ofrlabel,
      this.ceilingrate,
      this.floorrate,
      this.ceilingdefaultrate,
      this.floordefaultrate,
      this.calid,
      this.ctepartinvoicingmode,
      this.ctepartratetype,
      this.ctepartrateformula,
      this.ctedirectionlabel,
      this.ctetypelabel,
      this.ctecategorylabel,
      this.ctestatuslabel,
      this.cteidparentorder,
      this.tpname,
      this.prilabel,
      this.ctecalculationtypelabel,
      this.ctecalculationbasislabel,
      this.ctepaymenttermlabel,
      this.cteperiodicitylabel,
      this.ctedeferredinterestmethodlabel,
      this.ctegraceperiodmethodlabel,
      this.ctedepositinterestmethodlabel,
      this.cteunitlabel,
      this.ctepartmethodlabel,
      this.tpnamepart,
      this.assetdescription,
      this.assetreference,
      this.ctepartratespread,
      this.servuseunit,
      this.servusefrequency,
      this.servuseqty,
      this.servuseminamount,
      this.servusemaxamount,
      this.servusecoverage,
      this.servusedeductionamount,
      this.servusedeductionpercenrage,
      this.servdescription});

  ConElement.fromJson(Map<String, dynamic> json) {
    cteorder = json['cteorder'];
    ctedirection = json['ctedirection'];
    ctetype = json['ctetype'];
    ctecategory = json['ctecategory'];
    ctestatus = json['ctestatus'];

    tpid = json['tpid'];
    priid = json['priid'];
    currcode = json['currcode'];
    taxcode = json['taxcode'];
    ctestartdate = json['ctestartdate'];
    cteenddate = json['cteenddate'];
    ctecalculationtype = json['ctecalculationtype'];
    ctecalculationbasis = json['ctecalculationbasis'];
    cteinitialamount = json['cteinitialamount']?.toDouble();
    cteupfrontamount = json['cteupfrontamount']?.toDouble();
    cteinvestamount = json['cteinvestamount']?.toDouble();
    ctefinancedamount = json['ctefinancedamount']?.toDouble();
    ctestartamount = json['ctestartamount']?.toDouble();
    cteendamount = json['cteendamount']?.toDouble();
    ctepaymentterm = json['ctepaymentterm'];
    cteinterestmethod = json['cteinterestmethod'];
    cteperiodicity = json['cteperiodicity'];
    cteduration = json['cteduration'];

    ctedeferredinterestmethod = json['ctedeferredinterestmethod'];
    ctegraceperiodduration = json['ctegraceperiodduration'];
    ctegraceperiodmethod = json['ctegraceperiodmethod'];
    ctervcoef = json['ctervcoef']?.toDouble();

    ctervamount = json['ctervamount']?.toDouble();

    ctefirstpayment = json['ctefirstpayment']?.toDouble();

    ctefirstpaymentcoef = json['ctefirstpaymentcoef']?.toDouble();

    ctedepositamount = json['ctedepositamount']?.toDouble();

    ctedepositcoef = json['ctedepositcoef']?.toDouble();
    ctedepositinterestmethod = json['ctedepositinterestmethod'];
    ctedepositnominalrate = json['ctedepositnominalrate']?.toDouble();
    cteratetype = json['cteratetype'];
    cterateformula = json['cterateformula'];
    cterateterm = json['cterateterm'];
    cteratebasis = json['cteratebasis'];
    cterateperiodicity = json['cterateperiodicity'];
    cteactuarialrate = json['cteactuarialrate']?.toDouble();
    ctenominalrate = json['ctenominalrate']?.toDouble();
    cteratespread = json['cteratespread']?.toDouble();
    lastAction = json['last_action'];
    ctefree1 = json['ctefree1'];
    ctedeferredinterestnominalrate =
        json['ctedeferredinterestnominalrate']?.toDouble();

    cteinstallmentamount = json['cteinstallmentamount']?.toDouble();

    ctedescription = json['ctedescription'];
    cteunit = json['cteunit'];
    ctepartmethod = json['ctepartmethod'];
    ctepartamount = json['ctepartamount']?.toDouble();
    ctepartrate = json['ctepartrate']?.toDouble();

    ctepartdays = json['ctepartdays'];
    assetid = json['assetid'];
    ctedeferredinterest = json['ctedeferredinterest']?.toDouble();
    ctedepositinterest = json['ctedepositinterest']?.toDouble();
    cterentalamount = json['cterentalamount']?.toDouble();
    prefinmethod = json['prefinmethod'];
    prefinnominalrate = json['prefinnominalrate']?.toDouble();
    prefinbasis = json['prefinbasis'];
    prefinperiodicity = json['prefinperiodicity'];
    prefinratetype = json['prefinratetype'];
    prefinrateformula = json['prefinrateformula'];

    rvauthid = json['rvauthid'];
    rvtaskid = json['rvtaskid'];
    rateauthid = json['rateauthid'];
    ratetaskid = json['ratetaskid'];
    frauthid = json['frauthid'];
    frtaskid = json['frtaskid'];
    durationauthid = json['durationauthid'];
    durationtaskid = json['durationtaskid'];

    ctefeesamount = json['ctefeesamount']?.toDouble();

    ctecommissionamount = json['ctecommissionamount']?.toDouble();

    cteprofitabilityrate = json['cteprofitabilityrate']?.toDouble();

    cteaprrate = json['cteaprrate']?.toDouble();

    cteflatrate = json['cteflatrate']?.toDouble();

    ctecoefrate = json['ctecoefrate']?.toDouble();

    ctefundingrate = json['ctefundingrate']?.toDouble();

    ctefundingperiodicity = json['ctefundingperiodicity']?.toDouble();
    ctefundinginstallment = json['ctefundinginstallment']?.toDouble();
    ctefundingcost = json['ctefundingcost']?.toDouble();
    ctemarginamount = json['ctemarginamount']?.toDouble();
    ctemarginrate = json['ctemarginrate']?.toDouble();
    ctevatdeferralamount = json['ctevatdeferralamount']?.toDouble();
    ctevatdeferralduration = json['ctevatdeferralduration']?.toDouble();
    ctevatdeferralmethod = json['ctevatdeferralmethod'];
    ctevatdeferraldaysbasis = json['ctevatdeferraldaysbasis'];
    cteextracosttofinance = json['cteextracosttofinance']?.toDouble();
    cteextracostcomment = json['cteextracostcomment'];
    servbasis = json['servbasis']?.toDouble();
    ctemileage = json['ctemileage'];

    ctebilligdate = json['ctebilligdate'];
    cteid = json['cteid'];
    ctrid = json['ctrid'];
    taxrate = json['taxrate']?.toDouble();
    taxtype = json['taxtype'];
    rvcalculationmode = json['rvcalculationmode'];
    rvevaluationmode = json['rvevaluationmode'];

    prefinrateref = json['prefinrateref']?.toDouble();
    cterateref = json['cterateref']?.toDouble();
    servfixedamount = json['servfixedamount']?.toDouble();
    servpercentage = json['servpercentage']?.toDouble();
    ofrid = json['ofrid'];
    ofrtype = json['ofrtype'];
    ofrlabel = json['ofrlabel'];
    ceilingrate = json['ceilingrate']?.toDouble();
    floorrate = json['floorrate']?.toDouble();
    ceilingdefaultrate = json['ceilingdefaultrate']?.toDouble();
    floordefaultrate = json['floordefaultrate']?.toDouble();
    calid = json['calid'];
    ctepartinvoicingmode = json['ctepartinvoicingmode'];
    ctepartratetype = json['ctepartratetype'];
    ctepartrateformula = json['ctepartrateformula'];
    ctedirectionlabel = json['ctedirectionlabel'];
    ctetypelabel = json['ctetypelabel'];
    ctecategorylabel = json['ctecategorylabel'];
    ctestatuslabel = json['ctestatuslabel'];
    cteidparentorder = json['cteidparentorder'];
    tpname = json['tpname'];
    prilabel = json['prilabel'];
    ctecalculationtypelabel = json['ctecalculationtypelabel'];
    ctecalculationbasislabel = json['ctecalculationbasislabel'];
    ctepaymenttermlabel = json['ctepaymenttermlabel'];
    cteperiodicitylabel = json['cteperiodicitylabel'];
    ctedeferredinterestmethodlabel = json['ctedeferredinterestmethodlabel'];
    ctegraceperiodmethodlabel = json['ctegraceperiodmethodlabel'];
    ctedepositinterestmethodlabel = json['ctedepositinterestmethodlabel'];
    cteunitlabel = json['cteunitlabel'];
    ctepartmethodlabel = json['ctepartmethodlabel'];
    tpnamepart = json['tpnamepart'];
    assetdescription = json['assetdescription'];
    assetreference = json['assetreference'];
    ctepartratespread = json['ctepartratespread']?.toDouble();
    servuseunit = json['servuseunit'];
    servusefrequency = json['servusefrequency'];
    servuseqty = json['servuseqty']?.toDouble();
    servuseminamount = json['servuseminamount']?.toDouble();
    servusemaxamount = json['servusemaxamount']?.toDouble();
    servusecoverage = json['servusecoverage']?.toDouble();
    servusedeductionamount = json['servusedeductionamount']?.toDouble();
    servusedeductionpercenrage = json['servusedeductionpercenrage']?.toDouble();
    servdescription = json['servdescription'];
  }
}
