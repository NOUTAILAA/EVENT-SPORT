import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';
import '../../services/participant_service.dart';
import '../../models/participant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EvenementDetailsPage extends StatefulWidget {
  final Evenement evenement;
  final String typeDeSportName;
  final String localisationName;

  const EvenementDetailsPage({
    Key? key,
    required this.evenement,
    required this.typeDeSportName,
    required this.localisationName,
  }) : super(key: key);

  @override
  _EvenementDetailsPageState createState() => _EvenementDetailsPageState();
}

class _EvenementDetailsPageState extends State<EvenementDetailsPage> {
  late Map<String, dynamic> eventDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    try {
      final details = await EvenementService().fetchEvenementDetails(widget.evenement.id);
      setState(() {
        eventDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des détails: ${e.toString()}')),
      );
    }
  }

  void _addParticipant(BuildContext context, int evenementId) async {
    final participantService = ParticipantService();

    try {
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
                      child: Text(participant.name),
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

  void _registerParticipant(BuildContext context, int evenementId, int participantId) async {
    final service = EvenementService();
    try {
      await service.inscrireParticipant(evenementId, participantId);
      _loadEventDetails(); // Refresh event details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Participant ajouté avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Widget _buildResultsSection(List<dynamic> resultats) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Résultats:',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Divider(thickness: 2, color: Colors.teal),
      ...resultats.map((resultat) {
        // Formater le texte pour les buts et le temps seulement s'ils ne sont pas 'N/A'
        var butsText = (resultat['nombreButs'] != null && resultat['nombreButs'] != 'N/A') ? 'Buts: ${resultat['nombreButs']}' : '';
        var tempsText = (resultat['temps'] != null && resultat['temps'] != 'N/A') ? 'Temps: ${resultat['temps'].toStringAsFixed(2)}' : '';
        // Combinez les textes, en omettant les champs 'N/A'
        var displayText = [butsText, tempsText].where((text) => text.isNotEmpty).join(', ');

        return Card(
          elevation: 2,
          child: ListTile(
            title: Text('Équipe: ${resultat['equipeId']}'),
            trailing: Text(displayText.isNotEmpty ? displayText : 'Aucune donnée'),
          ),
        );
      }).toList(),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'événement'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.teal[50],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.evenement.nom,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date: ${eventDetails['date'] ?? 'Date non disponible'}',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
                            Text(
                              'Type de Sport: ${widget.typeDeSportName}',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
                            Text(
                              'Localisation: ${widget.localisationName}',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
                            Text(
                              'Prix: ${widget.evenement.prix.toStringAsFixed(2)} €',
                              style: TextStyle(fontSize: 18, color: Colors.teal[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (eventDetails.containsKey('equipes'))
                      ...eventDetails['equipes'].map<Widget>((equipe) {
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
                                  'Équipe ${equipe['equipeId']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                ...equipe['participants'].map<Widget>((participant) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                                    child: Text(
                                      participant['name'],
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
                    // Results Section
                    if (eventDetails.containsKey('resultats') && eventDetails['resultats'].isNotEmpty)
                      _buildResultsSection(eventDetails['resultats']),
                    SizedBox(height: 16),
                    // Button to Add Participant
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _addParticipant(context, widget.evenement.id),
                        child: Text('Ajouter un participant'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
