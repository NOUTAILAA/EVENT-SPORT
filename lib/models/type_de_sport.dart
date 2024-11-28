class TypeDeSport {
  final int? id; // id can be nullable
  final String nom;
  final int nombreEquipesMax;
  final int nombreParticipantsParEquipe;

  TypeDeSport({
    required this.id,
    required this.nom,
    required this.nombreEquipesMax,
    required this.nombreParticipantsParEquipe,
  });

  factory TypeDeSport.fromJson(Map<String, dynamic> json) {
    return TypeDeSport(
      id: json['id'] as int?, // id can be null, so keep it as int?
      nom: json['nom'] as String,
      nombreEquipesMax: json['nombreEquipesMax'] ?? 0, // Default to 0 if null
      nombreParticipantsParEquipe: json['nombreParticipantsParEquipe'] ?? 0, // Default to 0 if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'nombreEquipesMax': nombreEquipesMax,
      'nombreParticipantsParEquipe': nombreParticipantsParEquipe,
    };
  }
}
