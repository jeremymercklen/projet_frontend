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

const List<String> state = <String>[
  'Not seen',
  'Plan to watch',
  'Watching',
  'Finished'
];

const List<String> filters = <String>[
  'All',
  'Plan to watch',
  'Watching',
  'Finished',
  'Favorite'
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
                if (_animeToShow.isEmpty && isFirstTime) {
                  _animeToShow = _animeInList;
                }
                return FutureBuilder(
                    future: Future.wait(
                        [widget.animeAPI.animesByList(_animeToShow, context)]),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        if (isFirstTime) {
                          _animeList = snapshot.data?[0];
                        }
                        return Column(children: [
                          MyPadding(
                              child: DropdownMenu<String>(
                                  initialSelection: filters.elementAt(0),
                                  onSelected: (String? value) async {
                                    switch (value) {
                                      case 'All':
                                        _animeToShow = _animeInList;
                                        _animeList = await widget.animeAPI
                                            .animesByList(
                                                _animeToShow, context);
                                        isFirstTime = false;
                                      case 'Plan to watch':
                                        _animeToShow = [];
                                        for (var anime in _animeInList) {
                                          if (anime.state == 1) {
                                            _animeToShow.add(anime);
                                          }
                                        }
                                        isFirstTime = false;
                                        _animeList = await widget.animeAPI
                                            .animesByList(
                                                _animeToShow, context);
                                      case 'Watching':
                                        _animeToShow = [];
                                        for (var anime in _animeInList) {
                                          if (anime.state == 2) {
                                            _animeToShow.add(anime);
                                          }
                                        }
                                        isFirstTime = false;
                                        _animeList = await widget.animeAPI
                                            .animesByList(
                                                _animeToShow, context);
                                      case 'Finished':
                                        _animeToShow = [];
                                        for (var anime in _animeInList) {
                                          if (anime.state == 3) {
                                            _animeToShow.add(anime);
                                          }
                                        }
                                        isFirstTime = false;
                                        _animeList = await widget.animeAPI
                                            .animesByList(
                                                _animeToShow, context);
                                      case 'Favorite':
                                        _animeToShow = [];
                                        for (var anime in _animeInList) {
                                          if (anime.isFavorite == true) {
                                            _animeToShow.add(anime);
                                          }
                                        }
                                        isFirstTime = false;
                                        _animeList = await widget.animeAPI
                                            .animesByList(
                                                _animeToShow, context);
                                    }
                                    setState(() {});
                                  },
                                  dropdownMenuEntries: filters
                                      .map<DropdownMenuEntry<String>>(
                                          (String filters) {
                                    return DropdownMenuEntry<String>(
                                        value: filters, label: filters);
                                  }).toList())),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: _animeList?.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PageAnime(
                                                            anime: _animeList!
                                                                .elementAt(
                                                                    index))));
                                          },
                                          child: Card(
                                              child: Row(
                                            children: [
                                              (MyPadding(
                                                  child: Image(
                                                      image: NetworkImage(
                                                          _animeList!
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
                                              Expanded(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Column(children: [
                                                        MyText(_animeList!
                                                            .elementAt(index)
                                                            .info
                                                            .name),
                                                        MyPadding(
                                                            child: MyText(
                                                                'State : ${state.elementAt(_animeToShow.elementAt(index).state)}')),
                                                        _animeToShow
                                                                    .elementAt(
                                                                        index)
                                                                    .state ==
                                                                3
                                                            ? MyPadding(
                                                                child: _animeToShow
                                                                            .elementAt(
                                                                                index)
                                                                            .rating <=
                                                                        10
                                                                    ? MyText(
                                                                        'My rating : ${_animeToShow.elementAt(index).rating}')
                                                                    : MyText(
                                                                        'My rating : not rated'))
                                                            : _animeToShow
                                                                        .elementAt(
                                                                            index)
                                                                        .state ==
                                                                    2
                                                                ? MyPadding(
                                                                    child: MyText(
                                                                        'Episodes : ${_animeToShow.elementAt(index).numberOfEpisodesSeen}/${_animeList.elementAt(index).info.numberofepisodes}'))
                                                                : Container(),
                                                      ]))),
                                              _animeToShow
                                                      .elementAt(index)
                                                      .isFavorite
                                                  ? const Icon(Icons.favorite)
                                                  : Container()
                                            ],
                                          )))))
                        ]);
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
