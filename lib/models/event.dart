class Evenement {
  final int id;
  final String nom;
  final int localisationId;
  final int typeDeSportId;
  final double prix;
  final String date; // Add the date field

  Evenement({
    required this.id,
    required this.nom,
    required this.localisationId,
    required this.typeDeSportId,
    required this.prix,
    required this.date, // Include the date field
  });

  factory Evenement.fromJson(Map<String, dynamic> json) {
    return Evenement(
      id: json['id'],
      nom: json['nom'],
      localisationId: json['localisationId'],
      typeDeSportId: json['typeDeSportId'],
      prix: json['prix'].toDouble(),
      date: json['date'], // Parse the date field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'localisationId': localisationId,
      'typeDeSportId': typeDeSportId,
      'prix': prix,
      'date': date, // Include the date field in serialization
    };
  }
}
