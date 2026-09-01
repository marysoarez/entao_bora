import 'package:entao_bora/core/app_theme.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PartnerDashboardPage extends StatefulWidget {
  final PlaceEntity? place;

  const PartnerDashboardPage({super.key, this.place});

  @override
  State<PartnerDashboardPage> createState() => _PartnerDashboardPageState();
}

class _PartnerDashboardPageState extends State<PartnerDashboardPage> {
  final _authRepository = Modular.get<IAuthRepository>();
  final _placeRepository = Modular.get<IPlaceRepository>();
  final _eventRepository = Modular.get<IEventRepository>();

  bool loading = true;
  String? error;
  UserSummaryEntity? user;
  List<PlaceEntity> places = [];
  List<EventEntity> events = [];
  List<EventEntity> visibleEvents = [];
  PlaceEntity? selectedPlace;

  int get totalViews =>
      visibleEvents.fold(0, (total, event) => total + event.views);
  int get totalBoras =>
      visibleEvents.fold(0, (total, event) => total + event.boraCount);
  int get totalCheckins =>
      visibleEvents.fold(0, (total, event) => total + event.checkinCount);

  @override
  void initState() {
    super.initState();
    selectedPlace = widget.place;
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      loading = true;
      error = null;
    });

    final currentUser = await _authRepository.getCurrentUser();

    if (currentUser == null) {
      setState(() {
        user = null;
        loading = false;
        error = 'Faca login para acessar a area do parceiro.';
      });
      return;
    }

    final ownerIds = _ownerIdsFor(currentUser);
    final partnerPlaces = <PlaceEntity>[];

    for (final ownerId in ownerIds) {
      final result = await _placeRepository.getPlacesByOwnerId(ownerId);

      final failed = result.fold(
        (failure) {
          setState(() {
            user = currentUser;
            loading = false;
            error = failure.message;
          });
          return true;
        },
        (places) {
          partnerPlaces.addAll(places);
          return false;
        },
      );

      if (failed) return;
    }

    final uniquePlaces = _uniquePlaces(partnerPlaces);
    final partnerEvents = <EventEntity>[];

    for (final ownerId in ownerIds) {
      partnerEvents.addAll(await _loadEventsByCreatorId(ownerId));
    }

    final uniqueEvents = _uniqueEvents(partnerEvents);
    final place = _resolveSelectedPlace(uniquePlaces);
    if (!mounted) return;

    setState(() {
      user = currentUser;
      places = uniquePlaces;
      selectedPlace = place;
      events = uniqueEvents;
      visibleEvents = uniqueEvents;
      loading = false;
    });
  }

  List<String> _ownerIdsFor(UserSummaryEntity user) {
    return {
      user.id,
      if (user.partnerId != null && user.partnerId!.trim().isNotEmpty)
        user.partnerId!,
    }.toList();
  }

  List<PlaceEntity> _uniquePlaces(List<PlaceEntity> places) {
    return {for (final place in places) place.id: place}.values.toList();
  }

  List<EventEntity> _uniqueEvents(List<EventEntity> events) {
    return {for (final event in events) event.id: event}.values.toList();
  }

  PlaceEntity? _resolveSelectedPlace(List<PlaceEntity> partnerPlaces) {
    if (partnerPlaces.isEmpty) return null;

    final currentSelected = selectedPlace;
    if (currentSelected != null) {
      for (final place in partnerPlaces) {
        if (place.id == currentSelected.id) return place;
      }
    }

    return partnerPlaces.first;
  }

  Future<List<EventEntity>> _loadEventsByCreatorId(String creatorId) async {
    final result = await _eventRepository.getEventsByCreatorId(creatorId);

    return result.fold((failure) {
      error = failure.message;
      return <EventEntity>[];
    }, (events) => events);
  }

  Future<void> selectPlace(PlaceEntity place) async {
    setState(() {
      selectedPlace = place;
      visibleEvents = events;
      error = null;
    });
  }

  Future<void> openCreatePlace() async {
    final created = await Modular.to.pushNamed('/places/create');

    if (created == true) {
      await loadDashboard();
    }
  }

  Future<void> openEditPlace() async {
    final place = selectedPlace;
    if (place == null) return;

    final updated = await Modular.to.pushNamed(
      '/places/create',
      arguments: place,
    );

    if (updated == true) {
      await loadDashboard();
    }
  }

  Future<void> openCreateEvent() async {
    final created = await Modular.to.pushNamed(
      '/events/create',
      arguments: selectedPlace,
    );

    if (created == true) {
      await loadDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Meus eventos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: loading ? null : loadDashboard,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: _buildContent(),
                ),
              ),
            ),
    );
  }

  Widget _buildContent() {
    if (error != null && places.isEmpty) {
      return _EmptyState(
        icon: Icons.lock_outline,
        title: 'Nao foi possivel abrir o dashboard',
        message: error!,
        actionLabel: 'Tentar novamente',
        onAction: loadDashboard,
      );
    }

    if (places.isEmpty && events.isEmpty) {
      return _EmptyState(
        icon: Icons.event_busy_outlined,
        title: 'Nenhum evento criado',
        message:
            'Crie seu primeiro evento para acompanhar visualizacoes, boras e check-ins por aqui.',
        actionLabel: 'Criar evento',
        onAction: openCreateEvent,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (error != null) ...[
          const SizedBox(height: 16),
          _InlineError(message: error!),
        ],
        if (places.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildPlaceSelector(),
          const SizedBox(height: 32),
        ] else
          const SizedBox(height: 24),
        _buildSectionTitle('Resumo'),
        const SizedBox(height: 16),
        _buildMetrics(),
        const SizedBox(height: 36),
        _buildSectionTitle('Proximos eventos'),
        const SizedBox(height: 16),
        _buildUpcomingEvents(),
      ],
    );
  }

  Widget _buildHeader() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ola, ${user?.name ?? 'parceiro'}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Acompanhe os eventos que voce criou e veja os resultados publicados.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: openCreateEvent,
          icon: const Icon(Icons.add),
          label: const Text('Criar evento'),
        ),
        OutlinedButton.icon(
          onPressed: openCreatePlace,
          icon: const Icon(Icons.add_business_outlined),
          label: const Text('Novo local'),
        ),
      ],
    );
  }

  Widget _buildPlaceSelector() {
    final place = selectedPlace;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PlaceEntity>(
                      isExpanded: true,
                      value: place,
                      items: places.map((place) {
                        return DropdownMenuItem(
                          value: place,
                          child: Text(place.name),
                        );
                      }).toList(),
                      onChanged: (place) {
                        if (place != null) {
                          selectPlace(place);
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar estabelecimento',
                  onPressed: openEditPlace,
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            if (place != null) ...[
              const SizedBox(height: 12),
              Text(
                place.address.displayName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildMetrics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cardWidth = width >= 900
            ? (width - 48) / 4
            : width >= 600
            ? (width - 16) / 2
            : width;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.event_outlined,
                title: 'Eventos',
                value: '${visibleEvents.length}',
                subtitle: 'criados por voce',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.visibility_outlined,
                title: 'Visualizacoes',
                value: '$totalViews',
                subtitle: 'nos eventos listados',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.local_fire_department_outlined,
                title: 'Boras',
                value: '$totalBoras',
                subtitle: 'interessados',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.how_to_reg_outlined,
                title: 'Check-ins',
                value: '$totalCheckins',
                subtitle: 'realizados',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpcomingEvents() {
    if (visibleEvents.isEmpty) {
      return _EmptyState(
        icon: Icons.event_busy_outlined,
        title: 'Nenhum evento futuro',
        message:
            'Publique o proximo evento para acompanhar os resultados por aqui.',
        actionLabel: 'Criar evento',
        onAction: openCreateEvent,
      );
    }

    return Card(
      child: Column(
        children: [
          for (var index = 0; index < visibleEvents.length; index++) ...[
            _EventDashboardTile(event: visibleEvents[index]),
            if (index != visibleEvents.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: AppTheme.primary),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventDashboardTile extends StatelessWidget {
  final EventEntity event;

  const _EventDashboardTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Modular.to.pushNamed('/events/${event.id}'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.background,
              ),
              child: const Icon(Icons.music_note),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatEventDate(event.startDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _EventMetric(icon: Icons.visibility_outlined, value: event.views),
            const SizedBox(width: 20),
            _EventMetric(
              icon: Icons.local_fire_department_outlined,
              value: event.boraCount,
            ),
            const SizedBox(width: 20),
            _EventMetric(
              icon: Icons.how_to_reg_outlined,
              value: event.checkinCount,
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} - $hour:$minute';
  }
}

class _EventMetric extends StatelessWidget {
  final IconData icon;
  final int value;

  const _EventMetric({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 5),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 34, color: AppTheme.primary),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondary),
      ),
    );
  }
}
