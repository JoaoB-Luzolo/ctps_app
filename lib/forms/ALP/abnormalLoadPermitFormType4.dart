import 'package:ctps_app/pages/homeScreen.dart';
//import 'package:ctps/components/truckSelectDropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

//import '../components/clientSelectDropdDown.dart';

class AbnormalLoadPermitFormType4 extends StatefulWidget {
  const AbnormalLoadPermitFormType4({
    super.key,
  });

  @override
  State<AbnormalLoadPermitFormType4> createState() =>
      _AbnormalLoadPermitViewState();
}

class _AbnormalLoadPermitViewState extends State<AbnormalLoadPermitFormType4> {
  final TextEditingController _declaration = TextEditingController();
  final TextEditingController _loadDetail = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _length = TextEditingController();
  final TextEditingController _width = TextEditingController();
  final TextEditingController _telephone = TextEditingController();
  final TextEditingController _mass = TextEditingController();
  final TextEditingController _abnormalVehicleRegNo = TextEditingController();
  final TextEditingController _abnormalVehicleRegType = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _totalWidth = TextEditingController();
  final TextEditingController _totalHeight = TextEditingController();
  final TextEditingController _wheelbase = TextEditingController();
  final TextEditingController _frontOverhang = TextEditingController();
  final TextEditingController _rearOverhang = TextEditingController();
  final TextEditingController _frontloadProjection = TextEditingController();
  final TextEditingController _attachement = TextEditingController();
  final TextEditingController _rearLoadProjection = TextEditingController();
  final TextEditingController _rearLoadProjetionHeight =
      TextEditingController();
  final TextEditingController _frontLoadProjectHeight = TextEditingController();
  final TextEditingController _approxCG = TextEditingController();
  final TextEditingController _totalLadenMass = TextEditingController();
  final TextEditingController _totalLength = TextEditingController();
  final TextEditingController _totalNoofAxles = TextEditingController();
  final TextEditingController _axlesMassComply = TextEditingController();
  final TextEditingController _Totaldistance = TextEditingController();
  final TextEditingController _Tripdistance = TextEditingController();
  final TextEditingController _noOfTrips = TextEditingController();
  final TextEditingController _oparationArea = TextEditingController();
  final TextEditingController _exemptionFromDate = TextEditingController();
  final TextEditingController _exemtionToDate = TextEditingController();
  final TextEditingController _noOfdays = TextEditingController();
  final TextEditingController _applicationDate = TextEditingController();
  final TextEditingController _route = TextEditingController();
  final TextEditingController _archived = TextEditingController();

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

  // Number of axles for the truck
  int numAxles = 9;

