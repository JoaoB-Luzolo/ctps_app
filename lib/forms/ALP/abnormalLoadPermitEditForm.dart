import 'package:ctps_app/pages/homeScreen.dart';
//import 'package:ctps/components/truckSelectDropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

//import '../components/clientSelectDropdDown.dart';

class AbnormalLoadPermitEditForm extends StatefulWidget {
  const AbnormalLoadPermitEditForm({super.key, required this.alp});
  final Map? alp;
  @override
  State<AbnormalLoadPermitEditForm> createState() =>
      _AbnormalLoadPermitEditFormState();
}

class _AbnormalLoadPermitEditFormState
    extends State<AbnormalLoadPermitEditForm> {
  final TextEditingController _loadDetail = TextEditingController();
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
    getAllClients();
    hi = DateTime.now();
    print(hi);
    // getTrucks();

    final alp = widget.alp;
    final loadDetail = alp?['loadDetail'];

    _loadDetail.text = loadDetail;
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
  String ser = 'Yes';

  // List of items in our dropdown menu
  var service = [
    'Yes',
    'No',
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
        title: Text(
            'Abnormal Load/Vehicle Permit Form'), // Set the title of the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Application For Abnormal Load/Vehicle Permit: Horse/Trailer',
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
                  labelText: 'Permit Number',
                ),
              ),
              SizedBox(height: 14),
              SizedBox(
                height: 8,
              ),
              Text(
                'Select Client: ',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                DropdownButton(
                  // Initial Value

                  iconSize: 30,
                  isExpanded: true,
                  elevation: 8,
                  // hint: Text('Select'),

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  items: clientdata.map((e) {
                    return DropdownMenuItem(
                      value: e['clientID'].toString(),
                      child: Text(e['tradeName'].toString()),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      dropdownvalue = val!;
                      //print(dropdownvalue);
                      getTrucks(dropdownvalue);

                      _Selclient.text = dropdownvalue.toString();
                      //  filterTrucks(_Selclient.text);
                      //  clientBasedonTruck(_Selclient.text);
                      //print(Selclient.text);
                    });
                  },
                  value: dropdownvalue,
                ),
              ]),
              SizedBox(
                height: 9,
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _loadDetail,
                decoration: InputDecoration(
                  labelText: 'Details of Load',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _itendNum,
                decoration: InputDecoration(
                  labelText: 'Length mm',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _loadDetail,
                decoration: InputDecoration(
                  labelText: 'Width mm',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _ReqPeriod,
                decoration: InputDecoration(
                  labelText: 'Height mm',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _originCountry,
                decoration: InputDecoration(
                  labelText: 'Mass Kg',
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _transitCountry,
                decoration: InputDecoration(
                  labelText: 'Has any portion of the load been removed?',
                ),
              ),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Details of abnormal vehicle and/or loaded vehcile combination',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  'Furnish vehicle combination identification (Registration and/or A.V numbers)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 18),
              Center(
                child: Text(
                  'Abnormal vehicle registraion number (choice of two)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Abnormal Vehicle Registration Number 1',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Abnormal Vehicle Registration Number 2',
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                child: Text(
                  'Registration Numbers',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Truck - tractor or Single vehicle',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Semi - trailer/Trailer',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Other(Specify)',
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                child: Text(
                  'Complete',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Total length mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Total width mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Total height mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Wheelbase mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Front overhang mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Rear overhang mm',
                ),
              ),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Front Load Projection',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Projection mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Height mm',
                ),
              ),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Rear Load Projection',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Projection mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Height mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Aprox C.G from kingpin mm',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Total laden mass Kg',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Total number of axles',
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Center(
                child: Text(
                  'Clear height under projection (If earthmoving or mobile equipment indicate clear height under overhang here)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Height',
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Does the laden axle mass comply with regulation 102',
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
                  'Route Details',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Route',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Trip distance',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'No. of Trips',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Total distance',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Exemption required from :',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'From date',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'From To date',
                ),
              ),
              TextFormField(
                controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'and/or No of days',
                ),
              ),
              SizedBox(height: 14),
              SizedBox(height: 14),
              SizedBox(height: 8),
              Text(
                'I certifiy that the details given above and on the attached sketch are correct in all respects, and undertake to ensure that the prescribed conditions are strictly adhered to. ',
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
              SizedBox(
                height: 14,
              ),
              Container(
                child: Column(children: [
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
    final id = _itendNum.text;
    final docAdd = "Hey";

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
    final appComment = _DocAdress.text; // addres where documents must be served
    final destPoint = _DestPost.text;
    final dec = _declaration.text;
    final client = _Selclient.text;
    final truck = _Seltruck.text;

    final body = {
      "name": "Krush Logistics",
      "extension": "3",
      "loadDetail": "Gold",
      "length": "15 m",
      "width": "12 m",
      "telephone": "+264612789562",
      "mass": "1 ton",
      "abnormalVehicleRegNo": "Normal",
      "abnormalVehicleRegType": "Normal",
      "height": "20 m",
      "totalWidth": "250 m",
      "totalHeight": "350 m",
      "wheelBase": "17",
      "frontOverhang": "0",
      "rearOverhang": "0",
      "frontLoadProjection": "50 m",
      "attachment": "yes",
      "rearLoadProjection": "80 m",
      "rearLoadProjectionHeight": "120 m",
      "frontLoadProjectionHeight": "250 m",
      "approxCGFromKingpin": "5",
      "totalLadenMass": "1 ton",
      "totalLength": "150 m",
      "totalNoOfAxles": "40",
      "axlesMassComply": "17",
      "permitTypeDistance": "long",
      "permitTypeAreaPeriod": "3",
      "clearHeightUnderProjection": "15 m",
      "tripDistance": "750 km",
      "totalDistance": "1500 km",
      "noOfTrips": "2",
      "operationArea": "Namibia",
      "exceptionFromDate": "2023-07-06",
      "exceptionToDate": "2023-07-08",
      "noOfDas": "3",
      "applicationDate": "2023-07-05",
      "route": "Mariantal To Oshakati",
      "archived": "false",
      "clientID": "vncElYUy4o",
      "truckID": "2Gtp4xmO3q"
    };

    //submit data to the server
    final url = 'https://development.mbt.com.na:3001/alp';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //show success or fail message
    if (response.statusCode == 201) {
      print('Creation succes');
      showSuccessMessage('Application Creation Success');
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
