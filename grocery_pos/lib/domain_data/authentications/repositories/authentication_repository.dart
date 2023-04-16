import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_pos/common/models/models.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

class LogOutFailure implements Exception {}

abstract class IAuthenticationRepository {
  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  UserModel get currentUser;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<UserModel> get user;

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a Exception if an exception occurs.
  Future logInWithEmailAndPassword(
      {required String email, required String password}) async {}

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a Exception if an exception occurs.
  Future signUp({required String email, required String password}) async {}

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a Exception if an exception occurs.
  Future<void> logOut() async {}
}

class AuthenticationRepository implements IAuthenticationRepository {
  static const userCacheKey = '__user_cache_key__';
  final FirebaseAuth _firebaseAuth;
  final CacheClient _cache;

  @override
  UserModel get currentUser =>
      _cache.read(key: userCacheKey) ?? UserModel.empty;

  @override
  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user =
          firebaseUser == null ? UserModel.empty : firebaseUser.toUserModel;
      _cache.write(
        key: userCacheKey,
        value: user,
      );
      return user;
    });
  }

  AuthenticationRepository({FirebaseAuth? firebaseAuth, CacheClient? cache})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _cache = cache ?? CacheClient();

  @override
  Future logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      // Login with firebase auth
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future logOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (_) {
      throw LogOutFailure();
    }
  }

  @override
  Future signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }
}

extension FirebaseUsertoUser on User {
  UserModel get toUserModel {
    return UserModel(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
