import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../constants.dart';
import '../../../controllers/api_helper.dart';
import '../../../controllers/ReqRecentFile.dart';
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
    void showDisapprovePopup(ReqRecentFile fileInfo) {
      showDialog(
        context: context,
        builder: (context) {
          return DisapprovePopup(
            fileInfo: fileInfo,
            onDisapprove: () {
              setState(() {
                _fetchRecentFiles = reqFetchData();
              });
            },
          );
        },
      );
    }

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
                      }, () {
                        showDisapprovePopup(fileInfo);
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

DataRow reqrecentFileDataRow(ReqRecentFile fileInfo, BuildContext context,
    VoidCallback onUpdate, VoidCallback onDisapprove) {
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
        Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical: defaultPadding / 1,
                ),
              ),
              onPressed: () async {
                final response =
                    await ApiHelper().put('user/verify/${fileInfo.ID}');

                await sendEmail(
                  fileInfo.email!,
                  'Your request to become an organizer has been approved.',
                );

                // Call the callback function to update recent files
                onUpdate();
              },
              icon: Icon(Icons.check),
              label: Text("Approve"),
            ),
            SizedBox(width: defaultPadding / 2),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical: defaultPadding / 1,
                ),
                primary: Colors.red,
              ),
              onPressed: onDisapprove,
              icon: Icon(Icons.close),
              label: Text("Disapprove"),
            ),
          ],
        ),
      ),
    ],
  );
}

Future<void> sendEmail(String email, String body) async {
  final smtpServer = gmail('clustevents@gmail.com', 'ovqsvecbocresybx');

  final message = Message()
    ..from = Address('clustevents@gmail.com', 'Clust Events')
    ..recipients.add(email)
    ..subject = 'Approval Notification'
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Sending email failed: ${e.toString()}');
  }
}

Future<List<ReqRecentFile>> reqFetchData() async {
  final response = await ApiHelper().get('/user/req');

  final List<dynamic> data = response;
  return data.map((item) {
    return ReqRecentFile(
      ID: "${item['id']}",
      title: "${item['first_name']} ${item['last_name']}",
      email: item['email'],
      verified: item['SID'].toString(),
    );
  }).toList();
}

class DisapprovePopup extends StatefulWidget {
  final ReqRecentFile fileInfo;
  final VoidCallback onDisapprove;

  DisapprovePopup({required this.fileInfo, required this.onDisapprove});

  @override
  _DisapprovePopupState createState() => _DisapprovePopupState();
}

class _DisapprovePopupState extends State<DisapprovePopup> {
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void disapproveRequest(String reason) async {
      // API call to disapprove the request
      final response =
          await ApiHelper().put('user/disapprove/${widget.fileInfo.ID}');

      // Send email when the request is disapproved
      await sendEmail(
        widget.fileInfo.email!,
        'Your request to become an organizer has been disapproved.\n Reason: $reason',
      );
    
    }

    return AlertDialog(
      title: Text("Disapprove Request"),
      content: TextField(
        controller: _reasonController,
        decoration: InputDecoration(
          labelText: 'Reason',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final reason = _reasonController.text;
            widget.onDisapprove.call(); // Call the disapprove callback function
            disapproveRequest(reason); // Call the API to disapprove the request
            Navigator.of(context).pop(); // Close the popup
          },
          child: Text('Disapprove'),
        ),
      ],
    );
  }
}
