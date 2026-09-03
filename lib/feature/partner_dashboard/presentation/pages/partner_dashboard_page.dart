import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/event_dashboard_skeleton.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/viewmodels/partner_dashboard_viewmodel.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_dashboard_header.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_events_section.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_menu_section.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_metrics_section.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_place_selector.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_transfer_event_dialog.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/public_url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PartnerDashboardPage extends StatefulWidget {
  final PlaceEntity? place;

  const PartnerDashboardPage({super.key, this.place});

  @override
  State<PartnerDashboardPage> createState() => _PartnerDashboardPageState();
}

class _PartnerDashboardPageState extends State<PartnerDashboardPage> {
  final vm = Modular.get<PartnerDashboardViewModel>();

  @override
  void initState() {
    super.initState();
    vm.setInitialPlace(widget.place);
    vm.loadDashboard();
  }

  Future<void> openCreatePlace() async {
    final created = await Modular.to.pushNamed('/places/create');

    if (created == true) {
      await vm.loadDashboard();
    }
  }

  Future<void> openEditPlace() async {
    final place = vm.selectedPlace;
    if (place == null) return;

    final updated = await Modular.to.pushNamed(
      '/places/create',
      arguments: place,
    );

    if (updated == true) {
      await vm.loadDashboard();
    }
  }

  Future<void> openCreateEvent() async {
    final created = await Modular.to.pushNamed(
      '/events/create',
      arguments: vm.selectedPlace,
    );

    if (created == true) {
      await vm.loadDashboard();
    }
  }

  Future<void> openEditEvent(EventEntity event) async {
    final updated = await Modular.to.pushNamed(
      '/events/create',
      arguments: event,
    );

    if (updated == true) {
      await vm.loadDashboard();
    }
  }

  void openEvent(EventEntity event) {
    Modular.to.pushNamed(
      PublicUrlHelper.eventPath(slug: event.slug, id: event.id),
    );
  }

  Future<void> openManageMenu() async {
    final place = vm.selectedPlace;
    if (place == null) return;

    final updated = await Modular.to.pushNamed(
      '/places/menu',
      arguments: place,
    );

    if (updated == true) {
      await vm.loadDashboard();
    }
  }

  Future<void> transferEvent(EventEntity event) async {
    final targetUserId = await showDialog<String>(
      context: context,
      builder: (context) => const PartnerTransferEventDialog(),
    );

    if (targetUserId == null || targetUserId.isEmpty) return;

    final targetUserName = await vm.transferEvent(event, targetUserId);
    if (!mounted) return;

    if (targetUserName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.error ?? 'Usuario de destino nao encontrado.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evento transferido para $targetUserName.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          backgroundColor: DsColors.adminBackground,
          appBar: AppBar(
            title: const Text('Meus eventos'),
            actions: [
              IconButton(
                tooltip: 'Atualizar',
                onPressed: vm.loading ? null : vm.loadDashboard,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: vm.loading
              ? const PartnerDashboardSkeleton()
              : DsAdminPage(
                  child: _DashboardContent(
                    vm: vm,
                    onCreateEvent: openCreateEvent,
                    onCreatePlace: openCreatePlace,
                    onEditPlace: openEditPlace,
                    onOpenEvent: openEvent,
                    onEditEvent: openEditEvent,
                    onTransferEvent: transferEvent,
                    onManageMenu: openManageMenu,
                  ),
                ),
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final PartnerDashboardViewModel vm;
  final VoidCallback onCreateEvent;
  final VoidCallback onCreatePlace;
  final VoidCallback onEditPlace;
  final ValueChanged<EventEntity> onOpenEvent;
  final ValueChanged<EventEntity> onEditEvent;
  final ValueChanged<EventEntity> onTransferEvent;
  final VoidCallback onManageMenu;

  const _DashboardContent({
    required this.vm,
    required this.onCreateEvent,
    required this.onCreatePlace,
    required this.onEditPlace,
    required this.onOpenEvent,
    required this.onEditEvent,
    required this.onTransferEvent,
    required this.onManageMenu,
  });

  @override
  Widget build(BuildContext context) {
    if (vm.error != null && vm.places.isEmpty) {
      return DsEmptyState(
        icon: Icons.lock_outline,
        title: 'Nao foi possivel abrir o dashboard',
        message: vm.error!,
        actionLabel: 'Tentar novamente',
        onAction: vm.loadDashboard,
      );
    }

    if (vm.places.isEmpty && vm.events.isEmpty) {
      return DsEmptyState(
        icon: Icons.event_busy_outlined,
        title: 'Nenhum evento criado',
        message:
            'Crie seu primeiro evento para acompanhar visualizacoes, boras e check-ins por aqui.',
        actionLabel: 'Criar evento',
        onAction: onCreateEvent,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PartnerDashboardHeader(
          userName: vm.user?.name ?? 'parceiro',
          onCreateEvent: onCreateEvent,
          onCreatePlace: onCreatePlace,
        ),
        if (vm.error != null) ...[
          const SizedBox(height: 16),
          DsInlineError(message: vm.error!),
        ],
        if (vm.places.isNotEmpty) ...[
          const SizedBox(height: 24),
          PartnerPlaceSelector(
            places: vm.places,
            selectedPlace: vm.selectedPlace,
            onSelectPlace: vm.selectPlace,
            onEditPlace: onEditPlace,
          ),
          const SizedBox(height: 32),
        ] else
          const SizedBox(height: 24),
        _SectionTitle(title: 'Resumo'),
        const SizedBox(height: 16),
        PartnerMetricsSection(
          eventsCount: vm.visibleEvents.length,
          totalViews: vm.totalViews,
          totalBoras: vm.totalBoras,
          totalCheckins: vm.totalCheckins,
        ),
        const SizedBox(height: 36),
        _SectionTitle(title: 'Proximos eventos'),
        const SizedBox(height: 16),
        PartnerEventsSection(
          events: vm.visibleEvents,
          onCreateEvent: onCreateEvent,
          onOpenEvent: onOpenEvent,
          onEditEvent: onEditEvent,
          onTransferEvent: onTransferEvent,
        ),
        if (vm.selectedPlace != null) ...[
          const SizedBox(height: 36),
          PartnerMenuSection(
            place: vm.selectedPlace!,
            onManageMenu: onManageMenu,
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}
