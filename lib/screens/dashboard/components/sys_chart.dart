import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../controllers/api_helper.dart';

class SysChart extends StatefulWidget {
  const SysChart();

  @override
  _SysChartState createState() => _SysChartState();
}

class _SysChartState extends State<SysChart> {
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
    final liveResponse = await ApiHelper().get(
       'event/getlivecount' 
    );
    final futureResponse = await ApiHelper().get(
     'event/getfuturecount' 
    );
    final pastResponse = await ApiHelper().get(
      'event/getpastcount' 
    );
    final countResponse = await ApiHelper().get(
      'event/count' 
    );
   
      final liveData = liveResponse;
      final futureData = futureResponse;
      final pastData = pastResponse;
      final countData = countResponse;
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
                color: Color(0xFF26E5FF),
                value: liveData.toDouble(),
                showTitle: false,
                radius: 22,
              ),
             
          ];
        });
      }
    
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: pieChartSelectionData.isEmpty?  Center(
              child: CircularProgressIndicator(),
            ):Stack(
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
