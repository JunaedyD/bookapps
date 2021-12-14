import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  var _idToken;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_idToken != null) {
      return _idToken;
    } else {
      return null;
    }
  }

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future logIn(String email, String password) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/auth/login');
    var response = await http.post(url,
        headers: requestHeaders,
        body: json.encode({
          'email': email,
          'password': password,
        }));
    //print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    _idToken = data["token"];

    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
    
  }
}
