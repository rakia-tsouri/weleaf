class ProposalListResponse {
  String? code;
  String? message;
  String? description;
  List<Proposal>? list;

  ProposalListResponse({this.code, this.message, this.description, this.list});

  ProposalListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    description = json['description'];

    if (json['list'] != null) {
      list = <Proposal>[];
      json['list'].forEach((v) {
        list!.add(Proposal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['description'] = description;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Proposal {
  int? ctrid;
  String? ctreference;
  int? mgid;
  String? ctdescription;
  String? ctphase;
  String? ctstatus;
  String? ctstatusdate;
  int? tpidclient;
  String? prcode;
  String? assetPictureUrl;
  List? imageBytes;

  String? ctorderdate;
  String? ctdeliverydate;
  String? ctactivationdate;
  double? ctfinancedamount;
  String? tpreference;
  String? clientname;
  String? statuslabel;
  String? ctstage;
  String? propreference;
  int? tpidbroker;
  String? tprefbroker;
  String? brokername;
  String? ctnetworkcode;
  int? mcid;
  int? offerid;
  String? offeridlabel;
  String? prcodelabel;
  int? mfid;
  String? mfreference;
  String? currcode;
  String? ctcomment;
  int? cteduration;
  double? cteupfrontamount;
  double? ctervamount;
  double? ctefirstpayment;
  double? cterentalamount;
  double? ctepartamount;
  int? ctegraceperiodduration;
  String? ctedescription;
  String? assetpictureurl;
  int? catalogid;

  double? mfusedamount;
  double? mfbookedamount;
  double? mfavailableamount;
  double? mfagreedamount;

  Proposal({
    this.ctrid,
    this.ctreference,
    this.mgid,
    this.ctdescription,
    this.ctphase,
    this.ctstatus,
    this.assetPictureUrl,
    this.ctstatusdate,
    this.tpidclient,
    this.prcode,
    this.ctorderdate,
    this.ctdeliverydate,
    this.ctactivationdate,
    this.ctfinancedamount,
    this.tpreference,
    this.clientname,
    this.statuslabel,
    this.ctstage,
    this.propreference,
    this.tpidbroker,
    this.tprefbroker,
    this.brokername,
    this.ctnetworkcode,
    this.mcid,
    this.offerid,
    this.offeridlabel,
    this.prcodelabel,
    this.mfid,
    this.mfreference,
    this.currcode,
    this.ctcomment,
    this.cteduration,
    this.cteupfrontamount,
    this.ctervamount,
    this.ctefirstpayment,
    this.cterentalamount,
    this.ctepartamount,
    this.ctegraceperiodduration,
    this.ctedescription,
    this.assetpictureurl,
    this.catalogid,
    this.mfusedamount,
    this.mfbookedamount,
    this.mfavailableamount,
    this.mfagreedamount,
    this.imageBytes,
  });

  Proposal.fromJson(Map<String, dynamic> json) {
    ctrid = json['ctrid'];
    ctreference = json['ctreference'];
    mgid = json['mgid'];
    ctdescription = json['ctdescription'];
    ctphase = json['ctphase'];
    ctstatus = json['ctstatus'];
    ctstatusdate = json['ctstatusdate'];
    tpidclient = json['tpidclient'];
    prcode = json['prcode'];
    assetPictureUrl = json['assetpictureurl'];

    ctorderdate = json['ctorderdate'];
    ctdeliverydate = json['ctdeliverydate'];
    ctactivationdate = json['ctactivationdate'];
    ctfinancedamount = json['ctfinancedamount']?.toDouble();
    tpreference = json['tpreference'];
    clientname = json['clientname'];
    statuslabel = json['statuslabel'];
    ctstage = json['ctstage'];
    propreference = json['propreference'];
    tpidbroker = json['tpidbroker'];
    tprefbroker = json['tprefbroker'];
    brokername = json['brokername'];
    ctnetworkcode = json['ctnetworkcode'];
    mcid = json['mcid'];
    offerid = json['offerid'];
    offeridlabel = json['offeridlabel'];
    prcodelabel = json['prcodelabel'];
    mfid = json['mfid'];
    mfreference = json['mfreference'];
    currcode = json['currcode'];
    ctcomment = json['ctcomment'];
    cteduration = json['cteduration'];
    cteupfrontamount = json['cteupfrontamount']?.toDouble();
    ctervamount = json['ctervamount']?.toDouble();
    ctefirstpayment = json['ctefirstpayment']?.toDouble();
    cterentalamount = json['cterentalamount']?.toDouble();
    ctepartamount = json['ctepartamount']?.toDouble();
    ctegraceperiodduration = json['ctegraceperiodduration'];
    ctedescription = json['ctedescription'];
    assetpictureurl = json['assetpictureurl'];
    catalogid = json['catalogid'];

    mfusedamount = json['mfusedamount']?.toDouble();
    mfbookedamount = json['mfbookedamount']?.toDouble();
    mfavailableamount = json['mfavailableamount']?.toDouble();
    mfagreedamount = json['mfagreedamount']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ctrid'] = ctrid;
    data['ctreference'] = ctreference;
    data['mgid'] = mgid;
    data['ctdescription'] = ctdescription;
    data['ctphase'] = ctphase;
    data['ctstatus'] = ctstatus;
    data['ctstatusdate'] = ctstatusdate;
    data['tpidclient'] = tpidclient;
    data['prcode'] = prcode;

    data['ctorderdate'] = ctorderdate;
    data['ctdeliverydate'] = ctdeliverydate;
    data['ctactivationdate'] = ctactivationdate;
    data['ctfinancedamount'] = ctfinancedamount;
    data['tpreference'] = tpreference;
    data['clientname'] = clientname;
    data['statuslabel'] = statuslabel;
    data['ctstage'] = ctstage;
    data['propreference'] = propreference;
    data['tpidbroker'] = tpidbroker;
    data['tprefbroker'] = tprefbroker;
    data['brokername'] = brokername;
    data['ctnetworkcode'] = ctnetworkcode;
    data['mcid'] = mcid;
    data['offerid'] = offerid;
    data['offeridlabel'] = offeridlabel;
    data['prcodelabel'] = prcodelabel;
    data['mfid'] = mfid;
    data['mfreference'] = mfreference;
    data['currcode'] = currcode;
    data['ctcomment'] = ctcomment;
    data['cteduration'] = cteduration;
    data['cteupfrontamount'] = cteupfrontamount;
    data['ctervamount'] = ctervamount;
    data['ctefirstpayment'] = ctefirstpayment;
    data['cterentalamount'] = cterentalamount;
    data['ctepartamount'] = ctepartamount;
    data['ctegraceperiodduration'] = ctegraceperiodduration;
    data['ctedescription'] = ctedescription;
    data['assetpictureurl'] = assetpictureurl;
    data['catalogid'] = catalogid;

    data['mfusedamount'] = mfusedamount;
    data['mfbookedamount'] = mfbookedamount;
    data['mfavailableamount'] = mfavailableamount;
    data['mfagreedamount'] = mfagreedamount;
    return data;
  }
}
