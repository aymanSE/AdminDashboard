import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../constants.dart';
import '../../../models/ReqRecentFile.dart';
import '../OrgDetails.dart';

class ReqRecentFiles extends StatefulWidget {
  const ReqRecentFiles({Key? key}) : super(key: key);

  @override
  _ReqRecentFilesState createState() => _ReqRecentFilesState();
}

class _ReqRecentFilesState extends State<ReqRecentFiles> {
  Future<List<ReqRecentFile>>? _fetchRecentFiles;

  @override
  void initState() {
    super.initState();
    _fetchRecentFiles = reqFetchData();
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
            "Organizers Requests List",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: defaultPadding),
          FutureBuilder<List<ReqRecentFile>>(
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
                        label: Text("SID"),
                      ),
                      DataColumn(
                        label: Text("Actions"),
                      ),
                    ],
                    rows: List.generate(recentFiles.length, (index) {
                      final fileInfo = recentFiles[index];
                      return reqrecentFileDataRow(fileInfo, context, () {
                        // Callback function to update recent files when the button is clicked
                        setState(() {
                          _fetchRecentFiles = reqFetchData();
                        });
                      });
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

DataRow reqrecentFileDataRow(
    ReqRecentFile fileInfo, BuildContext context, VoidCallback onUpdate) {
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
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding / 1,
            ),
          ),
          onPressed: () async {
            final response = await http.put(
                Uri.parse('http://192.168.8.120:3333/user/verify/${fileInfo.ID}'));
            if (response.statusCode == 200) {
              // Send email when the button is clicked
              await sendEmail(fileInfo.email!);

              // Call the callback function to update recent files
              onUpdate();
            } else {
              print('Failed to approve');
            }
          },
          icon: Icon(Icons.check),
          label: Text("Approve"),
        ),
      ),
    ],
  );
}

Future<void> sendEmail(String email) async {
    final smtpServer = gmail('clustevents@gmail.com', 'ovqsvecbocresybx');

    final message = Message()
      ..from = Address('clustevents@gmail.com', 'Clust Events')
      ..recipients.add(email)
      ..subject = 'Approval Notification'
      ..text =
          'Your request to become organizer has been approved. This message has been sent from the dashboard!';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Sending email failed: ${e.toString()}');
    }
  }

Future<List<ReqRecentFile>> reqFetchData() async {
  final response = await http.get(Uri.parse('http://192.168.8.120:3333/user/req'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) {
      return ReqRecentFile(
        ID: "${item['id']}",
        title: "${item['first_name']} ${item['last_name']}",
        email: item['email'],
        verified: item['SID'].toString(),
      );
    }).toList();
  } else {
    throw Exception('Failed to fetch data');
  }
}
