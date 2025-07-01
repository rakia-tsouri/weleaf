class AssetServicesResponse {
  String? code;
  String? message;
  String? description;

  List<AssetSerivce>? list;

  AssetServicesResponse({this.code, this.message, this.description, this.list});

  AssetServicesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    description = json['description'];

    if (json['list'] != null) {
      list = <AssetSerivce>[];
      json['list'].forEach((v) {
        list!.add(new AssetSerivce.fromJson(v));
      });
    }
  }
}

class AssetSerivce {
  int? associd;
  int? assetid;
  String? servcode;
  double? servpercentage;
  double? servfixedamount;
  String? servlabel;
  double? servpercentagedefault;
  double? servfixedamountdefault;
  int? cteid;
  String? startdate;
  String? enddate;
  String? status;
  AssetSerivce({
    this.associd,
    this.assetid,
    this.servcode,
    this.servpercentage,
    this.servfixedamount,
    this.servlabel,
    this.servpercentagedefault,
    this.servfixedamountdefault,
  });

  AssetSerivce.fromJson(Map<String, dynamic> json) {
    associd = json['associd'];
    assetid = json['assetid'];
    servcode = json['servcode'];
    servpercentage = json['servpercentage']?.toDouble();
    servfixedamount = json['servfixedamount']?.toDouble();
    servlabel = json['servlabel'];
    cteid = json['cteid'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    status = json['status'];
    servpercentagedefault = json['servpercentagedefault']?.toDouble();
    servfixedamountdefault = json['servfixedamountdefault']?.toDouble();
  }
}
