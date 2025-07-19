import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TruckSelect extends StatefulWidget {
  const TruckSelect({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TruckSelect> {
  // Initial Selected Value

  // Initial Selected Value
  List truckdata = [];
  // int _value = 1;

  Future getTrucks() async {
    var baseUrl = 'https://development.mbt.com.na:3001/truck';

    http.Response res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      setState(() {
        truckdata = jsonData;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrucks();
  }

  // List of items in our dropdown menu
  String? dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      DropdownButton(
        // Initial Value

        iconSize: 30,
        isExpanded: true,
        elevation: 8,
        // hint: Text('Select'),

        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        // // Array list of items
        // items: items.map((items) {
        //   return DropdownMenuItem(
        //     value: items,
        //     child: Text(items),
        //   );
        // }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        items: truckdata.map((e) {
          return DropdownMenuItem(
            value: e['truckID'].toString(),
            child: Text(e['make'].toString()),
          );
        }).toList(),
        onChanged: (String? val) {
          setState(() {
            dropdownvalue = val!;
          });
        },
        value: dropdownvalue,
      ),
    ]);
  }
}
