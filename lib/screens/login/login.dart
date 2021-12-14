import 'package:bookapps/Provider/auth.dart';
import 'package:bookapps/models/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var _apiResponse;
  LoginRequestModel requestModel;

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            
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
                          decoration: InputDecoration(labelText: "Input"),
                          keyboardType: TextInputType.text,
                          onSaved: (value) => requestModel.email = value,
                          // onSaved: (value) {
                          //   _username = value;
                          // },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Password"),
                          obscureText: true,
                          onSaved: (value) => requestModel.password = value,
                          // onSaved: (String value) {
                          //   _password = value;
                          // },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ButtonBar(
                          children: <Widget>[
                            RaisedButton.icon(
                                //onPressed: () {},
                                onPressed: () {
                                  validateAndSave();
                                  
                                },
                                icon: Icon(Icons.arrow_forward),
                                label: Text('Sign in')),
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

  Future<String> _login(email, password) {
    //print("email: " + email + ", password: " + password);
    return Future.delayed(loginTime).then((_) {
      Provider.of<Auth>(context, listen: false).logIn(email, password);
      return null;
    });
  }

  Future<bool> validateAndSave() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _apiResponse = await _login(requestModel.email, requestModel.password);

     
      return true;
    }
    return false;
  }


}
