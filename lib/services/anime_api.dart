import 'package:projet_frontend/models/anime.dart';
import 'package:projet_frontend/services/login_state.dart';

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StatusErrorException {
  final int statusCode;

  const StatusErrorException(this.statusCode);
}

class AnimeAPI {
  static const apiServer = '192.168.2.109:3333';
  static const apiUrl = '';
  static const searchRoute = '$apiUrl/anime';

  Future<List<Anime>> animes(category, context) async {
    List<Anime> animes = [];
    var token = Provider.of<LoginState>(context, listen: false).token;
    var result = await http.get(Uri.http(apiServer, searchRoute, {
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
}
