import 'dart:convert';
import 'package:bookapps/screens/users/editUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserManagement extends StatefulWidget {
  UserManagement({
    this.token,
  });
  final String token;

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
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

    print("Users Response " + response.statusCode.toString());
    print("Total Users " + json.decode(response.body)['data'].length.toString());

    return json.decode(response.body)['data'];
  }

  @override
  void initState() {
    super.initState();
    listData(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    // final datauser = Provider.of<UserMe>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: listData(widget.token),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      trailing: InkWell(
                        onTap: () {
                           Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new EditUser(

                                  token: widget.token,
                                  idUser: snapshot.data[index]['_id'],
                                  username: snapshot.data[index]['username'],
                                  role: snapshot.data[index]['role'],
                                )));
                        },
                        child: Icon(Icons.edit)),
                      title: Text(snapshot.data[index]['username']),
                      subtitle: Text(snapshot.data[index]['email']),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
