import 'dart:io';
import 'dart:ui' as ui;
import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_status_enum.dart';
import 'package:entao_bora/feature/events/domain/entities/event_ticket_entity.dart';
import 'package:entao_bora/feature/home/presentation/pages/map_seleton.dart';
import 'package:entao_bora/feature/home/presentation/widgets/home_explore.dart';
import 'package:entao_bora/feature/home/presentation/widgets/home_result_cards.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_section.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';
import 'package:entao_bora/shared/enum/ticket_type_enum.dart';
import 'package:entao_bora/shared/enum/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

const address = AddressEntity(
  displayName: 'Rua da Música, 10',
  neighborhood: 'Lapa',
  location: LocationEntity(latitude: -22.91, longitude: -43.18),
);
const user = UserSummaryEntity(id: 'u', name: 'Maria', role: UserRole.partner);
EventEntity event(
  String id, {
  String title = 'Noite de Rock',
  bool free = true,
  MusicGenre genre = MusicGenre.classicRock,
  String? placeId,
  DateTime? end,
  EventStatus status = EventStatus.published,
}) => EventEntity(
  id: id,
  slug: 'show-$id',
  title: title,
  description: '',
  locationName: 'Bar da Lapa',
  address: address,
  placeId: placeId,
  startDate: DateTime.now().add(const Duration(days: 1)),
  endDate: end ?? DateTime.now().add(const Duration(days: 2)),
  coverImage: '',
  gallery: [],
  musicGenres: [genre],
  attractions: [],
  ticket: EventTicketEntity(type: free ? TicketType.free : TicketType.external),
  boraCount: 0,
  checkinCount: 0,
  views: 0,
  shares: 0,
  createdBy: user,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  status: status,
);
PlaceEntity place(String id, {LocationEntity? location}) => PlaceEntity(
  id: id,
  slug: 'bar-$id',
  name: 'Bar da Lapa',
  description: '',
  address: location == null ? address : address.copyWith(location: location),
  musicGenres: [MusicGenre.classicRock],
  type: PlaceType.bar,
  phone: '',
  instagram: '',
  website: '',
  openingHours: [],
  photos: [],
  ownerId: user,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    final fallback = FontLoader('Arimo')
      ..addFont(rootBundle.load('assets/fonts/Arimo.ttf'));
    await fallback.load();
    // Optional installed Arial for local visual QA; no proprietary font is bundled.
    const font = String.fromEnvironment('HOME_PARITY_FONT');
    if (font.isNotEmpty) {
      final loader = FontLoader('Arial')
        ..addFont(
          Future.value(ByteData.sublistView(await File(font).readAsBytes())),
        );
      final bold = File('${File(font).parent.path}/arialbd.ttf');
      if (bold.existsSync()) {
        loader.addFont(
          Future.value(ByteData.sublistView(await bold.readAsBytes())),
        );
      }
      await loader.load();
    }
  });
  Widget home({
    List<EventEntity>? events,
    List<PlaceEntity>? places,
    bool configured = true,
    bool loading = false,
    String? error,
    UserSummaryEntity? session,
    ValueChanged<String>? navigate,
    VoidCallback? retry,
    Future<bool> Function()? location,
    Widget Function(List<PlaceEntity>, List<EventEntity>, double)? mapBuilder,
  }) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeExplore(
      events:
          events ??
          [
            event('1'),
            event(
              '2',
              title: 'Jazz ao vivo',
              free: false,
              genre: MusicGenre.jazz,
            ),
          ],
      places: places ?? [place('1')],
      configured: configured,
      loading: loading,
      error: error,
      user: session,
      onNavigate: navigate ?? (_) {},
      onLogin: () {},
      onCreate: () {},
      onRetry: retry ?? () {},
      onLocation: location ?? () async => true,
      mapBuilder:
          mapBuilder ??
          (p, e, h) => SizedBox(
            key: const ValueKey('map'),
            height: h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const MapSkeleton(),
            ),
          ),
    ),
  );
  Future<void> mount(
    WidgetTester tester,
    Widget widget, {
    double width = 1440,
    double height = 1600,
    double scale = 1,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, height);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: Size(width, height),
          disableAnimations: true,
          textScaler: TextScaler.linear(scale),
        ),
        child: widget,
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> tap(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label).first);
    await tester.tap(find.text(label).first);
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final width in [390.0, 760.0, 761.0, 768.0, 1250.0, 1440.0]) {
    testWidgets('responsive home at $width', (tester) async {
      await mount(tester, home(), width: width);
      expect(find.text('Encontre sua vibe no mapa'), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const ValueKey('map'))).height,
        width <= 760 ? 420 : 520,
      );
      expect(
        find.byType(Checkbox),
        width <= 760 ? findsNothing : findsOneWidget,
      );
      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(tester.takeException(), isNull);
      await tap(tester, 'Ver lista');
      expect(find.byType(HomeEventCard), findsNWidgets(2));
      final cards = find.byType(HomeEventCard);
      final a = tester.getTopLeft(cards.at(0)),
          b = tester.getTopLeft(cards.at(1));
      expect(width <= 760 ? b.dy > a.dy : b.dy == a.dy, isTrue);
      expect(tester.takeException(), isNull);
      await tap(tester, 'Estabelecimentos');
      expect(find.byType(HomePlaceCard), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('filters persist across tabs, view changes and resize', (
    tester,
  ) async {
    List<EventEntity> visibleEvents = [];
    List<PlaceEntity> visiblePlaces = [];
    await mount(
      tester,
      home(
        mapBuilder: (p, e, h) {
          visibleEvents = e;
          visiblePlaces = p;
          return SizedBox(height: h);
        },
      ),
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(visibleEvents.length, 1);
    expect(visiblePlaces.length, 1);
    await tap(tester, 'Estabelecimentos');
    expect(visibleEvents.length, 1);
    expect(visiblePlaces.length, 1);
    await tester.enterText(find.byType(TextField), 'NOITE');
    await tester.pump();
    expect(visibleEvents.length, 1);
    expect(visiblePlaces, isEmpty);
    await tap(tester, 'Ver lista');
    expect(find.text('Nenhum estabelecimento encontrado.'), findsOneWidget);
    await tap(tester, 'Eventos');
    expect(find.byType(HomeEventCard), findsOneWidget);
    tester.view.physicalSize = const Size(390, 1600);
    await tester.pump();
    expect(find.byType(Checkbox), findsNothing);
    expect(find.byType(HomeEventCard), findsOneWidget);
    await tester.enterText(find.byType(TextField), ' Noite');
    await tester.pump();
    expect(
      find.text('Nenhum evento com esses filtros. Experimente outro estilo.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('genre filters both sets and can be cleared', (tester) async {
    List<EventEntity> visibleEvents = [];
    List<PlaceEntity> visiblePlaces = [];
    await mount(
      tester,
      home(
        mapBuilder: (p, e, h) {
          visibleEvents = e;
          visiblePlaces = p;
          return SizedBox(height: h);
        },
      ),
    );
    await tester.tap(find.byType(DropdownButton<MusicGenre>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jazz').last);
    await tester.pumpAndSettle();
    expect(visibleEvents.single.title, 'Jazz ao vivo');
    expect(visiblePlaces, isEmpty);
    await tester.tap(find.byType(DropdownButton<MusicGenre>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Todos os estilos').last);
    await tester.pumpAndSettle();
    expect(visibleEvents.length, 2);
    expect(visiblePlaces.length, 1);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('finished events are excluded and results sort by end', (
    tester,
  ) async {
    final now = DateTime.now();
    List<EventEntity> visible = [];
    await mount(
      tester,
      home(
        events: [
          event('later', end: now.add(const Duration(days: 4))),
          event('expired', end: now.subtract(const Duration(seconds: 1))),
          event('sooner', end: now.add(const Duration(days: 3))),
        ],
        mapBuilder: (p, e, h) {
          visible = e;
          return SizedBox(height: h);
        },
      ),
    );
    expect(visible.map((e) => e.id), ['sooner', 'later']);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('errors coexist with content and retry remains available', (
    tester,
  ) async {
    var retried = false;
    await mount(
      tester,
      home(error: 'Localização negada', retry: () => retried = true),
    );
    expect(find.text('Localização negada'), findsOneWidget);
    expect(find.byKey(const ValueKey('map')), findsOneWidget);
    await tap(tester, 'Tentar novamente');
    expect(retried, isTrue);
    await tester.pumpWidget(const SizedBox());
    await mount(tester, home(loading: true));
    expect(find.text('Carregando o próximo rolê…'), findsOneWidget);
    expect(find.byKey(const ValueKey('map')), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await mount(tester, home(configured: false), width: 390);
    expect(
      find.text('Nenhum evento carregado neste ambiente.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('map')), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('location switches list to map only on success', (tester) async {
    var granted = false;
    await mount(tester, home(location: () async => granted));
    await tap(tester, 'Ver lista');
    await tap(tester, 'Usar localização');
    expect(find.byType(HomeEventCard), findsNWidgets(2));
    granted = true;
    await tap(tester, 'Usar localização');
    expect(find.byKey(const ValueKey('map')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  test('map groups exact coordinates and omits linked events', () {
    final groups = groupHomeMapItems(
      [
        place('1'),
        place(
          '2',
          location: const LocationEntity(
            latitude: -22.91001,
            longitude: -43.18,
          ),
        ),
      ],
      [event('1'), event('2', placeId: '1')],
    );
    expect(groups.length, 2);
    expect(groups.values.first.length, 2);
    expect(groups.values.last.length, 1);
    expect(groups.values.first.map((i) => i.route), [
      '/place/bar-1',
      '/events/show-1',
    ]);
  });
  testWidgets('mobile partner navigation keeps its accessible label', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await mount(tester, home(session: user), width: 390);
    expect(find.byTooltip('Painel do parceiro'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('map idle, timeout, retry and address groups', (tester) async {
    late google.GoogleMap sdkMap;
    String? route;
    Widget map(List<PlaceEntity> places, List<EventEntity> events) =>
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MapSection(
                places: places,
                events: events,
                onNavigate: (value) => route = value,
                mapBuilder: (value) {
                  sdkMap = value;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        );
    await mount(tester, map([place('1')], [event('1')]));
    expect(find.byType(MapSkeleton), findsOneWidget);
    expect(
      sdkMap.initialCameraPosition.target,
      const google.LatLng(-22.9068, -43.1729),
    );
    expect(sdkMap.initialCameraPosition.zoom, 11);
    expect(sdkMap.style, isNull);
    expect(sdkMap.circles, isEmpty);
    final initialKey = sdkMap.key;
    await tester.pump(const Duration(seconds: 31));
    expect(find.text('Não foi possível carregar o mapa.'), findsOneWidget);
    await tap(tester, 'Tentar novamente');
    expect(sdkMap.key, isNot(initialKey));
    expect(find.byType(MapSkeleton), findsOneWidget);
    sdkMap.onCameraIdle!();
    await tester.pump();
    expect(find.byType(MapSkeleton), findsNothing);
    expect(find.text('Mapa assombrado'), findsOneWidget);
    expect(find.text('Sem Boras nos eventos filtrados'), findsOneWidget);
    sdkMap.markers.single.onTap!();
    await tester.pump();
    expect(find.text('Neste endereço'), findsOneWidget);
    await tap(tester, 'Noite de Rock');
    expect(route, '/events/show-1');
    await tester.pumpWidget(map([place('1')], []));
    await tester.pump();
    expect(find.text('Neste endereço'), findsNothing);
    sdkMap.markers.single.onTap!();
    expect(route, '/place/bar-1');
    await tester.pumpWidget(const SizedBox());
  });
  for (final scale in [1.6, 2.0]) {
    testWidgets('large text stays usable at scale $scale', (tester) async {
      await mount(tester, home(session: user), width: 390, scale: scale);
      expect(
        MediaQuery.textScalerOf(
          tester.element(find.byType(HomeExplore)),
        ).scale(10),
        10 * scale,
      );
      expect(tester.takeException(), isNull);
      await tap(tester, 'Ver lista');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('long titles retain content and cards navigate by slug', (
    tester,
  ) async {
    String? route;
    const title =
        'Uma noite de Classic Rock com bandas convidadas e um título muito longo';
    await mount(
      tester,
      home(
        events: [event('long', title: title)],
        navigate: (value) => route = value,
      ),
      width: 390,
    );
    await tap(tester, 'Ver lista');
    expect(find.text(title), findsOneWidget);
    await tap(tester, title);
    expect(route, '/events/show-long');
    await tap(tester, 'Estabelecimentos');
    await tap(tester, 'Bar da Lapa');
    expect(route, '/place/bar-1');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  if (const bool.fromEnvironment('HOME_SCREENSHOTS')) {
    for (final width in [390.0, 760.0, 761.0, 768.0, 1250.0, 1440.0]) {
      testWidgets('capture home $width', (tester) async {
        final key = GlobalKey();
        await mount(
          tester,
          RepaintBoundary(key: key, child: home()),
          width: width,
          height: 1800,
        );
        await tester.pump(const Duration(seconds: 1));
        await tester.runAsync(() async {
          final context = tester.element(find.byType(HomeExplore));
          await precacheImage(
            const AssetImage('assets/images/home_logo.png'),
            context,
          );
          if (context.mounted) {
            await precacheImage(
              const AssetImage('assets/images/home_brand.jpg'),
              context,
            );
          }
        });
        await tester.pump();
        expect(
          tester.getSize(find.byKey(const ValueKey('home-header'))).height,
          width <= 760 ? 72 : 88,
        );
        Future<void> capture(String name) async {
          await tester.pump();
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage();
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            final dir = Directory('build/home-parity')
              ..createSync(recursive: true);
            await File(
              '${dir.path}/$name-${width.toInt()}.png',
            ).writeAsBytes(data!.buffer.asUint8List());
            image.dispose();
          });
        }

        await capture('home');
        if (width == 390 || width == 1440) {
          await tap(tester, 'Ver lista');
          await capture('events');
          await tap(tester, 'Estabelecimentos');
          await capture('places');
          await tester.pumpWidget(const SizedBox());
          await mount(
            tester,
            RepaintBoundary(
              key: key,
              child: home(configured: false, events: [], places: []),
            ),
            width: width,
            height: 1800,
          );
          await capture('offline');
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
