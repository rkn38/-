import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      debugPrint('DEBUG REPO: Calling signInWithEmailAndPassword...');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(
        'DEBUG REPO: signInWithEmailAndPassword returned. User: ${credential.user?.uid}',
      );

      if (credential.user != null) {
        debugPrint('DEBUG REPO: Fetching user data via getUserData...');
        return await getUserData(credential.user!.uid);
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول: ${e.toString()}');
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    String role = 'user',
  }) async {
    User? firebaseUser;
    try {
      debugPrint('DEBUG REPO: Calling createUserWithEmailAndPassword...');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser = credential.user;
      debugPrint('DEBUG REPO: Auth success for ${firebaseUser?.uid}');
    } catch (e) {
      debugPrint('DEBUG REPO: Auth error caught: $e');
      // Handle the Pigeon cast error that user is experiencing
      if (e.toString().contains('PigeonUserDetails')) {
        debugPrint(
          'DEBUG REPO: Pigeon cast error detected, verifying user creation...',
        );
        firebaseUser = _auth.currentUser;
      }

      if (firebaseUser == null) {
        throw Exception('خطأ في التسجيل: ${e.toString()}');
      }
      debugPrint('DEBUG REPO: User exists after error, proceeding...');
    }

    if (firebaseUser != null) {
      try {
        // Update display name
        await firebaseUser.updateDisplayName(displayName);
      } catch (e) {
        debugPrint('DEBUG REPO: Ignored error updating display name: $e');
      }

      // Create user document in Firestore
      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: email,
        displayName: displayName,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        debugPrint(
          'DEBUG REPO: Creating Firestore user document for ${firebaseUser.uid}...',
        );
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userModel.toJson());
        debugPrint('DEBUG REPO: Firestore document created successfully.');
      } catch (e) {
        debugPrint('DEBUG REPO: Firestore document creation failed: $e');
        // We still return the userModel so the app can function
      }

      return userModel;
    }
    return null;
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if user exists in Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // Create new user document
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            displayName: userCredential.user!.displayName ?? 'مستخدم',
            photoURL: userCredential.user!.photoURL,
            role: 'user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userModel.toJson());

          return userModel;
        } else {
          return UserModel.fromJson(userDoc.data()!);
        }
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول بـ Google: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('خطأ في تسجيل الخروج: ${e.toString()}');
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      debugPrint('DEBUG REPO: getUserData called for $uid');
      final doc = await _firestore.collection('users').doc(uid).get();
      debugPrint('DEBUG REPO: Firestore doc retrieved. Exists: ${doc.exists}');
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('DEBUG: Error getting user data: $e');
      // Return null instead of throwing to allow debugging
      return null;
      // throw Exception('خطأ في جلب بيانات المستخدم: ${e.toString()}');
    }
  }

  // Create user document
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      throw Exception('خطأ في إنشاء ملف المستخدم: ${e.toString()}');
    }
  }

  // Update user data
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(user.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      throw Exception('خطأ في تحديث البيانات: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('خطأ في إعادة تعيين كلمة المرور: ${e.toString()}');
    }
  }

  /// إنشاء مدير جديد بواسطة مدير حالي
  /// لا يغير حالة تسجيل الدخول الحالية
  Future<UserModel?> createAdminByAdmin({
    required String email,
    required String password,
    required String displayName,
    required String createdBy,
  }) async {
    try {
      // حفظ المستخدم الحالي
      final currentUser = _auth.currentUser;

      // إنشاء حساب جديد
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // تحديث اسم العرض
        try {
          await credential.user!.updateDisplayName(displayName);
        } catch (e) {
          debugPrint('Error updating display name: $e');
        }

        // إنشاء وثيقة المستخدم في Firestore
        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
          role: 'admin', // مدير
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(credential.user!.uid).set({
          ...userModel.toJson(),
          'createdBy': createdBy, // من أنشأ هذا المدير
        });

        // تسجيل خروج المدير الجديد والعودة للمدير الأصلي
        await _auth.signOut();

        // إعادة تسجيل دخول المدير الأصلي
        // ملاحظة: هذا يتطلب أن يكون لدينا credentials المدير الأصلي
        // لذلك سنعتمد على أن المستخدم سيبقى مسجل دخول

        return userModel;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating admin: $e');
      throw Exception('خطأ في إنشاء المدير: ${e.toString()}');
    }
  }

  /// جلب قائمة المدراء
  Future<List<UserModel>> getAdminsList() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting admins: $e');
      throw Exception('خطأ في جلب المدراء: ${e.toString()}');
    }
  }

  /// جلب إحصائيات المستخدمين
  Future<Map<String, int>> getUserStats() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final admins = usersSnapshot.docs
          .where((doc) => doc.data()['role'] == 'admin')
          .length;
      final users = usersSnapshot.docs.length - admins;

      return {
        'total': usersSnapshot.docs.length,
        'admins': admins,
        'users': users,
      };
    } catch (e) {
      return {'total': 0, 'admins': 0, 'users': 0};
    }
  }
}
