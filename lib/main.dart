import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/consts.dart';
import 'package:projet_frontend/pages/login_page.dart';
import 'package:projet_frontend/pages/page_anime.dart';
import 'package:projet_frontend/services/anime_api.dart';
import 'package:projet_frontend/services/list_anime_api.dart';
import 'package:projet_frontend/services/login_state.dart';
import 'package:projet_frontend/widgets/drawer.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/models/anime.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (loginState) => LoginState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anime',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<LoginState>(builder: (context, loginState, child) {
          return loginState.connected
              ? MyHomePage(title: 'Anime')
              : LoginPage();
        }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  var animeAPI = AnimeAPI();
  final animeRoutes = AnimeListRoutes();
  final userRoutes = UserAccountRoutes();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, String>> _response;
  late Future<List<Anime>> _anime;

  @override
  Widget build(BuildContext context) {
    _response = widget.userRoutes.refreshToken(context);
    _anime = widget.animeAPI.animes('Shounen', context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        drawer: const MyDrawer(),
        body: FutureBuilder(
            future: _response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Provider.of<LoginState>(context, listen: false).token =
                    snapshot.data!['token']!;
                return Column(children: [
                  Align(
                      alignment: Alignment.topLeft, child: MyText('Action :')),
                  SizedBox(
                      height: 220,
                      child: FutureBuilder(
                          future: _anime,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data;
                              return ListView.builder(
                                  itemCount: data!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PageAnime(
                                                            anime:
                                                                data.elementAt(
                                                                    index))));
                                          },
                                          child: Card(
                                              child: Column(
                                            children: [
                                              (MyPadding(
                                                  child: Image(
                                                      image: NetworkImage(data
                                                          .elementAt(index)
                                                          .info
                                                          .picture),
                                                      height: 150,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      }))),
                                              MyPadding(
                                                  child: MyText(data
                                                      .elementAt(index)
                                                      .info
                                                      .name))
                                            ],
                                          ))));
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Container();
                          }))
                ]);
              }
              if (snapshot.hasError) {
                Provider.of<LoginState>(context, listen: false).disconnect();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
