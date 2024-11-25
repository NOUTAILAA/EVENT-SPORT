import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';
import '../../services/participant_service.dart';
import '../../models/participant.dart';
import 'package:http/http.dart' as http; // Pour http.Response

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

  /// Afficher la liste des participants et permettre de sélectionner un participant
  void _addParticipant(BuildContext context, int evenementId) async {
    final participantService = ParticipantService();

    try {
      // Récupérer la liste des participants
      final participants = await participantService.fetchParticipants();

      showDialog(
        context: context,
        builder: (context) {
          Participant? selectedParticipant;

          return AlertDialog(
            title: Text('Sélectionner un Participant'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DropdownButton<Participant>(
                  value: selectedParticipant,
                  hint: Text("Choisissez un participant"),
                  items: participants.map((participant) {
                    return DropdownMenuItem<Participant>(
                      value: participant,
                      child: Text(participant.name), // Afficher le nom du participant
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedParticipant = value!;
                    });
                  },
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedParticipant != null) {
                    _registerParticipant(context, evenementId, selectedParticipant!.id);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Veuillez sélectionner un participant')),
                    );
                  }
                },
                child: Text('Ajouter'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des participants')),
      );
    }
  }

  /// Enregistrer un participant sélectionné pour cet événement
 void _registerParticipant(BuildContext context, int evenementId, int participantId) async {
  final service = EvenementService();
  try {
    await service.inscrireParticipant(evenementId, participantId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Participant ajouté avec succès')),
    );
  } catch (e) {
    if (e is http.ClientException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion : ${e.message}')),
      );
    } else if (e is Exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur inattendue')),
      );
    }
  }
}



  /// Charger les détails de l'événement
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
            final eventDate = data['date'] ?? 'Date non disponible';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Details
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
                              'Date: $eventDate',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
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
                    SizedBox(height: 16),

                    // Teams and Participants Section
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
                              Text(
                                'Équipe ID: $equipeId',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              ...participants.map((participant) {
                                final participantName = participant['name'];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                                  child: Text(
                                    participantName ?? 'Nom inconnu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16),
                    // Button to Add Participant
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _addParticipant(context, evenement.id),
                        child: Text('Ajouter un participant'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                      ),
                    ),
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
