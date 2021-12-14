import 'package:bookapps/Provider/auth.dart';
import 'package:bookapps/Provider/books.dart';
import 'package:bookapps/Provider/products.dart';
import 'package:bookapps/Provider/userme.dart';
import 'package:bookapps/screens/login/login.dart';
import 'package:bookapps/screens/login/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (BuildContext context) => Auth(),),
    ChangeNotifierProvider(create: (BuildContext context) => UserMe(),),
    ChangeNotifierProvider(create: (BuildContext context) => Products(),),
    ChangeNotifierProvider(create: (BuildContext context) => BooksNotifier(),),

  ],
  builder: (context, child) => Consumer<Auth>(
    builder: (context, auth, child) =>
    
      MaterialApp(
          home: auth.isAuth ? SplashScreen(token: auth.token) : LoginScreen(), 
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
        ),
  ),
    );
  }
}
