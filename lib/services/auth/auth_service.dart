import 'package:notee/services/auth/auth_provider.dart';
import 'package:notee/services/auth/auth_user.dart';
import 'package:notee/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);
  factory AuthService.firebase() {
    return AuthService(FirebaseAuthProvider());
  }
  @override
  Future<AuthUser> createUser(
    String email,
    String password,
  ) {
    return provider.createUser(email, password);
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login(String email, String password) {
    return provider.login(email, password);
  }

  @override
  Future<void> logout() {
    return provider.logout();
  }

  @override
  Future<void> sendVerificationEmail() {
    return provider.sendVerificationEmail();
  }

  @override
  Future<void> initialize() {
    return provider.initialize();
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    return provider.sendPasswordReset(toEmail: toEmail);
  }
}
