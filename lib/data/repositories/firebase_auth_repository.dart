import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return _loadOrCreateUserDocument(
      user.uid,
      fallbackEmail: user.email ?? email,
      fallbackName: user.displayName ?? _nameFromEmail(user.email ?? email),
    );
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(name);
    await _firestore.collection('users').doc(user.uid).set({
      'email': email,
      'displayName': name,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return AppUser(
      uid: user.uid,
      email: email,
      displayName: name,
    );
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  @override
  Stream<AppUser?> watchAuthState() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }

      return _loadOrCreateUserDocument(
        firebaseUser.uid,
        fallbackEmail: firebaseUser.email ?? '',
        fallbackName: firebaseUser.displayName ?? _nameFromEmail(firebaseUser.email ?? ''),
      );
    });
  }

  Future<AppUser> _loadOrCreateUserDocument(
    String uid, {
    required String fallbackEmail,
    required String fallbackName,
  }) async {
    final ref = _firestore.collection('users').doc(uid);
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        'email': fallbackEmail,
        'displayName': fallbackName,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return AppUser(
        uid: uid,
        email: fallbackEmail,
        displayName: fallbackName,
      );
    }

    final data = snapshot.data()!;
    return AppUser.fromMap(uid, data);
  }

  String _nameFromEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return 'Beauty Shopper';
    }

    final base = email.split('@').first.replaceAll('.', ' ').trim();
    if (base.isEmpty) {
      return 'Beauty Shopper';
    }

    return base
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
