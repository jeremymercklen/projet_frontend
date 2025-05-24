import 'package:projet_frontend/models/anime.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/services/login_state.dart';

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StatusErrorException {
  final int statusCode;

  const StatusErrorException(this.statusCode);
}

class AnimeAPI {
  static const apiServer = '192.168.0.21:3333';
  static const apiUrl = '';
  static const searchRoute = '$apiUrl/anime';

  Future<List<Anime>> animes(String genre, context, {int page = 1, int limit = 10}) async {
    var token = Provider.of<LoginState>(context, listen: false).token;

    var result = await http.get(
        Uri.http(apiServer, '$searchRoute/$genre', {
          'page': page.toString(),
          'limit': limit.toString(),
        }),
        headers: {'Authorization': 'Bearer $token'}
    );

    if (result.statusCode == 200) {
      final Map<String, dynamic> datas = await jsonDecode(result.body);
      List<Anime> animes = [];
      if (datas['infos'] != null) {
        for (var data in datas['infos']) {
          animes.add(Anime.fromJson(data));
        }
      }
      return animes;
    }
    throw StatusErrorException(result.statusCode);
  }

  Future<List<Anime>> animesByList(List<ListAnimes> animeList, context) async {
    List<Anime> animes = [];
    var token = Provider.of<LoginState>(context, listen: false).token;
    for (var animeInList in animeList) {
      if (animeInList.idAnime != null) {
        var result = await http.get(Uri.http(apiServer, searchRoute, {
          'id': '${animeInList.idAnime}',
        }), headers: {'Authorization': 'Bearer $token'});
        if (result.statusCode == 200) {
          final Map<String, dynamic> datas = await jsonDecode(result.body);
          Anime anime = Anime.fromJson(datas);
          animes.add(anime);
        }
        else throw StatusErrorException(result.statusCode);
      }
    }
    return animes;
  }

  Future<List<Anime>> searchAnimes(String query, context) async {
    List<Anime> animes = [];
    var token = Provider.of<LoginState>(context, listen: false).token;

    var result = await http.get(
        Uri.http(apiServer, '$searchRoute/search/$query'),
        headers: {'Authorization': 'Bearer $token'}
    );

    if (result.statusCode == 200) {
      final Map<String, dynamic> datas = await jsonDecode(result.body);
      if (datas['infos'] != null) {
        for (var data in datas['infos']) {
          Anime anime = Anime.fromJson(data);
          animes.add(anime);
        }
      }
      return animes;
    }
    throw StatusErrorException(result.statusCode);
  }
}
