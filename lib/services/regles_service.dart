import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/regle.dart';

class RegleService {
  final String baseUrl = 'http://192.168.1.107:8090/api/regles';

  // Récupérer toutes les règles
 Future<List<Regle>> fetchRegles() async {
  final response = await http.get(Uri.parse('$baseUrl'));

  print('Réponse de l\'API: ${response.body}');  // Afficher la réponse brute pour débogage
  
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Regle.fromJson(json)).toList();
  } else {
    throw Exception('Erreur lors de la récupération des règles');
  }
}

  // Ajouter une nouvelle règle
 Future<void> addRegle(Regle regle) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(regle.toJson()),
  );

  print('Réponse de l\'API lors de l\'ajout: ${response.body}');  // Ajoutez ce log pour vérifier la réponse complète

  if (response.statusCode != 200) {
    print('Erreur HTTP: ${response.statusCode}'); // Vérification de l'erreur HTTP
    throw Exception('Échec de l\'ajout de la règle');
  }
}


  // Modifier une règle existante
  Future<void> updateRegle(int id, Regle regle) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(regle.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour de la règle');
    }
  }

  // Supprimer une règle
  Future<void> deleteRegle(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression de la règle');
    }
  }
 // Fetch rules for a specific TypeDeSport
  Future<List<Regle>> fetchReglesForTypeDeSport(int typeDeSportId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/typeDeSport/$typeDeSportId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Regle.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load rules');
      }
    } catch (e) {
      throw Exception('Error fetching rules: $e');
    }
  }
}
