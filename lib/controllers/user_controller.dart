import 'dart:developer';

import 'dart:convert';
import '../models/Users_Model.dart';
import 'api_helper.dart';

class UserController {
  String path = "user/";
  Future<User> getAll() async {
    dynamic jsonObject = await ApiHelper().get(path);
    print(jsonObject);
    User result = User.fromJson(jsonObject);
    return result;
  }

  Future<User> getByID(int id) async {
    dynamic jsonObject = await ApiHelper().get("$path$id");
    User result = User.fromJson(jsonObject);
    return result;
  }

  Future<User> create(User user) async {
    user.accessRole = AccessRole.attendee;
    dynamic jsonObject = await ApiHelper().post(path, body: user.toJson());
    User result = User.fromJson(jsonObject);
    String type = jsonObject["type"];
    String token = jsonObject["token"];

    return result;
  }

  Future<void> distroy(int id) async {
    dynamic jsonObject = await ApiHelper().delete("$path$id/");
    // User result = User.fromJson(jsonObject);
    // return result;
  }

  Future<bool> signin(email, password) async {
    try {
      print("signin");
      dynamic jsonObject = await ApiHelper().post(
        "${path}login/",
        body: ({'email': email, 'password': password}),
      );
      print("passed");
      String type = jsonObject["type"];
      String token = jsonObject["token"];
      ApiHelper.token = "$type $token";

      return true;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> signout(int id) async {
    try {
      print(path);
      dynamic jsonObject = await ApiHelper().post("${path}logout/${id}");

      return true;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }
}
