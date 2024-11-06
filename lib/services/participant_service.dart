import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/participant.dart';

class ParticipantService {
  final String baseUrl = 'http://192.168.1.107:8090/participants';  // Assurez-vous que l'API est bien sur ce port

  // Fonction pour récupérer tous les participants
  Future<List<Participant>> fetchParticipants() async {
    final response = await http.get(Uri.parse('$baseUrl/liste'));  // L'endpoint correct pour la liste des participants

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Participant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load participants');
    }
  }

  // Fonction pour ajouter un participant
  Future<void> createParticipant(Participant participant) async {
    final response = await http.post(
      Uri.parse('$baseUrl/creer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(participant.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create participant');
    }
  }

  // Fonction pour mettre à jour un participant
  Future<void> updateParticipant(int id, Participant participant) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(participant.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update participant');
    }
  }

  // Fonction pour supprimer un participant
  Future<void> deleteParticipant(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete participant');
    }
  }
}
