import '../entities/user_summary_entity.dart';

abstract class IAuthRepository {
  UserSummaryEntity? get currentUser;
  Future<UserSummaryEntity?> signInWithGoogle();

  Future<UserSummaryEntity> signInAnonymously();

  Future<void> signOut();

  Future<UserSummaryEntity?> getCurrentUser();

  Future<bool> isLogged();
}
