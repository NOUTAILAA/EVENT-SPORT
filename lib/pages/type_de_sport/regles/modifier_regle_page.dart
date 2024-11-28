import 'package:flutter/material.dart';
import '../../../models/regle.dart';
import '../../../services/regles_service.dart';

class ModifierReglePage extends StatefulWidget {
  final Regle regle;
  final Function refreshPage; // Fonction pour rafraîchir la page principale

  ModifierReglePage({required this.regle, required this.refreshPage});

  @override
  _ModifierReglePageState createState() => _ModifierReglePageState();
}

class _ModifierReglePageState extends State<ModifierReglePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final RegleService _regleService = RegleService();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.regle.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier la règle"),
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
                onPressed: _updateRegle,
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour mettre à jour la règle
  void _updateRegle() async {
    if (_formKey.currentState?.validate() ?? false) {
      Regle updatedRegle = Regle(
        id: widget.regle.id,
        description: _descriptionController.text,
      );

      try {
        await _regleService.updateRegle(updatedRegle.id!, updatedRegle);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Règle mise à jour')));
        widget.refreshPage(); // Rafraîchit la page principale
        Navigator.pop(context); // Retour à la page précédente après mise à jour
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour')));
      }
    }
  }
}
