import 'package:flutter/material.dart';
import '../../models/type_de_sport.dart';
import '../../services/type_de_sport_service.dart';

class AddTypeDeSportPage extends StatefulWidget {
  @override
  _AddTypeDeSportPageState createState() => _AddTypeDeSportPageState();
}

class _AddTypeDeSportPageState extends State<AddTypeDeSportPage> {
  final _formKey = GlobalKey<FormState>();
  final _typeDeSportService = TypeDeSportService();

  String _nom = '';
  int _nombreEquipesMax = 0;
  int _nombreParticipantsParEquipe = 0;

  Future<void> _saveTypeDeSport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Assurez-vous que le constructeur TypeDeSport accepte ces paramètres
      TypeDeSport newType = TypeDeSport(
        id: null, // Si l'ID est auto-généré, utilisez null ou un identifiant approprié
        nom: _nom,
        nombreEquipesMax: _nombreEquipesMax,
        nombreParticipantsParEquipe: _nombreParticipantsParEquipe,
      );

      await _typeDeSportService.createTypeDeSport(newType);
      Navigator.pop(context, true); // Retourne à la page précédente avec un succès
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Type de Sport'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du sport'),
                onSaved: (value) => _nom = value!,
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre maximal d\'équipes'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _nombreEquipesMax = int.parse(value!),
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Participants par équipe'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _nombreParticipantsParEquipe = int.parse(value!),
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTypeDeSport,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
