import 'package:flutter/material.dart';

class TransportTypeDropDown extends StatefulWidget {
  const TransportTypeDropDown({Key? key}) : super(key: key);

  @override
  _TransportTypeDropDown createState() => _TransportTypeDropDown();
}

class _TransportTypeDropDown extends State<TransportTypeDropDown> {
  // Initial Selected Value
  String ttype = 'Regular Internation Passenger Vehicle';

  // List of items in our dropdown menu
  var titems = [
    'Regular Internation Passenger Vehicle',
    'International Tourist Service',
    'Occasional International Passenger Service',
    'Goods Transport',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          });
        },
      ),
    ]);
  }
}
