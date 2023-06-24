import 'dart:ui';

import 'package:admin/screens/main/components/rate_provider.dart';

import '../controllers/rate_controller.dart';

class Event {
  final int id;
  final List<dynamic> report;
  final String name;
  final String status;
  final String organizerEmail;
  final int reportsCount;
  final Color reportsColor;
  var rate;

  Event({
    required this.id,
    required this.name,
    required this.status,
    required this.organizerEmail,
    required this.reportsCount,
    required this.reportsColor,
    required this.report,
  }) {
    getRate();
  }
  
  void getRate() async {
  try {
    rate = await RateProvider().getEventRates(this);
  } catch (ex) {
    rate ??= 0;
  }
}
}