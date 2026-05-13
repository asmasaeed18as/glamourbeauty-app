import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/app_user.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository) {
    _subscription = _repository.watchAuthState().listen((user) {
      currentUser = user;
      isLoading = false;
      notifyListeners();
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _subscription;

  AppUser? currentUser;
  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  bool get isAuthenticated => currentUser != null;

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    return _handleAuthAction(() {
      return _repository.signIn(email: email, password: password);
    });
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _handleAuthAction(() {
      return _repository.signUp(name: name, email: email, password: password);
    });
  }

  Future<void> signOut() async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repository.signOut();
    } on FirebaseAuthException catch (error) {
      errorMessage = error.message ?? 'Unable to sign out right now.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> _handleAuthAction(Future<AppUser> Function() action) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await action();
      return true;
    } on FirebaseAuthException catch (error) {
      errorMessage = error.message ?? 'Authentication failed.';
      return false;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
