import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/core/firestore/data/firestore_client.dart';

class FirestoreClientImpl implements FirestoreClient {
  final FirebaseFirestore _firestore;

  FirestoreClientImpl(this._firestore);

  @override
  FirebaseFirestore get instance => _firestore;

  @override
  CollectionReference<Map<String, dynamic>> collection(
    String path,
  ) {
    return _firestore.collection(path);
  }

  @override
  DocumentReference<Map<String, dynamic>> document(
    String path,
  ) {
    return _firestore.doc(path);
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String path,
  ) {
    return document(path).get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String path,
  ) {
    return collection(path).get();
  }

  @override
  Future<void> set(
    String path,
    Map<String, dynamic> data,
  ) {
    return document(path).set(data);
  }

  @override
  Future<void> update(
    String path,
    Map<String, dynamic> data,
  ) {
    return document(path).update(data);
  }

  @override
  Future<void> delete(
    String path,
  ) {
    return document(path).delete();
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    return collection(collectionPath).add(data);
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
    String path,
  ) {
    return document(path).snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    String path,
  ) {
    return collection(path).snapshots();
  }

  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler,
  ) {
    return _firestore.runTransaction(transactionHandler);
  }

  @override
  WriteBatch batch() {
    return _firestore.batch();
  }
}