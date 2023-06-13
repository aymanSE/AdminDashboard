import 'dart:ui';

class Event {
  final int id;
    final List<dynamic> report;
  final String name;
  final String status;
  final String organizerEmail;
  final int reportsCount;
  final Color reportsColor;
  Event({
    required this.id,
    required this.name,
    required this.status,
    required this.organizerEmail,
    required this.reportsCount,
    required this.reportsColor,
        required this.report,

  });
}