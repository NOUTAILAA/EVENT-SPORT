import 'package:flutter/material.dart';
import '../../models/type_de_sport.dart';
import '../../services/type_de_sport_service.dart';

class UpdateTypeDeSportPage extends StatefulWidget {
  final TypeDeSport typeDeSport;

  UpdateTypeDeSportPage({required this.typeDeSport});

  @override
  _UpdateTypeDeSportPageState createState() => _UpdateTypeDeSportPageState();
}

class _UpdateTypeDeSportPageState extends State<UpdateTypeDeSportPage> {
  final _formKey = GlobalKey<FormState>();
  late String _nom;
  late int _nombreEquipesMax;
  late int _nombreParticipantsParEquipe;

  @override
  void initState() {
    super.initState();
    _nom = widget.typeDeSport.nom;
    _nombreEquipesMax = widget.typeDeSport.nombreEquipesMax;
    _nombreParticipantsParEquipe = widget.typeDeSport.nombreParticipantsParEquipe;
  }

  void _updateTypeDeSport() async {
    if (_formKey.currentState!.validate()) {
      TypeDeSport updatedType = TypeDeSport(
        id: widget.typeDeSport.id, // Assurez-vous que l'id est inclus
        nom: _nom,
        nombreEquipesMax: _nombreEquipesMax,
        nombreParticipantsParEquipe: _nombreParticipantsParEquipe,
      );

      await TypeDeSportService().updateTypeDeSport(updatedType);
      Navigator.pop(context, true); // Retourne à la page précédente avec un succès
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mettre à jour Type de Sport'),
        backgroundColor: Colors.teal, // Utilisez la même couleur que l'autre page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nom,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                onChanged: (value) => _nom = value,
                validator: (value) => value!.isEmpty ? 'Entrez un nom' : null,
              ),
              TextFormField(
                initialValue: _nombreEquipesMax.toString(),
                decoration: InputDecoration(
                  labelText: 'Nombre d\'équipes max',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _nombreEquipesMax = int.parse(value),
                validator: (value) => value!.isEmpty ? 'Entrez un nombre' : null,
              ),
              TextFormField(
                initialValue: _nombreParticipantsParEquipe.toString(),
                decoration: InputDecoration(
                  labelText: 'Nombre de participants par équipe',
                  labelStyle: TextStyle(color: Colors.teal),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _nombreParticipantsParEquipe = int.parse(value),
                validator: (value) => value!.isEmpty ? 'Entrez un nombre' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTypeDeSport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Couleur du bouton
                ),
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
