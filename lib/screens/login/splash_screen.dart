import 'package:bookapps/Provider/userme.dart';
import 'package:bookapps/screens/adminScreen.dart';
import 'package:bookapps/screens/users/userScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({
    this.token,
  });
  final String token;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<UserMe>(context, listen: false).userMeData(widget.token);
    print("ini page book" + widget.token);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.deepOrange,
    ));
    return Consumer<UserMe>(
      builder: (context, userme, child) {
        Future.delayed(Duration(milliseconds: 2000), () {
          if (userme.isAdmin == "admin") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminScreen(token: widget.token)));
            
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => UserScreenUI(token: widget.token)));
          }
        });

        return Scaffold(
          appBar: AppBar(backgroundColor: Colors.white,
            elevation: 0,
          
          ),
          body: Center(child: Text("Loading...")));
      },
    );
  }
}
