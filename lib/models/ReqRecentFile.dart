import 'dart:convert';
import 'package:http/http.dart' as http;
class ReqRecentFile {
  final String? ID, title, email, verified;

  ReqRecentFile({this.ID, this.title, this.email, this.verified});
}
List<ReqRecentFile> reqdemoRecentFiles = [];

Future<void> reqfetchData() async {
  final response = await http.get(Uri.parse( 'http://192.168.8.120:3333/user/req')   );
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    reqdemoRecentFiles = data.map((item) {
      return ReqRecentFile(
       
        ID: "${item['id']}",
        title: "${item['first_name']} ${item['last_name']}",
        // You can modify the date format as per your requirement
        email: item['email'],
        verified : item['verified']==0?'true':'false',
      );
    }).toList();
  } else {
    throw Exception('Failed to fetch data');
  }
}