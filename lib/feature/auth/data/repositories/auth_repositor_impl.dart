import 'package:entao_bora/feature/auth/data/datasource/auth_datasource.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/stores/session_store.dart';
import 'package:flutter/foundation.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._datasource, this._session);

  final AuthDatasource _datasource;
  final SessionStore _session;

  @override
  UserSummaryEntity? get currentUser => _session.currentUser;

  @override
  Future<UserSummaryEntity?> signInWithGoogle() async {
    final dto = await _datasource.signInWithGoogle();

    _session.currentUser = dto?.toEntity();

    return _session.currentUser;
  }

  @override
  Future<UserSummaryEntity?> getCurrentUser({bool forceRefresh = false}) async {
    if (!forceRefresh && _session.currentUser != null) {
      return _session.currentUser;
    }

    _session.currentUser = (await _datasource.getCurrentUser())?.toEntity();

    debugPrint(
      'Auth current user loaded: uid=${_session.currentUser?.id} role=${_session.currentUser?.role.slug} forceRefresh=$forceRefresh',
    );

    return _session.currentUser;
  }

  @override
  Future<UserSummaryEntity> signInAnonymously() async {
    final dto = await _datasource.signInAnonymously();

    _session.currentUser = dto.toEntity();

    return _session.currentUser!;
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();

    _session.currentUser = null;
  }

  @override
  Future<bool> isLogged() async {
    if (_session.currentUser != null) {
      return true;
    }

    _session.currentUser = (await _datasource.getCurrentUser())?.toEntity();

    return _session.currentUser != null;
  }
}
