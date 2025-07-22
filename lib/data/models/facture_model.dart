class Facture {
  final int ciid;
  final String cireference;
  final int mgid;
  final String citype;
  final String cistatus;
  final DateTime cidocdate;
  final String? tpreference;
  final String? clientname;
  final String cidocreference;
  final String ctreference;
  final double cigrosstotal;
  final double cidueamount;
  final String? currcode;
  final String citypelabel;
  final String cistatuslabel;

  Facture({
    required this.ciid,
    required this.cireference,
    required this.mgid,
    required this.citype,
    required this.cistatus,
    required this.cidocdate,
    this.tpreference,
    this.clientname,
    required this.cidocreference,
    required this.ctreference,
    required this.cigrosstotal,
    required this.cidueamount,
    this.currcode,
    required this.citypelabel,
    required this.cistatuslabel,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      ciid: json['ciid'],
      cireference: json['cireference'],
      mgid: json['mgid'],
      citype: json['citype'],
      cistatus: json['cistatus'],
      cidocdate: DateTime.parse(json['cidocdate']),
      tpreference: json['tpreference'],
      clientname: json['clientname'],
      cidocreference: json['cidocreference'],
      ctreference: json['ctreference'],
      cigrosstotal: (json['cigrosstotal'] as num).toDouble(),
      cidueamount: (json['cidueamount'] as num).toDouble(),
      currcode: json['currcode'],
      citypelabel: json['citypelabel'],
      cistatuslabel: json['cistatuslabel'],
    );
  }
}