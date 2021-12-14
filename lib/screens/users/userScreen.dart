// import 'package:bookapps/Provider/books.dart';
// import 'package:bookapps/widget/productitem.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class UserScreenUI extends StatefulWidget {
//   UserScreenUI({
//     this.token,
//   });
//   final String token;

//   @override
//   _UserScreenUIState createState() => _UserScreenUIState();
// }

// class _UserScreenUIState extends State<UserScreenUI> {
//   bool isInit = true;
//   bool isLoading = false;

//   @override
//   void didChangeDependencies() {
//     if (isInit) {
//       isLoading = true;
//       Provider.of<BooksNotifier>(context, listen: false)
//           .inisialData(widget.token)
//           .then((value) {
//         setState(() {
//           isLoading = false;
//         });
//       }).catchError(
//         (err) {
//           print(err);
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("Error Occured"),
//                 content: Text(err.toString()),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         isLoading = false;
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: Text("Okay"),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );

//       isInit = false;
//     }
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = Provider.of<BooksNotifier>(context);
//     print(prov.allBooks.length);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("All Products"),
//         // actions: [
//         //   IconButton(
//         //     icon: Icon(Icons.add),
//         //     onPressed: () => Navigator.pushNamed(context, AddProductPage.route),
//         //   ),
//         // ],
//       ),
//       body: (isLoading)
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : (prov.allProduct.length == 0)
//               ? Center(
//                   child: Text(
//                     "No Data",
//                     style: TextStyle(
//                       fontSize: 25,
//                     ),
//                   ),
//                 )
//               : ListView.builder(
//                   itemBuilder: (context, i) => ProductItem(
//                     prov.allProduct[i].id,
//                     prov.allProduct[i].name,
//                     prov.allProduct[i].description,
//                   ),
//                 ),
//     );
//   }
// }

import 'dart:convert';

import 'package:bookapps/Provider/userme.dart';
import 'package:bookapps/main.dart';
import 'package:bookapps/models/books.dart';
import 'package:bookapps/screens/books/addBook.dart';
import 'package:bookapps/screens/books/editBook.dart';
import 'package:bookapps/screens/users/editUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserScreenUI extends StatefulWidget {
  UserScreenUI({
    this.token,
  });
  final String token;

  @override
  _UserScreenUIState createState() => _UserScreenUIState();
}

class _UserScreenUIState extends State<UserScreenUI> {
  String idUser;
  var result = [];
  var _allBooks = [];
  Map<String, dynamic> map;
  int count = 0;
  List<Books> bookList = [];

  Future<dynamic> listData(token) async {
    print("Tokennya adalah " + widget.token);
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
  initState() {
    super.initState();

    final datauser = Provider.of<UserMe>(context);
    datauser.userMeData(widget.token);
    idUser = datauser.result.id;

    listData(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final datauser = Provider.of<UserMe>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("User Screen  "),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new EditUser(
                            token: widget.token,
                            idUser: datauser.result.id,
                            username: datauser.result.username,
                            role: datauser.result.role,
                          )));
                },
                child: Icon(Icons.edit))
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    Text(" Logout   "),
                  ],
                )),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "My Books",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 135,
                child: FutureBuilder<dynamic>(
                  future: listData(widget.token),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(10),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: ListTile(
                                trailing: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new EditBook(
                                                    token: widget.token,
                                                    idBook: snapshot.data[index]
                                                        ['_id'],
                                                    nameBook: snapshot
                                                        .data[index]['name'],
                                                    descriptionBook:
                                                        snapshot.data[index]
                                                            ['description'],
                                                  )));
                                    },
                                    child: Icon(Icons.edit)),
                                title: Text(snapshot.data[index]['name']),
                                subtitle:
                                    Text(snapshot.data[index]['description']),
                              ),
                            );
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 50),
            child: Container(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 40.0,
                //width: 100,
                child: new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                    child: new Text("Add Book",
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white)),
                    onPressed: () async {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => AddBook(
                                token: widget.token,
                                idUser: datauser.result.id,
                              )));
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
