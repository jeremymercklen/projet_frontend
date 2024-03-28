import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_frontend/components.dart';

import 'package:projet_frontend/models/anime.dart';

class PageAnime extends StatefulWidget {
  PageAnime({super.key, required this.anime});

  Datum anime;

  @override
  State<StatefulWidget> createState() => _PageAnime();
}

class _PageAnime extends State<PageAnime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Align(
            alignment: Alignment.topLeft,
            child: Column(children: [
              Row(children: [
                widget.anime.attributes.coverImage != null
                    ? MyPadding(
                        child: Image.network(
                            widget.anime.attributes.posterImage!.tiny,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(child: CircularProgressIndicator());
                      }))
                    : Container(),
                Text(widget.anime.attributes.titles.enJp)
              ]),
              Text(widget.anime.attributes.synopsis)
            ])));
    throw UnimplementedError();
  }
}