  // List to store the selected number of wheels for each axle
  List<int> selectedWheelsPerAxle = List.generate(10, (index) => 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
            'Abnormal Load/Vehicle Permit Type 4'), // Set the title of the AppBar
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
                // controller: _,
                decoration: InputDecoration(
                  labelText: 'Permit ss Number',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 187, 114, 4))),
                ),
              ),
              SizedBox(height: 14),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Name Of Carriers',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              TextFormField(
                controller: _telephone,
                decoration: InputDecoration(
                  labelText: 'Telephone Number',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
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
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _length,
                decoration: InputDecoration(
                  labelText: 'Length mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _width,
                decoration: InputDecoration(
                  labelText: 'Width mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _height,
                decoration: InputDecoration(
                  labelText: 'Height mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _mass,
                decoration: InputDecoration(
                  labelText: 'Mass Kg',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                // controller: _,
                decoration: InputDecoration(
                  labelText: 'Has any portion of the load been removed?',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
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
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _abnormalVehicleRegNo,
                decoration: InputDecoration(
                  labelText: 'Abnormal Vehicle Registration Number 1',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              TextFormField(
                controller: _abnormalVehicleRegType,
                decoration: InputDecoration(
                  labelText: 'Abnormal Vehicle Registration Number 2',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
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
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // controller: ,
                decoration: InputDecoration(
                  labelText: 'Truck - tractor or Single vehicle',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                // controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Semi - trailer/Trailer',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                // controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Other(Specify)',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
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
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _totalLength,
                decoration: InputDecoration(
                  labelText: 'Total length mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _totalWidth,
                decoration: InputDecoration(
                  labelText: 'Total width mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _totalHeight,
                decoration: InputDecoration(
                  labelText: 'Total height mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _wheelbase,
                decoration: InputDecoration(
                  labelText: 'Wheelbase mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _frontOverhang,
                decoration: InputDecoration(
                  labelText: 'Front overhang mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _rearOverhang,
                decoration: InputDecoration(
                  labelText: 'Rear overhang mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Front Load Projection',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _frontloadProjection,
                decoration: InputDecoration(
                  labelText: 'Projection mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _frontLoadProjectHeight,
                decoration: InputDecoration(
                  labelText: 'Height mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              Center(
                child: Text(
                  'Rear Load Projection',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _rearLoadProjection,
                decoration: InputDecoration(
                  labelText: 'Projection mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _rearLoadProjetionHeight,
                decoration: InputDecoration(
                  labelText: 'Height mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _approxCG,
                decoration: InputDecoration(
                  labelText: 'Aprox C.G from kingpin mm',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _totalLadenMass,
                decoration: InputDecoration(
                  labelText: 'Total laden mass Kg',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _totalNoofAxles,
                decoration: InputDecoration(
                  labelText: 'Total number of axles',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
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
              SizedBox(
                height: 12,
              ),
              TextFormField(
                // controller: _destCountry,
                decoration: InputDecoration(
                  labelText: 'Height',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
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
                      _axlesMassComply.text = ser;
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
              SizedBox(height: 14),
              TextFormField(
                controller: _route,
                decoration: InputDecoration(
                  labelText: 'Route',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _Tripdistance,
                decoration: InputDecoration(
                  labelText: 'Trip distance',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _noOfTrips,
                decoration: InputDecoration(
                  labelText: 'No. of Trips',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _Totaldistance,
                decoration: InputDecoration(
                  labelText: 'Total distance',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
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
                controller: _exemptionFromDate,
                decoration: InputDecoration(
                  labelText: 'From date',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _exemtionToDate,
                decoration: InputDecoration(
                  labelText: 'From To date',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _noOfdays,
                decoration: InputDecoration(
                  labelText: 'and/or No of days',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 14),
              SizedBox(height: 14),
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Sketch of Abnormal Vehicle Type 4',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Image.asset(
                'lib/images/truck4.png',
                color: Color.fromARGB(255, 247, 247, 247),
                colorBlendMode: BlendMode.darken,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 7,
              ),
              Image.asset(
                'lib/images/truck4bottom.png',
                color: Color.fromARGB(255, 247, 247, 247),
                colorBlendMode: BlendMode.darken,
                fit: BoxFit.fitWidth,
              ),
              Container(
                child: ListView.builder(
                  // scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: numAxles,
                  itemBuilder: (context, index) {
                    final axleNumber = index + 1;
                    return ListTile(
                      title: Text('Axle $axleNumber'),
                      trailing: DropdownButton<int>(
                        value: selectedWheelsPerAxle[index],
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedWheelsPerAxle[index] = newValue!;
                          });
                        },
                        items: List.generate(
                                7,
                                (index) =>
                                    index +
                                    2) // Generate options for 4 to 10 wheels
                            .map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value Wheels'),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 12,
              ),
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
              Column(
                children: [
                  ElevatedButton(
                      style: style,
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          final filePath = result.files.single.path;
                          print("Selected file path: $filePath");
                          //uploadFile(filePath!);
                        } else {
                          print("No file selected");
                          return;
                        }
                      },
                      child: const Text('Upload Documents')),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Column(
                children: [
                  ElevatedButton(
                      style: style,
                      onPressed: () {},
                      child: const Text('Save')),
                ],
              )
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
