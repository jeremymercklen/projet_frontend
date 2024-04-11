// To parse this JSON data, do
//
//     final genre = genreFromJson(jsonString);

import 'dart:convert';

Genre genreFromJson(String str) => Genre.fromJson(json.decode(str));

String genreToJson(Genre data) => json.encode(data.toJson());

class Genre {
  List<DatumGenre> data;
  Meta meta;
  GenreLinks links;

  Genre({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    data: List<DatumGenre>.from(json["data"].map((x) => DatumGenre.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
    links: GenreLinks.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
    "links": links.toJson(),
  };
}

class DatumGenre {
  String id;
  String type;
  DatumLinks links;
  Attributes attributes;

  DatumGenre({
    required this.id,
    required this.type,
    required this.links,
    required this.attributes,
  });

  factory DatumGenre.fromJson(Map<String, dynamic> json) => DatumGenre(
    id: json["id"],
    type: json["type"],
    links: DatumLinks.fromJson(json["links"]),
    attributes: Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "links": links.toJson(),
    "attributes": attributes.toJson(),
  };
}

class Attributes {
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String slug;
  String? description;

  Attributes({
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.slug,
    required this.description,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "name": name,
    "slug": slug,
    "description": description,
  };
}

class DatumLinks {
  String self;

  DatumLinks({
    required this.self,
  });

  factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
    self: json["self"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
  };
}

class GenreLinks {
  String first;
  String last;

  GenreLinks({
    required this.first,
    required this.last,
  });

  factory GenreLinks.fromJson(Map<String, dynamic> json) => GenreLinks(
    first: json["first"],
    last: json["last"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
  };
}

class Meta {
  int count;

  Meta({
    required this.count,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
  };
}
