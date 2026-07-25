import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'splash_viewmodel.g.dart';

class SplashViewModel = SplashViewModelBase with _$SplashViewModel;

abstract class SplashViewModelBase with Store {
  SplashViewModelBase(this._authRepository);

  final AuthRepository _authRepository;

  @action
  Future<void> initialize() async {
    final logged = await _authRepository.isLogged();

    Modular.to.navigate('/home', arguments: {'showLogin': !logged});
  }
}
