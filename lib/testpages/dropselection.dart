import 'package:flutter/material.dart';

// class MyDropdown extends StatefulWidget {
//   @override
//   _MyDropdownState createState() => _MyDropdownState();
// }

// class _MyDropdownState extends State<MyDropdown> {
//   List<bool> isChecked = [false, false, false, false, false, false];

//   String _selectedItem = 'Option 1'; // Initially selected value
//   Widget _content = Container(
//     padding: EdgeInsets.all(16.0),
//     child: Column(
//       children: [
//         Text('Hi there'),
//         Text('Hi there'),
//         Text('Hi there'),
//       ],
//     ),
//   ); // Content for the container

//   // Define a function to update the content based on the selected dropdown item
//   void _updateContent(String newItem) {
//     setState(() {
//       _selectedItem = newItem;
//       // Update the content based on the selected item
//       if (newItem == 'Option 1') {
//         _content = Container(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text('Hi there'),
//               Text('Hi there'),
//               Text('Hi there'),
//             ],
//           ),
//         );
//       } else if (newItem == 'Option 2') {
//         _content = Container(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text('Hi there 2'),
//               Text('Hi there 2'),
//               Text('Hi there 2'),
//             ],
//           ),
//         );
//       } else if (newItem == 'Option 3') {
//         _content = Container(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text('Hi there 3'),
//               Text('Hi there 3'),
//               Text('Hi there 3'),
//             ],
//           ),
//         );
//         ;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//         backgroundColor: Colors.orange,
//       ),
//       body: Column(
//         children: [
//           // DropdownButton widget to select an item
//           DropdownButton<String>(
//             value: _selectedItem,
//             onChanged: (String? newItem) {
//               _updateContent(newItem!);
//             },
//             items: <String>['Option 1', 'Option 2', 'Option 3']
//                 .map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//           // Container to display the selected content
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: _content,
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class CheckboxGrid extends StatefulWidget {
//   @override
//   _CheckboxGridState createState() => _CheckboxGridState();
// }

// class _CheckboxGridState extends State<CheckboxGrid> {
//   List<bool> isCheckedList = List.generate(12, (index) => false);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Checkbox Grid Example'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3, // Number of columns
//         ),
//         itemCount: 12, // Total number of checkboxes
//         itemBuilder: (context, index) {
//           return CheckboxListTile(
//             title: Text('Item ${index + 1}'),
//             value: isCheckedList[index],
//             onChanged: (value) {
//               setState(() {
//                 isCheckedList[index] = value!;
//               });
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class AxleWheelsSelection extends StatefulWidget {
//   @override
//   _AxleWheelsSelectionState createState() => _AxleWheelsSelectionState();
// }

// class _AxleWheelsSelectionState extends State<AxleWheelsSelection> {
//   // Number of axles for the truck
//   int numAxles = 8;

//   // List to store the selected number of wheels for each axle
//   List<int> selectedWheelsPerAxle = List.generate(8, (index) => 6);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Truck Axle Wheels Selection'),
//       ),
//       body: ListView.builder(
//         itemCount: numAxles,
//         itemBuilder: (context, index) {
//           final axleNumber = index + 1;
//           return ListTile(
//             title: Text('Axle $axleNumber'),
//             trailing: DropdownButton<int>(
//               value: selectedWheelsPerAxle[index],
//               onChanged: (int? newValue) {
//                 setState(() {
//                   selectedWheelsPerAxle[index] = newValue!;
//                 });
//               },
//               items: List.generate(7, (index) => index + 2) // Generate options for 4 to 10 wheels
//                   .map((int value) {
//                 return DropdownMenuItem<int>(
//                   value: value,
//                   child: Text('$value Wheels'),
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popup Example',
      home: PopupExample(),
    );
  }
}

class PopupExample extends StatelessWidget {
  void _showSecondPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Second Popup'),
          content: Text('You selected an option in the first popup.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the second popup
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFirstPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('First Popup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Option 1'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the first popup
                  _showSecondPopup(context); // Open the second popup
                },
              ),
              ListTile(
                title: Text('Option 2'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the first popup
                  // You can perform other actions for Option 2 here
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popup Example'),
      ),
      body: Center(
        child: Text('Click the Floating Action Button to open a popup.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFirstPopup(context); // Open the first popup
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
