import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String bookId;
  final String bookTitle;
  final String bookCoverURL;
  final double price;
  final DateTime addedAt;

  CartItemModel({
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverURL,
    required this.price,
    required this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      bookCoverURL: json['bookCoverURL'] as String,
      price: (json['price'] as num).toDouble(),
      addedAt: (json['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookCoverURL': bookCoverURL,
      'price': price,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
