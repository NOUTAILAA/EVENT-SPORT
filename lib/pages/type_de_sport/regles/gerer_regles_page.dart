import 'package:flutter/material.dart';
import '../../../models/regle.dart';
import '../../../services/regles_service.dart';
import './ajouter_regle_page.dart'; // Importez la page d'ajout
import './modifier_regle_page.dart'; // Importez la page de modification

class GererReglesPage extends StatefulWidget {
  @override
  _GererReglesPageState createState() => _GererReglesPageState();
}

class _GererReglesPageState extends State<GererReglesPage> {
  final RegleService _regleService = RegleService();
  List<Regle> _regles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRegles();
  }

  Future<void> _fetchRegles() async {
    try {
      List<Regle> regles = await _regleService.fetchRegles();
      setState(() {
        _regles = regles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la récupération des règles")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Règles'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _regles.length,
              itemBuilder: (context, index) {
                final regle = _regles[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      regle.description,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Naviguer vers la page de modification
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifierReglePage(
                              regle: regle,
                              refreshPage: _fetchRegles, // Passer la fonction de rafraîchissement
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers la page d'ajout
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AjouterReglePage(
                refreshPage: _fetchRegles, // Passer la fonction de rafraîchissement
              ),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
