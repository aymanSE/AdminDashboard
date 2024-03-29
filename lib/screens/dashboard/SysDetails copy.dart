import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/orgDetails.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../main/components/side_menu.dart';
import 'components/eventList.dart';
import 'components/header.dart';
import 'components/my_sys_fields.dart';
import 'components/OrgData.dart';
import 'components/OrgStat.dart';
import 'components/sys_stat_details.dart';

class EventDetails extends StatefulWidget {


  const EventDetails();

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
    bool isVerified = false;
    int id = 0;

  @override
  void initState() {
    super.initState();
   

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        EventListScreen(),
                        SizedBox(height: defaultPadding),
                        //  RecentFiles(),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                  // On Mobile means if the screen is less than 850 we don't want to show it
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: SysStorageDetails(),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
