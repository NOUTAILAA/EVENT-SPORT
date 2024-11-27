import 'package:flutter/material.dart';
import 'type_de_sport/type_de_sport_page.dart';
import 'localisation/localisation_page.dart';
import 'participant/participant_page.dart';
import 'event/event_page.dart'; // Import the events page
import 'resultat/ajouter_resultat.dart'; // Import the page for adding results

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Add EvenementsPage and AjouterResultatPage to the list of pages
  final List<Widget> _pages = [
  TypeDeSportPage(),
  LocalisationPage(),
  ParticipantPage(),
  EvenementsPage(),
  AjouterResultatPage(), // Ajoutez cette page
];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planification Événements Sportifs'),
        backgroundColor: Colors.teal,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Types de Sport',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Localisation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Participants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Événements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart),
            label: 'Résultats',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black, // Change unselected items to black
        onTap: _onItemTapped,
      ),
    );
  }
}
