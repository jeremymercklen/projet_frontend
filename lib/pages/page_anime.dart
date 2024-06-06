import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projet_frontend/components.dart';
import 'package:provider/provider.dart';

import 'package:projet_frontend/models/anime.dart';
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

  Anime anime;
  final userRoutes = UserAccountRoutes();
  final animeListRoutes = AnimeListRoutes();
  final animeAPI = AnimeAPI();

  @override
  State<StatefulWidget> createState() => _PageAnime();
}

class _PageAnime extends State<PageAnime> {
  late Future<Map<String, String>> _responseToken;
  final TextEditingController _controller = TextEditingController();
  bool canEditNbOfEpisodesSeen = true;

  _onChange (text) {
    if (text == "" || int.parse(text) < 0) {
      text = "0"
          .toString();
      _controller.value =
          _controller.value.copyWith(
              text: text,
              selection:
              TextSelection.collapsed(
                  offset:
                  text.length));
    }
    else if(int.parse(text) > widget.anime.info.numberofepisodes) {
      text = widget
          .anime.info.numberofepisodes
          .toString();
      _controller.value =
          _controller.value.copyWith(
              text: text,
              selection:
              TextSelection.collapsed(
                  offset:
                  text.length));
    }
    text = (int.parse(text)).toString();
    _controller.value =
        _controller.value.copyWith(
            text: text,
            selection:
            TextSelection.collapsed(
                offset:
                text.length));
    widget.animeListRoutes.changeNbOfEpisodesSeen(context, widget.anime.info.id, int.parse(text));
  }

