import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/localisation.dart';

class LocalisationService {
  final String baseUrl = 'http://192.168.137.1:8090/api/localisations';

  Future<List<Localisation>> fetchLocalisations() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Localisation> localisations = body.map((dynamic item) => Localisation.fromJson(item)).toList();
      return localisations;
    } else {
      throw Exception('Failed to load localisations');
    }
  }

  Future<Localisation> createLocalisation(Localisation localisation) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(localisation.toJson()), // Assurez-vous que Localisation a une méthode toJson
    );

    if (response.statusCode == 201) {
      return Localisation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create localisation');
    }
  }

  Future<Localisation> updateLocalisation(int id, Localisation localisation) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(localisation.toJson()), // Assurez-vous que Localisation a une méthode toJson
    );

    if (response.statusCode == 200) {
      return Localisation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update localisation');
    }
  }

  Future<void> deleteLocalisation(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete localisation');
    }
  }
}
