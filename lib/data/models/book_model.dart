import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String coverImageURL;
  final String? pdfURL;
  final String category;
  final String language;
  final int pages;
  final String? publisher;
  final DateTime? publishDate;
  final String? isbn;
  final double rating;
  final int ratingsCount;
  final int purchaseCount;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? addedBy;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.coverImageURL,
    this.pdfURL,
    required this.category,
    this.language = 'عربي',
    this.pages = 0,
    this.publisher,
    this.publishDate,
    this.isbn,
    this.rating = 0.0,
    this.ratingsCount = 0,
    this.purchaseCount = 0,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    this.addedBy,
  });

  factory BookModel.fromJson(Map<String, dynamic> json, String docId) {
    return BookModel(
      id: docId,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      coverImageURL: json['coverImageURL'] as String,
      pdfURL: json['pdfURL'] as String?,
      category: json['category'] as String,
      language: json['language'] as String? ?? 'عربي',
      pages: json['pages'] as int? ?? 0,
      publisher: json['publisher'] as String?,
      publishDate: json['publishDate'] != null
          ? (json['publishDate'] as Timestamp).toDate()
          : null,
      isbn: json['isbn'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: json['ratingsCount'] as int? ?? 0,
      purchaseCount: json['purchaseCount'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      addedBy: json['addedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'coverImageURL': coverImageURL,
      'pdfURL': pdfURL,
      'category': category,
      'language': language,
      'pages': pages,
      'publisher': publisher,
      'publishDate':
          publishDate != null ? Timestamp.fromDate(publishDate!) : null,
      'isbn': isbn,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'purchaseCount': purchaseCount,
      'isFeatured': isFeatured,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'addedBy': addedBy,
    };
  }

  // Aliases for compatibility
  Map<String, dynamic> toMap() => toJson();

  factory BookModel.fromMap(Map<String, dynamic> map, String id) {
    return BookModel.fromJson(map, id);
  }

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    double? price,
    String? coverImageURL,
    String? pdfURL,
    String? category,
    String? language,
    int? pages,
    String? publisher,
    DateTime? publishDate,
    String? isbn,
    double? rating,
    int? ratingsCount,
    int? purchaseCount,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? addedBy,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      price: price ?? this.price,
      coverImageURL: coverImageURL ?? this.coverImageURL,
      pdfURL: pdfURL ?? this.pdfURL,
      category: category ?? this.category,
      language: language ?? this.language,
      pages: pages ?? this.pages,
      publisher: publisher ?? this.publisher,
      publishDate: publishDate ?? this.publishDate,
      isbn: isbn ?? this.isbn,
      rating: rating ?? this.rating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      addedBy: addedBy ?? this.addedBy,
    );
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get ratingText => rating.toStringAsFixed(1);
  bool get hasRatings => ratingsCount > 0;
}
