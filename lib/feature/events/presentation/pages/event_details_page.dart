import 'package:entao_bora/feature/events/presentation/pages/event_details_skeleton.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/event_details_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_card_widget.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EventsDetailsPage extends StatefulWidget {
  final String id;

  const EventsDetailsPage({super.key, required this.id});

  @override
  State<EventsDetailsPage> createState() => _EventsDetailsPageState();
}

class _EventsDetailsPageState extends State<EventsDetailsPage> {
  late final EventDetailsViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = Modular.get<EventDetailsViewModel>();

    vm.load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (vm.loading) {
          return const EventDetailsSkeleton();
        }

        if (vm.event == null) {
          return const Scaffold(
            backgroundColor: DsColors.publicBackground,
            body: Center(
              child: Text(
                "Evento não encontrado",
                style: TextStyle(color: DsColors.publicTextMuted),
              ),
            ),
          );
        }

        return EventCard(event: vm.event!, place: vm.place);
      },
    );
  }
}
