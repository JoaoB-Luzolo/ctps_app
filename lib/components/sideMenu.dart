import 'package:flutter/material.dart';

class SideMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Side Menu'),
      ),
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Container(
              color:
                  Colors.white, // Change this to your desired background color
              child: Center(
                child: Text('Main Content'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Adjust the width of the side menu as needed
      color: Colors.grey[200], // Change this to your desired background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20), // Add some spacing at the top
          Text(
            'Option 1',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10), // Add some spacing between options
          Text(
            'Option 2',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10), // Add some spacing between options
          Text(
            'Option 3',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
