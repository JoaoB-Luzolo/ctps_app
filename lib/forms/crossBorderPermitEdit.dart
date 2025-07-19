import 'package:ctps_app/pages/homeScreen.dart';
//import 'package:ctps/components/truckSelectDropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

//import '../components/clientSelectDropdDown.dart';

class CrossBorderPermitEditForm extends StatefulWidget {
  final Map? cbp;
  const CrossBorderPermitEditForm({super.key, this.cbp});
  @override
  State<CrossBorderPermitEditForm> createState() =>
      _CrossBorderPermitEditFormState();
}

class _CrossBorderPermitEditFormState extends State<CrossBorderPermitEditForm> {
  final TextEditingController _NumofJourny = TextEditingController();
  final TextEditingController _ReqPeriod = TextEditingController();
  final TextEditingController _originCountry = TextEditingController();
  final TextEditingController _transitCountry = TextEditingController();
  final TextEditingController _destCountry = TextEditingController();
  final TextEditingController _DepartureP = TextEditingController();
  final TextEditingController _IntePoint1 = TextEditingController();
  final TextEditingController _IntePoint2 = TextEditingController();
  final TextEditingController _IntePoint3 = TextEditingController();
  final TextEditingController _IntePoint4 = TextEditingController();
  final TextEditingController _borderPost = TextEditingController();
  final TextEditingController _Inte2Point1 = TextEditingController();
  final TextEditingController _Inte2Point2 = TextEditingController();
  final TextEditingController _Inte2Point3 = TextEditingController();
  final TextEditingController _Inte2Point4 = TextEditingController();
  final TextEditingController _DestPost = TextEditingController();
  final TextEditingController _Selclient = TextEditingController();
  final TextEditingController _Seltruck = TextEditingController();
  final TextEditingController _transType = TextEditingController();
  final TextEditingController _archive = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _serviceFreq = TextEditingController();
  final TextEditingController _itendNum = TextEditingController();
  final TextEditingController _DocAdress = TextEditingController();
  final TextEditingController _declaration = TextEditingController();
  final TextEditingController _clientSelected = TextEditingController();
  final TextEditingController _clientID = TextEditingController();
  final TextEditingController _truckID = TextEditingController();
  final TextEditingController _truckName = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    minimumSize: Size(double.infinity, 48.0),
  );
  List clientdata = [];
  List truckdata = [];

  Future getAllClients() async {
    var baseUrl = 'https://development.mbt.com.na:3001/client';

    http.Response res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      setState(() {
        clientdata = jsonData;
      });
    }
  }

  // fetchtrucks() async {
  // var response = await Dio().get('https://development.mbt.com.na:3001/truck');
  // return response.data;
  //}

  // void filterTrucks(SelectedClient) {
  //   final client = fetchtrucks();
  //   final trucks = client?['clientID'];
  // _filteredTrucks =
  //      truckdata.where((truck) => truck['clientID'] == trucks).toList();
  //}

  Future getTrucks(selectedClientID) async {
    var baseUrl =
        'https://development.mbt.com.na:3001/truck/client/$selectedClientID';

    http.Response res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      setState(() {
        truckdata.clear();
        truckdata = jsonData;
        //String t = jsonData[0]['make'];
        print(truckdata);
      });
    } else if (truckdata.isEmpty) {
      showErrorMessage('No trucks for selected client');
    }
  }

  var hi;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  getAllClients();
    hi = DateTime.now();
    print(hi);
    // getTrucks();
    final cbp = widget.cbp;
    final identNUm = cbp?['identityNumber'];
    final numofJourney = cbp?['noOfJourneys'];
    final originCountry = cbp?['OriginCountry'];
    final transitC = cbp?['transitCountry'];
    final destCountry = cbp?['destCountry'];
    final departp = cbp?['departurePoint'];
    final transType = cbp?['transportType'];
    final intP1 = cbp?['depintermediatePoints1'];
    final intP2 = cbp?['depintermediatePoints2'];
    final intP3 = cbp?['depintermediatePoints3'];
    final intP4 = cbp?['depintermediatePoints4'];
    final int2P1 = cbp?['desintermediatePoints1'];
    final int2P2 = cbp?['desintermediatePoints2'];
    final int2P3 = cbp?['desintermediatePoints3'];
    final int2P4 = cbp?['desintermediatePoints4'];
    final periodStart = cbp?['periodStart'];
    final serviceFreq = cbp?['serviceFreq'];
    final destP = cbp?['destinationPoint'];
    final clientTradeName = cbp?['Client']['tradeName'];
    final clientID = cbp?['clientID'];
    final truckName = cbp?['Truck']['make'];
    final truckID = cbp?['truckID'];
    final borderP = cbp?['borderPost'];

    _itendNum.text = identNUm;
    _NumofJourny.text = numofJourney;
    _originCountry.text = originCountry;
    _transitCountry.text = transitC;
    _destCountry.text = destCountry;
    _DepartureP.text = departp;
    _transType.text = transType;
    _IntePoint1.text = intP1;
    _IntePoint2.text = intP2;
    _IntePoint3.text = intP3;
    _IntePoint4.text = intP4;
    _Inte2Point1.text = int2P1;
    _Inte2Point2.text = int2P2;
    _Inte2Point3.text = int2P3;
    _Inte2Point4.text = int2P4;
    _ReqPeriod.text = periodStart;
    _serviceFreq.text = serviceFreq;
    _DestPost.text = destP;
    _clientSelected.text = clientTradeName;
    _clientID.text = clientID;
    _truckID.text = truckID;
    _truckName.text = truckName;
    _borderPost.text = borderP;
  }

  String addressType = 'Postal Address';

  var addressTypes = ['Street Address'];

  String ttype = 'Regular Internation Passenger Vehicle';
  var titems = [
    'Regular Internation Passenger Vehicle',
    'International Tourist Service',
    'Occasional International Passenger Service',
    'Goods Transport',
  ];

  // Initial Selected Value
  String ser = 'Daily';

  // List of items in our dropdown menu
  var service = [
    'Daily',
    'Bi-Weekly',
    'Fortbightly',
    'Other',
  ];

  String iniaddr = 'Postal Address';

  var addr = ['Postal Address', 'Street Address'];

  String? dropdownvalue;
  String? dropdownval;
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Cross Border Permit Form'), // Set the title of the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Application For Cross Border Permit',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 14),
              Image.asset(
                'lib/images/Coat.png',
                height: 100,
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _itendNum,
                decoration: InputDecoration(
                  labelText: 'Identity Number / register nr of body',
                ),
              ),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Part A',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                ' Client: ',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              TextFormField(
                controller: _clientSelected,
                enabled: false,
                decoration: InputDecoration(
                    //  labelText: 'Required for period starting',
                    ),
              ),
              SizedBox(
                height: 9,
              ),
              Center(
                child: Text(
                  'Part B ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Address where offical documentation must be served: ',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                DropdownButton(
                  // Initial Value
                  value: addressType,
                  iconSize: 30,
                  isExpanded: true,
                  elevation: 8,
                  // hint: Text('Select'),

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addr.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      addressType = newValue!;
                      _DocAdress.text = addressType.toString();
                      //  print(_DocAdress.text);
                    });
                  },
                ),
              ]),
              SizedBox(
                height: 8,
              ),
              Text(
                'Type of Transport: ',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                DropdownButton(
                  // Initial Value
                  value: ttype,
                  iconSize: 30,
                  isExpanded: true,
                  elevation: 8,
                  // hint: Text('Select'),

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
                      _transType.text = ttype.toString();
                      //  print(_transType.text);
                    });
                  },
                ),
              ]),
              SizedBox(height: 14),
              TextFormField(
                controller: _NumofJourny,
                decoration: InputDecoration(
                  labelText: 'Number of Journeys',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _ReqPeriod,
                decoration: InputDecoration(
                  labelText: 'Required for period starting',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _originCountry,
                decoration: InputDecoration(
                  labelText: 'Country of Origin',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _transitCountry,
                decoration: InputDecoration(
                  labelText: 'Transit Country',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Country of destination',
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Service Frequency: ',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                DropdownButton(
                  // Initial Value
                  value: ser,
                  iconSize: 30,
                  isExpanded: true,
                  elevation: 8,
                  // hint: Text('Select'),

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: service.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      ser = newValue!;
                      _serviceFreq.text = ser;
                      //   print(_serviceFreq.text);
                    });
                  },
                ),
              ]),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Declaration by carrier/ Representative: ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'In the carrier/ representative declare that all the particulars furnished by me in this form are true and correct ',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Checkbox(
                  value: isChecked,
                  activeColor: Colors.orange,
                  onChanged: (newbool) {
                    setState(() {
                      isChecked = newbool;

                      _declaration.text = newbool.toString();
                      //   print(_declaration.text);
                    });
                  }),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Part C: ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _DepartureP,
                decoration: InputDecoration(
                  labelText: 'Departure Point',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _IntePoint1,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Max of 4)',
                ),
              ),
              TextFormField(
                controller: _IntePoint2,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Point 2)',
                ),
              ),
              TextFormField(
                controller: _IntePoint3,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Point 3)',
                ),
              ),
              TextFormField(
                controller: _IntePoint4,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Point 4)',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _borderPost,
                decoration: InputDecoration(
                  labelText: 'Border Post',
                ),
              ),
              TextFormField(
                controller: _Inte2Point1,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Point 1)',
                ),
              ),
              TextFormField(
                controller: _Inte2Point2,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Point 2)',
                ),
              ),
              TextFormField(
                controller: _Inte2Point3,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Point 3)',
                ),
              ),
              TextFormField(
                controller: _Inte2Point4,
                decoration: InputDecoration(
                  labelText: 'Intermediate Points(Point 4)',
                ),
              ),
              SizedBox(
                height: 14,
              ),
              TextFormField(
                controller: _DestPost,
                decoration: InputDecoration(
                  labelText: 'Destination Post',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Part D: ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 23),
              Text(
                'Trucks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _truckName,
                enabled: false,
                decoration: InputDecoration(
                    //  labelText: 'Required for period starting',
                    ),
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
                    children: [
                      ElevatedButton(
                          style: style,
                          onPressed: () async {
                            final result =
                                await FilePicker.platform.pickFiles();
                            if (result == null) return;
                          },
                          child: const Text('Upload Documents')),
                    ],
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

  void clientBasedonTruck(client) {}
  void _completeCreation() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => HomeScreen(),
      ),
    );
  }

  Future<void> submitData() async {
    final cbp = widget.cbp;
    final id = cbp?['cbpPermitID'];
    final ident = _itendNum.text;
    final docAdd = _DocAdress.text;
    final numofjurney = _NumofJourny.text;
    //  final rePeriod = _ReqPeriod.text;
    final originC = _originCountry.text;
    final transitCountry = _transitCountry.text;
    final destCountry = _destCountry.text;
    final departp = _DepartureP.text;
    final transType = _transType.text;
    final status = "Active";
    final inteP1 = _IntePoint1.text;
    final inteP2 = _IntePoint2.text;
    final inteP3 = _IntePoint3.text;
    final inteP4 = _IntePoint4.text;
    final Border = _borderPost.text;
    final inte2P1 = _Inte2Point1.text;
    final inte2P2 = _Inte2Point2.text;
    final inte2P3 = _Inte2Point3.text;
    final inte2P4 = _Inte2Point4.text;
    // final selectClient = "Hey";
    // final SelectTruck = "Hey";
    final archive = "false";
    final attachment = "False";
    final periodStart = _ReqPeriod.text;
    final serviceFreq = _serviceFreq.text;
    final dateRec = "2023-07-06"; // office stuff
    final dateDis = "2023-07-06"; // office stuff
    final appComment = "Null"; // addres where documents must be served
    final destPoint = _DestPost.text;
    final dec = _declaration.text;
    final client = _clientID.text;
    final truck = _truckID.text;

    final body = {
      ""
          "identityNumber": ident,
      "docAddressChoice": docAdd.toString(),
      "transportType": transType.toString(),
      "cbpStatus": status.toString(),
      "noOfJourneys": numofjurney,
      "periodStart": periodStart,
      "transitCountry": transitCountry,
      "OriginCountry": originC,
      "serviceFreq": serviceFreq,
      "departurePoint": departp,
      "depintermediatePoints1": inteP1.toString(),
      "depintermediatePoints2": inteP2.toString(),
      "depintermediatePoints3": inteP3.toString(),
      "depintermediatePoints4": inteP4.toString(),
      "desintermediatePoints1": inte2P1.toString(),
      "desintermediatePoints2": inte2P2.toString(),
      "desintermediatePoints3": inte2P3.toString(),
      "desintermediatePoints4": inte2P4.toString(),
      "destCountry": destCountry,
      "borderPost": Border.toString(),
      "appComment": appComment.toString(),
      "dateReceived": dateRec.toString(),
      "dateDispatched": dateDis.toString(),
      "deceleration": dec.toString(),
      "attachment": attachment.toString(),
      "destinationPoint": destPoint.toString(),
      "archived": archive.toString(),
      "clientID": client.toString(),
      "truckID": truck.toString()
    };

    //submit data to the server
    final url = 'https://development.mbt.com.na:3001/cbp/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //show success or fail message
    if (response.statusCode == 200) {
      print('Creation succes');
      showSuccessMessage('Application Update Success');
      _completeCreation();
    } else {
      showErrorMessage('Application Creation failed');
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
