import 'package:flutter/material.dart';
import '../../models/localisation.dart';
import '../../services/localisation_service.dart';

class LocalisationPage extends StatefulWidget {
  @override
  _LocalisationPageState createState() => _LocalisationPageState();
}

class _LocalisationPageState extends State<LocalisationPage> {
  final LocalisationService _service = LocalisationService();
  List<Localisation> _localisations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocalisations();
  }

  Future<void> _fetchLocalisations() async {
    try {
      List<Localisation> localisations = await _service.fetchLocalisations();
      setState(() {
        _localisations = localisations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addLocalisation() async {
    final localisation = await _showLocalisationDialog();
    if (localisation != null) {
      await _service.createLocalisation(localisation);
      _fetchLocalisations(); // Actualiser la liste
    }
  }

  void _updateLocalisation(Localisation localisation) async {
    final updatedLocalisation = await _showLocalisationDialog(localisation: localisation);
    if (updatedLocalisation != null) {
      await _service.updateLocalisation(updatedLocalisation.id, updatedLocalisation);
      _fetchLocalisations(); // Actualiser la liste
    }
  }

  Future<Localisation?> _showLocalisationDialog({Localisation? localisation}) {
    final villeController = TextEditingController(text: localisation?.ville);
    final adresseController = TextEditingController(text: localisation?.adresse);
    final paysController = TextEditingController(text: localisation?.pays);

    return showDialog<Localisation>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localisation == null ? 'Ajouter Localisation' : 'Modifier Localisation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: adresseController,
                decoration: InputDecoration(labelText: 'Adresse'),
              ),
              TextField(
                controller: villeController,
                decoration: InputDecoration(labelText: 'Ville'),
              ),
              TextField(
                controller: paysController,
                decoration: InputDecoration(labelText: 'Pays'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newLocalisation = Localisation(
                  id: localisation?.id ?? 0, // Utilisez une valeur par défaut, par exemple 0
                  adresse: adresseController.text,
                  ville: villeController.text,
                  pays: paysController.text,
                );

                Navigator.of(context).pop(newLocalisation);
              },
              child: Text(localisation == null ? 'Ajouter' : 'Modifier'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _deleteLocalisation(Localisation localisation) async {
    await _service.deleteLocalisation(localisation.id);
    _fetchLocalisations(); // Actualiser la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Utiliser Scaffold pour la structure de la page
      appBar: AppBar(
        title: Text('Localisations'), // Assurez-vous que le titre est cohérent
        backgroundColor: Colors.teal, // Même couleur que dans type_de_sport_page
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _localisations.length,
                      itemBuilder: (context, index) {
                        final localisation = _localisations[index];
                        return Card( // Utilisez un Card pour chaque élément
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(localisation.adresse),
                            subtitle: Text('${localisation.ville}, ${localisation.pays}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _updateLocalisation(localisation),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteLocalisation(localisation),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0), // Ajouter un padding autour du bouton
                    child: FloatingActionButton(
                      onPressed: _addLocalisation,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
