class User {
  final String? id;
  final String? full_name;
  final String? email;
  final String? phone;
  final String? gender;

  User({this.id, this.full_name, this.email, this.phone, this.gender});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      full_name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': full_name,
    'email': email,
    'phone': phone,
    'gender': gender
  };
}