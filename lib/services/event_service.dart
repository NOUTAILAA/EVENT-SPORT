import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/event.dart';

class EvenementService {
  final String baseUrl = 'http://192.168.1.107:8090';

  Future<List<Evenement>> fetchEvenements() async {
    final response = await http.get(Uri.parse('$baseUrl/evenements/listeSimple'));

    if (response.statusCode == 200) {
      List<dynamic> evenementJson = json.decode(response.body);
      return evenementJson.map((json) => Evenement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<Map<int, String>> fetchTypeDeSportNames() async {
    final response = await http.get(Uri.parse('$baseUrl/typesport/liste')); // Adjust API path

    if (response.statusCode == 200) {
      List<dynamic> typeDeSportJson = json.decode(response.body);
      return {for (var item in typeDeSportJson) item['id']: item['nom']};
    } else {
      throw Exception('Failed to load type de sport names');
    }
  }

  Future<Map<int, String>> fetchLocalisationNames() async {
    final response = await http.get(Uri.parse('$baseUrl/api/localisations')); // Adjust API path

    if (response.statusCode == 200) {
      List<dynamic> localisationJson = json.decode(response.body);
      return {for (var item in localisationJson) item['id']: item['ville']};
    } else {
      throw Exception('Failed to load localisation names');
    }
  }
  Future<Map<String, dynamic>> fetchEvenementDetails(int evenementId) async {
  final response = await http.get(Uri.parse('$baseUrl/evenements/$evenementId'));

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to load event details');
  }
}

}
