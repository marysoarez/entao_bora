import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final auth = Modular.get<AuthViewModel>();

  Future<void> _openPartnerArea(BuildContext context) async {
    await _openPartnerRoute(context, '/partner-dashboard');
  }

  Future<void> _openPartnerPlaces(BuildContext context) async {
    await _openPartnerRoute(context, '/places/manage');
  }

  Future<void> _openPartnerMenus(BuildContext context) async {
    await _openPartnerRoute(context, '/places/menu');
  }

  Future<void> _openPartnerRoute(BuildContext context, String route) async {
    if (!auth.isLogged) {
      await LoginDialog.show(context);
      await auth.refresh();

      if (!auth.isLogged) return;
    }

    if (!context.mounted) return;

    Navigator.pop(context);
    Modular.to.pushNamed(route);
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
                        title: 'Inicio',
                        onTap: () => Modular.to.navigate('/'),
                      ),
                      _drawerItem(
                        context,
                        icon: Icons.event_note_outlined,
                        title: 'Meus eventos',
                        onTap: () => _openPartnerArea(context),
                      ),
                      _drawerItem(
                        context,
                        icon: Icons.place_outlined,
                        title: 'Meus locais',
                        onTap: () => _openPartnerPlaces(context),
                      ),
                      _drawerItem(
                        context,
                        icon: Icons.restaurant_menu_outlined,
                        title: 'Cardapios',
                        onTap: () => _openPartnerMenus(context),
                      ),
                      const Divider(),
                      _drawerItem(
                        context,
                        icon: Icons.add_circle_outline,
                        title: 'Novo evento',
                        onTap: () => Modular.to.pushNamed('/events/create'),
                      ),
                      _drawerItem(
                        context,
                        icon: Icons.add_location_alt_outlined,
                        title: 'Reivindicar local',
                        onTap: () => Modular.to.pushNamed('/places/create'),
                      ),
                      const Divider(),
                      _drawerItem(
                        context,
                        icon: Icons.settings_outlined,
                        title: 'Configuracoes',
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
                        leading: const Icon(
                          Icons.logout,
                          color: DsColors.accent,
                        ),
                        title: const Text(
                          'Sair',
                          style: TextStyle(color: DsColors.accent),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          await auth.logout();
                        },
                      )
                    : ListTile(
                        leading: const Icon(
                          Icons.login,
                          color: DsColors.success,
                        ),
                        title: const Text(
                          'Entrar',
                          style: TextStyle(color: DsColors.success),
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
      padding: const EdgeInsets.all(DsSpacing.xl),
      decoration: const BoxDecoration(color: DsColors.primary),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: DsColors.publicTextSubtle,
            backgroundImage: auth.user?.photoUrl != null
                ? NetworkImage(auth.user!.photoUrl!)
                : null,
            child: auth.user?.photoUrl == null
                ? const Icon(Icons.person, size: 38, color: DsColors.publicText)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            auth.user?.name ?? 'Visitante',
            style: const TextStyle(
              color: DsColors.publicText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            auth.user?.email ?? 'Faca login para continuar',
            style: const TextStyle(color: DsColors.publicTextSubtle),
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
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
