import 'dart:convert';

import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final auth = Modular.get<AuthViewModel>();
  final placeRepository = Modular.get<IPlaceRepository>();

  Future<void> _openPartnerArea(BuildContext context) async {
    final user = auth.user;

    if (user == null) {
      return;
    }

    // Contexto do Navigator que está por trás do Drawer.
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    print('>>> BUSCANDO PLACES DO USUARIO');

    final result = await placeRepository.getPlacesByOwnerId(user.id);

    print('>>> RESULTADO: $result');

    result.fold(
      (failure) {
        print('>>> ERRO: $failure');
      },
      (places) async {
        print('>>> PLACES ENCONTRADOS: ${places.length}');

        if (places.isEmpty) {
          ScaffoldMessenger.of(rootContext).showSnackBar(
            const SnackBar(content: Text('Você não possui estabelecimentos.')),
          );
          return;
        }

        print('>>> ABRINDO SELECAO');

        final place = await _selectPlace(rootContext, places);

        if (place == null) {
          print('>>> NENHUM PLACE SELECIONADO');
          return;
        }

        print('>>> PLACE SELECIONADO: ${place.name}');

        Modular.to.pushNamed('/partner-dashboard', arguments: place);
      },
    );
  }

  Future<PlaceEntity?> _selectPlace(
    BuildContext context,
    List<PlaceEntity> places,
  ) {
    return showDialog<PlaceEntity>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Meus estabelecimentos'),
          content: SizedBox(
            width: 450,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: places.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final place = places[index];

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.store)),
                  title: Text(place.name),
                  subtitle: Text(place.address.displayName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(dialogContext).pop(place);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPartnerDashboard(BuildContext context) async {
    print('>>> CLIQUEI EM GERAL');

    final user = auth.user;

    print('>>> USER: $user');
    print('>>> USER ID: ${user?.id}');

    if (user == null) {
      print('>>> USUARIO NAO LOGADO');

      await LoginDialog.show(context);
      await auth.refresh();

      return;
    }

    print('>>> BUSCANDO PLACES DO USUARIO');

    final result = await placeRepository.getPlacesByOwnerId(user.id);

    print('>>> RESULTADO: $result');

    result.fold(
      (failure) {
        print('>>> ERRO AO BUSCAR PLACES: $failure');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível carregar seus estabelecimentos.'),
          ),
        );
      },
      (places) async {
        print('>>> PLACES ENCONTRADOS: ${places.length}');

        for (final place in places) {
          print('>>> PLACE: ${place.name} - ${place.id}');
        }

        if (places.isEmpty) {
          print('>>> NENHUM PLACE ENCONTRADO');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Você ainda não possui nenhum estabelecimento cadastrado.',
              ),
            ),
          );

          return;
        }

        PlaceEntity? place;

        if (places.length == 1) {
          print('>>> APENAS UM PLACE');

          place = places.first;
        } else {
          print('>>> MAIS DE UM PLACE - ABRINDO SELECAO');

          place = await _selectPlace(context, places);
        }

        if (place == null) {
          print('>>> NENHUM PLACE SELECIONADO');
          return;
        }

        print('>>> NAVEGANDO PARA DASHBOARD: ${place.name}');

        Modular.to.pushNamed('/partner-dashboard', arguments: place);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Drawer(
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(auth),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _drawerItem(
                        context,
                        icon: Icons.home_outlined,
                        title: 'Início',
                        onTap: () => Modular.to.navigate('/home/'),
                      ),

                      _drawerItem(
                        context,
                        icon: Icons.dashboard_outlined,
                        title: 'Estabelecimentos',
                        onTap: () => _openPartnerArea(context),
                      ),

                      _drawerItem(
                        context,
                        icon: Icons.place_outlined,
                        title: 'Locais',
                        onTap: () => Modular.to.navigate('/home/'),
                      ),

                      const Divider(),

                      _drawerItem(
                        context,
                        icon: Icons.add_circle_outline,
                        title: 'Novo Evento',
                        onTap: () => Modular.to.pushNamed('/events/create'),
                      ),

                      _drawerItem(
                        context,
                        icon: Icons.add_location_alt_outlined,
                        title: 'Novo Local',
                        onTap: () => Modular.to.pushNamed('/places/create'),
                      ),

                      const Divider(),

                      _drawerItem(
                        context,
                        icon: Icons.settings_outlined,
                        title: 'Configurações',
                        onTap: () {},
                      ),

                      _drawerItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'Ajuda',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                auth.isLogged
                    ? ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Sair',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          await auth.logout();
                        },
                      )
                    : ListTile(
                        leading: const Icon(Icons.login, color: Colors.green),
                        title: const Text(
                          'Entrar',
                          style: TextStyle(color: Colors.green),
                        ),
                        onTap: () async {
                          Navigator.pop(context);

                          await LoginDialog.show(context);

                          await auth.refresh();
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AuthViewModel auth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white24,
            backgroundImage: auth.user?.photoUrl != null
                ? NetworkImage(auth.user!.photoUrl!)
                : null,
            child: auth.user?.photoUrl == null
                ? const Icon(Icons.person, size: 38, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            auth.user?.name ?? 'Visitante',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            auth.user?.email ?? 'Faça login para continuar',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        onTap();
      },
    );
  }
}
