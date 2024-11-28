import 'package:flutter/material.dart';
import '../../../models/regle.dart';
import '../../../services/regles_service.dart';

class AjouterReglePage extends StatefulWidget {
  final Function refreshPage; // Cette fonction sera utilisée pour rafraîchir la page principale

  AjouterReglePage({required this.refreshPage});

  @override
  _AjouterReglePageState createState() => _AjouterReglePageState();
}

class _AjouterReglePageState extends State<AjouterReglePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final RegleService _regleService = RegleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une Règle"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description de la règle',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addRegle,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour ajouter une règle
  void _addRegle() async {
    if (_formKey.currentState?.validate() ?? false) {
      Regle newRegle = Regle(
        id: null, // L'ID est null car il est généré côté serveur
        description: _descriptionController.text,
      );

      try {
        await _regleService.addRegle(newRegle);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Règle ajoutée avec succès')),
        );
        widget.refreshPage(); // Rafraîchit la page principale
        Navigator.pop(context); // Retour à la page précédente après ajout
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de la règle')),
        );
      }
    }
  }
}
