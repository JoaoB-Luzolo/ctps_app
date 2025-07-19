import 'package:ctps_app/forms/fitnessCertForm.dart';
import 'package:ctps_app/forms/truckEditform.dart';
import 'package:ctps_app/pages/fitnessList.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TruckListScreen extends StatefulWidget {
  final Map? trucks;
  const TruckListScreen({super.key, this.trucks});
  @override
  State<TruckListScreen> createState() => _TruckListScreenState();
}

class _TruckListScreenState extends State<TruckListScreen> {
  List _trucks = [];
  List _filteredTrucks = [];

  fetchtrucks() async {
    var response = await Dio().get('https://development.mbt.com.na:3001/truck');
    return response.data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchtrucks();

    // final filtered =
    //     _trucks.where((truck) => truck['clientID'] = clientID).toList();
    // setState(() {
    //   _trucks = filtered;
    // });
    void filterTrucks() {
      final client = widget.trucks;
      final clientID = client?['clientID'];
      _filteredTrucks =
          _trucks.where((truck) => truck['clientID'] == clientID).toList();
    }

    fetchtrucks().then((data) {
      setState(() {
        _trucks = _filteredTrucks = data;
        filterTrucks();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trucks'),
        backgroundColor: Colors.orange,
      ),
      // drawer: NavigationDrawer(),
      body: ListView.builder(
        itemCount: _filteredTrucks.length,
        itemBuilder: (context, index) {
          final truck = _filteredTrucks[index] as Map;
          final id = truck['truckID'];

          if (_filteredTrucks.isEmpty) {
            //  return Container(child: alert(),);
          } else if (_trucks.isNotEmpty) {
            return Card(
              elevation: 8,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: const AssetImage('lib/images/lorry2.png'),
                  backgroundColor: Colors.white,
                ),
                title: Text(truck['make']),
                isThreeLine: true,
                subtitle: Text(truck['regNumber']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      //open edit page
                      //navigateToEditPage(item);
                      navigateToEditPage(truck);
                    } else if (value == 'delete') {
                      //delete and remove the item
                      //  deleteByID(id);
                      deleteByID(id);
                    } else if (value == 'cert') {
                      navigateToCertPage(truck);
                    } else if (value == 'addcert') {
                      addFitness(truck);
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
                        child: Text('Add Fitess Certificate'),
                        value: 'addcert',
                      ),
                      PopupMenuItem(
                        child: Text('Manage Fitness Certificates'),
                        value: 'cert',
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
          }
          return null;
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your floating action button functionality here
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (BuildContext context) => UserSignUpForm()));
      //   },
      //   backgroundColor: Colors.orange,
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void alert() {
    AlertDialog(
      title: Text('No trucks found'),
    );
  }

  void navigateToEditPage(Map truck) {
    final route =
        MaterialPageRoute(builder: (context) => TruckEditForm(truck: truck));
    Navigator.push(context, route);
  }

  void navigateToCertPage(Map truck) {
    final route = MaterialPageRoute(
        builder: (context) => FitnessListScreen(truck: truck));
    Navigator.push(context, route);
  }

  void addFitness(Map truck) {
    final route =
        MaterialPageRoute(builder: (context) => FitnessForm(truck: truck));
    Navigator.push(context, route);
  }

  // Future<void> fetchtrucks() async {
  //   final url = 'https://development.mbt.com.na:3001/truck';
  //   final uri = Uri.parse(url);
  //   final response = await http.get(uri);
  //   //print("hi");
  //   //print(response.body);
  //   //print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     print(json);
  //     //   final result = json['truck'] as List;
  //     // final filtered =
  //     //     _trucks.where((element) => element['_clientID'] != id).toList();
  //     // setState(() {
  //     //   _trucks = filtered;
  //     // });
  //   }
  // }

  Future<void> deleteByID(String id) async {
    // deletethe item
    //remove item from list

    final url = 'https://development.mbt.com.na:3001/truck/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => this.widget));
    });

    if (response.statusCode == 200) {
      final filtered =
          _trucks.where((element) => element['_truckID'] != id).toList();
      setState(() {
        _trucks = filtered;
      });
      //remove from list
    } else {
// show erroe
    }
  }
}
