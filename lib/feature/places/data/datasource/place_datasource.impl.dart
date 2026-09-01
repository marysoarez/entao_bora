import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/feature/places/data/datasource/place_datasource.dart';
import 'package:entao_bora/feature/places/data/dtos/place_dto.dart';

class PlaceDatasourceImpl implements IPlaceDatasource {
  final FirebaseFirestore firestore;

  PlaceDatasourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection('places');

  @override
  Future<List<PlaceDto>> getPlaces() async {
    final snapshot = await collection.get();

    return snapshot.docs.map(_mapDocument).toList();
  }

  @override
  Future<void> updatePlace(PlaceDto place) async {
    await firestore.collection('places').doc(place.id).update(place.toMap());
  }

  @override
  Future<void> createPlace(PlaceDto place) async {
    final doc = collection.doc();

    await doc.set(place.copyWith(id: doc.id).toMap());
  }

  @override
  Future<PlaceDto?> getPlaceById(String id) async {
    final doc = await collection.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return _mapDocument(doc);
  }

  PlaceDto _mapDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return PlaceDto.fromMap({'id': doc.id, ...?doc.data()});
  }

  @override
  Future<List<PlaceDto>> getPlacesByOwnerId(String ownerId) async {
    final placesById = <String, PlaceDto>{};

    final snapshots = await Future.wait([
      collection.where('ownerId', isEqualTo: ownerId).get(),
      collection.where('ownerId.id', isEqualTo: ownerId).get(),
    ]);

    for (final snapshot in snapshots) {
      for (final doc in snapshot.docs) {
        placesById[doc.id] = _mapDocument(doc);
      }
    }

    return placesById.values.toList();
  }
}
