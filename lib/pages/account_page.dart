import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/pages/page_anime.dart';

import 'package:projet_frontend/models/anime.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/services/anime_api.dart';
import 'package:projet_frontend/services/list_anime_api.dart';
import 'package:projet_frontend/pages/login_page.dart';
import 'package:provider/provider.dart';

import '../services/login_state.dart';
import '../widgets/drawer.dart';

class PageAccount extends StatefulWidget {
  PageAccount({super.key});

  final userRoutes = UserAccountRoutes();
  final animeListRoutes = AnimeListRoutes();
  final animeAPI = AnimeAPI();

  @override
  State<StatefulWidget> createState() => _PageListAnime();
}

class _PageListAnime extends State<PageAccount> {
  late Future<Map<String, String>> _responseToken;
  late List<ListAnimes> _animeInList;
  late List<Anime> _animeList;
  List<ListAnimes> _animeToShow = [];
  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    _responseToken = widget.userRoutes.refreshToken(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        drawer: const MyDrawer(),
        body: FutureBuilder(
            future: Future.wait(
                [_responseToken, widget.animeListRoutes.get(context)]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                _animeInList = snapshot.data?[1];
                int numberOfAnimeSeen = 0;
                int numberOfTotalEpisodesSeen = 0;
                for (var anime in _animeInList) {
                  numberOfTotalEpisodesSeen += anime.numberOfEpisodesSeen;
                  if (anime.isFavorite) {
                    _animeToShow.add(anime);
                  }
                  if (anime.state == 3) {
                    numberOfAnimeSeen++;
                  }
                }
                return FutureBuilder(
                    future: Future.wait(
                        [widget.animeAPI.animesByList(_animeToShow, context)]),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        _animeList = snapshot.data?[0];
                        return ListView.builder(
                            itemCount: 1,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) => MyPadding(
                                    child: Column(children: [
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: MyText(
                                          "Number of episodes seen : $numberOfTotalEpisodesSeen")),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: MyText(
                                          "Number of anime finished : $numberOfAnimeSeen")),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: MyText("Favorites :")),
                                  SizedBox(
                                      height: 210,
                                      child: ListView.builder(
                                          itemCount: _animeList?.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) => PageAnime(
                                                                anime: _animeList!
                                                                    .elementAt(
                                                                        index))));
                                                  },
                                                  child: Card(
                                                      child: Column(
                                                    children: [
                                                      (MyPadding(
                                                          child: Image(
                                                              image: NetworkImage(
                                                                  _animeList!
                                                                      .elementAt(
                                                                          index)
                                                                      .info
                                                                      .picture),
                                                              height: 150,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
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
                                                      MyText(_animeList!
                                                          .elementAt(index)
                                                          .info
                                                          .name)
                                                    ],
                                                  )))))
                                ])));
                      } else if (snapshot.hasError) {
                        Future.delayed(Duration.zero, () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        });
                        return Center(child: CircularProgressIndicator());
                      } else
                        return Center(child: CircularProgressIndicator());
                    });
              } else if (snapshot.hasError) {
                Future.delayed(Duration.zero, () {
                  Provider.of<LoginState>(context, listen: false).disconnect();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                });
                return Center(child: CircularProgressIndicator());
              } else
                return Center(child: CircularProgressIndicator());
            }));
  }
}
