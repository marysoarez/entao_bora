import 'dart:async';
import 'dart:math' as math;
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_status_enum.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:flutter/material.dart';
import 'home_style.dart';
import 'home_result_cards.dart';
import 'map_section.dart';

class HomeExplore extends StatefulWidget {
  const HomeExplore({
    super.key,
    required this.events,
    required this.places,
    required this.onNavigate,
    required this.onLogin,
    required this.onCreate,
    required this.onLocation,
    required this.onRetry,
    this.loading = false,
    this.configured = true,
    this.error,
    this.message,
    this.user,
    this.location,
    this.mapBuilder,
  });
  final List<EventEntity> events;
  final List<PlaceEntity> places;
  final bool loading, configured;
  final String? error, message;
  final UserSummaryEntity? user;
  final LocationEntity? location;
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogin, onCreate, onRetry;
  final Future<bool> Function() onLocation;
  final Widget Function(List<PlaceEntity>, List<EventEntity>, double)?
  mapBuilder;
  @override
  State<HomeExplore> createState() => _HomeExploreState();
}

class _HomeExploreState extends State<HomeExplore> {
  String _query = '';
  MusicGenre? _genre;
  bool _eventsTab = true, _map = true, _free = false, _locating = false;
  Timer? _clock;
  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events =
        widget.events
            .where(
              (e) =>
                  e.status == EventStatus.published &&
                  !e.isFinished &&
                  '${e.title} ${e.locationName}'.toLowerCase().contains(
                    _query.toLowerCase(),
                  ) &&
                  (_genre == null || e.musicGenres.contains(_genre)) &&
                  (!_free || e.ticket.isFree),
            )
            .toList()
          ..sort((a, b) => a.endDate.compareTo(b.endDate));
    final places = widget.places
        .where(
          (p) =>
              p.name.toLowerCase().contains(_query.toLowerCase()) &&
              (_genre == null || p.musicGenres.contains(_genre)),
        )
        .toList();
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Arial',
        fontFamilyFallback: const ['Helvetica', 'Arimo', 'sans-serif'],
        colorScheme: const ColorScheme.dark(
          primary: HomeStyle.accent,
          surface: HomeStyle.surface,
        ),
        splashFactory: NoSplash.splashFactory,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, viewport) {
              final width = viewport.maxWidth;
              final mobile = width <= 760;
              final inset = mobile
                  ? 18.0
                  : width <= 1250
                  ? 28.0
                  : 0.0;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _header(mobile, width),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 1200,
                          minHeight: math.max(0, viewport.maxHeight - 210),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            inset,
                            mobile
                                ? 30
                                : width <= 1250
                                ? 36
                                : 48,
                            inset,
                            mobile
                                ? 30
                                : width <= 1250
                                ? 50
                                : 60,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.message != null)
                                HomeMessage(widget.message!),
                              _intro(mobile),
                              const SizedBox(height: 32),
                              _search(mobile, width),
                              const SizedBox(height: 24),
                              _filters(mobile),
                              const SizedBox(height: 32),
                              if (widget.error != null)
                                HomeMessage(
                                  widget.error!,
                                  onRetry: widget.onRetry,
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _map
                                            ? 'Encontre sua vibe no mapa'
                                            : _eventsTab
                                            ? 'O que vai rolar'
                                            : 'Lugares para conhecer',
                                        style: HomeStyle.type(
                                          26,
                                          weight: FontWeight.w700,
                                          tracking: -1.17,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${_eventsTab ? events.length : places.length} encontrados',
                                      style: HomeStyle.type(
                                        12,
                                        color: const Color(0xFF777777),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!widget.configured)
                                _offline(mobile)
                              else if (widget.loading)
                                const HomeMessage('Carregando o próximo rolê…')
                              else if (_map)
                                widget.mapBuilder?.call(
                                      places,
                                      events,
                                      mobile ? 420 : 520,
                                    ) ??
                                    MapSection(
                                      places: places,
                                      events: events,
                                      location: widget.location,
                                      height: mobile ? 420 : 520,
                                      onNavigate: widget.onNavigate,
                                    )
                              else if (_eventsTab && events.isEmpty)
                                const HomeMessage(
                                  'Nenhum evento com esses filtros. Experimente outro estilo.',
                                )
                              else if (!_eventsTab && places.isEmpty)
                                const HomeMessage(
                                  'Nenhum estabelecimento encontrado.',
                                )
                              else
                                _grid(
                                  mobile
                                      ? 1
                                      : _eventsTab
                                      ? 3
                                      : 2,
                                  _eventsTab ? 22 : 16,
                                  _eventsTab
                                      ? events
                                            .map(
                                              (e) => HomeEventCard(
                                                event: e,
                                                onTap: () => widget.onNavigate(
                                                  '/events/${e.slug.isEmpty ? e.id : e.slug}',
                                                ),
                                              ),
                                            )
                                            .toList()
                                      : places
                                            .map(
                                              (p) => HomePlaceCard(
                                                place: p,
                                                onTap: () => widget.onNavigate(
                                                  '/place/${p.slug.isEmpty ? p.id : p.slug}',
                                                ),
                                              ),
                                            )
                                            .toList(),
                                ),
                              const SizedBox(height: 42),
                              _partner(mobile, width),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _footer(mobile, width),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _brand(bool mobile, {bool footer = false}) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (!footer) ...[
        ClipOval(
          child: Image.asset(
            'assets/images/home_logo.png',
            width: mobile ? 33 : 44,
            height: mobile ? 33 : 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
      ],
      Text.rich(
        // The logotype has fixed proportions; page content follows system scale.
        textScaler: TextScaler.noScaling,
        TextSpan(
          children: [
            const TextSpan(text: 'então'),
            TextSpan(
              text: 'bora',
              style: TextStyle(color: HomeStyle.brand),
            ),
          ],
        ),
        style: HomeStyle.type(
          footer
              ? 20
              : mobile
              ? 22
              : 25,
          weight: FontWeight.w900,
          tracking: -1.7,
        ),
      ),
      if (!mobile && !footer)
        const Padding(
          padding: EdgeInsets.only(left: 7),
          child: Text('🤘', style: TextStyle(fontSize: 19)),
        ),
    ],
  );

  Widget _header(bool mobile, double width) {
    final padding = mobile ? 18.0 : math.max(28.0, (width - 1200) / 2);
    final partner = widget.user?.isPartner == true && widget.user!.active;
    final loginLabel = widget.user == null
        ? 'Entrar'
        : '${widget.user!.name.split(' ').first} · Sair';
    double labelWidth(String label, double size) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: HomeStyle.type(size)),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final result = painter.width;
      painter.dispose();
      return result;
    }

    final loginWidth = (labelWidth(loginLabel, 14) + 45).clamp(104.0, 180.0);
    final navigationWidth = mobile
        ? (partner ? 132 : 88) + (partner ? 12 : 8) + loginWidth
        : labelWidth('Explorar', 13) +
              labelWidth('Minha área', 13) +
              48 +
              loginWidth +
              (partner ? labelWidth('Painel do parceiro', 13) + 96 : 64);
    return Container(
      key: const ValueKey('home-header'),
      constraints: BoxConstraints(minHeight: mobile ? 72 : 88),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: padding),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF242424))),
      ),
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        overflowAlignment: OverflowBarAlignment.end,
        spacing: 16,
        overflowSpacing: 8,
        children: [
          _brand(mobile),
          SizedBox(
            width: math.min(width - padding * 2, navigationWidth + .5),
            child: Wrap(
              spacing: mobile ? 4 : 32,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.end,
              children: [
                HomeAction(
                  'Explorar',
                  onTap: () => widget.onNavigate('/'),
                  icon: HomeGlyph.compass,
                  hideLabel: mobile,
                ),
                HomeAction(
                  'Minha área',
                  onTap: () => widget.onNavigate('/minha-area'),
                  icon: HomeGlyph.user,
                  hideLabel: mobile,
                  color: const Color(0xFF999999),
                ),
                if (widget.user?.isPartner == true && widget.user!.active)
                  HomeAction(
                    'Painel do parceiro',
                    onTap: () => widget.onNavigate('/partner-dashboard'),
                    icon: mobile ? HomeGlyph.store : null,
                    hideLabel: mobile,
                  ),
                SizedBox(
                  width: loginWidth,
                  child: OutlinedButton(
                    onPressed: widget.onLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: HomeStyle.text,
                      minimumSize: const Size(104, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      side: const BorderSide(color: Color(0xFF333333)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HomeIcon(
                          widget.user == null
                              ? HomeGlyph.login
                              : HomeGlyph.logout,
                          size: 16,
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(loginLabel, style: HomeStyle.type(14)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _intro(bool mobile) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: HomeStyle.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                'A CIDADE ESTÁ NO RITMO',
                style: HomeStyle.type(
                  10,
                  color: HomeStyle.muted,
                  weight: FontWeight.w700,
                  tracking: 2,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Seu próximo rolê\ncomeça '),
                const TextSpan(
                  text: 'aqui.',
                  style: TextStyle(color: HomeStyle.accent),
                ),
              ],
            ),
            style: HomeStyle.type(
              mobile ? 42 : 54,
              weight: FontWeight.w700,
              tracking: mobile ? -1.89 : -2.43,
              height: 1.08,
            ),
          ),
        ),
        Text(
          'Música boa, lugares incríveis e gente na mesma vibe.',
          style: HomeStyle.type(
            mobile ? 13 : 16,
            color: HomeStyle.muted,
            height: 1.65,
          ),
        ),
      ],
    );
    final location = Container(
      padding: EdgeInsets.all(mobile ? 10 : 16),
      decoration: HomeStyle.box(
        color: const Color(0xFF101010),
        border: const Color(0xFF252525),
      ),
      child: Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HomeIcon(HomeGlyph.pin, size: 18, color: HomeStyle.accent),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explorando',
                      style: HomeStyle.type(12, color: HomeStyle.muted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rio de Janeiro, RJ',
                      style: HomeStyle.type(13, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          HomeAction(
            _locating ? 'Localizando…' : 'Usar localização',
            size: 11,
            compact: true,
            color: HomeStyle.muted,
            onTap: () async {
              if (_locating) return;
              setState(() => _locating = true);
              try {
                final ok = await widget.onLocation();
                if (mounted && ok) setState(() => _map = true);
              } finally {
                if (mounted) setState(() => _locating = false);
              }
            },
          ),
        ],
      ),
    );
    return mobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 22), location],
          )
        : Row(
            children: [
              Expanded(child: title),
              const SizedBox(width: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: location,
              ),
            ],
          );
  }

  Widget _search(bool mobile, double width) {
    final search = Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: HomeStyle.box(),
      child: Row(
        children: [
          const HomeIcon(HomeGlyph.search, size: 19, color: Color(0xFF888888)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              style: HomeStyle.type(width < 768 ? 16 : 14),
              decoration: InputDecoration(
                hintText: 'Qual é a boa? Busque evento, bar ou casa de show',
                hintStyle: HomeStyle.type(
                  width < 768 ? 16 : 14,
                  color: const Color(0xFF888888),
                ),
                filled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: HomeStyle.accent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    final genre = Container(
      height: mobile ? 45 : 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: HomeStyle.box(),
      child: Row(
        children: [
          const HomeIcon(HomeGlyph.sliders),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<MusicGenre>(
                icon: const HomeIcon(HomeGlyph.chevron),
                value: _genre,
                isExpanded: true,
                hint: Text('Todos os estilos', style: HomeStyle.type(14)),
                dropdownColor: HomeStyle.surface,
                style: HomeStyle.type(14),
                items: [
                  DropdownMenuItem<MusicGenre>(
                    value: null,
                    child: Text('Todos os estilos', style: HomeStyle.type(14)),
                  ),
                  ...MusicGenre.values.map(
                    (g) => DropdownMenuItem(value: g, child: Text(g.label)),
                  ),
                ],
                onChanged: (value) => setState(() => _genre = value),
              ),
            ),
          ),
        ],
      ),
    );
    return mobile
        ? Column(children: [search, const SizedBox(height: 12), genre])
        : Row(
            children: [
              Expanded(child: search),
              const SizedBox(width: 16),
              SizedBox(width: 230, child: genre),
            ],
          );
  }

  Widget _filters(bool mobile) {
    Widget tab(String title, HomeGlyph icon, bool selected, VoidCallback tap) =>
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? HomeStyle.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: HomeAction(
            title,
            onTap: tap,
            icon: icon,
            size: mobile ? 11 : 13,
            color: selected ? HomeStyle.text : const Color(0xFF999999),
          ),
        );
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF282828))),
      ),
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: mobile ? 8 : 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: mobile ? 13 : 24,
            children: [
              tab(
                'Eventos',
                HomeGlyph.calendar,
                _eventsTab,
                () => setState(() => _eventsTab = true),
              ),
              tab(
                'Estabelecimentos',
                HomeGlyph.store,
                !_eventsTab,
                () => setState(() => _eventsTab = false),
              ),
            ],
          ),
          Wrap(
            spacing: mobile ? 13 : 24,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (!mobile)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      label: 'Gratuitos',
                      child: Checkbox(
                        value: _free,
                        activeColor: HomeStyle.accent,
                        onChanged: (value) => setState(() => _free = value!),
                      ),
                    ),
                    Text(
                      'Gratuitos',
                      style: HomeStyle.type(12, color: HomeStyle.muted),
                    ),
                  ],
                ),
              HomeAction(
                _map ? 'Ver lista' : 'Explorar mapa',
                onTap: () => setState(() => _map = !_map),
                icon: _map ? HomeGlyph.list : HomeGlyph.compass,
                size: mobile ? 11 : 13,
                color: const Color(0xFF999999),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _grid(int columns, double gap, List<Widget> cards) => LayoutBuilder(
    builder: (_, box) => Wrap(
      spacing: gap,
      runSpacing: gap,
      children: cards
          .map(
            (card) => SizedBox(
              width: (box.maxWidth - gap * (columns - 1)) / columns,
              child: card,
            ),
          )
          .toList(),
    ),
  );

  Widget _partner(bool mobile, double width) {
    final left = Wrap(
      spacing: 14,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const HomeIcon(HomeGlyph.music, size: 25),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'O seu palco também é aqui.',
            style: HomeStyle.type(mobile ? 15 : 17, weight: FontWeight.w700),
          ),
        ),
        if (width > 1250)
          Text(
            'Leve seu evento a quem curte a mesma vibe.',
            style: HomeStyle.type(12, color: HomeStyle.muted),
          ),
      ],
    );
    final link = HomeAction(
      'Divulgar um evento',
      onTap: widget.onCreate,
      icon: HomeGlyph.arrow,
      trailingIcon: true,
      compact: true,
      size: 12,
      color: const Color(0xFFEE7777),
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 30,
        vertical: mobile ? 20 : 24,
      ),
      decoration: HomeStyle.box(color: Colors.black),
      child: mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [left, const SizedBox(height: 18), link],
            )
          : Row(
              children: [
                Expanded(child: left),
                const SizedBox(width: 20),
                link,
              ],
            ),
    );
  }

  Widget _footer(bool mobile, double width) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: mobile
          ? 18
          : width <= 1250
          ? 28
          : 0,
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF252525))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _brand(mobile, footer: true),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                'A vida acontece lá fora. Bora?',
                style: HomeStyle.type(
                  mobile ? 10 : 12,
                  color: const Color(0xFF777777),
                ),
              ),
            ),
            if (!mobile)
              Text(
                'Rio de Janeiro · Música e encontros',
                style: HomeStyle.type(10, color: const Color(0xFF777777)),
              ),
          ],
        ),
      ),
    ),
  );

  Widget _offline(bool mobile) {
    final photo = Image.asset(
      'assets/images/home_brand.jpg',
      height: mobile ? 230 : 320,
      width: double.infinity,
      fit: BoxFit.cover,
    );
    final copy = Padding(
      padding: EdgeInsets.all(mobile ? 26 : 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O ROLÊ TEM PONTO DE ENCONTRO',
            style: HomeStyle.type(10, weight: FontWeight.w700, tracking: 2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Onde a música\nencontra você.',
              style: HomeStyle.type(
                mobile ? 30 : 35,
                weight: FontWeight.w700,
                tracking: -1.35,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Text(
              'A agenda está aguardando conexão. Em breve, explore eventos, descubra lugares e marque seu Bora.',
              style: HomeStyle.type(14, color: HomeStyle.muted, height: 1.65),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum evento carregado neste ambiente.',
            style: HomeStyle.type(11, color: const Color(0xFF777777)),
          ),
        ],
      ),
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: HomeStyle.box(
        color: const Color(0xFF111111),
        border: const Color(0xFF252525),
        radius: 14,
      ),
      child: mobile
          ? Column(children: [photo, copy])
          : Row(
              children: [
                Expanded(child: photo),
                Expanded(child: copy),
              ],
            ),
    );
  }
}
