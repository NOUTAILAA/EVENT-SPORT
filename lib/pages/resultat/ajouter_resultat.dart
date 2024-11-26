import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';

class AjouterResultatPage extends StatefulWidget {
  @override
  _AjouterResultatPageState createState() => _AjouterResultatPageState();
}

class _AjouterResultatPageState extends State<AjouterResultatPage> {
  final EvenementService _evenementService = EvenementService();

  List<Evenement> _evenements = [];
  List<Map<String, dynamic>> _equipes = [];

  Evenement? _selectedEvenement;
  Map<String, dynamic>? _selectedEquipe;
  final TextEditingController _nombreButsController = TextEditingController(text: "0");
  final TextEditingController _tempsController = TextEditingController(text: "0");

  bool _isLoadingEvenements = true;
  bool _isLoadingEquipes = false;

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    try {
      List<Evenement> evenements = await _evenementService.fetchEvenements();
      setState(() {
        _evenements = evenements;
        _isLoadingEvenements = false;
      });
    } catch (e) {
      _showError("Erreur lors du chargement des événements");
    }
  }

  Future<void> _loadEquipes(int evenementId) async {
    setState(() {
      _isLoadingEquipes = true;
    });
    try {
      Map<String, dynamic> evenementDetails =
          await _evenementService.fetchEvenementDetails(evenementId);
      setState(() {
        _equipes = (evenementDetails['equipes'] as List)
            .map((equipe) => equipe as Map<String, dynamic>)
            .toList();
        _selectedEquipe = null;
        _isLoadingEquipes = false;
      });
    } catch (e) {
      _showError("Erreur lors du chargement des équipes");
      setState(() {
        _isLoadingEquipes = false;
      });
    }
  }

  Future<void> _ajouterResultat() async {
    if (_selectedEvenement == null || _selectedEquipe == null) {
      _showError("Veuillez sélectionner un événement et une équipe");
      return;
    }

    int? nombreButs = int.tryParse(_nombreButsController.text) ?? 0;
    double? temps = double.tryParse(_tempsController.text) ?? 0.0;

    try {
      await _evenementService.ajouterResultat(
        _selectedEvenement!.id,
        _selectedEquipe!['equipeId'],
        nombreButs,
        temps: temps,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Résultat ajouté avec succès")),
      );
      _nombreButsController.text = "0"; // Reset to default
      _tempsController.text = "0"; // Reset to default
    } catch (e) {
      _showError("Erreur : ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter Résultat"),
        backgroundColor: Colors.teal,
      ),
      body: _isLoadingEvenements
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              DropdownButton<Evenement>(
                                isExpanded: true,
                                hint: Text("Sélectionner un événement"),
                                value: _selectedEvenement,
                                onChanged: (Evenement? newValue) {
                                  setState(() {
                                    _selectedEvenement = newValue;
                                    _equipes = [];
                                    _selectedEquipe = null;
                                  });
                                  if (newValue != null) {
                                    _loadEquipes(newValue.id);
                                  }
                                },
                                items: _evenements
                                    .map((evenement) => DropdownMenuItem<Evenement>(
                                          value: evenement,
                                          child: Text(evenement.nom),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              _isLoadingEquipes
                                  ? Center(child: CircularProgressIndicator())
                                  : DropdownButton<Map<String, dynamic>>(
                                      isExpanded: true,
                                      hint: Text("Sélectionner une équipe"),
                                      value: _selectedEquipe,
                                      onChanged: (Map<String, dynamic>? newValue) {
                                        setState(() {
                                          _selectedEquipe = newValue;
                                        });
                                      },
                                      items: _equipes
                                          .map((equipe) => DropdownMenuItem<Map<String, dynamic>>(
                                                value: equipe,
                                                child: Text("Équipe ID: ${equipe['equipeId']}"),
                                              ))
                                          .toList(),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nombre de buts",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextField(
                                controller: _nombreButsController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Temps (optionnel)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextField(
                                controller: _tempsController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _ajouterResultat,
                    child: Text("Ajouter Résultat"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
