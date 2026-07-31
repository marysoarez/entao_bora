import 'package:entao_bora/feature/auth/data/dtos/user_summary_dto.dart';

abstract class UserDatasource {
  Future<UserSummaryDto?> getUser(String id);

  Future<void> createUser(UserSummaryDto user);

  Future<void> updateUser(UserSummaryDto user);
Future<void> saveUser(UserSummaryDto user);
  Future<bool> exists(String id);
}