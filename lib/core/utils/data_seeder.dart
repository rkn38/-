import 'package:flutter/foundation.dart';
import '../../data/repositories/book_repository.dart';

class DataSeeder {
  static Future<void> seedAll() async {
    final bookRepo = BookRepository();

    debugPrint('Starting seeding process...');

    try {
      // Seed Books using existing method in repository
      await bookRepo.seedBooks();

      // We can add category seeding here if needed
      debugPrint('Seeding completed!');
    } catch (e) {
      debugPrint('Seeding failed: $e');
    }
  }
}
