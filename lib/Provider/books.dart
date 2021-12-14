import 'dart:convert';
import 'package:bookapps/models/books.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class BooksNotifier with ChangeNotifier {
  String role = "";

  Books hasil;

  List<Books> result;
  List<Books> resultList;
  var map;

  List<Books> _allBooks = [];

  List<Books> get allBooks => _allBooks;

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> getBook(token, id) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/books?page=1&limit=10');
    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
     

      var values = new Map<String, dynamic>();
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i]['created_by_id'] == id) {
            Map<String, dynamic> map = values[i];
            result.add(Books.fromJson(map));
          }
        }
        print("jumlah : " + result.length.toString());
      }
      return result;
    }

  }

  Future<List<Books>> getBookAdmin(token) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/books?page=1&limit=10');
    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // print("jumlah buku: " + response.body.length.toString());

    if (response.statusCode == 200) {
      // final data = json.decode(response.body) as Map<String, dynamic>;
      // var list = data as List;

      //List<dynamic> values = new List<dynamic>();

      var values = new Map<String, dynamic>();
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i]['created_by_id']) {
            Map<String, dynamic> map = values[i];
            // result.add(Books.fromJson(map));
          }
        }
        print("jumlah : " + result.length.toString());
      }
      return result;
    }
  }

  Future addBook(name, description, idUser, token) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/books');
    var response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          // '_id': getRandomString(15),
          'name': name,
          'description': description,
          // 'created_by_id': idUser,
          // 'created': DateTime.now().toString()
        }));
    //print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    String _idResult = data["_id"];
    String nameResult = data["name"];
    String descriptionResult = data["description"];
    String created_by_idResult = data["created_by_id"];
    String createdResult = data["created"];

    print("ID adalah : ${_idResult}");
    print("Name adalah : ${nameResult}");
    print("Description adalah : ${descriptionResult}");
    print("Created By Id adalah : ${created_by_idResult}");
    print("Created adalah : ${createdResult}");

    // token = json.decode(response.body);
    // print("tokennya adalah : ${_idToken}");

    notifyListeners();

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.setString('token', token);
  }

  Future editBook(name, description, idBook, token) async {
    print(name);
    print(description);
    print(idBook);
    print(token);
    Uri url = Uri.parse('https://frntest.atmatech.id/books/' + idBook);
    var response = await http.put(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          // '_id': getRandomString(15),
          'name': name,
          'description': description,
          // 'created_by_id': idUser,
          // 'created': DateTime.now().toString()
        }));
    print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    String _idResult = data["_id"];
    String nameResult = data["name"];
    String descriptionResult = data["description"];
    String createdByIdResult = data["created_by_id"];
    String createdResult = data["created"];

    print("ID adalah : ${_idResult}");
    print("Name adalah : ${nameResult}");
    print("Description adalah : ${descriptionResult}");
    print("Created By Id adalah : ${createdByIdResult}");
    print("Created adalah : ${createdResult}");

    // token = json.decode(response.body);
    // print("tokennya adalah : ${_idToken}");

    notifyListeners();

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.setString('token', token);
  }

  
  

}
