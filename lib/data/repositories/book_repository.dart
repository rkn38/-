import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/book_model.dart';

class BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all books
  Future<List<BookModel>> getAllBooks() async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الكتب: ${e.toString()}');
    }
  }

  // Get featured books
  Future<List<BookModel>> getFeaturedBooks() async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الكتب المميزة: ${e.toString()}');
    }
  }

  // Get books by category
  Future<List<BookModel>> getBooksByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب كتب الفئة: ${e.toString()}');
    }
  }

  // Get book by ID
  Future<BookModel?> getBookById(String bookId) async {
    try {
      final doc = await _firestore.collection('books').doc(bookId).get();

      if (doc.exists) {
        return BookModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في جلب الكتاب: ${e.toString()}');
    }
  }

  // Search books
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في البحث: ${e.toString()}');
    }
  }

  // Add book (Admin only)
  Future<String> addBook(BookModel book) async {
    try {
      final docRef = await _firestore.collection('books').add(book.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('خطأ في إضافة الكتاب: ${e.toString()}');
    }
  }

  // Update book (Admin only)
  Future<void> updateBook(BookModel book) async {
    try {
      await _firestore
          .collection('books')
          .doc(book.id)
          .update(book.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      throw Exception('خطأ في تحديث الكتاب: ${e.toString()}');
    }
  }

  // Delete book (Admin only)
  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      throw Exception('خطأ في حذف الكتاب: ${e.toString()}');
    }
  }

  // Get best sellers
  Future<List<BookModel>> getBestSellers() async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .orderBy('purchaseCount', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الأكثر مبيعاً: ${e.toString()}');
    }
  }

  // Get books stream (realtime)
  Stream<List<BookModel>> getBooksStream() {
    return _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  // Seed sample books
  Future<void> seedBooks() async {
    try {
      final snapshot = await _firestore.collection('books').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        debugPrint('Database already seeded');
        return;
      }

      final List<BookModel> sampleBooks = [
        BookModel(
          id: '',
          title: 'مقدمة ابن خلدون',
          author: 'ابن خلدون',
          description:
              'كتاب العبر وديوان المبتدأ والخبر في معرفة أيام العرب والعجم والبربر ومن عاصرهم من ذوي السلطان الأكبر.',
          price: 15.0,
          coverImageURL:
              'https://books.google.com/books/content?id=bH1lAAAAMAAJ&printsec=frontcover&img=1&zoom=1&imgtk=AFLRE71y8293y89123891283',
          category: 'تاريخ',
          language: 'عربي',
          pages: 500,
          rating: 4.8,
          ratingsCount: 150,
          purchaseCount: 100,
          isFeatured: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        BookModel(
          id: '',
          title: 'فن الحرب',
          author: 'سون تزو',
          description:
              'أطروحة عسكرية صينية قديمة تُنسب إلى سون تزو، وهو استراتيجي عسكري صيني رفيع المستوى.',
          price: 10.0,
          coverImageURL:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/BambergApocalypse0340.JPG/250px-BambergApocalypse0340.JPG',
          category: 'استراتيجية',
          language: 'عربي',
          pages: 120,
          rating: 4.5,
          ratingsCount: 200,
          purchaseCount: 300,
          isFeatured: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        BookModel(
          id: '',
          title: 'الأب الغني والأب الفقير',
          author: 'روبرت كيوساكي',
          description:
              'كتاب يدافع عن أهمية الاستقلال المالي وبناء الثروة عن طريق الاستثمار.',
          price: 20.0,
          coverImageURL:
              'https://upload.wikimedia.org/wikipedia/en/b/b9/Rich_Dad_Poor_Dad.jpg',
          category: 'تطوير ذاتي',
          language: 'عربي',
          pages: 336,
          rating: 4.7,
          ratingsCount: 500,
          purchaseCount: 1000,
          isFeatured: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (var book in sampleBooks) {
        await addBook(book);
      }
      debugPrint('Seeding completed successfully');
    } catch (e) {
      debugPrint('Error seeding books: $e');
      throw Exception('خطأ في إضافة البيانات التجريبية: $e');
    }
  }
}
