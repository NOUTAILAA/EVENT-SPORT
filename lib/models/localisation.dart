class Localisation {
  final int id;
  final String ville;
  final String adresse;
  final String pays;

  Localisation({
    required this.id,
    required this.ville,
    required this.adresse,
    required this.pays,
  });

  factory Localisation.fromJson(Map<String, dynamic> json) {
    return Localisation(
      id: json['id'],
      ville: json['ville'],
      adresse: json['adresse'],
      pays: json['pays'],
    );
  }

  /// Placeholder or default instance
  factory Localisation.placeholder() {
    return Localisation(
      id: 0,
      ville: "Unknown City",
      adresse: "Unknown Address",
      pays: "Unknown Country",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ville': ville,
      'adresse': adresse,
      'pays': pays,
    };
  }
}
