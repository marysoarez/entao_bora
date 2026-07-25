import 'dart:convert';

import 'package:entao_bora/core/location/data/data_source/location_data_source.dart';
import 'package:entao_bora/core/location/data/dtos/address_dto.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationDatasourceImpl implements ILocationDatasource {
  @override
  Future<LocationEntity> getCurrentLocation() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Serviço de localização desabilitado.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Permissão de localização negada.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização negada permanentemente.',
      );
    }

    final position = await Geolocator.getCurrentPosition();

    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Future<List<AddressDto>> searchAddress(String query) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=${Uri.encodeQueryComponent(query)}'
      '&format=jsonv2'
      '&addressdetails=1'
      '&limit=10'
      '&countrycodes=br',
    );

    final response = await http.get(
      uri,
      headers: const {
        'User-Agent': 'EntaoBora/1.0',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar endereço (${response.statusCode}).',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((item) => AddressDto.fromNominatim(item))
        .toList();
  }

  @override
  Future<AddressDto?> reverseGeocode(
    LocationEntity location,
  ) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse'
      '?lat=${location.latitude}'
      '&lon=${location.longitude}'
      '&format=jsonv2'
      '&addressdetails=1',
    );

    final response = await http.get(
      uri,
      headers: const {
        'User-Agent': 'EntaoBora/1.0',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body);

    return AddressDto.fromNominatim(data);
  }
}