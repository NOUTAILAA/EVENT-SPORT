class Regle {
  final int? id;
  final String description;
  
  Regle({
    this.id,
    required this.description,
  });

  factory Regle.fromJson(Map<String, dynamic> json) {
    return Regle(
      id: json['id'], // Assurez-vous que les noms de champs correspondent exactement
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }
}
