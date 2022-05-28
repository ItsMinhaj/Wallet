// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// class SignupBody extends Equatable {
//   final String name;
//   final String email;
//   final String password;
//   const SignupBody({
//     required this.name,
//     required this.email,
//     required this.password,
//   });

//   SignupBody copyWith({
//     String? name,
//     String? email,
//     String? password,
//   }) {
//     return SignupBody(
//       name: name ?? this.name,
//       email: email ?? this.email,
//       password: password ?? this.password,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'email': email,
//       'password': password,
//     };
//   }

//   factory SignupBody.fromMap(Map<String, dynamic> map) {
//     return SignupBody(
//       name: map['name'] as String,
//       email: map['email'] as String,
//       password: map['password'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory SignupBody.fromJson(String source) =>
//       SignupBody.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   bool get stringify => true;

//   @override
//   List<Object> get props => [name, email, password];
// }
