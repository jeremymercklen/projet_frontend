// To parse this JSON data, do
//
//     final anime = animeFromJson(jsonString);

import 'dart:convert';

Anime animeFromJson(String str) => Anime.fromJson(json.decode(str));

String animeToJson(Anime data) => json.encode(data.toJson());

class Anime {
  List<Datum> data;
  AnimeMeta meta;
  AnimeLinks links;

  Anime({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory Anime.fromJson(Map<String, dynamic> json) => Anime(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        meta: AnimeMeta.fromJson(json["meta"]),
        links: AnimeLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
        "links": links.toJson(),
      };
}

class Datum {
  String id;
  String type;
  DatumLinks links;
  Attributes attributes;
  Map<String, Relationship> relationships;

  Datum({
    required this.id,
    required this.type,
    required this.links,
    required this.attributes,
    required this.relationships,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        links: DatumLinks.fromJson(json["links"]),
        attributes: Attributes.fromJson(json["attributes"]),
        relationships: Map.from(json["relationships"]).map((k, v) =>
            MapEntry<String, Relationship>(k, Relationship.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "links": links.toJson(),
        "attributes": attributes.toJson(),
        "relationships": Map.from(relationships)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Attributes {
  DateTime createdAt;
  DateTime updatedAt;
  String slug;
  String synopsis;
  String description;
  int coverImageTopOffset;
  Titles titles;
  String canonicalTitle;
  List<String> abbreviatedTitles;
  String? averageRating;
  Map<String, String> ratingFrequencies;
  int userCount;
  int favoritesCount;
  DateTime startDate;
  DateTime? endDate;
  dynamic nextRelease;
  int popularityRank;
  int? ratingRank;
  String? ageRating;
  String? ageRatingGuide;
  String subtype;
  String status;
  dynamic tba;
  PosterImage? posterImage;
  CoverImage? coverImage;
  int episodeCount;
  int? episodeLength;
  int? totalLength;
  String? youtubeVideoId;
  String showType;
  bool nsfw;

  Attributes({
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.synopsis,
    required this.description,
    required this.coverImageTopOffset,
    required this.titles,
    required this.canonicalTitle,
    required this.abbreviatedTitles,
    required this.averageRating,
    required this.ratingFrequencies,
    required this.userCount,
    required this.favoritesCount,
    required this.startDate,
    required this.endDate,
    required this.nextRelease,
    required this.popularityRank,
    required this.ratingRank,
    required this.ageRating,
    required this.ageRatingGuide,
    required this.subtype,
    required this.status,
    required this.tba,
    required this.posterImage,
    required this.coverImage,
    required this.episodeCount,
    required this.episodeLength,
    required this.totalLength,
    required this.youtubeVideoId,
    required this.showType,
    required this.nsfw,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        slug: json["slug"],
        synopsis: json["synopsis"],
        description: json["description"],
        coverImageTopOffset: json["coverImageTopOffset"],
        titles: Titles.fromJson(json["titles"]),
        canonicalTitle: json["canonicalTitle"],
        abbreviatedTitles:
            List<String>.from(json["abbreviatedTitles"].map((x) => x)),
        averageRating: json["averageRating"] != null ? json["averageRating"] : null,
        ratingFrequencies: Map.from(json["ratingFrequencies"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        userCount: json["userCount"],
        favoritesCount: json["favoritesCount"],
        startDate: DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        nextRelease: json["nextRelease"],
        popularityRank: json["popularityRank"],
        ratingRank: json["ratingRank"] != null ? json["ratingRank"] : null,
        ageRating: json["ageRating"] != null ? json["ageRating"] : null,
        ageRatingGuide: json["ageRatingGuide"] != null ? json["ageRatingGuide"] : null,
        subtype: json["subtype"],
        status: json["status"],
        tba: json["tba"],
        posterImage: json["posterImage"] != null ? PosterImage.fromJson(json["posterImage"]) : null,
        coverImage: json["coverImage"] != null
            ? CoverImage.fromJson(json["coverImage"])
            : null,
        episodeCount: json["episodeCount"],
        episodeLength: json["episodeLength"],
        totalLength: json["totalLength"] != null ? json["totalLength"] : null,
        youtubeVideoId: json["youtubeVideoId"] != null ? json["youtubeVideoId"] : null,
        showType: json["showType"],
        nsfw: json["nsfw"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "slug": slug,
        "synopsis": synopsis,
        "description": description,
        "coverImageTopOffset": coverImageTopOffset,
        "titles": titles.toJson(),
        "canonicalTitle": canonicalTitle,
        "abbreviatedTitles":
            List<dynamic>.from(abbreviatedTitles.map((x) => x)),
        "averageRating": averageRating,
        "ratingFrequencies": Map.from(ratingFrequencies)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "userCount": userCount,
        "favoritesCount": favoritesCount,
        "startDate":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "nextRelease": nextRelease,
        "popularityRank": popularityRank,
        "ratingRank": ratingRank,
        "ageRating": ageRating,
        "ageRatingGuide": ageRatingGuide,
        "subtype": subtype,
        "status": status,
        "tba": tba,
        "posterImage": posterImage?.toJson(),
        "coverImage": coverImage?.toJson(),
        "episodeCount": episodeCount,
        "episodeLength": episodeLength,
        "totalLength": totalLength,
        "youtubeVideoId": youtubeVideoId,
        "showType": showType,
        "nsfw": nsfw,
      };
}

class CoverImage {
  String tiny;
  String large;
  String small;
  String original;
  CoverImageMeta meta;

  CoverImage({
    required this.tiny,
    required this.large,
    required this.small,
    required this.original,
    required this.meta,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
        tiny: json["tiny"],
        large: json["large"],
        small: json["small"],
        original: json["original"],
        meta: CoverImageMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "tiny": tiny,
        "large": large,
        "small": small,
        "original": original,
        "meta": meta.toJson(),
      };
}

class CoverImageMeta {
  Dimensions dimensions;

  CoverImageMeta({
    required this.dimensions,
  });

  factory CoverImageMeta.fromJson(Map<String, dynamic> json) => CoverImageMeta(
        dimensions: Dimensions.fromJson(json["dimensions"]),
      );

  Map<String, dynamic> toJson() => {
        "dimensions": dimensions.toJson(),
      };
}

class Dimensions {
  Large tiny;
  Large large;
  Large small;
  Large? medium;

  Dimensions({
    required this.tiny,
    required this.large,
    required this.small,
    this.medium,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        tiny: Large.fromJson(json["tiny"]),
        large: Large.fromJson(json["large"]),
        small: Large.fromJson(json["small"]),
        medium: json["medium"] == null ? null : Large.fromJson(json["medium"]),
      );

  Map<String, dynamic> toJson() => {
        "tiny": tiny.toJson(),
        "large": large.toJson(),
        "small": small.toJson(),
        "medium": medium?.toJson(),
      };
}

class Large {
  int? width;
  int? height;

  Large({
    required this.width,
    required this.height,
  });

  factory Large.fromJson(Map<String, dynamic> json) => Large(
        width: json["width"] != null ? json["width"] : null,
        height: json["height"] != null ? json["height"] : null,
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
      };
}

class PosterImage {
  String tiny;
  String large;
  String small;
  String medium;
  String original;
  CoverImageMeta meta;

  PosterImage({
    required this.tiny,
    required this.large,
    required this.small,
    required this.medium,
    required this.original,
    required this.meta,
  });

  factory PosterImage.fromJson(Map<String, dynamic> json) => PosterImage(
        tiny: json["tiny"],
        large: json["large"],
        small: json["small"],
        medium: json["medium"],
        original: json["original"],
        meta: CoverImageMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "tiny": tiny,
        "large": large,
        "small": small,
        "medium": medium,
        "original": original,
        "meta": meta.toJson(),
      };
}

class Titles {
  String? en;
  String enJp;
  String jaJp;

  Titles({
    required this.en,
    required this.enJp,
    required this.jaJp,
  });

  factory Titles.fromJson(Map<String, dynamic> json) => Titles(
        en: json["en"],
        enJp: json["en_jp"],
        jaJp: json["ja_jp"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "en_jp": enJp,
        "ja_jp": jaJp,
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

class Relationship {
  RelationshipLinks links;

  Relationship({
    required this.links,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) => Relationship(
        links: RelationshipLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "links": links.toJson(),
      };
}

class RelationshipLinks {
  String self;
  String related;

  RelationshipLinks({
    required this.self,
    required this.related,
  });

  factory RelationshipLinks.fromJson(Map<String, dynamic> json) =>
      RelationshipLinks(
        self: json["self"],
        related: json["related"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "related": related,
      };
}

class AnimeLinks {
  String first;
  String last;

  AnimeLinks({
    required this.first,
    required this.last,
  });

  factory AnimeLinks.fromJson(Map<String, dynamic> json) => AnimeLinks(
        first: json["first"],
        last: json["last"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
      };
}

class AnimeMeta {
  int count;

  AnimeMeta({
    required this.count,
  });

  factory AnimeMeta.fromJson(Map<String, dynamic> json) => AnimeMeta(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}
