import '../models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchAuthState();
  Future<AppUser> signIn({
    required String email,
    required String password,
  });
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signOut();
}
