import 'package:bookapps/Provider/books.dart';
import 'package:bookapps/Provider/userme.dart';
import 'package:bookapps/main.dart';
import 'package:bookapps/models/books.dart';
import 'package:bookapps/models/userData.dart';
import 'package:bookapps/screens/books/books_management.dart';
import 'package:bookapps/screens/users/user_management.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({
    this.token,
  });
  final String token;

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Screen"),
        actions: [
          InkWell(
              onTap: () {
                 Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MyApp()));
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

      body: Container(
        child: ListView(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new UserManagement(
                            token: widget.token,
                          )));
                },
                child: Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30, top: 30, left: 0, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            
                            children: [
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      "Users",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  

                                  

                                  //   Padding(
                                  //   padding: const EdgeInsets.only(left: 10),
                                  //   child: Container(
                                  //     width: 200,
                                  //     //height: imageHeight,
                                  //     child: Text(jabatan.toString(),
                                  //         maxLines: 5,
                                  //         style: TextStyle(fontSize: 16)),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new BookManagement(
                            token: widget.token,
                          )));
                  
                },
                child: Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30, top: 30, left: 0, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            
                            children: [
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      "Books",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        
        ],),
      ),
    );
  }
}
