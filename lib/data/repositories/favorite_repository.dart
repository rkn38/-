import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book_model.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _favoritesRef =>
      _firestore.collection('favorites').doc(_userId).collection('books');

  /// إضافة كتاب للمفضلة
  Future<void> addToFavorites(BookModel book) async {
    if (_userId == null) return;
    await _favoritesRef.doc(book.id).set(book.toMap());
  }

  /// إزالة كتاب من المفضلة
  Future<void> removeFromFavorites(String bookId) async {
    if (_userId == null) return;
    await _favoritesRef.doc(bookId).delete();
  }

  /// التحقق مما إذا كان الكتاب في المفضلة
  Future<bool> isFavorite(String bookId) async {
    if (_userId == null) return false;
    final doc = await _favoritesRef.doc(bookId).get();
    return doc.exists;
  }

  /// الحصول على قائمة الكتب المفضلة
  Stream<List<BookModel>> getFavoritesStream() {
    if (_userId == null) return Stream.value([]);
    return _favoritesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return BookModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          })
          .toList()
          .cast<BookModel>();
    });
  }
}
