import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venus/src/services/firebase_authentication/entities/firebase_user.dart';
import 'package:venus/src/services/firebase_authentication/repository/exception.dart';
import 'package:venus/src/services/cache/cache.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  static const userCacheKey = 'user_cache_key';

  Stream<FirebaseUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      late FirebaseUser fuser;

      if (firebaseUser == null) {
        fuser = FirebaseUser.empty;
      } else {
        if (currentUser.isEmpty) {
          fuser = firebaseUser.toUser;
        } else {
          fuser = currentUser;
        }
      }
      _cache.write(key: userCacheKey, value: fuser);
      return fuser;
    });
  }

  FirebaseUser get currentUser {
    return _cache.read<FirebaseUser>(key: userCacheKey) ?? FirebaseUser.empty;
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } catch (_) {}
  }

  Future<void> saveAccount(
      {required String email, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  Future<void> refreshToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      final password = prefs.getString('password');

      await _firebaseAuth.signInWithEmailAndPassword(
          email: email ?? "", password: password ?? "");
    } catch (_) {}
  }

  Future<FirebaseUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      await refreshToken();

      return FirebaseUser(
          uid: userCredential.user?.uid ?? "",
          email: email,
          displayName: userCredential.user?.displayName,
          photoURL: userCredential.user?.photoURL,
          isAnonymous: userCredential.user?.isAnonymous,
          isEmailVerified: userCredential.user?.emailVerified,
          metadata: '{}',
          phoneNumber: userCredential.user?.phoneNumber,
          refreshToken: userCredential.user?.refreshToken,
          tenantId: userCredential.user?.tenantId);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await saveAccount(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithEmailAndPasswordFailure();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final googleProvider = firebase_auth.GoogleAuthProvider();
      final userCredential = await _firebaseAuth.signInWithPopup(
        googleProvider,
      );

      credential = userCredential.credential!;
      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithGoogleFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('email');
      prefs.remove('password');

      _cache.write(key: userCacheKey, value: Null);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  FirebaseUser get toUser {
    return FirebaseUser(
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        isAnonymous: isAnonymous,
        isEmailVerified: emailVerified,
        metadata: '{}',
        phoneNumber: phoneNumber,
        refreshToken: refreshToken,
        tenantId: tenantId);
  }
}
