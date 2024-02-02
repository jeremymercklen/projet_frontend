import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/pages/login_page.dart';
import 'package:projet_frontend/services/car_api.dart';
import 'package:projet_frontend/services/login_state.dart';
import 'package:projet_frontend/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/car.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (loginState) => LoginState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cars',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<LoginState>(builder: (context, loginState, child) {
          return loginState.connected ? MyHomePage(title: 'Cars') : LoginPage();
        }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final carRoutes = CarRoutes();
  final userRoutes = UserAccountRoutes();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Car>> _cars;

  @override
  Widget build(BuildContext context) {
    _cars = widget.carRoutes.get(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        drawer: const MyDrawer(),
        body: Center(
            child: Column(children: [
              Expanded(
                  child: FutureBuilder(
                      future: _cars,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          return ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (context, index) =>
                                  Card(child: Text(data.elementAt(index).model)));
                        }
                        return Container();
                      })),
              MySizedBox(
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Add car')))
            ])));
  }
}
