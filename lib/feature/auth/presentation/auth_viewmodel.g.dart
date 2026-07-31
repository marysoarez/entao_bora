// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthViewModel on _AuthViewModelBase, Store {
  Computed<bool>? _$isLoggedComputed;

  @override
  bool get isLogged => (_$isLoggedComputed ??= Computed<bool>(
    () => super.isLogged,
    name: '_AuthViewModelBase.isLogged',
  )).value;

  late final _$userAtom = Atom(
    name: '_AuthViewModelBase.user',
    context: context,
  );

  @override
  UserSummaryEntity? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserSummaryEntity? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$loadingAtom = Atom(
    name: '_AuthViewModelBase.loading',
    context: context,
  );

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$loadUserAsyncAction = AsyncAction(
    '_AuthViewModelBase.loadUser',
    context: context,
  );

  @override
  Future<void> loadUser() {
    return _$loadUserAsyncAction.run(() => super.loadUser());
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_AuthViewModelBase.logout',
    context: context,
  );

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_AuthViewModelBase.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
user: ${user},
loading: ${loading},
isLogged: ${isLogged}
    ''';
  }
}
