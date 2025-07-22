// models/contract_model.dart
class Contract {
  final int ctrid;
  final String ctreference;
  final String ctdescription;
  final String ctphase;
  final String ctstatus;
  final DateTime? ctactivationdate;
  final double ctfinancedamount;
  final String clientname;
  final String statuslabel;
  final String propreference;
  final String brokername;
  final String ctnetworkcode;
  final String offeridlabel;
  final String prcodelabel;
  final String currcode;
  final int cteduration;
  final double cteupfrontamount;
  final double ctervamount;
  final double ctefirstpayment;
  final double cterentalamount;
  final String ctedescription;
  final String clientreference;
  final String ctestartdate;
  final String cteenddate;
  final String assetpictureurl;
  final int ctremainingduration;
  final double ctenominalrate;

  Contract({
    required this.ctrid,
    required this.ctreference,
    required this.ctdescription,
    required this.ctphase,
    required this.ctstatus,
    this.ctactivationdate,
    required this.ctfinancedamount,
    required this.clientname,
    required this.statuslabel,
    required this.propreference,
    required this.brokername,
    required this.ctnetworkcode,
    required this.offeridlabel,
    required this.prcodelabel,
    required this.currcode,
    required this.cteduration,
    required this.cteupfrontamount,
    required this.ctervamount,
    required this.ctefirstpayment,
    required this.cterentalamount,
    required this.ctedescription,
    required this.clientreference,
    required this.ctestartdate,
    required this.cteenddate,
    required this.assetpictureurl,
    required this.ctremainingduration,
    required this.ctenominalrate,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      ctrid: json['ctrid'] ?? 0,
      ctreference: json['ctreference'] ?? '',
      ctdescription: json['ctdescription'] ?? '',
      ctphase: json['ctphase'] ?? '',
      ctstatus: json['ctstatus'] ?? '',
      ctactivationdate: json['ctactivationdate'] != null
          ? DateTime.parse(json['ctactivationdate'])
          : null,
      ctfinancedamount: json['ctfinancedamount']?.toDouble() ?? 0.0,
      clientname: json['clientname'] ?? '',
      statuslabel: json['statuslabel'] ?? '',
      propreference: json['propreference'] ?? '',
      brokername: json['brokername'] ?? '',
      ctnetworkcode: json['ctnetworkcode'] ?? '',
      offeridlabel: json['offeridlabel'] ?? '',
      prcodelabel: json['prcodelabel'] ?? '',
      currcode: json['currcode'] ?? '',
      cteduration: json['cteduration'] ?? 0,
      cteupfrontamount: json['cteupfrontamount']?.toDouble() ?? 0.0,
      ctervamount: json['ctervamount']?.toDouble() ?? 0.0,
      ctefirstpayment: json['ctefirstpayment']?.toDouble() ?? 0.0,
      cterentalamount: json['cterentalamount']?.toDouble() ?? 0.0,
      ctedescription: json['ctedescription'] ?? '',
      clientreference: json['clientreference'] ?? '',
      ctestartdate: json['ctestartdate'] ?? '',
      cteenddate: json['cteenddate'] ?? '',
      assetpictureurl: json['assetpictureurl'] ?? '',
      ctremainingduration: json['ctremainingduration'] ?? 0,
      ctenominalrate: json['ctenominalrate']?.toDouble() ?? 0.0,
    );
  }
}