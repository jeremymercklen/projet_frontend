enum AnimeState { notSeen, planToWatch, watching, finished }

class ListAnimes {
  late var idAnime;
  late var state;
  late var rating;
  late int numberOfEpisodesSeen;
  late var isFavorite;

  ListAnimes(this.idAnime, this.state, this.rating, this.numberOfEpisodesSeen,
      this.isFavorite);

  ListAnimes.fromMap(Map<String, dynamic> map) {
    idAnime = map['idanime'];
    state = map['state'];
    rating = map['rating'];
    numberOfEpisodesSeen = map['numberofepisodesseen'];
    isFavorite = map['isfavorite'];
  }

  toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAnime'] = this.idAnime;
    data['state'] = this.state;
    data['rating'] = this.rating;
    data['numberOfEpisodesSeen'] = this.numberOfEpisodesSeen;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}
