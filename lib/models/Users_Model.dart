import 'dart:convert';
import 'package:http/http.dart' as http;

import '../controllers/api_helper.dart';
class RecentFile {
  final String? ID, title, email, verified;

  RecentFile({this.ID, this.title, this.email, this.verified});
}
List<RecentFile> demoRecentFiles = [];
final ApiHelper apiHelper = ApiHelper();

Future<void> fetchData() async {
  try {
    dynamic response = await apiHelper.get('/user/org');
    if (response.statusCode == 200) {
      final List<dynamic> data = response['data'];
      demoRecentFiles = data.map((item) {
        return RecentFile(
          ID: "${item['id']}",
          title: "${item['first_name']} ${item['last_name']}",
          email: item['email'],
          verified: item['verified'] == 0 ? 'true' : 'false',
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    throw e;
  }
}

