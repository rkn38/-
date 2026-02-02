import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? bio;
  final String role; // 'user' or 'admin'
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalPurchases;
  final List<String>? favoriteGenres;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.bio,
    this.role = 'user',
    required this.createdAt,
    required this.updatedAt,
    this.totalPurchases = 0,
    this.favoriteGenres,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      totalPurchases: json['totalPurchases'] as int? ?? 0,
      favoriteGenres: json['favoriteGenres'] != null
          ? List<String>.from(json['favoriteGenres'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'bio': bio,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'totalPurchases': totalPurchases,
      'favoriteGenres': favoriteGenres,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? bio,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalPurchases,
    List<String>? favoriteGenres,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
    );
  }

  bool get isAdmin => role == 'admin';
}
