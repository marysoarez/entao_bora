import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'auth_viewmodel.g.dart';

class AuthViewModel = _AuthViewModelBase with _$AuthViewModel;

abstract class _AuthViewModelBase with Store {
  _AuthViewModelBase(this._repository);

  final IAuthRepository _repository;

  @observable
  UserSummaryEntity? user;

  @observable
  bool loading = false;

  @computed
  bool get isLogged => user != null;

  @action
  Future<void> loadUser() async {
    user = await _repository.getCurrentUser();
  }

  @action
  Future<void> logout() async {
    await _repository.signOut();
    user = null;
  }
Future<bool> ensureLogged(BuildContext context) async {
  if (isLogged) return true;

  final success = await LoginDialog.show(context);

  if (!success) return false;

  await loadUser();

  return isLogged;
}
  @action
  Future<void> refresh() async {
    await loadUser();
  }
}
