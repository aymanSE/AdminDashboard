import 'package:admin/models/Card_Model.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../controllers/api_helper.dart';
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
     final attendanceResponse = await ApiHelper().get(
      'spot/count'
    );
    final viewsResponse = await ApiHelper().get(
      'event/totalviews'
    );
    final eventsResponse = await ApiHelper().get(
      'event/count'
    );
    final usersResponse = await ApiHelper().get(
      'user/count'
    );
        final attendResponse = await ApiHelper().get(
      'user/countAtten'
    );
        final pendResponse = await ApiHelper().get(
      'user/countPen'
    );
         final orgResponse = await ApiHelper().get(
      'user/countOrg'
    );
    
      final attendanceData =  attendanceResponse ;
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalAttendance = attendanceData;
        });
   
    }

       final viewsData = viewsResponse as List<dynamic>;
      final List<int> viewsList =
          viewsData.map<int>((item) => item['views']).toList();
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalViews = viewsList;
        });
       
    }

       final eventsData = eventsResponse;
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalEvents = eventsData;
        });
       
    }
       final usersData = usersResponse;
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalUsers = usersData;
        });
       
    }
       final attendData = attendResponse;
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalAttend = attendData;
        });
       
    }
       final orgsData = orgResponse;
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalOrg = orgsData;
        });
       
    }
       final pendsData = pendResponse;
      if (_isMounted) { // Check if the widget is still mounted before calling setState()
        setState(() {
          totalPend = pendsData;
        });
       
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
