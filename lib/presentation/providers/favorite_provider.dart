import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/models/book_model.dart';
import '../../data/repositories/favorite_repository.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteRepository _repository = FavoriteRepository();
  List<BookModel> _favorites = [];
  bool _isLoading = false;
  StreamSubscription? _subscription;

  List<BookModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoriteProvider() {
    // الاستماع لتغيرات حالة تسجيل الدخول
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _initStream();
    });
  }

  void _initStream() {
    _subscription?.cancel();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _favorites = [];
      notifyListeners();
      return;
    }

    _subscription = _repository.getFavoritesStream().listen((books) {
      _favorites = books;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// تبديل حالة المفضلة (إضافة/إزالة)
  Future<void> toggleFavorite(BookModel book) async {
    final isFav = isFavorite(book.id);
    if (isFav) {
      await _repository.removeFromFavorites(book.id);
    } else {
      await _repository.addToFavorites(book);
    }
  }

  /// التحقق مما إذا كان الكتاب مفضلاً
  bool isFavorite(String bookId) {
    return _favorites.any((book) => book.id == bookId);
  }
}
