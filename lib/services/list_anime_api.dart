import 'dart:convert';
import 'dart:io';

import 'package:projet_frontend/models/user_account.dart';
import 'package:projet_frontend/models/authentication_result.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/services/login_state.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StatusErrorException {
  final int _statusCode;

  const StatusErrorException(this._statusCode);

  get statusCode => _statusCode;
}

class AnimeListAPI {
  static const apiServer = '192.168.0.21:3333';
  static const apiUrl = '';
}

class UserAccountRoutes extends AnimeListAPI {
  static const userAccountRoutes = '${AnimeListAPI.apiUrl}/useraccount';
  static const authRoutes = '$userAccountRoutes/authenticate';

  Future insert(UserAccount userAccount) async {
    var result = await http.post(
        Uri.http(AnimeListAPI.apiServer, '$userAccountRoutes'),
        body: userAccount.toMap());
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
  }

  Future get(String login) async {
    var result = await http
        .get(Uri.http(AnimeListAPI.apiServer, '$userAccountRoutes/$login'));
    if (result.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<AuthenticationResult> authenticate(
      String login, String password) async {
    var result = await http.post(Uri.http(AnimeListAPI.apiServer, authRoutes),
        body: {'login': login, 'password': password});
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
    final Map<String, dynamic> datas = jsonDecode(result.body);
    return AuthenticationResult.fromMap(datas);
  }

  Future<Map<String, String>> refreshToken(context) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    var result = await http.get(
        Uri.http(AnimeListAPI.apiServer, '$userAccountRoutes/refreshtoken'),
        headers: {'Authorization': 'Bearer $token'});
    if (result.statusCode == 200) {
      Map<String, String> map = {
        'id': jsonDecode(result.body)["id"].toString(),
        'token': jsonDecode(result.body)["token"]
      };
      return map;
    } else
      throw StatusErrorException(result.statusCode);
  }
}

class AnimeListRoutes extends AnimeListAPI {
  static const animeRoutes = '${AnimeListAPI.apiUrl}/animelist';
  var userRoutes = UserAccountRoutes();

  Future<List<ListAnimes>> get(context) async {
    List<ListAnimes> listsAnimes = [];

    try {
      var value = await userRoutes.refreshToken(context);
      var token = value['token']!;
      Provider.of<LoginState>(context, listen: false).token = token;

      //var token = Provider.of<LoginState>(context, listen: false).token;
      var result = await http.get(
          Uri.http(AnimeListAPI.apiServer, '$animeRoutes'),
          headers: {'Authorization': 'Bearer $token'});
      if (result.statusCode == 200) {
        var datas = jsonDecode(result.body);
        for (var data in datas) {
          var listAnimes = ListAnimes.fromMap(data);
          if (listAnimes.state != null) {
            listsAnimes.add(listAnimes);
          }
        }
      }
    } on StatusErrorException catch (error) {
      if ((error.statusCode == 401))
        Provider.of<LoginState>(context, listen: false).disconnect();
    }
    return listsAnimes;
  }

  Future<ListAnimes> getByIdAnime(context, idAnime) async {
    try {
      var value = await userRoutes.refreshToken(context);
      var token = value['token']!;
      Provider.of<LoginState>(context, listen: false).token = token;

      //var token = Provider.of<LoginState>(context, listen: false).token;
      var result = await http.get(
          Uri.http(AnimeListAPI.apiServer, '$animeRoutes/$idAnime'),
          headers: {'Authorization': 'Bearer $token'});
      if (result.statusCode == 200) {
        var datas = jsonDecode(result.body);
        ListAnimes listAnimes = ListAnimes.fromMap(datas);
        return listAnimes;
      }
    } on StatusErrorException catch (error) {
      if ((error.statusCode == 401))
        Provider.of<LoginState>(context, listen: false).disconnect();
    }
    return ListAnimes(idAnime, 0, 0, 0, false);
  }

  Future<List<String>> getGenresByMostViewed(context) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    var result = await http.get(Uri.http(AnimeListAPI.apiServer, '$animeRoutes/most-viewed-genres'),
        headers: {'Authorization': 'Bearer $token'});
    if (result.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(result.body);
      return (data['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList();
    } else if (result.statusCode == 401) {
      Provider.of<LoginState>(context, listen: false).disconnect();
    }
    return [];
  }

  Future insert(
      {context, required int idAnime, required int state, int nbOfEpisodesSeen = 0}) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    var result = await http.get(Uri.http(AnimeListAPI.apiServer, '$animeRoutes/${idAnime.toString()}'),
        headers: {'Authorization': 'Bearer $token'});
    if (result.statusCode == 404) {
      var anime = ListAnimes(idAnime, state, 11, nbOfEpisodesSeen, false);
      result = await http.post(Uri.http(AnimeListAPI.apiServer, '$animeRoutes'),
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
          body: jsonEncode(anime));
    }
    else if (result.statusCode == 200) {
      result = await http.patch(Uri.http(AnimeListAPI.apiServer, '$animeRoutes/$idAnime'),
          headers: {'Authorization': 'Bearer $token'},
          body: {'state': state.toString(), 'nbOfEpisodesSeen': nbOfEpisodesSeen.toString()});
    }
    if (result.statusCode == 401) {
      Provider.of<LoginState>(context, listen: false).disconnect();
    }
  }

  Future changeFavorite(context, int idAnime, bool isFavorite) async {
    var token = Provider
        .of<LoginState>(context, listen: false)
        .token;
    await http.patch(Uri.http(AnimeListAPI.apiServer, '$animeRoutes/$idAnime'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'isFavorite': isFavorite.toString()});
  }

  Future changeNbOfEpisodesSeen(context, int idAnime, int nbOfEpisodesSeen) async {
    var token = Provider
        .of<LoginState>(context, listen: false)
        .token;
    await http.patch(Uri.http(AnimeListAPI.apiServer, '$animeRoutes/$idAnime'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'nbOfEpisodesSeen': nbOfEpisodesSeen.toString()});
  }

  Future changeRating(context, int idAnime, int rating) async {
    var token = Provider
        .of<LoginState>(context, listen: false)
        .token;
    await http.patch(Uri.http(AnimeListAPI.apiServer, '$animeRoutes/$idAnime'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'rating': rating.toString()});
  }

  Future delete(context, int idAnime) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    var response = await http.delete(
        Uri.http(AnimeListAPI.apiServer, '$animeRoutes/$idAnime'),
        headers: {'Authorization': 'Bearer $token'});
  }
}
