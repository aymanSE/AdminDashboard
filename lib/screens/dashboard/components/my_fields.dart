import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatefulWidget {
  final int orgId;

  const MyFiles({required this.orgId});

  @override
  _MyFilesState createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  int totalAttendance = 0;
  List<int> totalViews = [];
  int totalEvents = 0;
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
    final attendanceResponse = await http.get(
      Uri.parse(
          'http://192.168.93.1:3333/spot/totalattendance/${widget.orgId}'),
    );
    final viewsResponse = await http.get(
      Uri.parse('http://192.168.93.1:3333/event/totalviews/${widget.orgId}'),
    );
    final eventsResponse = await http.get(
      Uri.parse('http://192.168.93.1:3333/event/count/${widget.orgId}'),
    );

    if (attendanceResponse.statusCode == 200) {
      final attendanceData = json.decode(attendanceResponse.body);
      if (_isMounted) {
        setState(() {
          totalAttendance = attendanceData;
        });
      }
    }

    if (viewsResponse.statusCode == 200) {
      final viewsData = json.decode(viewsResponse.body) as List<dynamic>;
      final List<int> viewsList =
          viewsData.map<int>((item) => item['views']).toList();
      if (_isMounted) {
        setState(() {
          totalViews = viewsList;
        });
      }
    }
    if (eventsResponse.statusCode == 200) {
      final eventsData = json.decode(eventsResponse.body);
      if (_isMounted) {
        setState(() {
          totalEvents = eventsData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List demoMyFiles = [
      CloudStorageInfo(
        title: "Total Attendance",
        numOfFiles: totalAttendance,
        svgSrc: "assets/icons/users.svg",
        totalStorage: "1.9GB",
        color: primaryColor,
      ),
      CloudStorageInfo(
        title: "Total Views",
        numOfFiles: totalViews.fold(0, (a, b) => a! + b),
        svgSrc: "assets/icons/eye.svg",
        totalStorage: "2.9GB",
        color: Color(0xFFFFA113),
      ),
      CloudStorageInfo(
        title: "Total Events",
        numOfFiles: totalEvents,
        svgSrc: "assets/icons/calendar.svg",
        totalStorage: "1GB",
        color: Color(0xFFA4CDFF),
      ),
    ];
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Statistics",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
            fileInfoList: demoMyFiles,
          ),
          tablet: FileInfoCardGridView(
            fileInfoList: demoMyFiles,
          ),
          desktop: FileInfoCardGridView(
            fileInfoList: demoMyFiles,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.fileInfoList,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<dynamic> fileInfoList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(
        info: fileInfoList[index],
      ),
    );
  }
}
