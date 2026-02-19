import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '847294136607-eaod9np13oub8mhhv7kqjcasipd52aoh.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;
        debugPrint('auth: $auth');
        debugPrint('account: $account');
        debugPrint('ID Token: ${auth.idToken}');
        debugPrint('User Email: ${account.email}');
      }

      return account;
    } catch (error) {
      debugPrint('구글 로그인 중 에러 발생: $error');
      return null;
    }
  }

  Future<void> signOut() => _googleSignIn.disconnect();
}
