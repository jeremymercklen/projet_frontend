// To parse this JSON data, do
//
//     final anime = animeFromJson(jsonString);

import 'dart:convert';

Anime animeFromJson(String str) => Anime.fromJson(json.decode(str));

String animeToJson(Anime data) => json.encode(data.toJson());

class Anime {
  Info info;

  Anime({
    required this.info,
  });

  factory Anime.fromJson(Map<String, dynamic> json) => Anime(
    info: Info.fromJson(json),
  );

  Map<String, dynamic> toJson() => {
    "info": info.toJson(),
  };
}

class Info {
  int id;
  int idapi;
  String name;
  String picture;
  String synopsis;
  int numberofepisodes;
  List<Genre> genres;

  Info({
    required this.id,
    required this.idapi,
    required this.name,
    required this.picture,
    required this.synopsis,
    required this.numberofepisodes,
    required this.genres,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    id: json["id"],
    idapi: json["idapi"],
    name: json["name"],
    picture: json["picture"],
    synopsis: json["synopsis"],
    numberofepisodes: json["numberofepisodes"],
    genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idapi": idapi,
    "name": name,
    "picture": picture,
    "synopsis": synopsis,
    "numberofepisodes": numberofepisodes,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
  };
}

class Genre {
  String name;

  Genre({
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
