import 'package:entao_bora/feature/auth/data/datasource/auth_datasource.dart';
import 'package:entao_bora/feature/auth/data/dtos/user_summary_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDatasourceImpl implements AuthDatasource {
  AuthDatasourceImpl(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<UserSummaryDto> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();

      final credential = await _auth.signInWithPopup(provider);

      final user = credential.user;

      if (user == null) {
        throw Exception('Falha ao autenticar.');
      }

      return UserSummaryDto.fromUser(user);
    }

    final google = GoogleSignIn.instance;

    await google.initialize();

    final account = await google.authenticate();

    final authentication = account.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
    );

    final result = await _auth.signInWithCredential(credential);

    final user = result.user;

    if (user == null) {
      throw Exception('Falha ao autenticar.');
    }

    return UserSummaryDto.fromUser(user);
  }

  @override
  Future<UserSummaryDto> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();

    final user = credential.user;

    if (user == null) {
      throw Exception('Falha ao autenticar anonimamente.');
    }

    return UserSummaryDto.fromUser(user);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<UserSummaryDto?> getCurrentUser() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return UserSummaryDto.fromUser(user);
  }

  @override
  Future<bool> isLogged() async {
    return _auth.currentUser != null;
  }
}
