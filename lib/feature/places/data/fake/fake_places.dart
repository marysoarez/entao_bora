// import 'package:entao_bora/shared/enum/oppening_hours.dart';
// import 'package:entao_bora/shared/enum/week_da_enum.dart';
// import 'package:entao_bora/shared/models/geopoint.dart';
// import 'package:flutter/material.dart';

// import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
// import 'package:entao_bora/shared/enum/music_genre.dart';
// import 'package:entao_bora/shared/enum/place_type_enum.dart';


// final fakePlaces = [
//   PlaceEntity(
//     id: '1',
//     name: 'Garage Pub',
//     description: 'Pub especializado em Classic Rock e Heavy Metal.',
//     address: 'Rua Ceará, 154 - Praça da Bandeira, Rio de Janeiro',
//     location: const GeoPoint(
//       latitude: -22.9126,
//       longitude: -43.2146,
//     ),
//     musicGenres: const [
//       MusicGenre.classicRock,
//       MusicGenre.heavyMetal,
//       MusicGenre.hardRock,
//     ],
//     type: PlaceType.pub,
//     phone: '(21) 99999-1111',
//     instagram: '@garagepubrj',
//     website: 'https://garagepub.com.br',
//     openingHours: const [
//       OpeningHours(
//         weekday: Weekday.thursday,
//         opensAt: TimeOfDay(hour: 19, minute: 0),
//         closesAt: TimeOfDay(hour: 2, minute: 0),
//       ),
//       OpeningHours(
//         weekday: Weekday.friday,
//         opensAt: TimeOfDay(hour: 19, minute: 0),
//         closesAt: TimeOfDay(hour: 3, minute: 0),
//       ),
//       OpeningHours(
//         weekday: Weekday.saturday,
//         opensAt: TimeOfDay(hour: 18, minute: 0),
//         closesAt: TimeOfDay(hour: 3, minute: 0),
//       ),
//     ],
//     photos: [
//       'https://picsum.photos/600/400?1',
//       'https://picsum.photos/600/400?2',
//     ],
//   ),

//   PlaceEntity(
//     id: '2',
//     name: 'Black Dog Pub',
//     description: 'Pub com bandas de Rock Nacional e Indie.',
//     address: 'Rua do Catete, 250 - Catete, Rio de Janeiro',
//     location: const GeoPoint(
//       latitude: -22.9252,
//       longitude: -43.1765,
//     ),
//     musicGenres: const [
//       MusicGenre.nacional,
//       MusicGenre.indie,
//       MusicGenre.alternative,
//     ],
//     type: PlaceType.pub,
//     phone: '(21) 98888-2222',
//     instagram: '@blackdogpub',
//     website: 'https://blackdog.com.br',
//     openingHours: const [
//       OpeningHours(
//         weekday: Weekday.wednesday,
//         opensAt: TimeOfDay(hour: 18, minute: 0),
//         closesAt: TimeOfDay(hour: 1, minute: 0),
//       ),
//       OpeningHours(
//         weekday: Weekday.friday,
//         opensAt: TimeOfDay(hour: 18, minute: 0),
//         closesAt: TimeOfDay(hour: 2, minute: 0),
//       ),
//       OpeningHours(
//         weekday: Weekday.saturday,
//         opensAt: TimeOfDay(hour: 18, minute: 0),
//         closesAt: TimeOfDay(hour: 2, minute: 0),
//       ),
//     ],
//     photos: [
//       'https://picsum.photos/600/400?3',
//       'https://picsum.photos/600/400?4',
//     ],
//   ),

//   PlaceEntity(
//     id: '3',
//     name: 'Circo Voador',
//     description: 'Uma das casas de shows mais tradicionais do Brasil.',
//     address: 'Rua dos Arcos, s/n - Lapa, Rio de Janeiro',
//     location: const GeoPoint(
//       latitude: -22.9136,
//       longitude: -43.1791,
//     ),
//     musicGenres: const [
//       MusicGenre.heavyMetal,
//       MusicGenre.punk,
//       MusicGenre.hardcore,
//       MusicGenre.alternative,
//     ],
//     type: PlaceType.concertHall,
//     phone: '(21) 99999-3333',
//     instagram: '@circovoador',
//     website: 'https://circovoador.com.br',
//     openingHours: const [
//       OpeningHours(
//         weekday: Weekday.friday,
//         opensAt: TimeOfDay(hour: 19, minute: 0),
//         closesAt: TimeOfDay(hour: 4, minute: 0),
//       ),
//       OpeningHours(
//         weekday: Weekday.saturday,
//         opensAt: TimeOfDay(hour: 19, minute: 0),
//         closesAt: TimeOfDay(hour: 4, minute: 0),
//       ),
//     ],
//     photos: [
//       'https://picsum.photos/600/400?5',
//       'https://picsum.photos/600/400?6',
//     ],
//   ),
// ];