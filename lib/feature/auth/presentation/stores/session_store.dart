import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:mobx/mobx.dart';

part 'session_store.g.dart';

class SessionStore = _SessionStoreBase with _$SessionStore;

abstract class _SessionStoreBase with Store {
  @observable
  UserSummaryEntity? currentUser;

  @computed
  bool get isLogged => currentUser != null;
}