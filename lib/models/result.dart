class Resultat {
  final int resultatId;
  final int? equipeId;
  final int? participantId;
  final int? nombreButs;
  final double? temps;

  Resultat({
    required this.resultatId,
    this.equipeId,
    this.participantId,
    this.nombreButs,
    this.temps,
  });

  factory Resultat.fromJson(Map<String, dynamic> json) {
    return Resultat(
      resultatId: json['resultatId'],
      equipeId: json['equipeId'],
      participantId: json['participantId'],
      nombreButs: json['nombreButs'],
      temps: json['temps'] != null ? json['temps'].toDouble() : null,
    );
  }
}
