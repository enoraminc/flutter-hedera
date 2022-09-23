import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:hedera_core/apis/auth_api.dart';
import 'package:hedera_core/utils/log.dart';

class AuthApiImpl extends AuthApi {
  late FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

  AuthApiImpl() {
    _auth = FirebaseAuth.instance;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return true;
    } else {
      User? firebaseUser = await _auth.authStateChanges().first;
      Log.setLog('currentUser: ${firebaseUser?.email}', method: "AuthApiImpl");
      if (firebaseUser != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      Log.setLog('Google user:', method: "AuthApiImpl");
      Log.setLog(googleUser?.email, method: "AuthApiImpl");

      if (googleUser == null) {
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(
        credential,
      );

      Log.setLog('Auth result:', method: "AuthApiImpl");
      Log.setLog(authResult.user?.email, method: "AuthApiImpl");

      // String firebaseIdToken = await authResult.user?.getIdToken() ?? "";
      // print("=======================JWT AUTH==========================");
      // while (firebaseIdToken.length > 0) {
      //   int startTokenLength =
      //       (firebaseIdToken.length >= 500 ? 500 : firebaseIdToken.length);
      //   print("TokenPart: " + firebaseIdToken.substring(0, startTokenLength));
      //   int lastTokenLength = firebaseIdToken.length;
      //   firebaseIdToken =
      //       firebaseIdToken.substring(startTokenLength, lastTokenLength);
      // }

      // String firebaseIdToken = await authResult.user?.getIdToken() ?? "";
      // while (firebaseIdToken.length > 0) {
      //   int startTokenLength =
      //       (firebaseIdToken.length >= 500 ? 500 : firebaseIdToken.length);
      //   Log.setLog(
      //       "TokenPart: " + firebaseIdToken.substring(0, startTokenLength));
      //   int lastTokenLength = firebaseIdToken.length;
      //   firebaseIdToken =
      //       firebaseIdToken.substring(startTokenLength, lastTokenLength);
      // }
      // Log.setLog('currentUser JWT: $firebaseIdToken');
      return authResult.user != null;
    } catch (e, s) {
      Log.setLog('loginWithGoogle error: $e, $s', method: "AuthApiImpl");
      return Future.error(e);
    }
  }

  @override
  Future logout() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
    return true;
  }
}
