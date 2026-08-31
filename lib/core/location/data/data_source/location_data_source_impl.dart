import 'dart:convert';

import 'package:entao_bora/core/location/data/data_source/location_data_source.dart';
import 'package:entao_bora/core/location/data/dtos/address_dto.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/shared/config/google_config.dart';
import 'package:flutter/material.dart';
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

    final position =
        await Geolocator.getCurrentPosition();

    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Future<List<AddressDto>> searchAddress(
    String query,
  ) async {
   final response = await http.post(
  Uri.parse(
    'https://places.googleapis.com/v1/places:autocomplete',
  ),
  headers: {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': GoogleConfig.apiKey,
    'X-Goog-FieldMask':
        'suggestions.placePrediction.placeId,'
        'suggestions.placePrediction.text',
  },
  body: jsonEncode({
    'input': query,
    'includedRegionCodes': ['br'],
    'languageCode': 'pt-BR',
  }),
);

    debugPrint(
      '📍 GOOGLE AUTOCOMPLETE STATUS: '
      '${response.statusCode}',
    );

    if (response.statusCode != 200) {
      debugPrint(
        '❌ GOOGLE AUTOCOMPLETE: ${response.body}',
      );

      throw Exception(
        'Erro ao buscar endereço (${response.statusCode}).',
      );
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final suggestions =
        data['suggestions'] as List<dynamic>? ?? [];

    final addresses = <AddressDto>[];

    for (final item in suggestions) {
      final prediction =
          item['placePrediction']
              as Map<String, dynamic>?;

      if (prediction == null) continue;

      final placeId =
          prediction['placeId']?.toString();

      if (placeId == null || placeId.isEmpty) {
        continue;
      }

      final address =
          await _getPlaceDetails(placeId);

      if (address != null) {
        addresses.add(address);
      }
    }

    return addresses;
  }

  Future<AddressDto?> _getPlaceDetails(
    String placeId,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://places.googleapis.com/v1/places/$placeId',
      ),
      headers: {
        'X-Goog-Api-Key':GoogleConfig.apiKey,
        'X-Goog-FieldMask':
            'id,displayName,formattedAddress,location,addressComponents',
      },
    );

    debugPrint(
      '📍 GOOGLE PLACE DETAILS STATUS: '
      '${response.statusCode}',
    );

    if (response.statusCode != 200) {
      debugPrint(
        '❌ GOOGLE PLACE DETAILS: ${response.body}',
      );

      return null;
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final location =
        data['location'] as Map<String, dynamic>?;

    if (location == null) {
      return null;
    }

    final components =
        data['addressComponents'] as List<dynamic>? ?? [];

    String? getComponent(String type) {
      for (final item in components) {
        final component =
            item as Map<String, dynamic>;

        final types =
            component['types'] as List<dynamic>? ?? [];

        if (types.contains(type)) {
          return component['longText']?.toString();
        }
      }

      return null;
    }

    final displayName =
        (data['displayName']
                as Map<String, dynamic>?)?['text']
            ?.toString() ??
        data['formattedAddress']?.toString() ??
        '';

    return AddressDto(
      displayName: displayName,
      street: getComponent('route'),
      number: getComponent('street_number'),
      neighborhood:
          getComponent('sublocality_level_1') ??
          getComponent('sublocality'),
      city:
          getComponent('locality') ??
          getComponent('administrative_area_level_2'),
      state: getComponent(
        'administrative_area_level_1',
      ),
      country: getComponent('country'),
      postalCode: getComponent('postal_code'),
      location: LocationEntity(
        latitude:
            (location['latitude'] as num).toDouble(),
        longitude:
            (location['longitude'] as num).toDouble(),
      ),
    );
  }

  @override
  Future<AddressDto?> geocodeAddress(
    AddressDto address,
  ) async {
    final parts = [
      if (address.street?.trim().isNotEmpty ?? false)
        address.street!.trim(),
      if (address.number?.trim().isNotEmpty ?? false)
        address.number!.trim(),
      if (address.neighborhood?.trim().isNotEmpty ?? false)
        address.neighborhood!.trim(),
      if (address.city?.trim().isNotEmpty ?? false)
        address.city!.trim(),
      if (address.state?.trim().isNotEmpty ?? false)
        address.state!.trim(),
      if (address.postalCode?.trim().isNotEmpty ?? false)
        address.postalCode!.trim(),
      'Brasil',
    ];

    final query = parts.join(', ');

    debugPrint('📍 GOOGLE GEOCODING: $query');

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'address': query,
        'key': GoogleConfig.apiKey,
        'language': 'pt-BR',
        'region': 'br',
      },
    );

    final response = await http.get(uri);

    debugPrint(
      '📍 GOOGLE GEOCODING STATUS: '
      '${response.statusCode}',
    );

    if (response.statusCode != 200) {
      debugPrint(
        '❌ GOOGLE GEOCODING: ${response.body}',
      );

      throw Exception(
        'Erro ao geocodificar endereço.',
      );
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final status = data['status']?.toString();

    debugPrint(
      '📍 GOOGLE GEOCODING RESULT: $status',
    );

    if (status != 'OK') {
      debugPrint(
        '❌ GOOGLE GEOCODING RESPONSE: $data',
      );

      return null;
    }

    final results =
        data['results'] as List<dynamic>? ?? [];

    if (results.isEmpty) {
      return null;
    }

    final result =
        results.first as Map<String, dynamic>;

    final geometry =
        result['geometry'] as Map<String, dynamic>?;

    final location =
        geometry?['location'] as Map<String, dynamic>?;

    if (location == null) {
      return null;
    }

    final latitude =
        (location['lat'] as num).toDouble();

    final longitude =
        (location['lng'] as num).toDouble();

    debugPrint(
      '✅ GOOGLE COORDENADA: '
      '$latitude, $longitude',
    );

    return AddressDto(
      displayName:
          result['formatted_address']?.toString() ??
          address.displayName,
      street: address.street,
      number: address.number,
      complement: address.complement,
      neighborhood: address.neighborhood,
      city: address.city,
      state: address.state,
      country: address.country,
      postalCode: address.postalCode,
      location: LocationEntity(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  Future<AddressDto?> reverseGeocode(
    LocationEntity location,
  ) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng':
            '${location.latitude},${location.longitude}',
        'key': GoogleConfig.apiKey,
        'language': 'pt-BR',
        'region': 'br',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return null;
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (data['status'] != 'OK') {
      return null;
    }

    final results =
        data['results'] as List<dynamic>? ?? [];

    if (results.isEmpty) {
      return null;
    }

    final result =
        results.first as Map<String, dynamic>;

    final geometry =
        result['geometry'] as Map<String, dynamic>?;

    final locationData =
        geometry?['location']
            as Map<String, dynamic>?;

    if (locationData == null) {
      return null;
    }

    final components =
        result['address_components']
            as List<dynamic>? ??
        [];

    String? getComponent(String type) {
      for (final item in components) {
        final component =
            item as Map<String, dynamic>;

        final types =
            component['types'] as List<dynamic>? ?? [];

        if (types.contains(type)) {
          return component['long_name']?.toString();
        }
      }

      return null;
    }

    return AddressDto(
      displayName:
          result['formatted_address']?.toString() ?? '',
      street: getComponent('route'),
      number: getComponent('street_number'),
      neighborhood:
          getComponent('sublocality_level_1') ??
          getComponent('sublocality'),
      city:
          getComponent('locality') ??
          getComponent('administrative_area_level_2'),
      state: getComponent(
        'administrative_area_level_1',
      ),
      country: getComponent('country'),
      postalCode: getComponent('postal_code'),
      location: LocationEntity(
        latitude:
            (locationData['lat'] as num).toDouble(),
        longitude:
            (locationData['lng'] as num).toDouble(),
      ),
    );
  }
}