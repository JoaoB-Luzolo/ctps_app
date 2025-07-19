import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DropDown extends StatefulWidget {
  final Function(String) onSelected;
  const DropDown({Key? key, required this.onSelected}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DropDown> {
  // Initial Selected Value

  // Initial Selected Value
  List clientdata = [];
  // int _value = 1;

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

  Future getTrucks(id) async {
    print(id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllClients();
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
          });
        },
        value: dropdownvalue,
      ),
    ]);
  }
}
