class TypeDeSport {
  final int? id; // Optional if auto-generated
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
      id: json['id'],
      nom: json['nom'],
      nombreEquipesMax: json['nombreEquipesMax'],
      nombreParticipantsParEquipe: json['nombreParticipantsParEquipe'],
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
