import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../controllers/api_helper.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatefulWidget {
  final int orgId;

  const StorageDetails({required this.orgId});

  @override
  _StorageDetailsState createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails> {
  int liveData = 0;
  int futureData = 0;
  int pastData = 0;
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
    final liveResponse = await ApiHelper().get(
      'event/getliveorg/${widget.orgId}'
    );

    final futureResponse = await ApiHelper().get(
      'event/getfutureorg/${widget.orgId}'
    );

    final pastResponse = await ApiHelper().get(
      'event/getpastorg/${widget.orgId}'
    );

    
      final liveDataResponse = liveResponse;
      final futureDataResponse = futureResponse;
      final pastDataResponse = pastResponse;

      if (_isMounted) {
        setState(() {
          liveData = liveDataResponse;
          futureData = futureDataResponse;
          pastData = pastDataResponse;
        });
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
          Chart(orgId: widget.orgId),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Past",
            amountOfFiles: pastData.toString(),
            numOfFiles: 0,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Live",
            amountOfFiles:liveData.toString(),
            numOfFiles: 0,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Future",
            amountOfFiles: futureData.toString(),
            numOfFiles: 0,
          ),
        ],
      ),
    );
  }
}
