import 'package:flutter/material.dart';
import '../promotions/gestion_promotions_page.dart'; // Importez la page des promotions
import '../../models/event.dart';
import '../../services/event_service.dart';
import './event_details_page.dart';
import './ajouter_event_page.dart';

class EvenementsPage extends StatefulWidget {
  @override
  _EvenementsPageState createState() => _EvenementsPageState();
}

class _EvenementsPageState extends State<EvenementsPage> {
  late Future<List<Evenement>> futureEvenements;
  late Future<Map<int, String>> futureTypeDeSportNames;
  late Future<Map<int, String>> futureLocalisationNames;
  List<Evenement> evenements = []; // Liste des événements
  List<Evenement> filteredEvenements = []; // Liste filtrée des événements
  TextEditingController _searchController = TextEditingController(); // Contrôleur pour la recherche

  @override
  void initState() {
    super.initState();
    final service = EvenementService();
    futureEvenements = service.fetchEvenements();
    futureTypeDeSportNames = service.fetchTypeDeSportNames();
    futureLocalisationNames = service.fetchLocalisationNames();

    // Initialiser la liste des événements après la récupération des données
    futureEvenements.then((data) {
      setState(() {
        evenements = data;
        filteredEvenements = evenements; // Initialiser la liste filtrée avec tous les événements
      });
    });
  }

  // Méthode de filtrage des événements par nom
  void _filterEvenements(String query) {
    final filteredList = evenements.where((evenement) {
      return evenement.nom.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredEvenements = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Événements'),
        backgroundColor: Colors.teal,
        actions: [
          // Champ de recherche dans l'AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: EventSearchDelegate(
                    allEvenements: evenements,
                    onSearch: _filterEvenements,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([futureEvenements, futureTypeDeSportNames, futureLocalisationNames]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else {
            final typeDeSportNames = snapshot.data![1] as Map<int, String>;
            final localisationNames = snapshot.data![2] as Map<int, String>;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredEvenements.length,
                    itemBuilder: (context, index) {
                      final evenement = filteredEvenements[index];
                      final typeDeSportName = typeDeSportNames[evenement.typeDeSportId] ?? "Unknown Sport";
                      final localisationName = localisationNames[evenement.localisationId] ?? "Unknown City";

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(evenement.nom),
                          subtitle: Text('$typeDeSportName - $localisationName'),
                          trailing: Icon(Icons.event, color: Colors.teal),
                          onTap: () {
                            // Navigate to the details page with the selected evenement
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EvenementDetailsPage(
                                  evenement: evenement,
                                  typeDeSportName: typeDeSportName,
                                  localisationName: localisationName,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute buttons in space
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the promotions management page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GestionPromotionsPage(),
                            ),
                          );
                        },
                        child: Text("Gérer les Promotions"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, // Button color
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AjouterEvenementPage(),
                            ),
                          ).then((value) {
                            setState(() {
                              final service = EvenementService();
                              futureEvenements = service.fetchEvenements();
                            });
                          });
                        },
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
class EventSearchDelegate extends SearchDelegate {
  final List<Evenement> allEvenements;
  final Function(String) onSearch;

  EventSearchDelegate({required this.allEvenements, required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Effacer la recherche
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query); // Mettre à jour les résultats en fonction de la requête
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredEvenements = allEvenements.where((evenement) {
      return evenement.nom.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredEvenements.length,
      itemBuilder: (context, index) {
        final evenement = filteredEvenements[index];
        
        return GestureDetector(
          onTap: () {
            close(context, evenement); // Ferme la recherche et sélectionne l'événement
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EvenementDetailsPage(
                  evenement: evenement,
                  typeDeSportName: 'Type de sport',  // Passer les données de sport
                  localisationName: 'Localisation',  // Passer les données de localisation
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.teal[50], // Couleur de fond claire
              borderRadius: BorderRadius.circular(8.0), // Coins arrondis
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Ombre légère
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.event, color: Colors.teal), // Icône d'événement
              title: Text(
                evenement.nom,
                style: TextStyle(
                  color: Colors.teal, // Couleur du texte
                  fontWeight: FontWeight.bold, // Mettre en gras
                  fontSize: 18, // Taille de la police
                ),
              ),
              
            ),
          ),
        );
      },
    );
  }
}
