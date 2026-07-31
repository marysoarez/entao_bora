import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/feature/auth/data/dtos/user_summary_dto.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource.dart';

class UserDatasourceImpl implements UserDatasource {
  UserDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');

  @override
  Future<UserSummaryDto?> getUser(String id) async {
    final doc = await _users.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return UserSummaryDto.fromMap(doc.data()!);
  }

  @override
  Future<bool> exists(String id) async {
    final doc = await _users.doc(id).get();

    return doc.exists;
  }

  @override
  Future<void> createUser(UserSummaryDto user) async {
    await _users.doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(UserSummaryDto user) async {
    await _users.doc(user.id).update(user.toMap());
  }
  @override
Future<void> saveUser(UserSummaryDto user) async {
  await firestore
      .collection('users')
      .doc(user.id)
      .set(
        user.toMap(),
        SetOptions(merge: true),
      );
}
}