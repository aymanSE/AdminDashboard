 
import 'package:admin/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/Event_Model.dart';
import 'package:flutter/material.dart';
 

class EventReportsScreen extends StatelessWidget {
  final Event event;

  const EventReportsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Name: ${event.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Reports:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: event.report.length,
                itemBuilder: (context, index) {
                  final report = event.report[index];
                  return Card(
                    color: secondaryColor,
                    elevation: 2,
                    margin: EdgeInsets.fromLTRB(0,0,200 , 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(report['description']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


