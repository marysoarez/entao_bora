import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
import 'package:entao_bora/feature/home/presentation/widgets/home_style.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/presentation/viewmodels/place_details_viewmodel.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_events_section.dart';
import 'package:entao_bora/shared/helpers/public_url_helper.dart';
import 'package:entao_bora/shared/widgets/public_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsByIdPage extends StatefulWidget {
  const PlaceDetailsByIdPage({super.key, required this.id});
  final String id;
  @override
  State<PlaceDetailsByIdPage> createState() => _PlaceDetailsByIdPageState();
}

class _PlaceDetailsByIdPageState extends State<PlaceDetailsByIdPage> {
  final vm = Modular.get<PlaceDetailsViewModel>();
  @override
  void initState() {
    super.initState();
    vm.load(widget.id);
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      if (vm.loading) return _message('Carregando detalhes…');
      if (vm.place == null) {
        return _message(vm.error ?? 'Não encontramos este registro.');
      }
      return PlaceDetailsPage(place: vm.place!);
    },
  );
  Widget _message(String text) {
    final auth = Modular.get<IAuthRepository>();
    return PublicDetailShell(
      user: auth.currentUser,
      onNavigate: Modular.to.navigate,
      onLogin: () => LoginDialog.show(context),
      child: HomeMessage(text),
    );
  }
}

class PlaceDetailsPage extends StatefulWidget {
  const PlaceDetailsPage({super.key, required this.place});
  final PlaceEntity place;
  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  final vm = Modular.get<PlaceDetailsViewModel>();
  final eventsVm = Modular.get<PlaceEventsViewModel>();
  final auth = Modular.get<IAuthRepository>();
  String? message;

  @override
  void initState() {
    super.initState();
    vm.setPlace(widget.place);
    eventsVm.load(widget.place.id, creatorId: widget.place.ownerId.id);
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      final place = vm.place ?? widget.place;
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
              cover: place.photos.isEmpty
                  ? null
                  : PublicDetailImage(
                      place.photos.first,
                      height: mobile ? 240 : 360,
                    ),
              article: _article(place, mobile),
              aside: _aside(place),
            );
          },
        ),
      );
    },
  );

  Widget _article(PlaceEntity place, bool mobile) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PublicChips(place.musicGenres.map((genre) => genre.label)),
      Text(place.name, style: publicTitle(mobile)),
      const SizedBox(height: 14),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 16,
            color: HomeStyle.muted,
          ),
          const SizedBox(width: 7),
          Expanded(child: Text(place.address.displayName, style: publicBody())),
        ],
      ),
      const SizedBox(height: 28),
      Text('Sobre o lugar', style: publicSectionTitle()),
      const SizedBox(height: 8),
      Text(place.description, style: publicBody()),
      PublicGallery(
        place.photos.length > 1 ? place.photos.sublist(1) : const [],
      ),
      PublicExpansion(
        title: 'Cardápio · ${place.name}',
        child: PublicMenu(place.menuItems),
      ),
      if (place.openingHours.isNotEmpty)
        PublicExpansion(
          title: 'Horários de funcionamento',
          child: PublicHours(place.openingHours),
        ),
      const SizedBox(height: 8),
      PlaceEventsSection(place: place, vm: eventsVm),
    ],
  );

  Widget _aside(PlaceEntity place) {
    final user = auth.currentUser;
    final canManage =
        user != null &&
        user.active &&
        (place.ownerId.id == user.id ||
            (user.isPartner &&
                (user.partnerId?.isNotEmpty ?? false) &&
                place.ownerId.id == user.partnerId));
    final website = _safeUri(place.website);
    return PublicAside(
      children: [
        Text(
          'Planeje sua visita',
          style: HomeStyle.type(19, weight: FontWeight.w700),
        ),
        if (place.phone.trim().isNotEmpty)
          Text(place.phone, style: publicBody()),
        if (website != null)
          PublicButton(
            'Visitar site ↗',
            onPressed: () =>
                launchUrl(website, mode: LaunchMode.externalApplication),
          ),
        PublicButton(
          'Como chegar ↗',
          icon: Icons.location_on_outlined,
          onPressed: () => launchUrl(
            Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=${place.address.location.latitude},${place.address.location.longitude}',
            ),
            mode: LaunchMode.externalApplication,
          ),
        ),
        PublicButton(
          'Compartilhar',
          icon: Icons.share_outlined,
          onPressed: () => _share(place),
        ),
        if (canManage)
          TextButton(
            onPressed: () => _edit(place),
            child: const Text('Editar informações'),
          ),
        if (message != null || eventsVm.error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: HomeStyle.box(border: const Color(0xFF353535)),
            child: Text(
              message ?? eventsVm.error!,
              style: HomeStyle.type(13, color: const Color(0xFFCCCCCC)),
            ),
          ),
      ],
    );
  }

  Uri? _safeUri(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https')
        ? uri
        : null;
  }

  Future<void> _share(PlaceEntity place) async {
    final url = PublicUrlHelper.placeUrl(slug: place.slug, id: place.id);
    try {
      await SharePlus.instance.share(ShareParams(title: place.name, text: url));
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: url));
      if (mounted) setState(() => message = 'Link copiado!');
    }
  }

  Future<void> _edit(PlaceEntity place) async {
    final updated = await Modular.to.pushNamed(
      '/places/create',
      arguments: place,
    );
    if (updated == true) await vm.reload();
  }
}
