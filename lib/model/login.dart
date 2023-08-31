import 'dart:convert';

class Login {
  final String username;
  final String password;

  Login({
    required this.username,
    required this.password,
  });
  
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'username': username});
    result.addAll({'password': password});

    return result;
  }

  String toJson() => json.encode(toMap());
}
