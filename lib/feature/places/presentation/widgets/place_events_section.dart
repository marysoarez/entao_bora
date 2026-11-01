import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
import 'package:entao_bora/feature/home/presentation/widgets/home_result_cards.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/helpers/public_url_helper.dart';
import 'package:entao_bora/shared/widgets/public_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PlaceEventsSection extends StatelessWidget {
  const PlaceEventsSection({super.key, required this.place, required this.vm});
  final PlaceEntity place;
  final PlaceEventsViewModel vm;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Próximos eventos', style: publicSectionTitle()),
      const SizedBox(height: 16),
      Observer(
        builder: (_) {
          if (vm.loading) return const SizedBox.shrink();
          if (vm.events.isEmpty) {
            return Text(
              'Nenhum evento anunciado no momento.',
              style: publicBody(),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = MediaQuery.sizeOf(context).width <= 760 ? 1 : 3;
              const gap = 22.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: vm.events
                    .map(
                      (event) => SizedBox(
                        width: width,
                        child: HomeEventCard(
                          event: event,
                          onTap: () => Modular.to.pushNamed(
                            PublicUrlHelper.eventPath(
                              slug: event.slug,
                              id: event.id,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          );
        },
      ),
    ],
  );
}
