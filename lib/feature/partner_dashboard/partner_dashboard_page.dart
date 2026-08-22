import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';

class PartnerDashboardPage extends StatefulWidget {
  final PlaceEntity place;

  const PartnerDashboardPage({
    super.key,
    required this.place,
  });

  @override
  State<PartnerDashboardPage> createState() => _PartnerDashboardPageState();
}

class _PartnerDashboardPageState extends State<PartnerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),

                _buildSectionTitle('Seu estabelecimento'),
                const SizedBox(height: 16),

                _buildPlaceMetrics(),

                const SizedBox(height: 36),

                _buildSectionTitle('Seus eventos'),
                const SizedBox(height: 16),

                _buildEventMetrics(),

                const SizedBox(height: 36),

                _buildSectionTitle('Próximos eventos'),
                const SizedBox(height: 16),

                _buildUpcomingEvents(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá! 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.place.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: criar evento
          },
          icon: const Icon(Icons.add),
          label: const Text('Criar evento'),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPlaceMetrics() {
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
                icon: Icons.visibility_outlined,
                title: 'Visualizações',
                value: '1.284',
                subtitle: 'nos últimos 30 dias',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.event_outlined,
                title: 'Eventos',
                value: '12',
                subtitle: 'publicados',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.favorite_border,
                title: 'Boras',
                value: '183',
                subtitle: 'interessados',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.location_on_outlined,
                title: 'Check-ins',
                value: '47',
                subtitle: 'realizados',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventMetrics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final cardWidth = width >= 900
            ? (width - 32) / 3
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
                icon: Icons.visibility_outlined,
                title: 'Visualizações',
                value: '2.481',
                subtitle: 'em todos os eventos',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.local_fire_department_outlined,
                title: 'Boras',
                value: '326',
                subtitle: 'em seus eventos',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                icon: Icons.people_outline,
                title: 'Check-ins',
                value: '89',
                subtitle: 'em seus eventos',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpcomingEvents() {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Column(
        children: [
          _EventDashboardTile(
            title: 'Rock Night',
            date: '22 AGO • 21:00',
            views: 127,
            boras: 38,
            checkins: 12,
          ),
          const Divider(height: 1),
          _EventDashboardTile(
            title: 'Metal Friday',
            date: '29 AGO • 22:00',
            views: 84,
            boras: 21,
            checkins: 0,
          ),
          const Divider(height: 1),
          _EventDashboardTile(
            title: 'Rock & Beer',
            date: '05 SET • 20:00',
            views: 43,
            boras: 9,
            checkins: 0,
          ),
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
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.black87,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventDashboardTile extends StatelessWidget {
  final String title;
  final String date;
  final int views;
  final int boras;
  final int checkins;

  const _EventDashboardTile({
    required this.title,
    required this.date,
    required this.views,
    required this.boras,
    required this.checkins,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12,
            ),
            child: const Icon(Icons.music_note),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _EventMetric(
            icon: Icons.visibility_outlined,
            value: views,
          ),
          const SizedBox(width: 24),
          _EventMetric(
            icon: Icons.favorite_border,
            value: boras,
          ),
          const SizedBox(width: 24),
          _EventMetric(
            icon: Icons.location_on_outlined,
            value: checkins,
          ),
        ],
      ),
    );
  }
}

class _EventMetric extends StatelessWidget {
  final IconData icon;
  final int value;

  const _EventMetric({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 5),
        Text(
          '$value',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}