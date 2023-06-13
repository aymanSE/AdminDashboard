import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/orgDetails.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'components/orgeventList.dart';
import 'components/recent_files.dart';
import 'components/storage_details.dart';

class OrgDetails extends StatefulWidget {
  final int orgId;
  final String orgName;

  const OrgDetails({required this.orgId, this.orgName = ''});

  @override
  _OrgDetailsState createState() => _OrgDetailsState();
}

class _OrgDetailsState extends State<OrgDetails> {
  bool isVerified = false;
  int id = 0;
  String orgName = '';
  @override
  void initState() {
    super.initState();
    id = widget.orgId;
    orgName = widget.orgName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${orgName}\'s Details'),
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
                        MyFiles(
                          orgId: id,
                        ),
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
                      child: StorageDetails(
                        orgId: id,
                      ),
                    ),
                ],
              ),OrganizationDataScreen(organizationId: id,)
            ],
          ),
        ),
      ),
    );
  }
}
