import 'package:flutter/material.dart';

class ServiceFrequencyDropDown extends StatefulWidget {
  const ServiceFrequencyDropDown({Key? key}) : super(key: key);

  @override
  _ServiceFrequencyDropDown createState() => _ServiceFrequencyDropDown();
}

class _ServiceFrequencyDropDown extends State<ServiceFrequencyDropDown> {
  // Initial Selected Value
  String ser = 'Daily';

  // List of items in our dropdown menu
  var service = [
    'Daily',
    'Bi-Weekly',
    'Fortbightly',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          });
        },
      ),
    ]);
  }
}
