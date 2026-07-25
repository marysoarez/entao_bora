import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'login_viewmodel.g.dart';

class LoginViewModel = LoginViewModelBase with _$LoginViewModel;

abstract class LoginViewModelBase with Store {
  LoginViewModelBase(this._authRepository);

  final AuthRepository _authRepository;

  @observable
  bool loading = false;

  @action
  Future<bool> loginWithGoogle() async {
    loading = true;

    try {
      await _authRepository.signInWithGoogle();
      return true;
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    } finally {
      loading = false;
    }
  }
}
