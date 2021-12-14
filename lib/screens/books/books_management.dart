import 'dart:convert';
import 'package:bookapps/screens/books/editBook.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookManagement extends StatefulWidget {
  BookManagement({
    this.token,
  });
  final String token;

  @override
  _BookManagementState createState() => _BookManagementState();
}

class _BookManagementState extends State<BookManagement> {
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
  }

  @override
  Widget build(BuildContext context) {
    // final datauser = Provider.of<UserMe>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Management'),
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ListTile(
                          trailing: InkWell(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => new EditBook(

                                    token: widget.token,
                                    idBook: snapshot.data[index]['_id'],
                                    nameBook: snapshot.data[index]['name'],
                                    descriptionBook: snapshot.data[index]['description'],
                                  )));
                            },
                            child: Icon(Icons.edit)),
                          title: Text(snapshot.data[index]['name']),
                          subtitle: Text(snapshot.data[index]['description']),
                            ),
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
