class User {
  int? id;
  String name;
  String email;
  String password;
  String dateOfBirth;
  String country;
  String? avatarPath;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.country,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'avatarPath': avatarPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      dateOfBirth: map['dateOfBirth'],
      country: map['country'],
      avatarPath: map['avatarPath'],
    );
  }
}
