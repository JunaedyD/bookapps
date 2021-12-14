import 'dart:convert';
import 'package:bookapps/Provider/books.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddBook extends StatefulWidget {
  AddBook({
    this.token,
    this.idUser,
  });
  final String token, idUser;

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String _username, _password;
  var _apiResponse;

  Future<dynamic> listData(token) async {
    Uri url = Uri.parse('https://frntest.atmatech.id/books?page=1&limit=10');
    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Book Response " + response.statusCode.toString());
    print("Total Book " + json.decode(response.body)['data'].length.toString());

    return json.decode(response.body)['data'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text('Add Book'),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            //autovalidate: true,
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          //key: Key("_input"),
                          decoration: InputDecoration(labelText: "Book Name"),
                          keyboardType: TextInputType.text,
                          //onSaved: (value) => requestModel.email = value,
                          onSaved: (value) {
                            _username = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Book Name is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Description"),
                          maxLines: 3,
                          //obscureText: true,
                          //onSaved: (value) => requestModel.password = value,
                          onSaved: (String value) {
                            _password = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10.0),
                        ButtonBar(
                          children: <Widget>[
                            RaisedButton.icon(
                                
                                onPressed: () {
                                  validateAndSave();
                                },
                                icon: Icon(Icons.save),
                                label: Text('Add')),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }

  Duration get loginTime => Duration(milliseconds: 2000);

  Future<String> _login(email, password, idUser, token) {
    //print("email: " + email + ", password: " + password);
    return Future.delayed(loginTime).then((_) {
      Provider.of<BooksNotifier>(context, listen: false).addBook(email, password, idUser, token);
      return null;
    });
  }

  Future<bool> validateAndSave() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _apiResponse = await _login(_username, _password, widget.idUser, widget.token);

     
      return true;
    }
    return false;
  }
}
