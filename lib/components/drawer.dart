import 'package:flutter/material.dart';

import '../pages/clientList.dart';
import '../pages/homeScreen.dart';
import '../pages/permitArchivesScreen.dart';
import '../pages/userlist.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
              ]),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );
  Widget buildMenuItems(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            Image.asset(
              'lib/images/logo.png',
              height: 100,
            ),
            const Divider(color: Colors.grey),
            ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                onTap: () => {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      )
                    }),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.workspaces_outline),
              title: const Text("Permit Archives"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PermitArcScreen()),
                );
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text("Clients"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ClientScreen()),
                );
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text("Users"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserListScreen()),
                );
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            )
          ],
        ),
      );
}