  @override
  Widget build(BuildContext context) {
    _responseToken = widget.userRoutes.refreshToken(context);

    return FutureBuilder(
        future: Future.wait([
          _responseToken,
          widget.animeListRoutes.getByIdAnime(context, widget.anime.info.id)
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var listAnimes = snapshot.data?[1] as ListAnimes;
            String dropdownValue = list.elementAt(listAnimes.state);
            List<String> genreNames = [];
            if (listAnimes.state == 2) {
                canEditNbOfEpisodesSeen = false;
            }
            else {
              canEditNbOfEpisodesSeen = true;
            }
            //setState(() {});
            for (Genre genre in widget.anime.info.genres) {
              genreNames.add(genre.name);
            }
            var baseNbOfEpisodes = listAnimes.numberOfEpisodesSeen.toString();
            _controller.value = _controller.value.copyWith(
              text: baseNbOfEpisodes,
              selection:
                  TextSelection.collapsed(offset: baseNbOfEpisodes.length),
            );
            String _synopsis = widget.anime.info.synopsis;
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
                              MyPadding(
                                  child: Image(
                                      image: NetworkImage(
                                          widget.anime.info.picture),
                                      width: 200,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                            child: CircularProgressIndicator());
                                      })),
                              Expanded(child: Text(widget.anime.info.name))
                            ]),
                            Align(
                              alignment: Alignment.topLeft,
                              child: MyPadding(
                                  child: DropdownMenu<String>(
                                      initialSelection: dropdownValue,
                                      onSelected: (String? value) async {
                                          switch (value) {
                                            case 'Not seen':
                                              canEditNbOfEpisodesSeen = true;
                                              await widget.animeListRoutes.delete(
                                                  context,
                                                  widget.anime.info.id);
                                              var updatedText = "0";
                                              _controller.value =
                                                  _controller.value.copyWith(
                                                text: updatedText,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset:
                                                            updatedText.length),
                                              );
                                            case 'Plan to watch':
                                              canEditNbOfEpisodesSeen = true;
                                              await widget.animeListRoutes.insert(
                                                  context: context,
                                                  state: 1,
                                                  idAnime:
                                                  widget.anime.info.id);
                                              var updatedText = "0";
                                              _controller.value =
                                                  _controller.value.copyWith(
                                                    text: updatedText,
                                                    selection:
                                                    TextSelection.collapsed(
                                                        offset:
                                                        updatedText.length),
                                                  );
                                            case 'Watching':
                                              canEditNbOfEpisodesSeen = false;
                                              await widget.animeListRoutes.insert(
                                                  context: context,
                                                  state: 2,
                                                  idAnime:
                                                      widget.anime.info.id);
                                              var updatedText = "0";
                                              _controller.value =
                                                  _controller.value.copyWith(
                                                text: updatedText,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset:
                                                            updatedText.length),
                                              );
                                            case 'Finished':
                                              canEditNbOfEpisodesSeen = true;
                                              await widget.animeListRoutes.insert(
                                                  context: context,
                                                  state: 3,
                                                  idAnime: widget.anime.info.id,
                                                  nbOfEpisodesSeen: widget.anime
                                                      .info.numberofepisodes);
                                              var updatedText = widget
                                                  .anime.info.numberofepisodes
                                                  .toString();
                                              _controller.value =
                                                  _controller.value.copyWith(
                                                text: updatedText,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset:
                                                            updatedText.length),
                                              );
                                        };
                                        setState(() {});
                                      },
                                      dropdownMenuEntries: list
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value, label: value);
                                      }).toList())),
                            ),
                            //Row(children: [
                            /*TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(labelText: "Number of episodes seen"),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ]),
                                    //Text('/' + widget.anime.info.numberofepisodes.toString())
                                  //]),*/
                            Align(
                                alignment: Alignment.topLeft,
                                child: MyPadding(
                                    child: Container(
                                        width: 200,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.black54)),
                                        child: Column(children: [
                                          Text("Number of episodes seen"),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width: 50,
                                                    child: TextFormField(
                                                        readOnly: canEditNbOfEpisodesSeen,
                                                        controller: _controller,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                    onChanged:(text) {
                                                          _onChange(text);
                                                    })),
                                                Text(
                                                    "/${widget.anime.info.numberofepisodes.toString()}"),
                                                SizedBox(
                                                    height:
                                                        50, //height of button
                                                    width:
                                                        50, //width of button
                                                    child: IconButton(
                                                        onPressed: () {
                                                          var updatedText = ((int.parse(_controller.text)) + 1).toString();
                                                          if (int.parse(updatedText) <= widget.anime.info.numberofepisodes) {
                                                            _controller.value =
                                                                _controller
                                                                    .value
                                                                    .copyWith(
                                                                    text: updatedText,
                                                                    selection:
                                                                    TextSelection
                                                                        .collapsed(
                                                                        offset:
                                                                        updatedText
                                                                            .length));
                                                            _onChange(_controller.text);
                                                          }
                                                        },
                                                        style: ButtonStyle(
                                                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(0)
                                                        ))),
                                                        icon: Icon(Icons.add))),
                                                SizedBox(
                                                    height:
                                                    50, //height of button
                                                    width:
                                                    50, //width of button
                                                    child: IconButton(
                                                        onPressed: () {
                                                          var updatedText = ((int.parse(_controller.text)) - 1).toString();
                                                          if (int.parse(updatedText) >= 0) {
                                                            _controller.value =
                                                                _controller
                                                                    .value
                                                                    .copyWith(
                                                                    text: updatedText,
                                                                    selection:
                                                                    TextSelection
                                                                        .collapsed(
                                                                        offset:
                                                                        updatedText
                                                                            .length));
                                                            _onChange(_controller.text);
                                                          }
                                                        },
                                                        style: ButtonStyle(
                                                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(0)
                                                                ))),
                                                        icon: Icon(Icons.remove))),
                                              ])
                                        ])))),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text('Genres:\n$genreNames')),
                            Text('\nSynopsis:\n$_synopsis')
                          ])
                        ]))));
          } else if (snapshot.hasError) {
            Provider.of<LoginState>(context, listen: false).disconnect();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()));
            return Center(child: CircularProgressIndicator());
          } else
            return Center(child: CircularProgressIndicator());
        });
  }
}
