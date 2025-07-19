import 'dart:convert';

import 'package:ctps_app/pages/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserSignUpForm extends StatefulWidget {
  @override
  State<UserSignUpForm> createState() => _UserSignUpFormState();
}

class _UserSignUpFormState extends State<UserSignUpForm> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _cellController = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    minimumSize: Size(double.infinity, 48.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('CTPS'), // Set the title of the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _cellController,
                decoration: InputDecoration(
                  labelText: 'Cellphone',
                ),
              ),
              SizedBox(height: 14),
              SizedBox(height: 23),
              Container(
                child: Column(children: [
                  SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          style: style,
                          onPressed: submitData,
                          child: const Text('Save')),
                    ],
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitData() async {
// get the data from form
    final username = _userNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final cell = _cellController.text;
    final validTo = '9999-12-12';
    final validFrom = '2022-05-17';
    final type = 'User';
    final body = {
      // this is what the api is expecting
      "username": username,
      "email": email,
      "password": password,
      "cell": cell,
      "validTo": validTo,
      "validFrom": validFrom,
      "userType": type
    };
//submit data to the server
    final url = 'http://burthiscity:3001/user';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
//http.post(url)

//show success or fail message
    if (response.statusCode == 201) {
      print('Creation succes');
      showSuccessMessage('Creation Succes');
      _completeLogin();
    } else {
      showErrorMessage('Creation failed');
      print(response.body);
    }
  }

  void _completeLogin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => LoginPage(),
      ),
    );
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
