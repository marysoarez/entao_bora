import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';

class EventLocationEntity {
final EventLocationEntity location;

  final String name;

  final AddressEntity address;

  const EventLocationEntity({
    required this.location,
    required this.name,
    required this.address,
  });

  // ignore: unnecessary_null_comparison
  bool get isRegisteredPlace => location != null;
}