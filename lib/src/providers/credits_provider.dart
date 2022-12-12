import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
// import 'package:scooby_app/src/models/pelicula_model.dart';

class CreditsProvider {
  String _apikey = 'cc5e4e5ef8fb4113f47bfe29ca173e32';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<String> getPeliId(String creditId) async {
    final url = Uri.https(_url, '3/credit/${creditId}',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    return decodedData["id"];
  }
}
