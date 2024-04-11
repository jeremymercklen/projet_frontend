import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projet_frontend/components.dart';
import 'package:provider/provider.dart';

import 'package:projet_frontend/models/anime.dart';
import 'package:projet_frontend/models/genre.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/services/anime_api.dart';
import 'package:projet_frontend/services/list_anime_api.dart';
import 'package:projet_frontend/services/login_state.dart';
import 'package:projet_frontend/pages/login_page.dart';

const List<String> list = <String>[
  'Not seen',
  'Plan to watch',
  'Watching',
  'Finished'
];

class PageAnime extends StatefulWidget {
  PageAnime({super.key, required this.anime});

  Datum anime;
  final userRoutes = UserAccountRoutes();
  final animeRoutes = AnimeRoutes();
  final animeAPI = AnimeAPI();

  @override
  State<StatefulWidget> createState() => _PageAnime();
}

class _PageAnime extends State<PageAnime> {
  late Future<Map<String, String>> _responseToken;
  late Future<List<DatumGenre>> _genre;
  late ListAnimes _listAnimes;
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    _responseToken = widget.userRoutes.refreshToken(context);

    return FutureBuilder(
        future: _responseToken,
        builder: (context, snapshot) {
          _genre = widget.animeAPI.getGenres(widget.anime.id);
          if (snapshot.hasData) {
            _listAnimes = ListAnimes(widget.anime.id, AnimeState.notSeen, -1, 0,
                0, int.parse(snapshot.data!['id']!));
            String _synopsis = widget.anime.attributes.synopsis!;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                body: MyPadding(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: ListView(children: [
                          Column(children: [
                            Row(children: [
                              widget.anime.attributes.coverImage != null
                                  ? MyPadding(
                                      child: Image.network(
                                          widget.anime.attributes.posterImage!
                                              .tiny,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }))
                                  : Container(),
                              Expanded(
                                  child:
                                      Text(widget.anime.attributes.titles.enJp))
                            ]),
                            Align(
                              alignment: Alignment.topLeft,
                              child: DropdownMenu<String>(
                                  initialSelection: list.first,
                                  onSelected: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      switch (value) {
                                        case 'Not seen':
                                        /*widget.animeRoutes
                                            .insert(listAnimes, context);*/
                                      }
                                    });
                                  },
                                  dropdownMenuEntries: list
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value, label: value);
                                  }).toList()),
                            ),
                            FutureBuilder(
                                future: _genre,
                                builder: (context, snapshotGenre) {
                                  final dataGenre = snapshotGenre.data;
                                  List<String> genres = [];
                                  dataGenre?.forEach((genre) =>
                                      genres.add(genre.attributes.name));
                                  return Text('Genres:\n$genres');
                                }),
                            /*Row(children: [
                                    TextField(
                                        decoration: InputDecoration(labelText: "0"),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ]),
                                    Text('/' + widget.anime.attributes.episodeCount.toString())
                                  ]),*/
                            Text('\nSynopsis:\n$_synopsis')
                          ])
                        ]))));
            throw UnimplementedError();
          }
          if (snapshot.hasError) {
            Provider.of<LoginState>(context, listen: false).disconnect();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
