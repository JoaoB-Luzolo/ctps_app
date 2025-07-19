// import 'dart:convert';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

// class FitnessNotification extends StatefulWidget {
//   const FitnessNotification({super.key});

//   @override
//   State<FitnessNotification> createState() => _FitnessNotificationState();
// }

// class _FitnessNotificationState extends State<FitnessNotification> {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   List _fitness = [];

//   Future<void> initializeNotifications() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/splash');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid, iOS: null);

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         onSelectNotification(response.payload);
//       },
//     );
//   }

//   Future<void> onSelectNotification(payload) async {
//     // Handle notification tap here
//   }

//   Future<List> fetchUsers() async {
//     final response =
//         await http.get(Uri.parse('https://development.mbt.com.na:3001/cbp'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       List users = [];

//       for (var userData in data) {
//         users.add((userData));
//       }

//       return users;
//     } else {
//       throw Exception('Failed to load users');
//     }
//   }

//   Future<void> checkBirthdayNotifications() async {
//     final users = await fetchUsers();

//     final currentDate = DateTime.now();

//     for (var user in users) {
//       final userBirthday = DateTime.parse(user.birthday);
//       if (userBirthday.month == currentDate.month &&
//           userBirthday.day == currentDate.day) {
//         await showBirthdayNotification(user.name);
//       }
//     }
//   }

//   Future<void> showBirthdayNotification(String userName) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'channel_id',
//       'Birthday Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Birthday Alert',
//       'It\'s $userName\'s birthday today!',
//       platformChannelSpecifics,
//       payload: 'Birthday',
//     );
//   }

//   Future<void> fetchfitness() async {
//     final url = 'https://development.mbt.com.na:3001/fitness';
//     final uri = Uri.parse(url);
//     final response = await http.get(uri);
//     //print("hi");
//     //print(response.body);
//     //print(response.statusCode);
//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       // json['cbp'][0]['cbpPermitID'];
//       //  print(json[0]['userID']);

//       //   final result = json['users'] as List;

//       setState(() {
//         _fitness = json;
//         print(_fitness);

//         // print(fitnessDetails);
//       });
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchfitness();
//     initializeNotifications();
//     checkBirthdayNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification'),
//       ),
//     );
//   }
// }
