import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:convert';

import '../../../constants.dart';
import '../../../controllers/api_helper.dart';
import 'orgeventList.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  Future<List<Event>>? _fetchEvents;

  @override
  void initState() {
    super.initState();
    _fetchEvents = fetchEvents();
  }

  Future<void> refreshData() async {
    setState(() {
      _fetchEvents = fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Events List',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: refreshData,
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding),
                FutureBuilder<List<Event>>(
                  future: _fetchEvents,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Failed to fetch data');
                    } else if (snapshot.hasData) {
                      final events = snapshot.data!;
                      return SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columnSpacing: defaultPadding,
                          columns: [
                            DataColumn(
                              label: Text("ID"),
                            ),
                            DataColumn(
                              label: Text("Event name"),
                            ),
                            DataColumn(
                              label: Text("Organizer Email"),
                            ),
                            DataColumn(
                              label: Text("Status"),
                            ),
                            DataColumn(
                              label: Text("Action"),
                            ),
                          ],
                          rows: List.generate(events.length, (index) {
                            final fileInfo = events[index];
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
          ),
        ),
      ],
    );
  }
}

Future<List<Event>> fetchEvents() async {
  final response = await ApiHelper().get('/event/admin');
  
    final List<dynamic> data = response;
    return data.map((item) {
      final organizer = item['organizer'];
      return Event(
        id: item['id'],
        name: item['name'],
        status: item['status'],
        organizerEmail: organizer['email'],
      );
    }).toList();
 
}


DataRow recentFileDataRow(Event fileInfo, BuildContext context) {
  void showConfirmationPopup(Event fileInfo) {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete this event?'),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(),
                  
                ),maxLines: 4,
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
                String emailText =
                    emailController.text.trim(); // Get the entered email text

                await sendEmail(fileInfo.organizerEmail,
                    emailText); // Send email to the organizer's email

                await deleteEvent(fileInfo.id); // Delete the event
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
        Text(fileInfo.id.toString()),
      ),
      DataCell(
        Text(fileInfo.name),
      ),
      DataCell(Text(fileInfo.organizerEmail)),
      DataCell(Text(fileInfo.status)),
       DataCell(
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => showConfirmationPopup(fileInfo),
        ),
      ),
    ],
  );
}

Future<void> sendEmail(String recipientEmail, String emailText) async {
  final smtpServer = gmail('clustevents@gmail.com', 'ovqsvecbocresybx');

  final message = Message()
    ..from = Address('clustevents@gmail.com', 'Clust Events')
    ..recipients.add(recipientEmail)
    ..subject = 'Event Deletion'
    ..text = emailText; // Use the entered email text
  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Sending email failed: ${e.toString()}');
  }
  // Rest of the code remains the same
}


Future<void> deleteEvent(int id) async {
  final response = await ApiHelper().delete('/event/$id');
  if (response.statusCode == 200) {
    print("sent");
  } else {
    throw Exception('Failed to delete event');
  }
}


class OrgDetails extends StatelessWidget {
  final int orgId;
  final String orgName;

  const OrgDetails({
    Key? key,
    required this.orgId,
    required this.orgName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for the organization details using the provided orgId and orgName
    throw UnimplementedError();
  }
}


