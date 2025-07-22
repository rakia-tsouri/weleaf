class calendar {
  final int calid;
  final String callabel;
  final String countcode;

  calendar({
    required this.calid,
    required this.callabel,
    required this.countcode,
  });

  factory calendar.fromJson(Map<String, dynamic> json) {
    return calendar(
      calid: json['calid'],
      callabel: json['callabel'],
      countcode: json['countcode'] ?? '',
    );
  }
}