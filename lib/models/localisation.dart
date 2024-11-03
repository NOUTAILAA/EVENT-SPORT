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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ville': ville,
      'adresse': adresse,
      'pays': pays,
    };
  }
}
