import 'package:flutter/material.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/models/book_model.dart';

class BookProvider with ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();

  List<BookModel> _allBooks = [];
  List<BookModel> _featuredBooks = [];
  List<BookModel> _filteredBooks = [];
  BookModel? _selectedBook;
  bool _isLoading = false;
  String? _errorMessage;

  List<BookModel> get allBooks => _allBooks;
  List<BookModel> get featuredBooks => _featuredBooks;
  List<BookModel> get filteredBooks => _filteredBooks;
  BookModel? get selectedBook => _selectedBook;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all books
  Future<void> fetchAllBooks() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _allBooks = await _bookRepository.getAllBooks();
      _filteredBooks = _allBooks;
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  // Fetch featured books
  Future<void> fetchFeaturedBooks() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _featuredBooks = await _bookRepository.getFeaturedBooks();
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  // Fetch books by category
  Future<void> fetchBooksByCategory(String category) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (category == 'الكل') {
        _filteredBooks = _allBooks;
      } else {
        _filteredBooks = await _bookRepository.getBooksByCategory(category);
      }
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  // Get book by ID
  Future<void> getBookById(String bookId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedBook = await _bookRepository.getBookById(bookId);
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  // Fetch book by ID (alias for getBookById)
  Future<void> fetchBookById(String bookId) async {
    await getBookById(bookId);
  }

  // Search books
  Future<void> searchBooks(String query) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (query.isEmpty) {
        _filteredBooks = _allBooks;
      } else {
        _filteredBooks = await _bookRepository.searchBooks(query);
      }
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  // Clear filters and search
  void clearFilters() {
    _filteredBooks = _allBooks;
    notifyListeners();
  }

  // Add book (Admin)
  Future<bool> addBook(BookModel book) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _bookRepository.addBook(book);
      await fetchAllBooks(); // Refresh list
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Update book (Admin)
  Future<bool> updateBook(BookModel book) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _bookRepository.updateBook(book);
      await fetchAllBooks(); // Refresh list
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Delete book (Admin)
  Future<bool> deleteBook(String bookId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _bookRepository.deleteBook(bookId);
      await fetchAllBooks(); // Refresh list
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedBook() {
    _selectedBook = null;
    notifyListeners();
  }
}
