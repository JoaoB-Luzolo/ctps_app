import 'dart:convert';

import 'package:ctps_app/forms/userCreateScreen.dart';
import 'package:ctps_app/forms/userEditForm.dart';
import 'package:ctps_app/pages/clientList.dart';
import 'package:ctps_app/pages/homeScreen.dart';
import 'package:ctps_app/pages/permitArchivesScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List _users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.orange,
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
            ListTile(
              leading: const Icon(Icons.workspaces_outline),
              title: const Text("Permit Archives"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PermitArcScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text("Clients"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ClientScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text("Users"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            )
          ]),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchUsers,
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final users = _users[index] as Map;
            final id = users['memberID'];
            return Card(
              elevation: 8,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.orange,
                  ),
                  backgroundColor: Colors.white,
                ),
                title: Text(users['username']),
                isThreeLine: true,
                subtitle: Text(users['email']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      //open edit page
                      //navigateToEditPage(item);
                      navigateToEditPage(users);
                    } else if (value == 'delete') {
                      //delete and remove the item
                      //  deleteByID(id);
                      deleteByID(id);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your floating action button functionality here
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => UserCreateScreen()));
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToEditPage(Map users) {
    final route = MaterialPageRoute(
      builder: (context) => UserEditForm(user: users),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchUsers() async {
    final url = 'https://development.mbt.com.na:3001/user';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    //print("hi");
    //print(response.body);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // json['cbp'][0]['cbpPermitID'];
      //  print(json[0]['userID']);

      //   final result = json['users'] as List;

      setState(() {
        _users = json;
      });
    }
  }

  Future<void> deleteByID(String id) async {
    // deletethe item
    //remove item from list

    final url = 'https://development.mbt.com.na:3001/user/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => this.widget));
    });

    if (response.statusCode == 200) {
      final filtered =
          _users.where((element) => element['_userID'] != id).toList();
      setState(() {
        _users = filtered;
      });
      //remove from list
    } else {
// show erroe
    }
  }
}
