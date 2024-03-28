import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pages/login_page.dart';
import '../services/login_state.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const DrawerHeader(child: Text('Anime')),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("List of anime"),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyHomePage(title: ''))),
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Log out"),
        onTap: () {
          Provider.of<LoginState>(context, listen: false).disconnect();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        },
      )
    ]));
  }
}
