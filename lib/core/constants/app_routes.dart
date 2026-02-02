class AppRoutes {
  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Main
  static const home = '/';
  static const bookDetails = '/book-details';
  static const bookReader = '/book-reader';

  // User
  static const cart = '/cart';
  static const myLibrary = '/my-library';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';

  // Admin
  static const adminDashboard = '/admin';
  static const addBook = '/admin/add-book';
  static const editBook = '/admin/edit-book';
  static const manageCategories = '/admin/categories';

  // Other
  static const search = '/search';
  static const categoryBooks = '/category-books';
}
