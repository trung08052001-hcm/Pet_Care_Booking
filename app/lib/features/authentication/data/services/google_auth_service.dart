import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Signs in with Google via Firebase Auth and returns a Firebase ID token
/// for backend verification at `POST /api/v1/auth/social/google`.
class GoogleAuthService {
  const GoogleAuthService();

  Future<String> signInAndGetIdToken() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
      );

      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const GoogleAuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken(true);

      if (idToken == null || idToken.isEmpty) {
        throw const GoogleAuthException('Failed to obtain Google ID token.');
      }

      return idToken;
    } on GoogleAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw GoogleAuthException(
        e.message ?? 'Firebase authentication failed.',
      );
    } catch (e) {
      throw GoogleAuthException('Google sign-in error: $e');
    }
  }
}

class GoogleAuthException implements Exception {
  const GoogleAuthException(this.message);
  final String message;

  @override
  String toString() => 'GoogleAuthException: $message';
}
