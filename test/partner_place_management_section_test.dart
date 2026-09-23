import 'package:entao_bora/core/app_theme.dart';
import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_place_management_section.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';
import 'package:entao_bora/shared/enum/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _owner = UserSummaryEntity(
  id: 'partner-1',
  name: 'Parceiro',
  role: UserRole.partner,
);

const _place = PlaceEntity(
  id: 'place-1',
  name: 'Casa da Música',
  description: 'Shows e gastronomia',
  address: AddressEntity(
    displayName: 'Rua Principal, 10',
    location: LocationEntity(latitude: -23, longitude: -46),
  ),
  musicGenres: [MusicGenre.classicRock],
  type: PlaceType.bar,
  phone: '',
  instagram: '',
  website: '',
  openingHours: [],
  photos: [],
  menuItems: [
    MenuItemEntity(
      id: 'item-1',
      title: 'Petisco',
      description: '',
      price: 20,
      photo: '',
    ),
  ],
  ownerId: _owner,
);

void main() {
  testWidgets('shows every establishment management shortcut', (tester) async {
    var selectedAction = '';

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PartnerPlaceManagementSection(
              place: _place,
              onOpenPlace: () => selectedAction = 'open',
              onEditPlace: () => selectedAction = 'edit',
              onManageMenu: () => selectedAction = 'menu',
              onCreateEvent: () => selectedAction = 'event',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Informações'), findsOneWidget);
    expect(find.text('Cardápio'), findsOneWidget);
    expect(find.text('Programação'), findsOneWidget);
    expect(find.text('Página pública'), findsOneWidget);
    expect(find.text('1 item(ns) publicado(s)'), findsOneWidget);

    await tester.tap(find.text('Gerenciar'));
    expect(selectedAction, 'menu');
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a single column on mobile without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PartnerPlaceManagementSection(
              place: _place,
              onOpenPlace: () {},
              onEditPlace: () {},
              onManageMenu: () {},
              onCreateEvent: () {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
