import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
// import 'package:scooby_app/src/models/pelicula_model.dart';

class ActoresProvider {
  String _apikey = 'cc5e4e5ef8fb4113f47bfe29ca173e32';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Actor> _populares = [];

  final _popularesStreamController = StreamController<List<Actor>>.broadcast();

  Function(List<Actor>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Actor>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Actor>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final actores = new Actor.fromJsonList(decodedData['results']);
    List<Actor> actoresFinal = await getListActores(actores.items);

    return actoresFinal;
  }

  Future<List<Actor>> getListActores(actoresPrev) async {
    final actoresProvider = new ActoresProvider();
    List<Actor> actoresList = [];

    for (var actor in actoresPrev) {
      actoresList.add(await actoresProvider.getActor(actor.id));
    }

    return actoresList;
  }

  Future<List<Actor>> getPopulares() async {
    final url = Uri.https(_url, '3/person/popular',
        {'api_key': _apikey, 'language': _language}); // Pelicula
    return await _procesarRespuesta(url);
  }

  Future<Actor> getActor(int peopleId) async {
    final url = Uri.https(_url, '3/person/${peopleId}',
        {'api_key': _apikey, 'language': _language}); // actores

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final actor = new Actor(
      id: decodedData["id"],
      name: decodedData["name"],
      gender: decodedData["gender"],
      profilePath: decodedData["profile_path"],
      biography: decodedData["biography"] == ""
          ? "No hay información."
          : decodedData["biography"],
    );

    return actor;
  }

  Future<List<Pelicula>> getPelis(String actorId) async {
    final url = Uri.https(_url, '3/person/${actorId}/movie_credits',
        {'api_key': _apikey, 'language': _language}); // pelicula

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    var pelisCredits = decodedData.values.elementAt(0);
    // final pelisCredits = new Peliculas.fromJsonList(decodedData['cast']);

    List<Pelicula> peliculasList;
    for (var peliCred in pelisCredits) {
      Pelicula peli = new Pelicula();
      peli.originalTitle = peliCred["original_title"].toString();
      peli.posterPath = peliCred["poster_path"];
      peliculasList.add(peli);
    }

    return peliculasList;
  }

  // Future<List<Actor>> getActoresPopulares() async {
  //   final url = Uri.https(_url, '3/person/popular',
  //       {'api_key': _apikey, 'language': _language}); // actores

  //   final resp = await http.get(url);
  //   final decodedData = json.decode(resp.body);
  //   final results = decodedData.values.elementAt(1);

  //   List<Actor> actoresList = [];
  //   for (var i = 0; i < results.length; i++) {
  //     final actor = new Actor();
  //     actor.id = results[i]["id"];
  //     actor.name = results[i]["name"];
  //     actor.gender = results[i]["gender"];
  //     actor.profilePath = results[i]["profile_path"];
  //     actoresList.add(actor);
  //   }
  //   return actoresList;
  // }

  Future<List<Actor>> getActoresPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/person/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    }); // Actores
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }
}
