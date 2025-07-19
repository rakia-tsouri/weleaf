import 'dart:typed_data';
import 'dart:convert';

class ProposalListResponse {
  String? code;
  String? message;
  String? description;
  List<Proposal>? list;

  ProposalListResponse({this.code, this.message, this.description, this.list});

  factory ProposalListResponse.fromJson(Map<String, dynamic> json) {
    return ProposalListResponse(
      code: json['code'],
      message: json['message'],
      description: json['description'],
      list: json['list'] != null
          ? (json['list'] as List).map((v) => Proposal.fromJson(v)).toList()
          : null,
    );
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
  String? ctdescription;
  String? ctstatus;
  String? ctstatusdate;
  String? clientname;
  double? ctfinancedamount;
  String? propreference;
  String? prcodelabel;
  int? cteduration;
  double? cteupfrontamount;
  double? ctervamount;
  double? cterentalamount;
  String? assetpictureurl;
  Uint8List? imageBytes;

  Proposal({
    this.ctrid,
    this.ctreference,
    this.ctdescription,
    this.ctstatus,
    this.ctstatusdate,
    this.clientname,
    this.ctfinancedamount,
    this.propreference,
    this.prcodelabel,
    this.cteduration,
    this.cteupfrontamount,
    this.ctervamount,
    this.cterentalamount,
    this.assetpictureurl,
    this.imageBytes,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    Uint8List? imageBytes;
    if (json['imageBytes'] != null) {
      if (json['imageBytes'] is String) {
        imageBytes = base64Decode(json['imageBytes']);
      } else if (json['imageBytes'] is List) {
        imageBytes = Uint8List.fromList((json['imageBytes'] as List).cast<int>());
      }
    }

    return Proposal(
      ctrid: json['ctrid'],
      ctreference: json['ctreference'],
      ctdescription: json['ctdescription'],
      ctstatus: json['ctstatus'],
      ctstatusdate: json['ctstatusdate'],
      clientname: json['clientname'],
      ctfinancedamount: json['ctfinancedamount']?.toDouble(),
      propreference: json['propreference'],
      prcodelabel: json['prcodelabel'],
      cteduration: json['cteduration'],
      cteupfrontamount: json['cteupfrontamount']?.toDouble(),
      ctervamount: json['ctervamount']?.toDouble(),
      cterentalamount: json['cterentalamount']?.toDouble(),
      assetpictureurl: json['assetpictureurl'],
      imageBytes: imageBytes,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ctrid'] = ctrid;
    data['ctreference'] = ctreference;
    data['ctdescription'] = ctdescription;
    data['ctstatus'] = ctstatus;
    data['ctstatusdate'] = ctstatusdate;
    data['clientname'] = clientname;
    data['ctfinancedamount'] = ctfinancedamount;
    data['propreference'] = propreference;
    data['prcodelabel'] = prcodelabel;
    data['cteduration'] = cteduration;
    data['cteupfrontamount'] = cteupfrontamount;
    data['ctervamount'] = ctervamount;
    data['cterentalamount'] = cterentalamount;
    data['assetpictureurl'] = assetpictureurl;
    return data;
  }
}
