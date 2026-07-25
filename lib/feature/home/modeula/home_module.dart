import 'package:entao_bora/feature/home/presentation/pages/home.dart';
import 'package:entao_bora/feature/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.add(HomeViewModel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/home',
      child: (_) => HomePage(
        showLogin:
            (r.args.data as Map<String, dynamic>?)?['showLogin'] ?? false,
      ),
    );
  }
}
