class Cast {
  List<Actor> actores = [];

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    });
  }
}

class Actor {
  List<Actor> items = [];

  String uniqueId;
  // int castId;
  // String character;
  // String creditId;
  int gender;
  int id;
  String name;
  // int order;
  String profilePath;
  String biography;

  Actor({
    // this.castId,
    // this.character,
    // this.creditId,
    this.gender,
    this.id,
    this.name,
    // this.order,
    this.profilePath,
    this.biography,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    profilePath = json['profile_path'];
    biography = json['biography'];
  }

  Actor.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final actor = new Actor.fromJsonMap(item);
      if (actor.biography == null) {
        actor.biography = "No description. Id: ${actor.id}";
      }
      items.add(actor);
    }
  }

  getFoto() {
    if (profilePath == null) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
