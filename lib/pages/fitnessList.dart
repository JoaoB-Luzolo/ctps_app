import 'package:ctps_app/forms/fitnessCertForm.dart';
import 'package:ctps_app/forms/truckEditform.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FitnessListScreen extends StatefulWidget {
  final Map? truck;
  const FitnessListScreen({super.key, this.truck});
  @override
  State<FitnessListScreen> createState() => _FitnessListScreenState();
}

class _FitnessListScreenState extends State<FitnessListScreen> {
  List _trucks = [];
  List _filteredTrucks = [];

  fetchtrucks() async {
    var response =
        await Dio().get('https://development.mbt.com.na:3001/fitness');
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
      final truckObject = widget.truck;
      final clientID = truckObject?['truckID'];
      print(clientID);
      _filteredTrucks =
          _trucks.where((truck) => truck['truckID'] == clientID).toList();
      print(_filteredTrucks);
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
        title: Text('Fitness Certificates'),
        backgroundColor: Colors.orange,
      ),
      // drawer: NavigationDrawer(),
      body: ListView.builder(
        itemCount: _filteredTrucks.length,
        itemBuilder: (context, index) {
          final truck = _filteredTrucks[index] as Map;
          final id = truck['fitID'];
          return Card(
            elevation: 8,
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
                backgroundColor: Colors.orange,
              ),
              title: Text('Status:  ${truck['validity']}'),

              isThreeLine: true,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Certificate Expiriy Date:  ${truck['certFitExpDate']}'),
                  Text('Certificate Number:  ${truck['certFitNo']}')
                ],
              ),
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
                  }
                },
                itemBuilder: (context) {
                  return [
                    // PopupMenuItem(
                    //   child: Text('Edit'),
                    //   value: 'edit',
                    // ),
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: 'delete',
                    ),
                    // PopupMenuItem(
                    //   child: Text('Manage Fitness Certificates'),
                    //   value: 'cert',
                    // ),
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
                  builder: (BuildContext context) => FitnessForm()));
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToEditPage(Map truck) {
    final route =
        MaterialPageRoute(builder: (context) => TruckEditForm(truck: truck));
    Navigator.push(context, route);
  }

  void navigateToCertPage(Map truck) {
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

    final url = 'https://development.mbt.com.na:3001/fitness/$id';
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
