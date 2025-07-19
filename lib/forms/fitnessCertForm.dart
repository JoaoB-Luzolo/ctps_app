import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FitnessForm extends StatefulWidget {
  final Map? truck;
  const FitnessForm({super.key, this.truck});
  @override
  State<FitnessForm> createState() => _FitnessFormState();
}

class _FitnessFormState extends State<FitnessForm> {
  var _date = 'No Date Selected';
  DateTime _dateTime = DateTime.now();
  final TextEditingController _expDate = TextEditingController();

  final TextEditingController _valid = TextEditingController();

  final TextEditingController _certNo = TextEditingController();

  final TextEditingController _truckID = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    minimumSize: Size(double.infinity, 48.0),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final trucks = widget.truck;
    final id = trucks?['truckID'];

    _truckID.text = id;
  }

  final ButtonStyle style2 = ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      // minimumSize: Size(double.infinity, 18.0),
      padding: EdgeInsets.all(10));

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2040))
        .then((value) {
      setState(() {
        _dateTime = value!;
        _date = DateFormat('yyyy-MM-dd').format(_dateTime);
        print(_date);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Fitness Certification'), // Set the title of the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            //  crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Fitness Certificate Details',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  ElevatedButton(
                      style: style2,
                      onPressed: _showDatePicker,
                      child: const Text(
                        'Choose Date',
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Expiry Date :  ${_date.toString()}',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _certNo,
                decoration: InputDecoration(
                  labelText: 'Fitness Certificate Number',
                ),
              ),
              SizedBox(height: 14),
              SizedBox(height: 23),
              Container(
                child: Column(children: [
                  SizedBox(
                    height: 50,
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
    final expdate = _date.toString();
    final certNo = _certNo.text;
    final valid = 'valid';

    final truck = _truckID.text;
    final body = {
      // this is what the api is expecting
      "certFitExpDate": expdate,
      "validity": valid,
      "certFitNo": certNo,
      "truckID": truck
    };
//submit data to the server
    final url = 'https://development.mbt.com.na:3001/fitness';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
//http.post(url)

//show success or fail message
    if (response.statusCode == 201) {
      print('Fitness Certificate Created');
      showSuccessMessage('Fitness Certificate Created');
      _completeLogin();
    } else {
      showErrorMessage('Fitness Certificate Failed');
      print(response.body);
    }
  }

  void _completeLogin() {
    Navigator.pop(context);
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
