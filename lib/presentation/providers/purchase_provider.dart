import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/models/book_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/purchase_model.dart';
import '../../data/repositories/purchase_repository.dart';
import 'package:uuid/uuid.dart';

class PurchaseProvider with ChangeNotifier {
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  final _uuid = const Uuid();

  List<PurchaseModel> _userPurchases = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PurchaseModel> get userPurchases => _userPurchases;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PurchaseProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchUserPurchases(user.uid);
      } else {
        _userPurchases = [];
        notifyListeners();
      }
    });
  }

  // Fetch user purchases
  Future<void> fetchUserPurchases(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _userPurchases = await _purchaseRepository.getUserPurchases(userId);
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _userPurchases = [];
      _setLoading(false);
    }
  }

  // Purchase a book
  Future<bool> purchaseBook(BookModel book, String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Check if already purchased
      if (isBookPurchased(book.id)) {
        _setLoading(false);
        return true;
      }

      final purchase = PurchaseModel(
        id: _uuid.v4(),
        userId: userId,
        bookId: book.id,
        bookTitle: book.title,
        bookCoverURL: book.coverImageURL,
        price: book.price,
        purchaseDate: DateTime.now(),
        status: 'completed',
      );

      await _purchaseRepository.createPurchase(purchase);

      // Update local list
      _userPurchases.insert(0, purchase);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Checkout from cart
  Future<bool> checkoutCart(List<CartItemModel> items, String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      for (var item in items) {
        if (!isBookPurchased(item.bookId)) {
          final purchase = PurchaseModel(
            id: _uuid.v4(),
            userId: userId,
            bookId: item.bookId,
            bookTitle: item.bookTitle,
            bookCoverURL: item.bookCoverURL,
            price: item.price,
            purchaseDate: DateTime.now(),
            status: 'completed',
          );
          await _purchaseRepository.createPurchase(purchase);
          _userPurchases.insert(0, purchase);
        }
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  bool isBookPurchased(String bookId) {
    return _userPurchases.any((p) => p.bookId == bookId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
