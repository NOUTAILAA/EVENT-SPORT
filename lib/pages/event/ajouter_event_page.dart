import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../services/event_service.dart';

class AjouterEvenementPage extends StatefulWidget {
  @override
  _AjouterEvenementPageState createState() => _AjouterEvenementPageState();
}

class _AjouterEvenementPageState extends State<AjouterEvenementPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();

  late Future<Map<int, String>> futureLocalisations;
  late Future<Map<int, String>> futureTypesDeSport;

  int? _selectedLocalisation;
  int? _selectedTypeDeSport;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final service = EvenementService();
    futureLocalisations = service.fetchLocalisationNames();
    futureTypesDeSport = service.fetchTypeDeSportNames();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedLocalisation != null &&
        _selectedTypeDeSport != null &&
        _selectedDate != null) {
      final nom = _nomController.text;
      final prix = double.parse(_prixController.text);

      final evenementData = {
        'nom': nom,
        'localisationId': _selectedLocalisation,
        'typeDeSportId': _selectedTypeDeSport,
        'prix': prix,
        'date': _selectedDate!.toIso8601String(),
      };

      final service = EvenementService();
      try {
        await service.creerEvenement(evenementData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Événement créé avec succès!')),
        );
        Navigator.pop(context); // Retour à la page précédente
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de l\'événement')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Événement'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom de l'événement
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom de l\'événement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Localisation
              FutureBuilder<Map<int, String>>(
                future: futureLocalisations,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final localisations = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    value: _selectedLocalisation,
                    decoration: InputDecoration(labelText: 'Localisation'),
                    items: localisations.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocalisation = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Veuillez sélectionner une localisation' : null,
                  );
                },
              ),
              SizedBox(height: 16),

              // Type de sport
              FutureBuilder<Map<int, String>>(
                future: futureTypesDeSport,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final typesDeSport = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    value: _selectedTypeDeSport,
                    decoration: InputDecoration(labelText: 'Type de Sport'),
                    items: typesDeSport.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeDeSport = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Veuillez sélectionner un type de sport' : null,
                  );
                },
              ),
              SizedBox(height: 16),

              // Prix
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix (€)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Aucune date sélectionnée'
                          : 'Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Sélectionner une date'),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Bouton Soumettre
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Créer l\'événement'),
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
