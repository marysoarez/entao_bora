import 'package:entao_bora/feature/auth/data/datasource/auth_datasource.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);
  @override
  UserSummaryEntity? get currentUser => _currentUser;
  final AuthDatasource _datasource;

  UserSummaryEntity? _currentUser;

  @override
  Future<UserSummaryEntity?> signInWithGoogle() async {
    final dto = await _datasource.signInWithGoogle();

    _currentUser = dto?.toEntity();

    return _currentUser;
  }

  @override
  Future<UserSummaryEntity?> getCurrentUser() async {
    _currentUser ??= (await _datasource.getCurrentUser())?.toEntity();
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    await _datasource.signOut();
  }

  @override
  Future<UserSummaryEntity> signInAnonymously() async {
    final dto = await _datasource.signInAnonymously();

    _currentUser = dto.toEntity();

    return _currentUser!;
  }

  @override
  Future<bool> isLogged() async {
    _currentUser ??= (await _datasource.getCurrentUser())?.toEntity();

    return _currentUser != null;
  }
}
