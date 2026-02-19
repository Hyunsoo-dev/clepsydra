import 'package:clepsydra/data/remote_data_source.dart';
import 'package:clepsydra/data/user_model.dart';
import 'package:clepsydra/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService;
  final RemoteDataSource _remote;

  UserModel? _user;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  // final AuthService _authService = AuthService();

  UserProvider({
    required AuthService authService,
    required RemoteDataSource remote,
  }) : _authService = authService,
       _remote = remote;

  Future<void> login() async {
    final account = await _authService.signIn();
    final auth = await account?.authentication;
    if (auth?.idToken != null) {
      final user = await _remote.loginWithGoogle(auth!.idToken!);
      debugPrint('user: $user');
      _user = UserModel.fromJson(user);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
