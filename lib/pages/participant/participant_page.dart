import 'package:flutter/material.dart';
import '../../models/participant.dart';
import '../../services/participant_service.dart';

class ParticipantPage extends StatefulWidget {
  @override
  _ParticipantPageState createState() => _ParticipantPageState();
}

class _ParticipantPageState extends State<ParticipantPage> {
  final ParticipantService _service = ParticipantService();
  List<Participant> _participants = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  // Fonction pour récupérer la liste des participants
  Future<void> _fetchParticipants() async {
    try {
      List<Participant> participants = await _service.fetchParticipants();
      setState(() {
        _participants = participants;
        _isLoading = false;
        _errorMessage = null;  // Réinitialiser le message d'erreur si tout va bien
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors du chargement des participants : $e';
      });
    }
  }

  // Ajouter un participant
  void _addParticipant() async {
    final participant = await _showParticipantDialog();
    if (participant != null) {
      await _service.createParticipant(participant);
      _fetchParticipants(); // Actualiser la liste
    }
  }

  // Mettre à jour un participant
  void _updateParticipant(Participant participant) async {
    final updatedParticipant = await _showParticipantDialog(participant: participant);
    if (updatedParticipant != null) {
      // Passer l'id et le participant mis à jour
      await _service.updateParticipant(participant.id, updatedParticipant);
      _fetchParticipants(); // Actualiser la liste
    }
  }

  // Afficher le dialog pour ajouter ou modifier un participant
  Future<Participant?> _showParticipantDialog({Participant? participant}) {
    final nameController = TextEditingController(text: participant?.name);
    final emailController = TextEditingController(text: participant?.email);
    final telephoneController = TextEditingController(text: participant?.telephone.toString());
    final passwordController = TextEditingController(text: participant?.password);

    return showDialog<Participant>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(participant == null ? 'Ajouter Participant' : 'Modifier Participant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: telephoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newParticipant = Participant(
                  id: participant?.id ?? 0, // Si aucun participant, définir un id par défaut
                  name: nameController.text,
                  email: emailController.text,
                  telephone: int.tryParse(telephoneController.text) ?? 0,
                  password: passwordController.text,
                );

                Navigator.of(context).pop(newParticipant);
              },
              child: Text(participant == null ? 'Ajouter' : 'Modifier'),
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

  // Supprimer un participant
  void _deleteParticipant(Participant participant) async {
    await _service.deleteParticipant(participant.id); // Passer uniquement l'id
    _fetchParticipants(); // Actualiser la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _errorMessage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(height: 10),
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _participants.length,
                          itemBuilder: (context, index) {
                            final participant = _participants[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(participant.name),
                                subtitle: Text(participant.email),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.teal),
                                      onPressed: () => _updateParticipant(participant),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.teal),
                                      onPressed: () => _deleteParticipant(participant),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                     Padding(
  padding: const EdgeInsets.all(16.0),
  child: Align(
    alignment: Alignment.bottomRight, // Aligner à droite
    child: FloatingActionButton(
      onPressed: _addParticipant,
      backgroundColor: Colors.teal,
      child: Icon(Icons.add),
    ),
  ),
)

                    ],
                  ),
      ),
    );
  }
}
