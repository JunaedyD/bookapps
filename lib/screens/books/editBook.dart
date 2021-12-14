import 'dart:convert';
import 'package:bookapps/Provider/books.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditBook extends StatefulWidget {
  EditBook({this.idBook, this.token, this.nameBook, this.descriptionBook});
  final String token, idBook, nameBook, descriptionBook;

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String  _nameBook, _descBook;
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
    listData(widget.token);
    _nameBook = widget.nameBook;
    _descBook = widget.descriptionBook;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text('Edit Book'),
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
                          initialValue: _nameBook,
                          decoration: InputDecoration(labelText: "Book Name"),
                          keyboardType: TextInputType.text,
                          
                          onSaved: (value) {
                            _nameBook = value;
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
                          initialValue: _descBook,
                          maxLines: 3,
                          onSaved: (String value) {
                            _descBook = value;
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
                                label: Text('Edit')),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }

  Duration get durationTime => Duration(milliseconds: 2000);

  Future<String> _edit(namebook, descbook, idBook, token) {
    //print("email: " + email + ", password: " + password);
    return Future.delayed(durationTime).then((_) {
      Provider.of<BooksNotifier>(context, listen: false)
          .editBook(namebook, descbook, idBook, token);
      return null;
    });
  }

  Future<bool> validateAndSave() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _apiResponse =
          await _edit(_nameBook, _descBook, widget.idBook, widget.token);

      return true;
    }
    return false;
  }
}
