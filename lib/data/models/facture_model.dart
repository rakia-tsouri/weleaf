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
  final int? ciidcreditnote;
  final String? currcode;
  final String citypelabel;
  final String cistatuslabel;
  final String cirefcreditnote;
  final String ciinvoicetype;
  final int? printid;
  final int? printidemail;

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
    this.ciidcreditnote,
    this.currcode,
    required this.citypelabel,
    required this.cistatuslabel,
    required this.cirefcreditnote,
    required this.ciinvoicetype,
    this.printid,
    this.printidemail,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      ciid: json['ciid'] as int,
      cireference: json['cireference'] as String,
      mgid: json['mgid'] as int,
      citype: json['citype'] as String,
      cistatus: json['cistatus'] as String,
      cidocdate: DateTime.parse(json['cidocdate'] as String),
      tpreference: json['tpreference'] as String?,
      clientname: json['clientname'] as String?,
      cidocreference: json['cidocreference'] as String,
      ctreference: json['ctreference'] as String,
      cigrosstotal: (json['cigrosstotal'] as num).toDouble(),
      cidueamount: (json['cidueamount'] as num).toDouble(),
      ciidcreditnote: json['ciidcreditnote'] as int?,
      currcode: json['currcode'] as String?,
      citypelabel: json['citypelabel'] as String,
      cistatuslabel: json['cistatuslabel'] as String,
      cirefcreditnote: json['cirefcreditnote'] as String? ?? '',
      ciinvoicetype: json['ciinvoicetype'] as String,
      printid: json['printid'] as int?,
      printidemail: json['printidemail'] as int?,
    );
  }

  // Optionally add a toJson method if you need to serialize the object
  Map<String, dynamic> toJson() {
    return {
      'ciid': ciid,
      'cireference': cireference,
      'mgid': mgid,
      'citype': citype,
      'cistatus': cistatus,
      'cidocdate': cidocdate.toIso8601String(),
      'tpreference': tpreference,
      'clientname': clientname,
      'cidocreference': cidocreference,
      'ctreference': ctreference,
      'cigrosstotal': cigrosstotal,
      'cidueamount': cidueamount,
      'ciidcreditnote': ciidcreditnote,
      'currcode': currcode,
      'citypelabel': citypelabel,
      'cistatuslabel': cistatuslabel,
      'cirefcreditnote': cirefcreditnote,
      'ciinvoicetype': ciinvoicetype,
      'printid': printid,
      'printidemail': printidemail,
    };
  }
}