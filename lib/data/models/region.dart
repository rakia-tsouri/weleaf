class Region {
  final String parvalue;
  final String parlistlabel;
  final String parvalueparent;

  Region({
    required this.parvalue,
    required this.parlistlabel,
    required this.parvalueparent,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      parvalue: json['parvalue'] ?? '',
      parlistlabel: json['parlistlabel'] ?? '',
      parvalueparent: json['parvalueparent'] ?? '',
    );
  }
}