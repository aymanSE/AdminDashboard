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

class User {
  int id;
  String firstName;
  String lastName;
  String birthDate;
  Gender gender;
  String about = " ";
  String image = " ";
  var verified;
  AccessRole? accessRole;
  int? sid;
  String email;
  String password;
  User(
    this.firstName,
    this.lastName,
    this.birthDate,
    this.email,
    this.password,
    this.id, {
    this.gender = Gender.female,
    this.about = " ",
    this.image = " ",
    this.sid,
    this.verified,
    this.accessRole,
  }) {
    verified = 0;
  }

  factory User.fromJson(json) {
    User _user = User(
        json['first_name'] ?? "",
        json['last_name'] ?? "",
        json['birth_date'] ?? DateTime.now().toString(),
        // gender: json['gender'] ?? Gender.,
        json['email'] ?? "",
        json['password'] ?? "",
        json['id'] ?? 0,
        about: json['about'] ?? "",
        image: json['image'] ?? "",
        sid: json['SID'] ?? 0,
        accessRole: json["access_role"] == "organizer"
            ? AccessRole.organizer
            : json["access_role"] == "pending"
                ? AccessRole.pending:
               json["access_role"] == "pending" ?  AccessRole.attendee: AccessRole.admin);
    _user.verified = json['verified'];
    return _user;
  }

  factory User.fromObj(User user,
      {firstName,
      lastName,
      birthDate,
      gender,
      email,
      password,
      id,
      about,
      image,
      sid,
      verified,
      accessRole}) {
    print("${accessRole} to obj");
    User _user = User(
      firstName ?? user.firstName,
      lastName ?? user.lastName,
      birthDate ?? user.birthDate,
      email ?? user.email,
      password ?? user.password,
      id ?? user.id,
      gender: gender ?? user.gender,
      about: about ?? user.about,
      image: image ?? user.image,
      sid: sid ?? user.sid,
      verified: verified ?? user.verified,
      accessRole: accessRole,
    );
    print("${_user.accessRole} obj");
    return _user;
  }

  Map<String, dynamic> toJson() {
    // print(accessRole.name);
    print(accessRole!.name);
    print(accessRole!.name.toString());
    print(accessRole!.name.runtimeType);
    return {
      "first_name": firstName,
      "last_name": lastName,
      "birth_date": birthDate,
      "gender": gender.name,
      "email": email,
      "password": password,
      "SID": sid.toString(),
      "verified": "0",
      "access_role": accessRole!.name,
      "id": id.toString(),
      "about": " $about",
      "image": " $image",
    };
  }
}

enum Gender { female, male, other }

enum AccessRole { admin, pending, attendee, organizer }

