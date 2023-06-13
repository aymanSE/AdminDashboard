import 'package:admin/screens/dashboard/components/reportcards.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:convert';

import '../../../constants.dart';
import '../../../controllers/api_helper.dart';
import '../../../models/Event_Model.dart';

class OrganizationDataScreen extends StatefulWidget {
  final int organizationId;

  const OrganizationDataScreen({Key? key, required this.organizationId})
      : super(key: key);

  @override
  _OrganizationDataScreenState createState() => _OrganizationDataScreenState();
}

class _OrganizationDataScreenState extends State<OrganizationDataScreen> {
  Future<List<Event>>? _fetchEvents;

  @override
  void initState() {
    super.initState();
    _fetchEvents = fetchEvents(widget.organizationId);
  }

  Future<void> refreshData() async {
    setState(() {
      _fetchEvents = fetchEvents(widget.organizationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Organizer Events list',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: refreshData,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
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
                          ),  DataColumn(
                            label: Text("reports"),
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
      ],
    );
  }

  void showConfirmationPopup(Event event) {
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
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                primary: Colors.red, // Set the button background color to red
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                String emailText =
                    emailController.text.trim(); // Get the entered email text

                await sendEmail(event.organizerEmail,
                    emailText); // Send email to the organizer's email

                await deleteEvent(event.id); // Delete the event

                refreshData(); // Refresh the data after deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
Future<List<Event>> fetchEvents(int organizationId) async {
  final response = await ApiHelper().get('/event/org/$organizationId');
  final List<dynamic> data = response;
  return data.map((item) {
    final organizer = item['organizer'];
    final reports = item['report'] as List<dynamic>; // Get the reports list
    final reportsCount = reports.length; // Calculate the reports count
    final capacity = item['capacity'];
    final attendeesCount = item['spot'].length; // Count the number of attendees
    Color reportsColor;

    if (reportsCount < attendeesCount * 0.25) {
      reportsColor = Colors.green;
    } else if (reportsCount < attendeesCount * 0.66) {
      reportsColor = Colors.yellow;
    } else {
      reportsColor = Colors.red;
    }

    return Event(
      id: item['id'],
      name: item['name'],
      status: item['status'],
      organizerEmail: organizer['email'],
      reportsCount: reportsCount, // Pass the reports count to the model
      reportsColor: reportsColor, 
      report: reports// Pass the reports color to the model
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

    return  DataRow(
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
      GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventReportsScreen(event: fileInfo),
      ),
    );
  },
  child: Text(
    fileInfo.reportsCount.toString(),
    style: TextStyle(color: fileInfo.reportsColor),
  ),
),

      ),
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
  }

  Future<void> deleteEvent(int id) async {
    final response = await ApiHelper().delete('/event/$id');
    if (response.statusCode == 200) {
      print('Event deleted');
    } else {
      throw Exception('Failed to delete event');
    }
  }
}
