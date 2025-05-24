import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_frontend/consts.dart';
import 'package:projet_frontend/pages/account_page.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pages/login_page.dart';
import '../pages/anime_list_page.dart';
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
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MyApp())),
      ),
      ListTile(
        leading: const Icon(Icons.list),
        title: const Text("My list"),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageListAnime())),
      ),
      ListTile(
        leading: const Icon(Icons.account_circle),
        title: const Text("My account"),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PageAccount())),
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
