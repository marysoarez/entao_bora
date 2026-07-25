import 'package:entao_bora/feature/events/presentation/pages/create_event_page.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/create_event_viewmodel.dart';
import 'package:flutter_modular/flutter_modular.dart';
class EventModule extends Module {
  @override
  void binds(Injector i) {
    i.add(CreateEventViewModel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/create',
      child: (_) => const CreateEventPage(),
    );
  }
}