import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_mini_card.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/helpers/public_url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PlaceEventsSection extends StatelessWidget {
  final PlaceEntity place;
  final PlaceEventsViewModel vm;

  const PlaceEventsSection({super.key, required this.place, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.local_activity, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                "PrÃ³ximos eventos",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Observer(
          builder: (_) {
            if (vm.loading) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (vm.error != null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(vm.error!),
              );
            }

            if (vm.events.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Nenhum evento encontrado.",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.events.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final event = vm.events[index];

                return GestureDetector(
                  onTap: () {
                    Modular.to.pushNamed(
                      PublicUrlHelper.eventPath(slug: event.slug, id: event.id),
                    );
                  },
                  child: EventMiniCard(event: event, place: place),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
