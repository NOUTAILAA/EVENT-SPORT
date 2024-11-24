class Evenement {
  final int id;
  final String nom;
  final int localisationId;
  final int typeDeSportId;
  final double prix;

  Evenement({
    required this.id,
    required this.nom,
    required this.localisationId,
    required this.typeDeSportId,
    required this.prix,
  });

  factory Evenement.fromJson(Map<String, dynamic> json) {
    return Evenement(
      id: json['id'],
      nom: json['nom'],
      localisationId: json['localisationId'],
      typeDeSportId: json['typeDeSportId'],
      prix: json['prix'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'localisationId': localisationId,
      'typeDeSportId': typeDeSportId,
      'prix': prix,
    };
  }
}
