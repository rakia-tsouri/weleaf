class ApiNotification {
  final int id;
  final int notifid;
  final String notifmessage;
  final String? sendername;
  final String? conseqstatusdate;
  final String? modulename;
  final String? objectreference;

  ApiNotification({
    required this.id,
    required this.notifid,
    required this.notifmessage,
    this.sendername,
    this.conseqstatusdate,
    this.modulename,
    this.objectreference,
  });

  factory ApiNotification.fromJson(Map<String, dynamic> json) {
    return ApiNotification(
      id: json['id'] ?? 0,
      notifid: json['notifid'] ?? 0,
      notifmessage: json['notifmessage'] ?? '',
      sendername: json['sendername'],
      conseqstatusdate: json['conseqstatusdate'],
      modulename: json['modulename'],
      objectreference: json['objectreference'],
    );
  }

  String get formattedTime {
    if (conseqstatusdate == null) return 'Unknown';

    try {
      final date = DateTime.parse(conseqstatusdate!);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}