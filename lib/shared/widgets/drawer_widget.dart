import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/places/presentation/widgets/user_avatar_widget.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key, this.user});

  final UserSummaryEntity? user;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final auth = Modular.get<AuthViewModel>();

  @override
  void initState() {
    super.initState();
    auth.refresh();
  }

  Future<void> _openUserArea(BuildContext context) async {
    if (!auth.isLogged) {
      await LoginDialog.show(context);
      await auth.refresh();

      if (!auth.isLogged) return;
    }

    if (!context.mounted) return;

    Navigator.pop(context);
    Modular.to.pushNamed('/minha-area');
  }

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
        final user = widget.user ?? auth.user;

        return Drawer(
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(user),
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
                        icon: Icons.person_outline,
                        title: 'Minha area',
                        onTap: () => _openUserArea(context),
                      ),
                      if (user?.isPartner == true || user?.isAdmin == true) ...[
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
                      ],
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
                          await auth.logoutAndGoHome();
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

  Widget _buildHeader(UserSummaryEntity? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DsSpacing.xl),
      decoration: const BoxDecoration(color: DsColors.primary),
      child: Column(
        children: [
          UserAvatar(photoUrl: user?.photoUrl?.trim(), radius: 34),
          const SizedBox(height: 12),
          Text(
            user?.name.isNotEmpty == true ? user!.name : 'Visitante',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DsColors.publicText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user?.email ?? 'Faca login para continuar',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
