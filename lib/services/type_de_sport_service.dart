import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/type_de_sport.dart';

class TypeDeSportService {
  final String baseUrl = 'http://192.168.1.107:8090/typesport';
// LISTE DES TYPES DE SPORTS
  Future<List<TypeDeSport>> fetchTypesDeSport() async {
    final response = await http.get(Uri.parse('$baseUrl/liste'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => TypeDeSport.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load types de sport');
    }
  }
  // AJOUTER LISTE DES TYPES DE SPORT
  Future<void> createTypeDeSport(TypeDeSport typeDeSport) async {
    final response = await http.post(
      Uri.parse('$baseUrl/creer'), // Mettez l'URL appropriée pour ajouter un type de sport
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(typeDeSport.toJson()), // Utilisez la méthode toJson() pour convertir l'objet en JSON
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create type de sport');
    }
  }
  // MODIFIERRRR TYPE DE SPORT 
  Future<void> updateTypeDeSport(TypeDeSport typeDeSport) async {
  final response = await http.put(
    Uri.parse('$baseUrl/mettreajour/${typeDeSport.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(typeDeSport.toJson()), // Assurez-vous d'utiliser jsonEncode ici
  );

  if (response.statusCode != 200) {
    throw Exception('Échec de la mise à jour du type de sport');
  }
}
Future<void> associerReglesAuTypeDeSport(int typeDeSportId, List<int> regleIds) async {
  final response = await http.put(
    Uri.parse('$baseUrl/ajouter-regles/$typeDeSportId'),
    headers: {"Content-Type": "application/json"},
    body: json.encode(regleIds), // Envoyer les ID des règles à associer
  );

  if (response.statusCode != 200) {
    throw Exception('Erreur lors de l\'association des règles');
  }
}

}
