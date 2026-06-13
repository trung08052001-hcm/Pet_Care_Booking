import 'package:google_sign_in/google_sign_in.dart';

/// Signs in with Google and returns a Google OAuth ID token for the backend.
class GoogleAuthService {
  const GoogleAuthService();

  static const String _webClientId =
      '674702415842-qp6pb8fg2tf0eujddj4o97mtobug60lm.apps.googleusercontent.com';

  Future<String> signInAndGetIdToken() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: _webClientId,
      );

      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const GoogleAuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const GoogleAuthException('Failed to obtain Google ID token.');
      }

      return idToken;
    } on GoogleAuthException {
      rethrow;
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
