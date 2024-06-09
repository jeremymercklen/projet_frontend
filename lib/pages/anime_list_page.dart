import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/pages/page_anime.dart';
import 'package:provider/provider.dart';

import 'package:projet_frontend/models/anime.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/services/anime_api.dart';
import 'package:projet_frontend/services/list_anime_api.dart';
import 'package:projet_frontend/services/login_state.dart';
import 'package:projet_frontend/pages/login_page.dart';

import '../widgets/drawer.dart';

const List<String> state = <String>[
  'Not seen',
  'Plan to watch',
  'Watching',
  'Finished'
];

class PageListAnime extends StatefulWidget {
  PageListAnime({super.key});

  final userRoutes = UserAccountRoutes();
  final animeListRoutes = AnimeListRoutes();
  final animeAPI = AnimeAPI();

  @override
  State<StatefulWidget> createState() => _PageListAnime();
}

class _PageListAnime extends State<PageListAnime> {
  late Future<Map<String, String>> _responseToken;
  late Future<List<ListAnimes>> _animeInList;
  late Future<List<Anime>> _animeList;

  @override
  Widget build(BuildContext context) {
    _responseToken = widget.userRoutes.refreshToken(context);
    _animeInList = widget.animeListRoutes.get(context);

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    ),
    drawer: const MyDrawer(),
    body: FutureBuilder(
        future: Future.wait([_responseToken, _animeInList]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var animeInList = snapshot.data?[1];
            _animeList =
                widget.animeAPI.animesByList(animeInList, context);
            return FutureBuilder(
                future: _animeList,
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    var animeList = snapshot.data;
                    return ListView.builder(
                        itemCount: animeList?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PageAnime(
                                      anime: animeList?.elementAt(index))));
                            },
                            child: Card(
                                child: Row(
                              children: [
                                (MyPadding(
                                    child: Image(
                                        image: NetworkImage(animeList
                                            ?.elementAt(index)
                                            .info
                                            .picture),
                                        height: 150,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }))),
                                    Expanded(child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                                MyText(animeList?.elementAt(index).info.name),
                  MyPadding(child: MyText(state.elementAt(animeInList.elementAt(index).state)))
                                ])))
                              ],
                            ))));
                  } else if (snapshot.hasError) {
                    Provider.of<LoginState>(context, listen: false)
                        .disconnect();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    return Center(child: CircularProgressIndicator());
                  } else
                    return Center(child: CircularProgressIndicator());
                });
          } else if (snapshot.hasError) {
            Provider.of<LoginState>(context, listen: false).disconnect();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()));
            return Center(child: CircularProgressIndicator());
          } else
            return Center(child: CircularProgressIndicator());
        }));
  }
}
