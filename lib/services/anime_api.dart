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
  static const apiServer = 'www.main-bvxea6i-r5jyzsdl6nhxe.fr-3.platformsh.site';
  static const apiUrl = '';
  static const searchRoute = '$apiUrl/anime';

  Future<List<Anime>> animes(category, context) async {
    List<Anime> animes = [];
    var token = Provider.of<LoginState>(context, listen: false).token;
    var result = await http.get(Uri.https(apiServer, searchRoute, {
      'genre': category,
    }), headers: {'Authorization': 'Bearer $token'});
    if (result.statusCode == 200) {
      final Map<String, dynamic> datas = await jsonDecode(result.body);
      for (var data in datas['infos']) {
        Anime anime = Anime.fromJson(data);
        animes.add(anime);
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
        var result = await http.get(Uri.https(apiServer, searchRoute, {
          'id': '${animeInList.idAnime}',
        }), headers: {'Authorization': 'Bearer $token'});
        if (result.statusCode == 200) {
          final Map<String, dynamic> datas = await jsonDecode(result.body);
          Anime anime = Anime.fromJson(datas['info']);
          animes.add(anime);
        }
        else throw StatusErrorException(result.statusCode);
      }
    }
    return animes;
  }
}
