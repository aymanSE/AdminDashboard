 
import 'package:flutter/material.dart';

import '../../../controllers/rate_controller.dart';
import '../../../models/Event_Model.dart';
import '../../../models/rate_model.dart';

class RateProvider with ChangeNotifier {
  List<Rate> rates = [];
  dynamic eventRates = 0;
  static final RateProvider _rateProvider = RateProvider._internal();

  factory RateProvider() {
    return _rateProvider;
  }

  RateProvider._internal() {
    fetchRates();
  }

  fetchRates() async {
    var result = await RateController().getAll();
    rates.addAll(result);
    notifyListeners();
    return rates;
  }

  Future<List<Rate>> fetchEventRates(int id) async {
    List<Rate> eventrates = [];
    for (var rate in rates) {
      if (rate.eventId == id) {
        eventrates.add(rate);
      }
    }
    return eventrates;
  }

  getEventRates(Event event) async {
    eventRates = await RateController().getRate(event.id);
    print("eventRates");
    print(eventRates);
    event.rate = eventRates;
    notifyListeners();
    return eventRates;
  }

  checkRated(eventId, userId) {
    Rate rate = Rate(0, eventId, userId, 0);
    return rates.contains(rate);
  }

  addRate(Rate rate) async {
    dynamic jsonObj = await RateController().create(rate);
    rates.add(rate);
    notifyListeners();
  }
}
