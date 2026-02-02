import 'package:flutter/material.dart';
import '../../data/models/book_model.dart';
import '../../data/models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    for (var item in _items) {
      total += item.price;
    }
    return total;
  }

  void addToCart(BookModel book) {
    // Check if book already exists (optional: could increase quantity instead)
    final existingIndex = _items.indexWhere((item) => item.bookId == book.id);
    if (existingIndex >= 0) {
      return; // Already in cart
    }

    _items.add(
      CartItemModel(
        bookId: book.id,
        bookTitle: book.title,
        bookCoverURL: book.coverImageURL,
        price: book.price,
        addedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeFromCart(String bookId) {
    _items.removeWhere((item) => item.bookId == bookId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  bool isInCart(String bookId) {
    return _items.any((item) => item.bookId == bookId);
  }
}
