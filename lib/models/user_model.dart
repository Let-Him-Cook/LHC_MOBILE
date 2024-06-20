class User {
  const User({
    required this.uuid,
    required this.name,
    required this.cpf,
  });

  final String uuid;
  final String name;
  final String cpf;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['id'] as String,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
    );
  }
}

User? userInfo;
