import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import 'file_info_card.dart';

class MySysFiles extends StatefulWidget {

  const MySysFiles();

  @override
  _MySysFilesState createState() => _MySysFilesState();
}

class _MySysFilesState extends State<MySysFiles> {
  int totalAttendance = 0;
  List<int> totalViews = [];
  int totalEvents = 0;
    bool _isMounted = false; // Add a flag to track the mounted state
int  totalUsers=0;
int  totalAttend=0;
int  totalOrg=0;
int  totalPend=0;


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
      Uri.parse('http://127.0.0.1:3333/spot/count'),
    );
    final viewsResponse = await http.get(
      Uri.parse('http://127.0.0.1:3333/event/totalviews'),
    );
    final eventsResponse = await http.get(
      Uri.parse('http://127.0.0.1:3333/event/count'),
    );
    final usersResponse = await http.get(
      Uri.parse('http://127.0.0.1:3333/user/count'),
    );
        final attendResponse = await http.get(
      Uri.parse('http://127.0.0.1:3333/user/countAtten'),
    );
        final pendResponse = await http.get(
      Uri.parse('http://127.0.0.1:3333/user/countPen'),
    );
         final orgResponse = await http.get(
      Uri.parse('http://127.0.0.1:3333/user/countOrg'),
    );
    if (attendanceResponse.statusCode == 200) {
      final attendanceData = json.decode(attendanceResponse.body);
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalAttendance = attendanceData;
        });
      }
    }

    if (viewsResponse.statusCode == 200) {
      final viewsData = json.decode(viewsResponse.body) as List<dynamic>;
      final List<int> viewsList =
          viewsData.map<int>((item) => item['views']).toList();
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalViews = viewsList;
        });
      }
    }

    if (eventsResponse.statusCode == 200) {
      final eventsData = json.decode(eventsResponse.body);
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalEvents = eventsData;
        });
      }
    }
      if (usersResponse.statusCode == 200) {
      final usersData = json.decode(usersResponse.body);
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalUsers = usersData;
        });
      }
    }
      if (attendResponse.statusCode == 200) {
      final attendData = json.decode(attendResponse.body);
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalAttend = attendData;
        });
      }
    }
      if (orgResponse.statusCode == 200) {
      final orgsData = json.decode(orgResponse.body);
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalOrg = orgsData;
        });
      }
    }
     if (pendResponse.statusCode == 200) {
      final pendsData = json.decode(pendResponse.body);
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalPend = pendsData;
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
      totalStorage: "",
      color: primaryColor,
    ),
    CloudStorageInfo(
      title: "Total Views",
      numOfFiles: totalViews.fold(0, (a, b) => a! + b),
      svgSrc: "assets/icons/eye.svg",
      totalStorage: "",
      color: Color(0xFFFFA113),
    ),
    CloudStorageInfo(
      title: "Total Events",
      numOfFiles:totalEvents,
      svgSrc: "assets/icons/calendar.svg",
      totalStorage: "",
      color: Color(0xFFA4CDFF),
    ),
        CloudStorageInfo(
      title: "Total Users",
      numOfFiles:totalUsers,
      svgSrc: "assets/icons/user.svg",
      totalStorage: "",
      color: Color.fromARGB(255, 164, 255, 193),
    ),
        CloudStorageInfo(
      title: "Total Attendees",
      numOfFiles:totalAttend,
      svgSrc: "assets/icons/user.svg",
      totalStorage: "",
      color: Color.fromARGB(255, 249, 164, 255),
    ),
        CloudStorageInfo(
      title: "Total Organizers",
      numOfFiles:totalOrg,
      svgSrc: "assets/icons/user.svg",
      totalStorage: "",
      color: Color.fromARGB(255, 148, 153, 250),
    ),  CloudStorageInfo(
      title: "Total Pending",
      numOfFiles:totalPend,
      svgSrc: "assets/icons/user.svg",
      totalStorage: "",
      color: Color.fromARGB(255, 255, 110, 110),
    ),
  ];
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "System Statistics",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1, fileInfoList: demoMyFiles,
            ),
          tablet: FileInfoCardGridView( fileInfoList: demoMyFiles,
            ),
          desktop: FileInfoCardGridView( fileInfoList: demoMyFiles,
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
      itemCount: 7,
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
