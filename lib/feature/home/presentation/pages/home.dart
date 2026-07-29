import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/home/presentation/widgets/create_fab.dart';
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

  @override
  void initState() {
    super.initState();

    vm.load();

    if (widget.showLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LoginDialog.show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: "Então Bora!!"),
      drawer: AppDrawer(),
      // floatingActionButton: CreateFab(
      //   onCreateEvent: () async {
      //     await Modular.to.pushNamed('/events/create');
      //   },
      //   onCreatePlace: () async {
      //     final created = await Modular.to.pushNamed<bool>('/places/create');

      //     if (created == true) {
      //       await vm.reloadPlaces();
      //     }
      //   },
      // ),
      body: Observer(
        builder: (_) {
          if (vm.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.currentLocation == null) {
            return const Center(
              child: Text('Não foi possível obter sua localização.'),
            );
          }

          return Stack(
            // padding: const EdgeInsets.all(10),
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child:MapSection(
  currentLocation: vm.currentLocation!,
  places: vm.places,
  events: vm.events,
),
                ),
              ),

              Positioned(
                right: 16,
                bottom: 16,
                child: CreateFab(
                  onCreateEvent: () async {
                    await Modular.to.pushNamed('/events/create');
                  },
                  onCreatePlace: () async {
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
          );
        },
      ),
    );
  }
}
