import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';

class EvenementDetailsPage extends StatelessWidget {
  final Evenement evenement;
  final String typeDeSportName;
  final String localisationName;

  const EvenementDetailsPage({
    Key? key,
    required this.evenement,
    required this.typeDeSportName,
    required this.localisationName,
  }) : super(key: key);

  Future<Map<String, dynamic>> fetchEventDetails(BuildContext context) async {
    final service = EvenementService();
    return await service.fetchEvenementDetails(evenement.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'événement'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchEventDetails(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 8),
                  Text(
                    'Erreur: ${snapshot.error}',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Aucune donnée disponible',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final data = snapshot.data!;
            final equipes = data['equipes'] as List<dynamic>? ?? [];
            final resultats = data['resultats'] as List<dynamic>? ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Title
                    Card(
                      color: Colors.teal[50],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              evenement.nom,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Type de Sport: $typeDeSportName',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
                            Text(
                              'Localisation: $localisationName',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
                            Text(
                              'Prix: ${evenement.prix.toStringAsFixed(2)} €',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Teams and Participants
                    Text(
                      'Équipes et Participants:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Divider(thickness: 2, color: Colors.teal),
                    SizedBox(height: 16),

                    ...equipes.map((equipe) {
                      final equipeId = equipe['equipeId'];
                      final participants = equipe['participants'] as List<dynamic>? ?? [];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.group, color: Colors.teal, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Équipe ID: $equipeId',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[700],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ...participants.map((participant) {
                                final participantName = participant['name'];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, size: 18, color: Colors.grey[700]),
                                      SizedBox(width: 8),
                                      Text(
                                        participantName ?? 'Nom inconnu',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 24),

                    // Results
                    Text(
                      'Résultats:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Divider(thickness: 2, color: Colors.teal),
                    SizedBox(height: 16),

                    if (resultats.isEmpty)
                      Text(
                        'Aucun résultat disponible.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    else
                      ...resultats.map((resultat) {
                        final equipeId = resultat['equipeId'];
                        final participantId = resultat['participantId'];
                        final nombreButs = resultat['nombreButs'];
                        final temps = resultat['temps'];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  equipeId != null
                                      ? 'Équipe ID: $equipeId'
                                      : 'Participant ID: $participantId',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                if (nombreButs != null)
                                  Text(
                                    'Nombre de buts: $nombreButs',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                if (temps != null)
                                  Text(
                                    'Temps: ${temps.toStringAsFixed(2)} secondes',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
