import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserEditForm extends StatefulWidget {
  final Map? user;
  const UserEditForm({super.key, this.user});

  @override
  State<UserEditForm> createState() => _UserSignUpFormState();
}

class _UserSignUpFormState extends State<UserEditForm> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _cellController = TextEditingController();

  final TextEditingController _userType = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final users = widget.user;
    final username = users?['username'];
    final email = users?['email'];
    final usertype = users?['userType'];
    final cell = users?['cell'];

    _userNameController.text = username;
    _emailController.text = email;
    _cellController.text = cell;
    _userType.text = usertype;
  }

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
                'Edit User',
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
                controller: _cellController,
                decoration: InputDecoration(
                  labelText: 'Cellphone',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _userType,
                decoration: InputDecoration(
                  labelText: 'User Type',
                ),
              ),
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
                          onPressed: updateData,
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

  Future<void> updateData() async {
    final users = widget.user;
    final id = users?['userID'];
    final username = _userNameController.text;
    final email = _emailController.text;

    final cell = _cellController.text;
    final validTo = '9999-12-12';
    final validFrom = '2022-05-17';
    final type = _userType.text;

    final body = {
      // this is what the api is expecting
      "username": username,
      "email": email,

      "cell": cell,
      "validTo": validTo,
      "validFrom": validFrom,
      "userType": type
    };

    final url = 'https://development.mbt.com.na:3001/user/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //show success or fail message
    if (response.statusCode == 200) {
      print('Creation succes');
      showSuccessMessage('User Update Succes');
      _completeCreation();
    } else {
      showErrorMessage('User Update failed');
      print(response.body);
    }
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

  void _completeCreation() {
    Navigator.pop(context);
  }
}
