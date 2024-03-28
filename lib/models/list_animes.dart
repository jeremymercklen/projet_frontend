enum AnimeState { planToWatch, watching, finished }

class ListAnimes {
  late var idAPI;
  late var state;
  late var rating;
  late var numberOfEpisodesSeen;
  late var isFavorite;
  late var userId;

  ListAnimes(this.idAPI, this.state, this.rating, this.numberOfEpisodesSeen,
      this.isFavorite, this.userId);

  ListAnimes.fromMap(Map<String, dynamic> map) {
    idAPI = map['idAPI'];
    state = map['state'];
    rating = map['rating'];
    numberOfEpisodesSeen = map['numberOfEpisodesSeen'];
    isFavorite = map['isFavorite'];
    userId = map['userId'];
  }

  toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAPI'] = this.idAPI;
    data['state'] = this.state;
    data['rating'] = this.rating;
    data['numberOfEpisodesSeen'] = this.numberOfEpisodesSeen;
    data['isFavorite'] = this.isFavorite;
    data['userId'] = this.userId;
    return data;
  }
}
