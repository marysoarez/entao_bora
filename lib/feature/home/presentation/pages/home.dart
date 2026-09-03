import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/home/presentation/pages/map_seleton.dart';
import 'package:entao_bora/feature/home/presentation/widgets/create_fab.dart';
import 'package:entao_bora/feature/notifications/data/notification_service.dart';
import 'package:entao_bora/shared/widgets/app_bar_widget.dart';
import 'package:entao_bora/shared/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/map_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.showLogin = false});

  final bool showLogin;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final vm = Modular.get<HomeViewModel>();
  final auth = Modular.get<AuthViewModel>();
  final notifications = Modular.get<NotificationService>();

  @override
  void initState() {
    super.initState();

    vm.load();
    auth.loadUser();

    if (widget.showLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LoginDialog.show(context);
      });
    }
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: AppAppBar(
            title: auth.isLogged
                ? 'Então Bora, ${auth.user!.name}!'
                : 'Então Bora!!',
            showDrawer: true,
          ),
          drawer: AppDrawer(),

          body: Stack(
  children: [
    Positioned.fill(
      child: vm.loading
          ? const MapSkeleton()
          : MapSection(
              places: vm.places,
              events: vm.events,
            ),
    ),

    Positioned(
      right: 16,
      bottom: 16,
      child: CreateFab(
        onMyLocation: () async {
          if (vm.locationEnabled) {
            vm.disableLocation();
            return;
          }

          final enabled = await vm.enableLocation();

          if (!context.mounted) return;

          if (!enabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  vm.error ??
                      'Não foi possível obter sua localização.',
                ),
              ),
            );
          }
        },
        locationEnabled: vm.locationEnabled,
        onEnableNotifications: () async {
          if (!await auth.ensureLogged(context)) return;

          var location = vm.currentLocation;

          if (location == null) {
            final enabled = await vm.enableLocation();

            if (!context.mounted) return;

            if (!enabled) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    vm.error ??
                        'Compartilhe sua localizacao para melhorar a experiencia.',
                  ),
                ),
              );
              return;
            }

            location = vm.currentLocation;
          }

          if (location == null || auth.user == null) return;

          final result = await notifications.activate(
            user: auth.user!,
            location: location,
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
            ),
          );
        },
        onCreateEvent: () async {
          if (!await auth.ensureLogged(context)) return;

          final created = await Modular.to.pushNamed<bool>(
            '/events/create',
          );

          if (created == true) {
            await vm.reloadPlaces();
          }
        },
        onCreatePlace: () async {
          if (!await auth.ensureLogged(context)) return;

          final created = await Modular.to.pushNamed<bool>(
            '/places/create',
          );

          if (created == true) {
            await vm.reloadPlaces();
          }
        },
      ),
    ),
  ],
),
        );
      },
    );
  }
}
