import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/events_bora_viewmodel.dart';
import 'package:entao_bora/feature/home/presentation/widgets/home_style.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/enum/checkin_results.dart';
import 'package:entao_bora/shared/helpers/public_url_helper.dart';
import 'package:entao_bora/shared/widgets/public_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.event, required this.place});
  final EventEntity event;
  final PlaceEntity? place;
  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late final EventActionsViewModel vm;
  final auth = Modular.get<IAuthRepository>();
  String? message;

  @override
  void initState() {
    super.initState();
    vm = EventActionsViewModel(
      Modular.get<IEventRepository>(),
      Modular.get<ILocationRepository>(),
      auth,
      widget.event,
    );
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      final event = vm.event;
      final user = auth.currentUser;
      return PublicDetailShell(
        user: user,
        onNavigate: Modular.to.navigate,
        onLogin: () async {
          if (user == null) {
            await LoginDialog.show(context);
          } else {
            await auth.signOut();
            if (mounted) setState(() {});
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mobile = MediaQuery.sizeOf(context).width <= 760;
            return PublicDetailView(
              cover: event.coverImage.trim().isEmpty
                  ? null
                  : PublicDetailImage(
                      event.coverImage,
                      height: mobile ? 240 : 360,
                    ),
              article: _article(event, mobile),
              aside: _aside(event),
            );
          },
        ),
      );
    },
  );

  Widget _article(EventEntity event, bool mobile) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PublicChips(event.musicGenres.map((genre) => genre.label)),
      Text(event.title, style: publicTitle(mobile)),
      const SizedBox(height: 14),
      _info(
        Icons.calendar_month_outlined,
        '${_date(event.startDate)} — ${_date(event.endDate)}',
      ),
      _info(Icons.location_on_outlined, event.address.displayName),
      if (widget.place != null)
        TextButton(
          onPressed: () => Modular.to.pushNamed(
            PublicUrlHelper.placePath(
              slug: widget.place!.slug,
              id: widget.place!.id,
            ),
          ),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text('${widget.place!.name} ↗', style: HomeStyle.type(14)),
        ),
      const SizedBox(height: 24),
      Text('Sobre o evento', style: publicSectionTitle()),
      const SizedBox(height: 8),
      Text(event.description, style: publicBody()),
      if (event.attractions.isNotEmpty) ...[
        const SizedBox(height: 24),
        Text('Atrações', style: publicSectionTitle()),
        const SizedBox(height: 8),
        ...event.attractions.map(
          (a) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '${a.name}${a.isHeadliner ? ' · Atração principal' : ''}',
              style: publicBody(),
            ),
          ),
        ),
      ],
      PublicGallery(event.gallery),
      if (widget.place != null) ...[
        PublicExpansion(
          title: 'Cardápio · ${widget.place!.name}',
          child: PublicMenu(widget.place!.menuItems),
        ),
        if (widget.place!.openingHours.isNotEmpty)
          PublicExpansion(
            title: 'Horários de funcionamento',
            child: PublicHours(widget.place!.openingHours),
          ),
      ],
    ],
  );

  Widget _aside(EventEntity event) {
    final user = auth.currentUser;
    final canManage =
        user != null &&
        user.active &&
        (event.createdBy.id == user.id ||
            (user.isPartner &&
                (user.partnerId?.isNotEmpty ?? false) &&
                event.createdBy.id == user.partnerId));
    final ticketUri = _safeUri(event.ticket.ticketUrl);
    return PublicAside(
      children: [
        Text(
          'ENCONTRE A GALERA',
          style: HomeStyle.type(
            10,
            color: HomeStyle.muted,
            weight: FontWeight.w700,
            tracking: 2,
          ),
        ),
        Text(
          event.ticket.isFree ? 'Entrada gratuita' : 'Garanta seu ingresso',
          style: HomeStyle.type(19, weight: FontWeight.w700),
        ),
        if (!event.ticket.isFree && ticketUri != null)
          PublicButton(
            'Comprar ingresso ↗',
            onPressed: () =>
                launchUrl(ticketUri, mode: LaunchMode.externalApplication),
          ),
        PublicButton(
          event.isBora ? 'Você vai! Desmarcar' : 'Então Bora!',
          icon: event.isBora ? Icons.favorite : Icons.favorite_border,
          filled: true,
          onPressed: vm.loading ? null : _toggleBora,
        ),
        PublicButton(
          event.hasCheckedIn ? 'Check-in realizado' : 'Fazer check-in',
          icon: Icons.check,
          onPressed: vm.loading || event.hasCheckedIn ? null : _checkIn,
        ),
        Text(
          'Durante o evento, a até 100 metros do endereço.',
          style: HomeStyle.type(11, color: const Color(0xFF777777)),
        ),
        PublicButton(
          'Como chegar ↗',
          icon: Icons.location_on_outlined,
          onPressed: () => launchUrl(
            Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=${event.address.location.latitude},${event.address.location.longitude}',
            ),
            mode: LaunchMode.externalApplication,
          ),
        ),
        PublicButton(
          'Compartilhar',
          icon: Icons.share_outlined,
          onPressed: vm.loading ? null : () => _share(event),
        ),
        if (canManage)
          TextButton(
            onPressed: () =>
                Modular.to.pushNamed('/events/create', arguments: event),
            child: const Text('Editar informações'),
          ),
        if (message != null || vm.error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: HomeStyle.box(border: const Color(0xFF353535)),
            child: Text(
              message ?? vm.error!,
              style: HomeStyle.type(13, color: const Color(0xFFCCCCCC)),
            ),
          ),
      ],
    );
  }

  Widget _info(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: HomeStyle.muted),
        const SizedBox(width: 7),
        Expanded(child: Text(text, style: publicBody())),
      ],
    ),
  );

  String _date(DateTime value) =>
      DateFormat.yMMMd('pt_BR').add_Hm().format(value.toLocal());
  Uri? _safeUri(String? value) {
    final uri = Uri.tryParse(value ?? '');
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https')
        ? uri
        : null;
  }

  Future<bool> _ensureLogged() async =>
      vm.isLogged || await LoginDialog.show(context);
  Future<void> _toggleBora() async {
    if (await _ensureLogged()) await vm.toggleBora();
  }

  Future<void> _checkIn() async {
    if (!await _ensureLogged()) return;
    final result = await vm.checkIn();
    if (!mounted) return;
    setState(
      () => message = switch (result) {
        CheckInResult.success => 'Check-in realizado!',
        CheckInResult.tooFar => 'Você precisa estar no local do evento.',
        CheckInResult.eventNotStarted => 'O evento ainda não começou.',
        CheckInResult.eventFinished => 'Este evento já terminou.',
        CheckInResult.alreadyCheckedIn => 'Você já fez check-in.',
        _ => vm.error ?? 'Erro inesperado.',
      },
    );
  }

  Future<void> _share(EventEntity event) async {
    final url = PublicUrlHelper.eventUrl(slug: event.slug, id: event.id);
    try {
      await SharePlus.instance.share(
        ShareParams(title: event.title, text: url),
      );
      await Modular.get<IEventRepository>().incrementShares(event.id);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: url));
      if (mounted) setState(() => message = 'Link copiado!');
    }
  }
}
