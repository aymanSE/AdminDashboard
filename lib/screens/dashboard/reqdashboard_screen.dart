import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/orgDetails.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/reqrecent_files.dart';
import 'components/storage_details.dart';

class reqDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                     // MyFiles(),
                      SizedBox(height: defaultPadding),
                      ReqRecentFiles(),
                    //  if (Responsive.isMobile(context))
                      //  SizedBox(height: defaultPadding),
                    //  if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
