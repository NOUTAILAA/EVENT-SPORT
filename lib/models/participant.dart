class Participant {
  final int id;
  final String name;
  final String email;
  final int telephone;
  final String password;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    required this.password,
  });

factory Participant.fromJson(Map<String, dynamic> json) {
  return Participant(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    telephone: json.containsKey('telephone')
        ? (json['telephone'] is String
            ? int.tryParse(json['telephone']) ?? 0
            : json['telephone'] ?? 0)
        : 0,
    password: json['password'] ?? '',
  );
}




  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'telephone': telephone,
      'password': password,
    };
  }
}
