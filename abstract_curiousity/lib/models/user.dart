// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomUser {
  final String? id;
  final String firebaseUid;
  final String name;
  final String email;
  final bool writer;
  final String? bio;
  CustomUser({
    this.id,
    required this.firebaseUid,
    required this.name,
    required this.email,
    this.writer = false,
    this.bio,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firebaseUid': firebaseUid,
      'name': name,
      'email': email,
      'writer': writer,
      'bio': bio,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      id: map['_id'] as String,
      firebaseUid: map['firebaseUid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      writer: map['writer'] as bool,
      bio: map['bio'] != null ? map['bio'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomUser.fromJson(String source) {
    final Map<String, dynamic> data = json.decode(source);
    final Map<String, dynamic> userData = data['user'];
    return CustomUser.fromMap(userData);
  }
}
