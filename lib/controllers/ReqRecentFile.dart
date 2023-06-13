import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_helper.dart';
class ReqRecentFile {
  final String? ID, title, email, verified;

  ReqRecentFile({this.ID, this.title, this.email, this.verified});
}
List<ReqRecentFile> reqdemoRecentFiles = [];

Future<void> reqfetchData() async {
  final response = await ApiHelper().get('user/req');
  
    final List<dynamic> data  =response ;
    reqdemoRecentFiles = data.map((item) {
      return ReqRecentFile(
       
        ID: "${item['id']}",
        title: "${item['first_name']} ${item['last_name']}",
        // You can modify the date format as per your requirement
        email: item['email'],
        verified : item['SID'].toString(),
      );
    }).toList();
  
}