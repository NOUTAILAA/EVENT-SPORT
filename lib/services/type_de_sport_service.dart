import 'package:flutter/material.dart';
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

}

class SportListPage extends StatefulWidget {
  @override
  _SportListPageState createState() => _SportListPageState();
}

class _SportListPageState extends State<SportListPage> {
  late Future<List<TypeDeSport>> typesDeSport;

  @override
  void initState() {
    super.initState();
    typesDeSport = TypeDeSportService().fetchTypesDeSport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Types de Sport"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<TypeDeSport>>(
        future: typesDeSport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun type de sport disponible"));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final typeDeSport = snapshot.data![index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeDeSport.nom,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Nombre d'équipes max: ${typeDeSport.nombreEquipesMax}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                        Text(
                          "Participants par équipe: ${typeDeSport.nombreParticipantsParEquipe}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
