import 'dart:convert';
import 'package:bookapps/models/userData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserMe with ChangeNotifier {
  String token;
  List<UserData> allData = [];
  String role = "";
  String namaUser;

  UserData result;
  List<UserData> resultList;

  String get isAdmin {
    return role;
  }

  String get namaUserNow {
    return namaUser;
  }

  List get getDataMe {
    return allData;
  }

  Future<UserData> userMeData(token) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/users/me');
    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = UserData.fromJson(item);
      print("ini result " + result.toString());
    }

    print(response.body);
    var data = jsonDecode(response.body);
    role = data['role'];
    namaUser = data["username"];

    print('role user ini adalah ' + role);

    return result;
  }

  Future<dynamic> listData(token) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/users?page=1&limit=10');
    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);

    return json.decode(response.body)['data'];
  }

  Future editUser(
    username,
    password,
    passwordconfirm,
    role,
    idUser,
    token,
  ) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/users/' + idUser);
    var response = await http.put(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          // '_id': getRandomString(15),
          'username': username,
          'password': password,
          'confirm': passwordconfirm,
          'role': role,
          // 'created_by_id': idUser,
          // 'created': DateTime.now().toString()
        }));
    print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);


    namaUser = data["username"];


    notifyListeners();

  }
}
