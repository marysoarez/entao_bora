import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_metric_card.dart';
import 'package:flutter/material.dart';

class PartnerMetricsSection extends StatelessWidget {
  final int eventsCount;
  final int totalViews;
  final int totalBoras;
  final int totalCheckins;

  const PartnerMetricsSection({
    super.key,
    required this.eventsCount,
    required this.totalViews,
    required this.totalBoras,
    required this.totalCheckins,
  });

  @override
  Widget build(BuildContext context) {
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
              child: PartnerMetricCard(
                icon: Icons.event_outlined,
                title: 'Eventos',
                value: '$eventsCount',
                subtitle: 'criados por voce',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: PartnerMetricCard(
                icon: Icons.visibility_outlined,
                title: 'Visualizacoes',
                value: '$totalViews',
                subtitle: 'nos eventos listados',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: PartnerMetricCard(
                icon: Icons.local_fire_department_outlined,
                title: 'Boras',
                value: '$totalBoras',
                subtitle: 'interessados',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: PartnerMetricCard(
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
}
