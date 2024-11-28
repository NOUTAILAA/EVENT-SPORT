import 'package:flutter/material.dart';
import '../../models/type_de_sport.dart';
import '../../services/type_de_sport_service.dart';
import './regles/selectionner_regles_page.dart'; // Importer la page des règles générales
import '../../services/regles_service.dart';
import '../../models/regle.dart';

class UpdateTypeDeSportPage extends StatefulWidget {
  final TypeDeSport typeDeSport;

  UpdateTypeDeSportPage({required this.typeDeSport});

  @override
  _UpdateTypeDeSportPageState createState() => _UpdateTypeDeSportPageState();
}

class _UpdateTypeDeSportPageState extends State<UpdateTypeDeSportPage> {
  final _formKey = GlobalKey<FormState>();
  final _typeDeSportService = TypeDeSportService();
  final _regleService = RegleService(); // Service pour récupérer les règles

  late String _nom;
  late int _nombreEquipesMax;
  late int _nombreParticipantsParEquipe;
  List<Regle> _regles = []; // Liste pour stocker les règles associées
  List<int> _selectedRegles = []; // Liste des règles sélectionnées

  @override
  void initState() {
    super.initState();
    _nom = widget.typeDeSport.nom;
    _nombreEquipesMax = widget.typeDeSport.nombreEquipesMax;
    _nombreParticipantsParEquipe = widget.typeDeSport.nombreParticipantsParEquipe;
    
    // Charger les règles associées au TypeDeSport
    _fetchRegles();
  }

  // Charger les règles associées au TypeDeSport depuis l'API
  Future<void> _fetchRegles() async {
    try {
      List<Regle> regles = await _regleService.fetchReglesForTypeDeSport(widget.typeDeSport.id!);
      setState(() {
        _regles = regles;
      });
    } catch (e) {
      print('Erreur lors de la récupération des règles: $e');
    }
  }

  // Enregistrer les modifications du TypeDeSport
  Future<void> _saveTypeDeSport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      TypeDeSport updatedTypeDeSport = TypeDeSport(
        id: widget.typeDeSport.id,
        nom: _nom,
        nombreEquipesMax: _nombreEquipesMax,
        nombreParticipantsParEquipe: _nombreParticipantsParEquipe,
      );

      try {
        await _typeDeSportService.updateTypeDeSport(updatedTypeDeSport);
        // Envoyer les règles sélectionnées à l'API
        await _typeDeSportService.associerReglesAuTypeDeSport(widget.typeDeSport.id!, _selectedRegles);
        Navigator.pop(context, true); // Retourner à la page précédente avec succès
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement du type de sport')),
        );
      }
    }
  }

  // Dissocier une règle du TypeDeSport
  void _removeRegleFromSport(int regleId) async {
    try {
      await _typeDeSportService.dissocierRegleDuTypeDeSport(widget.typeDeSport.id!, regleId);
      
      setState(() {
        // Supprimer la règle de la liste des règles associées
        _regles.removeWhere((regle) => regle.id == regleId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Règle supprimée du type de sport')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression de la règle')),
      );
    }
  }

  // Fonction pour afficher la page de gestion des règles
  void _assignReglesToSport() async {
    final selectedRegles = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GGererReglesPage(
          typeDeSportId: widget.typeDeSport.id!,
          selectedRegles: _selectedRegles,
        ),
      ),
    );

    if (selectedRegles != null && selectedRegles is List<int>) {
      setState(() {
        _selectedRegles = selectedRegles; // Mettre à jour les règles sélectionnées
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mettre à jour Type de Sport'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ pour le nom du sport
              TextFormField(
                initialValue: _nom,
                decoration: InputDecoration(labelText: 'Nom du sport'),
                onSaved: (value) => _nom = value!,
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              // Champ pour le nombre maximal d'équipes
              TextFormField(
                initialValue: _nombreEquipesMax.toString(),
                decoration: InputDecoration(labelText: 'Nombre maximal d\'équipes'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _nombreEquipesMax = int.parse(value!),
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              // Champ pour le nombre de participants par équipe
              TextFormField(
                initialValue: _nombreParticipantsParEquipe.toString(),
                decoration: InputDecoration(labelText: 'Participants par équipe'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _nombreParticipantsParEquipe = int.parse(value!),
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 20),
              
              // Affichage des règles associées avec un bouton "Supprimer"
              Text('Règles associées:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._regles.map((regle) {
                return ListTile(
                  title: Text(regle.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeRegleFromSport(regle.id!),
                  ),
                );
              }).toList(),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTypeDeSport,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text('Enregistrer'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _assignReglesToSport,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: Text('Assigner des Règles'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
