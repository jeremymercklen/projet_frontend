import 'package:projet_frontend/models/anime.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class StatusErrorException {
  final int statusCode;

  const StatusErrorException(this.statusCode);
}

class AnimeAPI {
  static const apiServer = 'kitsu.io';
  static const apiUrl = '/api/edge';
  static const searchRoute = '$apiUrl/anime';

  Future<List<Datum>> animes(category) async {
    List<Datum> animes = [];
    var result = await http.get(Uri.https(apiServer, searchRoute, {
      'filter[categories]': category,
      'page[limit]': '5',
      'page[offset]': '20'
    }));
    if (result.statusCode == 200) {
      final Map<String, dynamic> datas = await jsonDecode(result.body);
      for (var data in datas['data']) {
        Datum anime = Datum.fromJson(data);
        animes.add(anime);
      }
      return animes;
    }
    throw StatusErrorException(result.statusCode);
  }
}
