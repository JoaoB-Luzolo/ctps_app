import 'dart:convert';

import 'package:ctps_app/forms/clientEditform.dart';
import 'package:ctps_app/forms/clientForm.dart';
import 'package:ctps_app/forms/truckForm.dart';
import 'package:ctps_app/pages/homeScreen.dart';
import 'package:ctps_app/pages/permitArchivesScreen.dart';
import 'package:ctps_app/pages/trucklist.dart';
import 'package:ctps_app/pages/userlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClientScreen extends StatefulWidget {
  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  List _client = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchclients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client List'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(children: [
            DrawerHeader(
              child: Image.asset(
                'lib/images/logo.png',
                height: 100,
              ),
            ),
            ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                onTap: () => {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      )
                    }),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.workspaces_outline),
              title: const Text("Permit Archives"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PermitArcScreen()),
                );
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text("Clients"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ClientScreen()),
                );
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text("Users"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserListScreen()),
                );
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            )
          ]),
        ),
      ),
      body: ListView.builder(
        itemCount: _client.length,
        itemBuilder: (context, index) {
          final clients = _client[index] as Map;
          final id = clients['clientID'];
          return Card(
            elevation: 8,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: const AssetImage('lib/images/trucklogo.png'),
                //  child: Text('${index + 1}'),
                //  backgroundColor: Colors.orange,
              ),
              title: Text(clients['tradeName']),
              isThreeLine: true,
              subtitle: Text(clients['email']),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    //open edit page
                    //navigateToEditPage(item);
                    navigateToEditPage(clients);
                  } else if (value == 'delete') {
                    //delete and remove the item
                    //  deleteByID(id);
                    deleteByID(id);
                  } else if (value == 'addvehicle') {
                    //delete and remove the item
                    //  deleteByID(id);
                    addtruck(clients);
                  } else if (value == 'viewvehicle') {
                    //delete and remove the item
                    //  deleteByID(id);
                    viewtruck(clients);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: 'delete',
                    ),
                    PopupMenuItem(
                      child: Text('Add Vehicle'),
                      value: 'addvehicle',
                    ),
                    PopupMenuItem(
                      child: Text('View Vehicles'),
                      value: 'viewvehicle',
                    ),
                  ];
                },
              ),
              // tileColor: Colors.grey,
              iconColor: Colors.orange,
              minVerticalPadding: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your floating action button functionality here
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ClientForm()));
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToEditPage(Map clients) {
    final route = MaterialPageRoute(
      builder: (context) => ClientEditForm(client: clients),
    );
    Navigator.push(context, route);
  }

  void addtruck(Map clients) {
    final route = MaterialPageRoute(
      builder: (context) => TruckForm(client: clients),
    );
    Navigator.push(context, route);
  }

  void viewtruck(Map clients) {
    final route = MaterialPageRoute(
      builder: (context) => TruckListScreen(trucks: clients),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchclients() async {
    final url = 'https://development.mbt.com.na:3001/client';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    //print("hi");
    //print(response.body);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(json);
      //   final result = json['clients'] as List;

      setState(() {
        _client = json;
      });
    }
  }

  Future<void> deleteByID(String id) async {
    // deletethe item
    //remove item from list

    final url = 'https://development.mbt.com.na:3001/client/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => this.widget));
    });

    if (response.statusCode == 200) {
      final filtered =
          _client.where((element) => element['_userID'] != id).toList();
      setState(() {
        _client = filtered;
      });
      //remove from list
    } else {
// show erroe
    }
  }
}
