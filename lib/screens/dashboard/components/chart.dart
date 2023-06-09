import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class Chart extends StatefulWidget {
  final int orgId;

  const Chart({required this.orgId});

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int value = 0;
  List<PieChartSectionData> pieChartSelectionData = [];
  bool _isMounted = false; // Add a flag to track the mounted state

  @override
  void initState() {
    super.initState();
        _isMounted = true; // Set the flag to false when the widget is disposed

    fetchData();
  }
  @override
  void dispose() {
    _isMounted = false; // Set the flag to false when the widget is disposed
    super.dispose();
  }
  Future<void> fetchData() async {
    final liveResponse = await http.get(
      Uri.parse('http://192.168.93.1:3333/event/getliveorg/${widget.orgId}'),
    );
    final futureResponse = await http.get(
      Uri.parse('http://192.168.93.1:3333/event/getfutureorg/${widget.orgId}'),
    );
    final pastResponse = await http.get(
      Uri.parse('http://192.168.93.1:3333/event/getpastorg/${widget.orgId}'),
    );
    final countResponse = await http.get(
      Uri.parse('http://192.168.93.1:3333/event/count/${widget.orgId}'),
    );
    if (liveResponse.statusCode == 200 &&
        futureResponse.statusCode == 200 &&
        pastResponse.statusCode == 200 &&
        countResponse.statusCode == 200) {
      final liveData = json.decode(liveResponse.body);
      final futureData = json.decode(futureResponse.body);
      final pastData = json.decode(pastResponse.body);
      final countData = json.decode(countResponse.body);
      if (_isMounted) {
        setState(() {
          //value = liveData + futureData + pastData;
          value = countData;
          pieChartSelectionData = [
            PieChartSectionData(
              color: primaryColor,
              value: pastData.toDouble(),
              showTitle: false,
              radius: 25,
            ),
            PieChartSectionData(
              color: Color(0xFFFFCF26),
              value: futureData.toDouble(),
              showTitle: false,
              radius: 19,
            ),
            PieChartSectionData(
              color: Color(0xFFEE2727),
              value: liveData.toDouble(),
              showTitle: false,
              radius: 16,
            ),
          ];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child:pieChartSelectionData.isEmpty?  Center(
              child: CircularProgressIndicator(),
            ) : Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("Total Events")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
