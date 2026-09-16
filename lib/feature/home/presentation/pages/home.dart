import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/home_explore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.showLogin = false});
  final bool showLogin;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final vm = Modular.get<HomeViewModel>();
  final auth = Modular.get<AuthViewModel>();
  String? _message;
  @override
  void initState() {
    super.initState();
    if (Firebase.apps.isNotEmpty) {
      vm.load();
      auth.loadUser();
    }
    if (widget.showLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) LoginDialog.show(context);
      });
    }
  }

  Future<void> _create() async {
    if (!await auth.ensureLogged(context) || !mounted) return;
    final created = await Modular.to.pushNamed<bool>('/events/create');
    if (created == true && mounted) {
      setState(() => _message = 'Evento criado com sucesso.');
      await vm.reloadPlaces();
    }
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) => HomeExplore(
      events: vm.events,
      places: vm.places,
      loading: vm.loading,
      error: vm.error,
      configured: Firebase.apps.isNotEmpty,
      location: vm.currentLocation,
      user: auth.user,
      message: _message,
      onRetry: vm.load,
      onLocation: vm.enableLocation,
      onLogin: () {
        if (auth.isLogged) {
          auth.logoutAndGoHome();
        } else {
          LoginDialog.show(context);
        }
      },
      onCreate: _create,
      onNavigate: (path) async {
        if ((path == '/minha-area' || path == '/partner-dashboard') &&
            !await auth.ensureLogged(context)) {
          return;
        }
        if (mounted) Modular.to.pushNamed(path);
      },
    ),
  );
}
