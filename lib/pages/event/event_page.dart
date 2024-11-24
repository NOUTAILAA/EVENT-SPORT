import 'package:flutter/material.dart';

import '../../models/event.dart'; // Adjust the import path based on your project structure
import '../../services/event_service.dart'; // Adjust the import path based on your project structure

class EvenementsPage extends StatefulWidget {
  @override
  _EvenementsPageState createState() => _EvenementsPageState();
}

class _EvenementsPageState extends State<EvenementsPage> {
  late Future<List<Evenement>> futureEvenements;
  late Future<Map<int, String>> futureTypeDeSportNames;
  late Future<Map<int, String>> futureLocalisationNames;

  @override
  void initState() {
    super.initState();
    final service = EvenementService();
    futureEvenements = service.fetchEvenements();
    futureTypeDeSportNames = service.fetchTypeDeSportNames();
    futureLocalisationNames = service.fetchLocalisationNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Événements'),
        backgroundColor: Colors.teal, // Same color as LocalisationPage
      ),
      body: FutureBuilder(
        future: Future.wait([
          futureEvenements,
          futureTypeDeSportNames,
          futureLocalisationNames,
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else {
            final evenements = snapshot.data![0] as List<Evenement>;
            final typeDeSportNames = snapshot.data![1] as Map<int, String>;
            final localisationNames = snapshot.data![2] as Map<int, String>;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: evenements.length,
                    itemBuilder: (context, index) {
                      final evenement = evenements[index];
                      final typeDeSportName = typeDeSportNames[evenement.typeDeSportId] ?? "Unknown Sport";
                      final localisationName = localisationNames[evenement.localisationId] ?? "Unknown City";

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(evenement.nom),
                          subtitle: Text('$typeDeSportName - $localisationName'),
                          trailing: Icon(Icons.event, color: Colors.teal),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Add event logic here
                      },
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.add),
                    ),
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
