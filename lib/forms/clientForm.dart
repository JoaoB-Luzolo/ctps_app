import 'dart:convert';

import 'package:ctps_app/pages/clientList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClientForm extends StatefulWidget {
  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final TextEditingController _tradeNameController = TextEditingController();

  final TextEditingController _firstController = TextEditingController();

  final TextEditingController _businessTypeController = TextEditingController();

  final TextEditingController _telNumberController = TextEditingController();

  final TextEditingController _streetAddController = TextEditingController();

  final TextEditingController _faxNumController = TextEditingController();

  final TextEditingController _postalAddController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    minimumSize: Size(double.infinity, 48.0),
  );

  String ttype = 'One Man Business';
  var titems = [
    'One Man Business',
    'International Tourist Service',
    'Occasional International Passenger Service',
    'Goods Transport',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _businessTypeController.text = "One Man Business";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Use Navigator to pop the current route and go back
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ClientScreen()));
          },
        ),
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
              Text(
                'Type of Transport: ',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                DropdownButtonFormField(
                  // Initial Value
                  value: ttype,
                  iconSize: 30,
                  isExpanded: true,
                  elevation: 8,
                  // hint: Text('Select'),
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange))),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: titems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      ttype = newValue!;
                      _businessTypeController.text = ttype.toString();
                      //  print(_transType.text);
                    });
                  },
                ),
              ]),
              // TextFormField(
              //   controller: _businessTypeController,
              //   decoration: InputDecoration(
              //     labelText: 'Business Type',
              //   ),
              // ),
              SizedBox(height: 14),
              TextFormField(
                controller: _streetAddController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                ),
              ),
              SizedBox(height: 23),
              // Text(
              //   'Trucks',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(children: [
                  SizedBox(
                    height: 5,
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
    final tradename = _tradeNameController.text;
    final email = _emailController.text;
    final firstname = _firstController.text;
    final businsstype = _businessTypeController.text;
    final streetadress = _streetAddController.text;
    final postal = _postalAddController.text;
    final tel = _telNumberController.text;
    final fax = _faxNumController.text;
    final user = "6mKae4rura";
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
    final url = 'https://development.mbt.com.na:3001/client';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
//http.post(url)

//show success or fail message
    if (response.statusCode == 201) {
      print('Creation succes');
      showSuccessMessage('Client Created');
      _completeCreation();

//response.body.clent.cliendid
    } else {
      showErrorMessage('Creation failed');
      print(response.body);
    }
  }

  void _completeCreation() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ClientScreen(),
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
