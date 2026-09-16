import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/event_details_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_card_widget.dart';
import 'package:entao_bora/feature/home/presentation/widgets/home_style.dart';
import 'package:entao_bora/shared/widgets/public_detail_widgets.dart';
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
          return _message('Carregando detalhes…');
        }

        if (vm.event == null) {
          return _message(vm.error ?? 'Não encontramos este registro.');
        }

        return EventCard(event: vm.event!, place: vm.place);
      },
    );
  }

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
