import 'package:entao_bora/feature/auth/data/dtos/user_summary_dto.dart';

abstract class AuthDatasource {
  Future<UserSummaryDto?> getCurrentUser();

  Future<UserSummaryDto?> signInWithGoogle();

  Future<UserSummaryDto> signInAnonymously();

  Future<void> signOut();
  Future<bool> isLogged();
}
