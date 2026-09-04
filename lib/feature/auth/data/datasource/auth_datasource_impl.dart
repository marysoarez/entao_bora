import 'package:entao_bora/feature/auth/data/datasource/auth_datasource.dart';
import 'package:entao_bora/feature/auth/data/dtos/user_summary_dto.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDatasourceImpl implements AuthDatasource {
  AuthDatasourceImpl(this._auth, this._users);

  final FirebaseAuth _auth;
  final UserDatasource _users;
  @override
  Future<UserSummaryDto> signInWithGoogle() async {
    User user;

    if (kIsWeb) {
      final provider = GoogleAuthProvider();

      final credential = await _auth.signInWithPopup(provider);

      if (credential.user == null) {
        throw Exception('Falha ao autenticar.');
      }

      user = credential.user!;
    } else {
      final google = GoogleSignIn.instance;

      await google.initialize();

      final account = await google.authenticate();

      final authentication = account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      if (result.user == null) {
        throw Exception('Falha ao autenticar.');
      }

      user = result.user!;
    }

    final dto = UserSummaryDto.fromUser(user);

    final existingUser = await _users.getUser(dto.id);

    if (existingUser == null) {
      await _users.createUser(dto);
    } else {
      final updatedUser = existingUser.copyWith(
        name: dto.name,
        email: dto.email,
        photoUrl: dto.photoUrl,
        isAnonymous: dto.isAnonymous,
      );

      await _users.updateUser(UserSummaryDto.fromEntity(updatedUser));
    }

    final savedUser = await _users.getUser(dto.id);

    if (savedUser == null) {
      throw Exception('Não foi possível carregar o usuário.');
    }

    return savedUser;
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
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    debugPrint(
      'Auth datasource loading Firestore user: uid=${firebaseUser.uid}',
    );

    return await _users.getUser(firebaseUser.uid);
  }

  @override
  Future<bool> isLogged() async {
    return _auth.currentUser != null;
  }
}
