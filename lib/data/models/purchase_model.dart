import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  final String id;
  final String userId;
  final String bookId;
  final String bookTitle;
  final String bookCoverURL;
  final double price;
  final DateTime purchaseDate;
  final String status;

  PurchaseModel({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverURL,
    required this.price,
    required this.purchaseDate,
    this.status = 'completed',
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json, String docId) {
    return PurchaseModel(
      id: docId,
      userId: json['userId'] as String,
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      bookCoverURL: json['bookCoverURL'] as String,
      price: (json['price'] as num).toDouble(),
      purchaseDate: (json['purchaseDate'] as Timestamp).toDate(),
      status: json['status'] as String? ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookCoverURL': bookCoverURL,
      'price': price,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'status': status,
    };
  }
}
