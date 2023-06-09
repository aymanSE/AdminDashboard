import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

class OrgDetails extends StatefulWidget {
  final int orgId;
  final String verified;

  const OrgDetails({required this.orgId, required this.verified});

  @override
  _OrgDetailsState createState() => _OrgDetailsState();
}

class _OrgDetailsState extends State<OrgDetails> {
  Future<List<CloudStorageInfo>> fetchData() async {
    // Fetch total attendance from API
    final attendanceResponse = await http.get(Uri.parse('http://172.28.205.102:3333/spot/totalattendance/${widget.orgId}'));
    final attendanceData = jsonDecode(attendanceResponse.body);

    // Fetch total views from API
    final viewsResponse = await http.get(Uri.parse('http://172.28.205.102:3333/event/totalviews/${widget.orgId}'));
    final viewsData = jsonDecode(viewsResponse.body);

    // Create CloudStorageInfo objects
    List<CloudStorageInfo> data = [
      CloudStorageInfo(
        title: "Attendance",
        numOfFiles: attendanceData['totalAttendance'],
        svgSrc: "assets/icons/users.svg",
        totalStorage: "N/A",
        color: primaryColor,
        percentage: 0,
      ),
      
      CloudStorageInfo(
        title: "Views",
        numOfFiles: viewsData.isNotEmpty ? viewsData[0]['views'] : 0,
        svgSrc: "assets/icons/eye.svg",
        totalStorage: "N/A",
        color: Color(0xFFFFA113),
        percentage: 0,
      ),
    ];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CloudStorageInfo>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<CloudStorageInfo>? data = snapshot.data;
          return Container(
            // Your widget code here...
          );
        }
      },
    );
  }
   
}
