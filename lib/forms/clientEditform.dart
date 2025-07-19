import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClientEditForm extends StatefulWidget {
  final Map? client;
  const ClientEditForm({super.key, this.client});

  @override
  State<ClientEditForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientEditForm> {
  final TextEditingController _tradeNameController = TextEditingController();

  final TextEditingController _firstController = TextEditingController();

  final TextEditingController _businessTypeController = TextEditingController();

  final TextEditingController _telNumberController = TextEditingController();

  final TextEditingController _streetAddController = TextEditingController();

  final TextEditingController _faxNumController = TextEditingController();

  final TextEditingController _postalAddController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final clients = widget.client;
    final tradename = clients?['tradeName'];
    final firstname = clients?['firstName'];
    final email = clients?['email'];
    final fax = clients?['fax'];
    final businessType = clients?['businessType'];
    final postal = clients?['postalAdd'];
    final tel = clients?['phone'];
    final add = clients?['streetAddress'];

    _tradeNameController.text = tradename;
    _firstController.text = firstname;
    _emailController.text = email;
    _faxNumController.text = fax;
    _businessTypeController.text = businessType;
    _postalAddController.text = postal;
    _telNumberController.text = tel;
    _streetAddController.text = add;
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
        title: Text('Clients'), // Set the title of the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Basic Client Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _tradeNameController,
                decoration: InputDecoration(
                  labelText: 'Trade Name',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _firstController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _telNumberController,
                decoration: InputDecoration(
                  labelText: 'Telephone Number',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _postalAddController,
                decoration: InputDecoration(
                  labelText: 'Postal Address',
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
                controller: _faxNumController,
                decoration: InputDecoration(
                  labelText: 'Fax Number',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _businessTypeController,
                decoration: InputDecoration(
                  labelText: 'Business Type',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _streetAddController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                ),
              ),
              SizedBox(height: 23),
              Text(
                'Trucks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(children: [
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [],
                  ),
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
    final clients = widget.client;
    final id = clients?['clientID'];
    final tradename = _tradeNameController.text;
    final email = _emailController.text;
    final firstname = _firstController.text;
    final businsstype = _businessTypeController.text;
    final streetadress = _streetAddController.text;
    final postal = _postalAddController.text;
    final tel = _telNumberController.text;
    final fax = _faxNumController.text;
    final user = "6pYUPX0qSV";
    final body = {
      // this is what the api is expecting
      "businessType": businsstype,
      "email": email,
      "streetAddress": streetadress,
      "phone": tel,
      "fax": fax,
      "tradeName": tradename,
      "firstName": firstname,
      "postalAdd": postal,
      "userID": user.toString()
    };
    print(body);
//submit data to the server
    final url = 'https://development.mbt.com.na:3001/client/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
//http.post(url)

//show success or fail message
    if (response.statusCode == 200) {
      print('Creation succes');
      showSuccessMessage('Client Updated');
    } else {
      showErrorMessage('Client Update Failed');
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
}
