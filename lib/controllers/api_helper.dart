import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
 
class ApiHelper {
  String domain = "192.168.8.120:3333"; 
 
 String gmailUsername = 'clustevents@gmail.com';
 String gmailPassword = 'ovqsvecbocresybx';
  Future get(String path) async {
    Uri uri = Uri.http(domain, path);
     var response = await http.get(uri);
    return responsing(response);
 
   }

  Future post(String path, {body}) async {
    print(body.toString());
    Uri uri = Uri.http(domain, path);
    var response = await http.post(uri, body: body);
    return responsing(response);
  }

  Future put(String path ) async {
    Uri uri = Uri.http(domain, path);
    var response = await http.put(uri );
    return responsing(response);
  }

  Future delete(String path) async {
    Uri uri = Uri.http(domain, path);
    var response = await http.delete(uri);
    return responsing(response);
  }
 
  responsing(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonObject = jsonDecode(response.body);
        return jsonObject;
      case 400:
        throw "${response.statusCode}: Bad Request\nResponse Body\n${response.body}";
      case 401:
        throw "${response.statusCode}: Unauthrizied\nResponse Body\n${response.body}";
      case 402:
        throw "${response.statusCode}: Payment Required\nResponse Body\n${response.body}";
      case 403:
        throw "${response.statusCode}: Forbidden\nResponse Body\n${response.body}";
      case 404:
        throw "${response.statusCode}: Not Found\nResponse Body\n${response.body}";
      case 500:
        throw "${response.statusCode}: Server Error :(\nResponse Body\n${response.body}";
      default:
        throw "${response.statusCode}: Server Error :(\nResponse Body\n${response.body}";
    }
  }
}
