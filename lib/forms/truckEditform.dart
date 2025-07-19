import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TruckEditForm extends StatefulWidget {
  final Map? truck;
  const TruckEditForm({super.key, this.truck});
  @override
  State<TruckEditForm> createState() => _TruckFormState();
}

class _TruckFormState extends State<TruckEditForm> {
  final TextEditingController _makeController = TextEditingController();

  final TextEditingController _manyearController = TextEditingController();

  final TextEditingController _maxpassController = TextEditingController();

  final TextEditingController _trucktypeController = TextEditingController();

  final TextEditingController _gvmController = TextEditingController();

  final TextEditingController _regisController = TextEditingController();

  final TextEditingController _chassisController = TextEditingController();

  final TextEditingController _tareController = TextEditingController();

  final TextEditingController _tyreSizeController = TextEditingController();

  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final trucks = widget.truck;
    final make = trucks?['make'];
    final manyear = trucks?['manuYear'];
    final maxpass = trucks?['maxPass'];
    final trucktype = trucks?['vehicleType'];
    final gvm = trucks?['gvm'];
    final regist = trucks?['regNumber'];
    final chassis = trucks?['chassisNo'];
    final tare = trucks?['tare'];
    final tyreSize = trucks?['tyreSize'];
    final status = trucks?['truckStatus'];

    _makeController.text = make;
    _manyearController.text = manyear;
    _maxpassController.text = maxpass;
    _trucktypeController.text = trucktype;
    _gvmController.text = gvm;
    _regisController.text = regist;
    _chassisController.text = chassis;
    _tareController.text = tare;
    _tyreSizeController.text = tyreSize;
    _statusController.text = status;
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
        title: Text('Trucks'), // Set the title of the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Truck Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _makeController,
                decoration: InputDecoration(
                  labelText: 'Make',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _manyearController,
                decoration: InputDecoration(
                  labelText: 'Manufacture Year',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _maxpassController,
                decoration: InputDecoration(
                  labelText: 'Max Passanger',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _gvmController,
                decoration: InputDecoration(
                  labelText: 'GVM',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _regisController,
                decoration: InputDecoration(
                  labelText: 'Registration Number',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _chassisController,
                decoration: InputDecoration(
                  labelText: 'Chassis No',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _tareController,
                decoration: InputDecoration(
                  labelText: 'Tare',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _trucktypeController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Type',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _tyreSizeController,
                decoration: InputDecoration(
                  labelText: 'Tyre Size',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Truck Status',
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

    final make = _makeController.text;
    final manyear = _manyearController.text;
    final maxpass = _maxpassController.text;
    final trucktype = _trucktypeController.text;
    final gvm = _gvmController.text;
    final regis = _regisController.text;
    final chassis = _chassisController.text;
    final tare = _tareController.text;
    final tyresize = _tyreSizeController.text;
    final status = _statusController.text;
    final trucks = widget.truck;
    final tradename = trucks?['clientID'];
    final id = trucks?['truckID'];
    final body = {
      // this is what the api is expecting

      "make": make,
      "manuYear": manyear,
      "maxPass": maxpass,
      "gvm": gvm,
      "regNumber": regis,
      "chassisNo": chassis,
      "tare": tare,
      "vehicleType": trucktype,
      "tyreSize": tyresize,
      "truckStatus": status,
      "clientID": tradename
    };
//submit data to the server
    final url = 'https://development.mbt.com.na:3001/truck/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
//http.post(url)

//show success or fail message
    if (response.statusCode == 200) {
      print('Truck creation success');
      showSuccessMessage('Truck Update Success');
      _completeCreation();
    } else if (response.statusCode == 400) {
      showErrorMessage('Truck Update failed');
      print(response.body);
    }
  }

  void _completeCreation() {
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
