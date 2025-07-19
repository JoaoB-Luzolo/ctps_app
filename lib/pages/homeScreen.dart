import 'package:ctps_app/forms/ALP/abnormalLoadPermitEditForm.dart';
import 'package:ctps_app/forms/ALP/abnormalLoadPermitFormType1.dart';
import 'package:ctps_app/forms/ALP/abnormalLoadPermitFormType2.dart';
import 'package:ctps_app/forms/ALP/abnormalLoadPermitFormType3.dart';
import 'package:ctps_app/forms/ALP/abnormalLoadPermitFormType4.dart';
import 'package:ctps_app/forms/crossBorderPermitCopy.dart';
import 'package:ctps_app/forms/crossBorderPermitEdit.dart';
import 'package:ctps_app/forms/crossBorderPermitForm.dart';
import 'package:ctps_app/pages/clientList.dart';
import 'package:ctps_app/pages/permitArchivesScreen.dart';
import 'package:ctps_app/pages/userlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../forms/ALP/abnormalLoadPermitViewForm.dart';
import 'cpbview.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// Replace with your target date

  List _cbpPermits = [];
  List _alpPermits = [];
  bool _isSearching = false;
  String _searchText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCBPpermits();
    fetchALPpermits();
    // fetchfitness();
    // fitnessBuilder();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

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
          title: _isSearching
              ? TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                )
              : Text('Home'),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchText = ''; // Clear the search text when closing
                  }
                });
              },
            ),
          ],
          // title: Text('Home'),
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Create Permit'),
              content: const Text('Select the type of Permit'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => CrossBorderPermitForm()),
                  ),
                  child: const Text('Cross Border Permit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 48.0),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the first popup
                    _showSecondPopup(context);
                  },
                  child: const Text('Abnormal Load Permit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 48.0),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      textStyle: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  bool _searchMatches(String tradeName) {
    return tradeName.toLowerCase().contains(_searchText.toLowerCase());
  }

  Future<void> fetchCBPpermits() async {
    final url = 'https://development.mbt.com.na:3001/cbp/archive/no';
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
    final url = 'https://development.mbt.com.na:3001/alp/archive/no';
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

  void navigateToCBPEditPage(Map permit) {
    final route = MaterialPageRoute(
      builder: (context) => CrossBorderPermitEditForm(cbp: permit),
    );
    Navigator.push(context, route);
  }

  Future<void> archiveCBPPermit(Map permit) async {
    final cbp = permit;
    final id = cbp['cbpPermitID'];
    final archive = "true";
    final body = {
      "archived": archive.toString(),
    };

    final url = 'https://development.mbt.com.na:3001/cbp/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //show success or fail message
    if (response.statusCode == 200) {
      print('Creation succes');
      showSuccessMessage('Application Archive Success');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
      // _completeCreation();
    } else {
      showErrorMessage('Application Creation failed');
      print(response.body);
    }
  }

  Future<void> archiveALPPermit(Map permit) async {
    final cbp = permit;
    final id = cbp['alpPermitID'];
    final archive = "true";
    final body = {
      "archived": archive.toString(),
    };

    final url = 'https://development.mbt.com.na:3001/alp/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //show success or fail message
    if (response.statusCode == 200) {
      print('Creation succes');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
      showSuccessMessage('Application Archive Success');
      // _completeCreation();
    } else {
      showErrorMessage('Application Archive failed');
      print(response.body);
    }
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

  void copyALPpermit(Map permit) {
    final route = MaterialPageRoute(
      builder: (context) => CrossBorderPermitCopy(cbp: permit),
    );
    Navigator.push(context, route);
  }

  void navigateToCBPViewPage(Map permit) {
    final route = MaterialPageRoute(
      builder: (context) => CrossBorderPermitView(cbp: permit),
    );
    Navigator.push(context, route);
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
            child: Container(
              color: Color(0xFFF2ECE3),
              child: ListTile(
                leading: Shimmer.fromColors(
                  baseColor: Colors.orange,
                  highlightColor: Colors.grey[300]!,
                  direction: ShimmerDirection.ltr,
                  child: Icon(
                    Icons.file_present_rounded,
                    size: 35,
                  ),
                ),
                title: Text(users['Client']['tradeName']),
                isThreeLine: true,
                contentPadding: EdgeInsets.all(10),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date Created ${dateOnly}'),
                    Text('Destination Country ${users['destCountry']} '),
                    Text('Truck : ${users['Truck']['regNumber']}'),
                    // Text('Arcived ${users['archived']} '),
                  ],
                ), //Text('Date Created ${dateOnly}'),
                onTap: () {
                  navigateToCBPViewPage(users);
                },

                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigateToCBPEditPage(users);
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
                    } else if (value == 'archive') {
                      archiveCBPPermit(users);
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
            ),
          );
        },
      );

  void _showSecondPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vehicle Combination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.car_repair),
                title: Text('Option 1 (8 Axles)'),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => AbnormalLoadPermitFormType1()),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.car_repair),
                title: Text('Option 2 (10 Axles)'),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => AbnormalLoadPermitFormType2()),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.car_repair),
                title: Text('Option 3 (5 Axles)'),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => AbnormalLoadPermitFormType3()),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.car_repair),
                title: Text('Option 4 (9 Axles)'),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => AbnormalLoadPermitFormType4()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
            child: Container(
              color: Color(0xFFF2ECE3),
              child: ListTile(
                leading: Shimmer.fromColors(
                  baseColor: Colors.orange,
                  highlightColor: Colors.grey[300]!,
                  direction: ShimmerDirection.ltr,
                  child: Icon(
                    Icons.file_present,
                    size: 35,
                  ),
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
                    //Text('Arcived ${users['archived']} '),
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
                    } else if (value == 'archive') {
                      archiveALPPermit(users);
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
            ),
          );
        },
      );
}
