import 'package:flutter/material.dart';
import '../../services/type_de_sport_service.dart';
import '../../models/type_de_sport.dart';
import 'add_type_de_sport_page.dart';
import 'update_type_de_sport_page.dart'; // Importez la page de mise à jour
import './regles/gerer_regles_page.dart'; // Importez la page des règles générales

class TypeDeSportPage extends StatefulWidget {
  @override
  _TypeDeSportPageState createState() => _TypeDeSportPageState();
}

class _TypeDeSportPageState extends State<TypeDeSportPage> {
  final TypeDeSportService _service = TypeDeSportService();
  List<TypeDeSport> _typesDeSport = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<TypeDeSport> types = await _service.fetchTypesDeSport();
      setState(() {
        _typesDeSport = types;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openAddTypeDeSportPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTypeDeSportPage()),
    ).then((value) {
      if (value == true) {
        _fetchData(); // Rafraîchir les données après l'ajout
      }
    });
  }

  void _openUpdateTypeDeSportPage(TypeDeSport typeDeSport) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTypeDeSportPage(typeDeSport: typeDeSport),
      ),
    ).then((value) {
      if (value == true) {
        _fetchData(); // Rafraîchir les données après la mise à jour
      }
    });
  }

  void _openListeReglesGeneralesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GererReglesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Types de Sport'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _typesDeSport.length,
              itemBuilder: (context, index) {
                final typeDeSport = _typesDeSport[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(
                      typeDeSport.nom,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    subtitle: Text(
                      'Max équipes : ${typeDeSport.nombreEquipesMax}\n'
                      'Participants par équipe : ${typeDeSport.nombreParticipantsParEquipe}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Icon(
                      Icons.sports,
                      color: Colors.teal,
                    ),
                    onTap: () => _openUpdateTypeDeSportPage(typeDeSport), // Ouvrir la page de mise à jour
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Bouton pour afficher les règles générales
          FloatingActionButton(
            onPressed: _openListeReglesGeneralesPage,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.list),
          ),
          SizedBox(height: 16),
          // Bouton pour ajouter un type de sport
          FloatingActionButton(
            onPressed: _openAddTypeDeSportPage,
            backgroundColor: Colors.teal,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
