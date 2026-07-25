import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreClient {
  FirebaseFirestore get instance;

  CollectionReference<Map<String, dynamic>> collection(
    String path,
  );

  DocumentReference<Map<String, dynamic>> document(
    String path,
  );

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String path,
  );

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String path,
  );

  Future<void> set(
    String path,
    Map<String, dynamic> data,
  );

  Future<void> update(
    String path,
    Map<String, dynamic> data,
  );

  Future<void> delete(
    String path,
  );

  Future<DocumentReference<Map<String, dynamic>>> add(
    String collection,
    Map<String, dynamic> data,
  );

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
    String path,
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    String path,
  );

  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler,
  );

  WriteBatch batch();
}