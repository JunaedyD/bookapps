import 'dart:convert';
import 'package:bookapps/Provider/userme.dart';
import 'package:bookapps/models/role.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditUser extends StatefulWidget {
  EditUser({this.idUser, this.token, this.username, this.role});
  final String token, idUser, username, role;

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String _username,
      _password,
      _passwordconfirm = "";
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

  String _currentRole;
  Role selectedRole;
  List<Role> roles = <Role>[
    const Role("member", '     Member'),
    const Role("admin", '     Admin'),
  ];

  @override
  void initState() {
    super.initState();
    listData(widget.token);
    _username = widget.username;  
    if (widget.role == 'admin') {
      _currentRole = "Admin";
      selectedRole = roles[1];
    } else if (widget.role == 'member') {
      _currentRole = "Member";
      selectedRole = roles[0];
    }
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
                          initialValue: _username,
                          decoration: InputDecoration(labelText: "Username"),
                          keyboardType: TextInputType.text,

                          onSaved: (value) {
                            _username = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Password"),
                          maxLines: 3,
                          onSaved: (String value) {
                            _password = value;
                          },
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Blank Password if not changing password';
                          //   }
                          //   return null;
                          // },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: "Confirm Password"),
                          maxLines: 3,
                          onSaved: (String value) {
                            _passwordconfirm = value;
                          },
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Re-type your password';
                          //   }
                          //   return null;
                          // },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text("Role"),
                              ),
                              Container(
                                  height: 40,
                                  width: 200,
                                  //color: Colors.red,
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.blue[200],
                                      border: Border.all()),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Role>(
                                        hint: Text("    " + _currentRole,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                        value: selectedRole,
                                        items: roles.map((Role role) {
                                          return DropdownMenuItem(
                                            child: Text(role.tampil,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                            value: role,
                                          );
                                        }).toList(),
                                        onChanged: (Role newvalue) {
                                          // _incrementCounter(
                                          //     newvalue.database);

                                          setState(() {
                                            selectedRole = newvalue;
                                            print("dipilih "+selectedRole
                                                .simpan); //Untuk memberitahu _valGender bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                          });
                                        }),
                                  )),
                            ],
                          ),
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

  Future<String> _edit(
      username, password, passwordconfirm, role, idUser, token) {
    //print("email: " + email + ", password: " + password);
    return Future.delayed(durationTime).then((_) {
      Provider.of<UserMe>(context, listen: false)
          .editUser(username, password, passwordconfirm, role, idUser, token);
      return null;
    });
  }

  Future<bool> validateAndSave() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_password == _passwordconfirm) {
        _apiResponse = await _edit(_username, _password, _passwordconfirm,
            selectedRole.simpan, widget.idUser, widget.token);
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
