import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/purchase_model.dart';
import 'package:flutter/foundation.dart';

class PurchaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new purchase
  Future<void> createPurchase(PurchaseModel purchase) async {
    try {
      // تم إلغاء استخدام batch وتحديث العداد لتجنب مشاكل الأذونات الحالية
      await _firestore
          .collection('purchases')
          .doc(purchase.id)
          .set(purchase.toJson());

      debugPrint('Purchase created: ${purchase.id}');
    } catch (e) {
      debugPrint('Error creating purchase: $e');
      throw Exception('Failed to create purchase');
    }
  }

  // Get purchases for a specific user
  Future<List<PurchaseModel>> getUserPurchases(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('purchases')
          .where('userId', isEqualTo: userId)
          // تم إزالة الترتيب في الاستعلام لتجنب الحاجة لفهرس معقد
          .get();

      final purchases = snapshot.docs
          .map((doc) => PurchaseModel.fromJson(doc.data(), doc.id))
          .toList();

      // الترتيب محلياً بدلاً من السيرفر
      purchases.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

      return purchases;
    } catch (e) {
      debugPrint('Error getting user purchases: $e');
      throw Exception('Failed to get user purchases');
    }
  }

  // Check if a user has purchased a specific book
  Future<bool> checkIfPurchased(String userId, String bookId) async {
    try {
      final snapshot = await _firestore
          .collection('purchases')
          .where('userId', isEqualTo: userId)
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking purchase: $e');
      return false;
    }
  }
}
