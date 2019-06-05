import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:liftu/user.dart';
//import 'package:liftu/Checkout.dart';
import 'package:liftu/homeScreen.dart';
import 'package:liftu/global.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';

void main() => runApp(new MaterialApp(
  title: 'Forms in Flutter',
  home: new loginPage(),
));

class loginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _loginPageState();
}

class _loginData {
  String email = '';
  String password = '';
}

class _loginPageState extends State<loginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _loginData _data = new _loginData();

  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 3) {
      return 'The Password must be at least 8 characters.';
    }

    return null;
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      fetchData();
    }
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid username or password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  fetchData()async {
    var dio = new Dio();

    FormData formData = new FormData.from({
      "email": '${_data.email}',
      "password": '${_data.password}'
    });

    //Response response = await dio.post("/token", data: formData);
    Response response = await dio.post(baseUrl + "/auth/mobile_login", data: formData);
//    Map userMap = json.decode(response.data);
//    print("***********************************************************************************");
//
//    print(response.data);
//    print("***********************************************************************************");
    print("test");
    print(response.data);
//    print("!!!!!!");
//
//    print(json.decode(response.data));
//    print("!!!!!!");

    print(baseUrl + "/auth/mobile_login");
    var currentUser = new user.fromJson(response.data);
    if(currentUser.id == 0){
      print("Invalid username or password");
      _neverSatisfied();
    } else {
      final prefs = await SharedPreferences.getInstance();

// set value

      prefs.setInt('employeeId', currentUser.id);
      final counter = prefs.getInt('employeeId') ?? 0;

      print('Howdy, $counter');
      Navigator.push(

        context,
        MaterialPageRoute(builder: (context) => homeScreen()),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
      ),

      body: new Container(

          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'you@example.com',
                        labelText: 'E-mail Address'
                    ),
                    validator: this._validateEmail,
                    onSaved: (String value) {
                      this._data.email = value;
                    }
                ),
                new TextFormField(
                    obscureText: true, // Use secure text for passwords.
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        labelText: 'Enter your password'
                    ),
                    validator: this._validatePassword,
                    onSaved: (String value) {
                      this._data.password = value;
                    }
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Login',
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: this.submit,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(
                      top: 20.0
                  ),
                )
              ],
            ),
          )

      ),
    );

  }
}

