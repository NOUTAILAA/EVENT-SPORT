import 'package:flutter/material.dart';
import '../../models/event.dart';

class EvenementDetailsPage extends StatelessWidget {
  final Evenement evenement;
  final String typeDeSportName;
  final String localisationName;

  const EvenementDetailsPage({
    Key? key,
    required this.evenement,
    required this.typeDeSportName,
    required this.localisationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'événement'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evenement.nom,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Type de Sport: $typeDeSportName',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Localisation: $localisationName',
              style: TextStyle(fontSize: 18),
            ),
            
            Text(
              'Prix: ${evenement.prix.toStringAsFixed(2)} €',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            // Add more details about the event here as needed
            Text(
              'Détails supplémentaires à ajouter ici...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
