import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../app/constants/app_strings.dart';
import '../../app/utils/validators.dart';
import '../models/user_model.dart';

/// Thrown by [AuthService] with a message that is safe to show to the user.
class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => message;
}

/// Data layer for authentication. Contains no UI code.
class AuthService extends GetxService {
  static const String usersCollection = 'users';

  /// emails/{lowercased email} → { uid, createdAt }. Lets the Sign-Up screen
  /// check if an email is taken, because Firebase Auth's
  /// fetchSignInMethodsForEmail is disabled by email enumeration protection.
  static const String emailsCollection = 'emails';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  DocumentReference<Map<String, dynamic>> _emailDoc(String email) => _firestore
      .collection(emailsCollection)
      .doc(Validators.normalizeEmail(email));

  /// Creates the Firebase Auth account, then saves the profile (without the
  /// password) to users/{uid} and reserves emails/{email} in one batch.
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthFailure(AppStrings.errorGeneric);

      await user.updateDisplayName(name);

      final profile = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      final batch = _firestore.batch()
        ..set(
          _firestore.collection(usersCollection).doc(user.uid),
          profile.toMap(),
        )
        ..set(_emailDoc(email), _emailEntry(user.uid));
      await batch.commit();
      return profile;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e.code));
    } on FirebaseException {
      throw const AuthFailure(AppStrings.errorGeneric);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) await _backfillEmailEntry(user);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e.code));
    }
  }

  /// Accounts created before the emails collection existed have no entry, so
  /// it is added on their next login. A failure here never blocks login.
  Future<void> _backfillEmailEntry(User user) async {
    final email = user.email;
    if (email == null || email.isEmpty) return;
    try {
      final doc = _emailDoc(email);
      final snapshot = await doc.get();
      if (!snapshot.exists) await doc.set(_emailEntry(user.uid));
    } on FirebaseException {
      // Ignored: the entry will be retried on the next login.
    }
  }

  Map<String, dynamic> _emailEntry(String uid) => {
    'uid': uid,
    'createdAt': FieldValue.serverTimestamp(),
  };

  /// True when no account uses [email]. Reads from the server only, so an
  /// offline cache can never report a taken email as available.
  Future<bool> isEmailAvailable(String email) async {
    try {
      final snapshot = await _emailDoc(email)
          .get(const GetOptions(source: Source.server));
      return !snapshot.exists;
    } on FirebaseException {
      throw const AuthFailure(AppStrings.errorGeneric);
    }
  }

  /// Sends a reset email. With email enumeration protection Firebase does not
  /// say whether the account exists, and neither does this method: a missing
  /// account completes normally just like an existing one.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return;
      throw AuthFailure(_messageFor(e.code));
    }
  }

  Future<void> logout() => _auth.signOut();

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
      case 'missing-email':
        return AppStrings.errorInvalidEmail;
      case 'user-disabled':
        return AppStrings.errorUserDisabled;
      case 'user-not-found':
        return AppStrings.errorUserNotFound;
      case 'wrong-password':
        return AppStrings.errorWrongPassword;
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return AppStrings.errorInvalidCredential;
      case 'email-already-in-use':
        return AppStrings.errorEmailInUse;
      case 'weak-password':
        return AppStrings.errorWeakPassword;
      case 'too-many-requests':
        return AppStrings.errorTooManyRequests;
      case 'network-request-failed':
        return AppStrings.errorNetwork;
      case 'operation-not-allowed':
        return AppStrings.errorOperationNotAllowed;
      default:
        return AppStrings.errorGeneric;
    }
  }
}
