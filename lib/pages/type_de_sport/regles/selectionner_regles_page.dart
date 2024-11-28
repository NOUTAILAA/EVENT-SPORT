import 'package:flutter/material.dart';
import '../../../models/regle.dart';
import '../../../services/regles_service.dart';

class GGererReglesPage extends StatefulWidget {
  final int typeDeSportId;
  final List<int> selectedRegles; // Liste des règles déjà sélectionnées

  GGererReglesPage({required this.typeDeSportId, required this.selectedRegles});

  @override
  _GererReglesPageState createState() => _GererReglesPageState();
}

class _GererReglesPageState extends State<GGererReglesPage> {
  final RegleService _regleService = RegleService();
  late List<Regle> _allRegles; // Liste de toutes les règles disponibles
  List<int> _selectedReglesLocal = []; // Liste des règles sélectionnées localement
  bool _isLoading = true; // Pour afficher un indicateur de chargement

  @override
  void initState() {
    super.initState();
    _selectedReglesLocal = List.from(widget.selectedRegles); // Charger les règles sélectionnées
    _fetchRegles(); // Charger les règles disponibles
  }

  // Fonction pour récupérer toutes les règles
  Future<void> _fetchRegles() async {
    try {
      List<Regle> regles = await _regleService.fetchReglesSansTypeDeSport(widget.typeDeSportId);
      setState(() {
        _allRegles = regles;
        _isLoading = false; // Arrêter le chargement une fois les données récupérées
      });
    } catch (e) {
      print('Erreur lors de la récupération des règles: $e');
      setState(() {
        _isLoading = false; // Arrêter le chargement en cas d'erreur
      });
    }
  }

  void _saveSelectedRegles() {
    // Retourner les règles sélectionnées à la page précédente
    Navigator.pop(context, _selectedReglesLocal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélectionner des Règles'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicateur de chargement
          : _allRegles.isEmpty
              ? Center(
                  child: Text(
                    'Aucune règle disponible pour ce type de sport.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ) // Afficher un message si aucune règle n'est disponible
              : ListView.builder(
                  itemCount: _allRegles.length,
                  itemBuilder: (context, index) {
                    final regle = _allRegles[index];
                    return ListTile(
                      title: Text(regle.description),
                      leading: Checkbox(
                        value: _selectedReglesLocal.contains(regle.id),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected!) {
                              _selectedReglesLocal.add(regle.id!); // Ajouter la règle
                            } else {
                              _selectedReglesLocal.remove(regle.id!); // Supprimer la règle
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedRegles,
        child: Icon(Icons.check),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
