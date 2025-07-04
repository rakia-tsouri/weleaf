class Calendar {
  final int calid;
  final String callabel;
  final String countcode;

  Calendar({
    required this.calid,
    required this.callabel,
    required this.countcode,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      calid: json['calid'],
      callabel: json['callabel'],
      countcode: json['countcode'] ?? '',
    );
  }
}