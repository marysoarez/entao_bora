import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/stores/session_store.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'auth_viewmodel.g.dart';

class AuthViewModel = _AuthViewModelBase with _$AuthViewModel;

abstract class _AuthViewModelBase with Store {
  _AuthViewModelBase(this._repository, this._session);

  final IAuthRepository _repository;
  final SessionStore _session;

  @observable
  bool loading = false;

  UserSummaryEntity? get user => _session.currentUser;

  @computed
  bool get isLogged => _session.isLogged;

  @action
  Future<void> loadUser() async {
    await _repository.getCurrentUser();
  }

  @action
  Future<void> reloadUser() async {
    await _repository.getCurrentUser(forceRefresh: true);
  }

  @action
  Future<void> logout() async {
    await _repository.signOut();
  }

  Future<void> logoutAndGoHome() async {
    await logout();
    Modular.to.navigate('/');
  }

  Future<bool> ensureLogged(BuildContext context) async {
    if (isLogged) return true;

    return await LoginDialog.show(context);
  }

  @action
  Future<void> refresh() async {
    await reloadUser();
  }

  @action
  Future<bool> loginWithGoogle() async {
    loading = true;

    try {
      await _repository.signInWithGoogle();
      return isLogged;
    } finally {
      loading = false;
    }
  }
}
