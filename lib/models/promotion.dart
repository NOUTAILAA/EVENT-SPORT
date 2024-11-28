class Promotion {
  final int id;
  final String code;
  final double remise;

  Promotion({required this.id, required this.code, required this.remise});

  // Convertir un objet Promotion en Map<String, dynamic> (utilisé pour les requêtes HTTP)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'remise': remise,
    };
  }

  // Créer un objet Promotion à partir d'un Map<String, dynamic> (utilisé lors de la récupération des données)
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      code: json['code'],
      remise: json['remise'],
    );
  }
}
