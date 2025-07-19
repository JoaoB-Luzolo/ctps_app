import 'package:ctps_app/pages/clientList.dart';
import 'package:ctps_app/pages/homeScreen.dart';
import 'package:ctps_app/pages/userlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../forms/ALP/abnormalLoadPermitEditForm.dart';
import '../forms/ALP/abnormalLoadPermitViewForm.dart';
import '../forms/crossBorderPermitCopy.dart';
import 'cpbview.dart';

class PermitArcScreen extends StatefulWidget {
  @override
  State<PermitArcScreen> createState() => _PermitArcScreenState();
}

class _PermitArcScreenState extends State<PermitArcScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCBPpermits();
    fetchALPpermits();
  }

  List _cbpPermits = [];
  List _alpPermits = [];
  bool _isSearching = false;
  String _searchText = '';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: ('CBP'),
            ),
            Tab(
              text: ('ALP'),
            ),
          ]),
          title: Text('Permit Archives'),
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
        //   drawer: NavigationDrawer(),
        body: TabBarView(
          children: [
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: RefreshIndicator(
                onRefresh: fetchCBPpermits,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(60)),
                  child: cbpbuildList(),
                ),
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: RefreshIndicator(
                onRefresh: fetchALPpermits,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(60)),
                  child: alpbuildList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cbpbuildList() => ListView.builder(
        itemCount: _cbpPermits.length,
        itemBuilder: (context, index) {
          _cbpPermits.sort((a, b) {
            final tradeNameA = a['Client']['tradeName'];
            final tradeNameB = b['Client']['tradeName'];
            return tradeNameA.compareTo(tradeNameB);
          });
          final users = _cbpPermits[index] as Map;

          final dateCreated = users['createdAt'].toString();
          final dateOnly = dateCreated.substring(0, 10);

          print(_cbpPermits);

          if (_isSearching) {
            final tradeName = users['Client']['tradeName'].toString();
            // final originCount = users['OriginCountry'].toString();
            if (!_searchMatches(tradeName)) {
              return SizedBox
                  .shrink(); // Hide items that don't match the search
            }
          }

          // final id = users['userID'];
          return Card(
            elevation: 8,
            child: ListTile(
              leading: Icon(
                Icons.archive_outlined,
                size: 35,
              ),
              title: Text(users['Client']['tradeName']),
              isThreeLine: true,
              contentPadding: EdgeInsets.all(14),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date Created ${dateOnly}'),
                  Text('Destination Country ${users['destCountry']} '),
                  Text('Truck : ${users['Truck']['regNumber']}'),
                  Text('Permit Status ${users['cbpStatus']} '),
                  Text('Arcived ${users['archived']} '),
                ],
              ), //Text('Date Created ${dateOnly}'),
              onTap: () {
                navigateToCBPViewPage(users);
              },

              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    //   navigateToCBPEditPage(users);
                    //open edit page
                    //navigateToCBPEditPage(item);
                    // navigateToCBPEditPage(users);
                  } else if (value == 'delete') {
                    //delete and remove the item
                    //  deleteByID(id);
                    //  deleteByID(id);
                  } else if (value == 'copy') {
                    copyCBPpermit(users);
                    //delete and remove the item
                    //  deleteByID(id);
                    //  deleteByID(id);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'edit',
                    ),
                    // PopupMenuItem(
                    //   child: Text('Delete'),
                    //   value: 'delete',
                    // ),
                    // PopupMenuItem(
                    //   child: Text('Archive'),
                    //   value: 'archive',
                    // ),
                    // PopupMenuItem(
                    //   child: Text('Make Copy Of'),
                    //   value: 'copy',
                    // ),
                  ];
                },
              ),
              // tileColor: Colors.grey,
              iconColor: Colors.orange,
              minVerticalPadding: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          );
        },
      );

  Widget alpbuildList() => ListView.builder(
        itemCount: _alpPermits.length,
        itemBuilder: (context, index) {
          _alpPermits.sort((a, b) {
            final tradeNameA = a['Client']['tradeName'];
            final tradeNameB = b['Client']['tradeName'];
            return tradeNameA.compareTo(tradeNameB);
          });
          final users = _alpPermits[index] as Map;

          final dateCreated = users['createdAt'].toString();
          final dateOnly = dateCreated.substring(0, 10);

          print(_cbpPermits);

          if (_isSearching) {
            final tradeName = users['Client']['tradeName'].toString();

            if (!_searchMatches(tradeName)) {
              return SizedBox
                  .shrink(); // Hide items that don't match the search
            }
          }

          // final id = users['userID'];
          return Card(
            elevation: 8,
            child: ListTile(
              leading: Icon(
                Icons.file_copy_rounded,
                size: 35,
              ),
              title: Text(users['Client']['tradeName']),
              isThreeLine: true,
              contentPadding: EdgeInsets.all(10),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date Created ${dateOnly}'),
                  Text('Load Details ${users['loadDetail']} '),
                  Text('Truck : ${users['Truck']['make']}'),
                  Text('Arcived ${users['archived']} '),
                ],
              ), //Text('Date Created ${dateOnly}'),
              onTap: () {
                navigateToALPViewPage(users);
              },

              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    navigateToALPEditPage(users);
                    //open edit page
                    //navigateToCBPEditPage(item);
                    // navigateToCBPEditPage(users);
                  } else if (value == 'delete') {
                    //delete and remove the item
                    //  deleteByID(id);
                    //  deleteByID(id);
                  } else if (value == 'copy') {
                    copyCBPpermit(users);
                    //delete and remove the item
                    //  deleteByID(id);
                    //  deleteByID(id);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'edit',
                    ),
                    // PopupMenuItem(
                    //   child: Text('Delete'),
                    //   value: 'delete',
                    // ),
                    PopupMenuItem(
                      child: Text('Archive'),
                      value: 'archive',
                    ),
                    PopupMenuItem(
                      child: Text('Make Copy Of'),
                      value: 'copy',
                    ),
                  ];
                },
              ),
              // tileColor: Colors.grey,
              iconColor: Colors.orange,
              minVerticalPadding: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          );
        },
      );

  void navigateToCBPViewPage(Map permit) {
    final route = MaterialPageRoute(
      builder: (context) => CrossBorderPermitView(cbp: permit),
    );
    Navigator.push(context, route);
  }

  void navigateToALPEditPage(Map permit) {
    final route = MaterialPageRoute(
      builder: (context) => AbnormalLoadPermitEditForm(alp: permit),
    );
    Navigator.push(context, route);
  }

  void navigateToALPViewPage(Map permit) {
    final route = MaterialPageRoute(
      builder: (context) => AbnormalLoadPermitView(alp: permit),
    );
    Navigator.push(context, route);
  }

  void copyCBPpermit(Map permit) {
    final route = MaterialPageRoute(
      builder: (context) => CrossBorderPermitCopy(cbp: permit),
    );
    Navigator.push(context, route);
  }

  bool _searchMatches(String tradeName) {
    return tradeName.toLowerCase().contains(_searchText.toLowerCase());
  }

  Future<void> fetchCBPpermits() async {
    final url = 'https://development.mbt.com.na:3001/cbp/archive/yes';
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
        _cbpPermits = json;
      });
    }
  }

  Future<void> fetchALPpermits() async {
    final url = 'https://development.mbt.com.na:3001/alp/archive/yes';
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
        _alpPermits = json;
      });
    }
  }
}
