import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String firebaseUid;
  final String fullName;
  final String email;
  final String provider;
  final String avatarUrl;
  final String role;

  AccountModel({
    required this.firebaseUid,
    required this.fullName,
    required this.email,
    required this.provider,
    this.avatarUrl = '',
    this.role = 'user',
  });

  Map<String, dynamic> toMap() => {
    'firebaseUid': firebaseUid,
    'fullName': fullName,
    'email': email,
    'provider': provider,
    'avatarUrl': avatarUrl,
    'role': role,
    'createdAt': FieldValue.serverTimestamp(),
  };

  factory AccountModel.fromMap(Map<String, dynamic> map) => AccountModel(
    firebaseUid: map['uid'] ?? '',
    fullName: map['fullName'] ?? '',
    email: map['email'] ?? '',
    provider: map['provider'] ?? '',
    avatarUrl: map['avatarUrl'] ?? '',
    role: map['role'] ?? 'user',
  );
}
