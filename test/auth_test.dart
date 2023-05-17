import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:notee/services/auth/auth_exceptions.dart';
import 'package:notee/services/auth/auth_provider.dart';
import 'package:notee/services/auth/auth_user.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test("should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });
    test("cannot log out if not initialized", () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedAuthException>()));
    });

    test("should be able to be initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("user should be null after initialization", () {
      expect(provider.currentUser, null);
    });
    test("should be able to initialize in less than 2 seconds", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test("Create user should delegate to login function", () async {
      final badEmailUser = provider.createUser("foo@baz.com", "anyting");
      expect(
        badEmailUser,
        throwsA(
          const TypeMatcher<UserNotFoundAuthException>(),
        ),
      );
      final badPasswordUser = provider.createUser("email", "bar");
      expect(
        badPasswordUser,
        throwsA(
          const TypeMatcher<WrongPasswordAuthException>(),
        ),
      );
      final user = await provider.createUser(
        "mail",
        "password",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test(
      "logged in user should be able to get verified",
      () {
        provider.sendVerificationEmail();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      },
    );
    test("should be able to logout and log in again", () async {
      await provider.logout();
      await provider.login("email", "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedAuthException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  bool _isInitialized = false;
  bool get isInitialized {
    return _isInitialized;
  }

  @override
  Future<AuthUser> createUser(
    String email,
    String password,
  ) async {
    if (!isInitialized) throw NotInitializedAuthException();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email,
      password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login(String email, String password) {
    if (!isInitialized) throw NotInitializedAuthException();
    if (email == "foo@baz.com") throw UserNotFoundAuthException();
    if (password == "bar") throw WrongPasswordAuthException();
    const user =
        AuthUser(isEmailVerified: false, email: "foo@bar.com", id: "foo");

    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedAuthException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendVerificationEmail() async {
    if (!isInitialized) throw NotInitializedAuthException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser =
        AuthUser(isEmailVerified: true, email: "foo@bar.com", id: "bar");
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
