import 'package:admin/models/Users_Model.dart';
import 'package:admin/screens/dashboard/components/palate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import '../../../controllers/api_helper.dart';
import '../OrgDetails.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({Key? key}) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  Future<List<RecentFile>>? _fetchRecentFiles;

  @override
  void initState() {
    super.initState();
    _fetchRecentFiles = fetchData();
  }

  Future<void> refreshData() async {
    setState(() {
      _fetchRecentFiles = fetchData();
    });
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Organizers List",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: refreshData,
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          FutureBuilder<List<RecentFile>>(
            future: _fetchRecentFiles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Failed to fetch data');
              } else if (snapshot.hasData) {
                final recentFiles = snapshot.data!;
                return SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(
                        label: Text("ID"),
                      ),
                      DataColumn(
                        label: Text("Organizer name"),
                      ),
                      DataColumn(
                        label: Text("Email"),
                      ),
                      DataColumn(
                        label: Text("SSN"),
                      ),
                      DataColumn(
                        label: Text("Actions"),
                      ),
                    ],
                    rows: List.generate(recentFiles.length, (index) {
                      final fileInfo = recentFiles[index];
                      return recentFileDataRow(fileInfo, context);
                    }),
                  ),
                );
              } else {
                return Text('No data available');
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<List<RecentFile>> fetchData() async {
   

  final response =
     await ApiHelper().get('/user/org');

    final List<dynamic> data = response;
    return data.map((item) {
      return RecentFile(
        ID: "${item['id']}",
        title: "${item['first_name']} ${item['last_name']}",
        email: item['email'],
        verified: item['SID'].toString(),
      );
    }).toList();
 
}

DataRow recentFileDataRow(RecentFile fileInfo, BuildContext context) {
  void showConfirmationPopup(RecentFile fileInfo) {
  TextEditingController emailContentController = TextEditingController();

Future<void> sendEmail(String emailContent,String email) async {
  final smtpServer = gmail('clustevents@gmail.com', 'ovqsvecbocresybx');

  final message = Message()
    ..from = Address('clustevents@gmail.com', 'Clust Events')
    ..recipients.add(email)
    ..subject = 'Account Deleted'
    ..text = emailContent;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Sending email failed: ${e.toString()}');
  }
}
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to delete this organizer?'),
            SizedBox(height: defaultPadding),
            Text('Reason'),
            TextField(
              controller: emailContentController,
              decoration: InputDecoration(
                hintText: 'Enter delete reason',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical: defaultPadding / 1,
              ),
              primary: Colors.red, // Set the button background color to red
            ),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await deleteItem(fileInfo.ID!); // Delete the item
              await sendEmail(emailContentController.text,fileInfo.email!); // Send the email
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}


  return DataRow(
    cells: [
      DataCell(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrgDetails(
                  orgId: int.parse(fileInfo.ID!),
                  orgName: fileInfo.title!,
                ),
              ),
            );
          },
          child: Text(fileInfo.ID!),
        ),
      ),
      DataCell(
        Text(fileInfo.title!),
      ),
      DataCell(Text(fileInfo.email!)),
      DataCell(Text(fileInfo.verified!)),
      DataCell(
        IconButton(
          icon: Icon(Icons.close),
          color:  Palate.lightwine,
          onPressed: () => showConfirmationPopup(fileInfo),
        ),
      ),
    ],
  );
}

Future<void> deleteItem(String id) async {
  final response = await http.delete(
    Uri.parse('http://192.168.8.120:3333/user/$id'),
  );

  // Handle the response as needed
  // Call the callback function to update recent files
}

 

 
 
