class User {
  // Define the properties of the User class
  String? email;
  String id, name, phone;

  User({required this.id, required this.name, this.email, required this.phone});

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}
