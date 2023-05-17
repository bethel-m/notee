import 'package:notee/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Future<AuthUser> login(
    String email,
    String password,
  );
  Future<AuthUser> createUser(
    String email,
    String password,
  );
  Future<void> logout();
  Future<void> sendVerificationEmail();
  Future<void> sendPasswordReset({required String toEmail});
}
