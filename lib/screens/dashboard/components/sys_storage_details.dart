import 'dart:convert';
import 'package:admin/screens/dashboard/components/sys_chart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class SysStorageDetails extends StatefulWidget {
  const SysStorageDetails();

  @override
  _SysStorageDetailsState createState() => _SysStorageDetailsState();
}

class _SysStorageDetailsState extends State<SysStorageDetails> {
  int liveData =0;
  int futureData = 0;
  int pastData =0;
  bool _isMounted = false; // Add a flag to track the mounted state

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Set the flag to false when the widget is disposed

    fetchData();
  }

  @override
  void dispose() {
    _isMounted = true; // Set the flag to false when the widget is disposed
    super.dispose();
  }

  Future<void> fetchData() async {
    // Perform API calls to fetch live, future, and past data
    // Assign the received data to liveData, futureData, and pastData

    // Example API call using http package
       final liveResponse = await http.get(
        Uri.parse('http://192.168.93.1:3333/event/getlivecount'),
      );
     
       final futureResponse = await http.get(
        Uri.parse('http://192.168.93.1:3333/event/getfuturecount'),
      );
     
       final pastResponse = await http.get(
        Uri.parse('http://192.168.93.1:3333/event/getpastcount'),
      );
    
    if (liveResponse.statusCode == 200 &&
        futureResponse.statusCode == 200 &&
        pastResponse.statusCode == 200) {
      final liveDataResponse = json.decode(liveResponse.body);
      final futureDataResponse = json.decode(futureResponse.body);
      final pastDataResponse = json.decode(pastResponse.body);
     
      if (_isMounted) {
        setState(() {
          liveData = liveDataResponse;
          futureData = futureDataResponse;
          pastData = pastDataResponse;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Events Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          SysChart(),

          
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Live",
            amountOfFiles:liveData.toString(),
            numOfFiles: 0,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Past",
            amountOfFiles: pastData.toString(),
            numOfFiles: 0,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Future",
            amountOfFiles:  futureData.toString(),
            numOfFiles: 0,
          ),
        ],
      ),
    );
  }
}
