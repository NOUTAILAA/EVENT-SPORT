import 'package:flutter/material.dart';
import '../../services/type_de_sport_service.dart';
import '../../models/type_de_sport.dart';
import 'add_type_de_sport_page.dart';
import 'update_type_de_sport_page.dart'; // Importez la page de mise à jour

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
        _fetchData(); // RAFRAICHIRR
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
        _fetchData(); // RAFRAICHIRRR LA PAGE
      }
    });
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
                    onTap: () => _openUpdateTypeDeSportPage(typeDeSport), // Ajoutez ceci pour la mise à jour
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTypeDeSportPage,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
