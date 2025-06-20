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
        list!.add(new Proposal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['description'] = this.description;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
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

  Proposal(
      {this.ctrid,
      this.ctreference,
      this.mgid,
      this.ctdescription,
      this.ctphase,
      this.ctstatus,
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
      this.mfagreedamount});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ctrid'] = this.ctrid;
    data['ctreference'] = this.ctreference;
    data['mgid'] = this.mgid;
    data['ctdescription'] = this.ctdescription;
    data['ctphase'] = this.ctphase;
    data['ctstatus'] = this.ctstatus;
    data['ctstatusdate'] = this.ctstatusdate;
    data['tpidclient'] = this.tpidclient;
    data['prcode'] = this.prcode;

    data['ctorderdate'] = this.ctorderdate;
    data['ctdeliverydate'] = this.ctdeliverydate;
    data['ctactivationdate'] = this.ctactivationdate;
    data['ctfinancedamount'] = this.ctfinancedamount;
    data['tpreference'] = this.tpreference;
    data['clientname'] = this.clientname;
    data['statuslabel'] = this.statuslabel;
    data['ctstage'] = this.ctstage;
    data['propreference'] = this.propreference;
    data['tpidbroker'] = this.tpidbroker;
    data['tprefbroker'] = this.tprefbroker;
    data['brokername'] = this.brokername;
    data['ctnetworkcode'] = this.ctnetworkcode;
    data['mcid'] = this.mcid;
    data['offerid'] = this.offerid;
    data['offeridlabel'] = this.offeridlabel;
    data['prcodelabel'] = this.prcodelabel;
    data['mfid'] = this.mfid;
    data['mfreference'] = this.mfreference;
    data['currcode'] = this.currcode;
    data['ctcomment'] = this.ctcomment;
    data['cteduration'] = this.cteduration;
    data['cteupfrontamount'] = this.cteupfrontamount;
    data['ctervamount'] = this.ctervamount;
    data['ctefirstpayment'] = this.ctefirstpayment;
    data['cterentalamount'] = this.cterentalamount;
    data['ctepartamount'] = this.ctepartamount;
    data['ctegraceperiodduration'] = this.ctegraceperiodduration;
    data['ctedescription'] = this.ctedescription;
    data['assetpictureurl'] = this.assetpictureurl;
    data['catalogid'] = this.catalogid;

    data['mfusedamount'] = this.mfusedamount;
    data['mfbookedamount'] = this.mfbookedamount;
    data['mfavailableamount'] = this.mfavailableamount;
    data['mfagreedamount'] = this.mfagreedamount;
    return data;
  }
}
